;
; IPRINT
; Print a string, followed by a carriage return
; DBR: bank containing string
; X: address of the string in data bank
; Modifies: X
;
IPRINT          JSL IPUTS
                JSL IPRINTCR
                RTL

; IPUTS
; Print a null terminated string
; DBR: bank containing string
; X: address of the string in data bank
; Modifies: X.
;  X will be set to the location of the byte following the string
;  So you can print multiple, contiguous strings by simply calling
;  IPUTS multiple times.
IPUTS           PHA
                PHP
                setas
                setxl
iputs1          LDA $0,b,x      ; read from the string
                BEQ iputs_done
iputs2          JSL IPUTC
iputs3          INX
                JMP iputs1
iputs_done      INX
                PLP
                PLA
                RTL

;
;IPUTC
; Print a single character to a channel.
; Handles terminal sequences, based on the selected text mode
; Modifies: none
;
IPUTC           PHD
                PHP             ; stash the flags (we'll be changing M)
                setdp 0
                setas
                CMP #$0D        ; handle CR
                BNE iputc_bs
                JSL IPRINTCR
                bra iputc_done
iputc_bs        CMP #$08        ; backspace
                BNE iputc_print
                JSL IPRINTBS
                BRA iputc_done
iputc_print     STA [CURSORPOS] ; Save the character on the screen
                JSL ICSRRIGHT
iputc_done	sim_refresh
                PLP
                PLD
                RTL

;
;IPUTB
; Output a single byte to a channel.
; Does not handle terminal sequences.
; Modifies: none
;
IPUTB
                ;
                ; TODO: write to open channel
                ;
                RTL

;
; IPRINTCR
; Prints a carriage return.
; This moves the cursor to the beginning of the next line of text on the screen
; Modifies: Flags
IPRINTCR	PHX
                PHY
                PHP
                LDX #0
                LDY CURSORY
                INY
                JSL ILOCATE
                PLP
                PLY
                PLX
                RTL

;
; IPRINTBS
; Prints a carriage return.
; This moves the cursor to the beginning of the next line of text on the screen
; Modifies: Flags
IPRINTBS	PHX
                PHY
                PHP
                LDX CURSORX
                LDY CURSORY
                DEX
                JSL ILOCATE
                PLP
                PLY
                PLX
                RTL

;
;ICSRRIGHT
; Move the cursor right one space
; Modifies: none
;
ICSRRIGHT	; move the cursor right one space
                PHX
                PHB
                setal
                setxl
                setdp $0
                INC CURSORPOS
                LDX CURSORX
                INX
                CPX COLS_VISIBLE
                BCC icsr_nowrap  ; wrap if the cursor is at or past column 80
                LDX #0
                PHY
                LDY CURSORY
                INY
                JSL ILOCATE
                PLY
icsr_nowrap     STX CURSORX
                PLB
                PLX
                RTL

ISRLEFT	RTL
ICSRUP	RTL
ICSRDOWN	RTL

;ILOCATE
;Sets the cursor X and Y positions to the X and Y registers
;Direct Page must be set to 0
;Input:
; X: column to set cursor
; Y: row to set cursor
;Modifies: none
ILOCATE         PHA
                PHP
                setaxl
ilocate_scroll  ; If the cursor is below the bottom row of the screen
                ; scroll the screen up one line. Keep doing this until
                ; the cursor is visible.
                CPY LINES_VISIBLE
                BCC ilocate_scrolldone
                JSL ISCROLLUP
                DEY
                ; repeat until the cursor is visible again
                BRA ilocate_scroll
ilocate_scrolldone
                ; done scrolling store the resultant cursor positions.
                STX CURSORX
                STY CURSORY
                LDA SCREENBEGIN
ilocate_row     ; compute the row
                CPY #$0
                BEQ ilocate_right
                ; move down the number of rows in Y
ilocate_down    CLC
                ADC COLS_PER_LINE
                DEY
                BEQ ilocate_right
                BRA ilocate_down
                ; compute the column
ilocate_right   CLC
                ADC CURSORX             ; move the cursor right X columns
                STA CURSORPOS
                LDY CURSORY
ilocate_done    PLP
                PLA
                RTL
;
; ISCROLLUP
; Scroll the screen up one line
; Inputs:
;   None
; Affects:
;   None
ISCROLLUP       ; Scroll the screen up by one row
                ; Place an empty line at the bottom of the screen.
                ; TODO: use DMA to move the data
                PHA
                PHX
                PHY
                PHB
                PHP
                setaxl
                ; Set block move source to second row
                CLC
                LDA SCREENBEGIN
                TAY             ; Destination is first row
                ADC COLS_PER_LINE
                TAX             ; Source is second row
                ;TODO compute screen bottom with multiplier
                ;(once implemented)
                ; for now, should be 8064 or $1f80 bytes
                LDA #SCREEN_PAGE1-SCREEN_PAGE0-COLS_PER_LINE
                ; Move the data
                MVP $00,$00

                PLP
                PLB
                PLY
                PLX
                PLA
                RTL 
