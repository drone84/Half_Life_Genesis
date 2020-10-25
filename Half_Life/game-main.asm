; *************************************************************************
; * Lame attempt at a copy-cat game like Frogger
; * Work under progress!
; *************************************************************************
.cpu "65816"

TARGET_FLASH = 1              ; The code is being assembled for Flash
TARGET_RAM = 2                ; The code is being assembled for RAM

.include "macros_inc.asm"
.include "bank_00_inc.asm"
.include "vicky_def.asm"
.include "VKYII_CFP9553_BITMAP_def.asm"
.include "VKYII_CFP9553_COLLISION_def.asm"
.include "VKYII_CFP9553_SPRITE_def.asm"
.include "VKYII_CFP9553_TILEMAP_def.asm"
.include "interrupt_def.asm"
.include "keyboard_def.asm"
.include "io_def.asm"

.include "dram_inc.asm"                     ; old Definition file that was supposed to be a Memory map used by kernel_lib.asm
.include "simulator_inc.asm"

INITKEYBOARD    JML IINITKEYBOARD

* = HRESET
                CLC
                XCE   ; go into native mode
                SEI   ; ignore interrupts
                JML GAME_START

* = HIRQ       ; IRQ handler.
RHIRQ
                .as
                .xl
                PHB
                PHD
                PHA
                PHX
                PHY
                ;
                ; todo: look up IRQ triggered and do stuff
                ;
                JSL IRQ_HANDLER

                PLY
                PLX
                PLA
                PLD
                PLB
                RTI

; Interrupt Vectors
* = VECTORS_BEGIN
JUMP_READY      JML GAME_START ; Kernel READY routine. Rewrite this address to jump to a custom kernel.
RVECTOR_COP     .addr HCOP     ; FFE4
RVECTOR_BRK     .addr HBRK     ; FFE6
RVECTOR_ABORT   .addr HABORT   ; FFE8
RVECTOR_NMI     .addr HNMI     ; FFEA
                .word $0000    ; FFEC
RVECTOR_IRQ     .addr HIRQ     ; FFEE

RRETURN         JML GAME_START

RVECTOR_ECOP    .addr HCOP     ; FFF4
RVECTOR_EBRK    .addr HBRK     ; FFF6
RVECTOR_EABORT  .addr HABORT   ; FFF8
RVECTOR_ENMI    .addr HNMI     ; FFFA
RVECTOR_ERESET  .addr HRESET   ; FFFC
RVECTOR_EIRQ    .addr HIRQ     ; FFFE

* = $160000

PLAYER_X_MOV .word 0          ; 0: stay where it is,   1: go up,     2: go down
PLAYER_Y_MOV .word 0          ; 0: stay where it is,   1: go right,  2: goleft
PLAYER_X     .word 100
PLAYER_Y     .word 100

game_array  ; the array treats each sprite in order
            ;     speed  X       Y        sprite
            .word $FFFC, 640-96, 480-128, 0 ; sprite  0 - car front
            .word $FFFC, 640-64, 480-128, 1 ; sprite  1 - car back
            .word     2, 32    , 480-160, 2 ; sprite  2 - bus back
            .word     2, 64    , 480-160, 3 ; sprite  3 - bus middle
            .word     2, 96    , 480-160, 4 ; sprite  4 - bus front
            .word $FFFA, 96    , 480-192, 0 ; sprite  5 - car front
            .word $FFFA, 128   , 480-192, 1 ; sprite  6 - car back
            .word     1, 192   , 256    , 8 ; sprite  7 - oldie front
            .word     1, 224   , 256    , 9 ; sprite  8 - oldie back
            .word $FFFB, 320   , 128    , 5 ; sprite  9 - log 1
            .word $FFFB, 352   , 128    , 6 ; sprite 10 - log 2
            .word $FFFB, 384   , 128    , 7 ; sprite 11 - log 3
            .word     2, 416   , 160    , 5 ; sprite 12 - log 1
            .word     2, 448   , 160    , 7 ; sprite 13 - log 3
            .word $FFFE, 512   , 192    ,10 ; sprite 15 - lilypad
            .word     0, 0     , 0      ,15 ; - not used


GAME_START
            setas
            setxl


            ; Setup the Interrupt Controller
            ; For Now all Interrupt are Falling Edge Detection (IRQ)
            LDA #$FF
            STA @lINT_EDGE_REG0
            STA @lINT_EDGE_REG1
            STA @lINT_EDGE_REG2
            STA @lINT_EDGE_REG3

            ; Mask all Interrupt @ This Point
            LDA #$FF
            STA @l INT_MASK_REG0
            STA @l INT_MASK_REG1
            STA @l INT_MASK_REG2
            STA @l INT_MASK_REG3
            LDA #$00

            ;STA @l INT_MASK_REG3

            ;setdp 0
            ;JSL INITKEYBOARD
            JSR VGM_START
            JSR CLEAR_VRAM_B0_BA
            JSR LOAD_MAIN_MENU

            setas
            ; diable the border
            LDA #0
            STA BORDER_CTRL_REG
            ; enable graphics, tiles and sprites display
            LDA #Mstr_Ctrl_Graph_Mode_En + Mstr_Ctrl_Bitmap_En + Mstr_Ctrl_TileMap_En + Mstr_Ctrl_Sprite_En + Mstr_Ctrl_Text_Mode_En; + Mstr_Ctrl_Text_Overlay
            STA MASTER_CTRL_REG_L

            ; Enable SOF
            .setas

            LDA @l INT_MASK_REG0
            AND #~( FNX0_INT00_SOF ); Start of Frame
            STA @l INT_MASK_REG0

            LDA @l INT_MASK_REG0
            AND #~( FNX0_INT07_MOUSE ) ; Mouse
            STA @l INT_MASK_REG0

            LDA @l INT_MASK_REG0
            AND #~( FNX0_INT02_TMR0 ) ; Timer 0
            STA @l INT_MASK_REG0

            LDA @l INT_MASK_REG1
            AND #~( FNX1_INT00_KBD ) ; Keyboard
            STA @l INT_MASK_REG1

            CLI ; active the Interrupt

            BRA GAME_LOOP

            JSR INIT_DISPLAY

            ; Enable SOF
            setas
            LDA @l INT_MASK_REG0
            AND #~( FNX0_INT00_SOF ); Start of Frame
            STA @l INT_MASK_REG0

            LDA @l INT_MASK_REG0
            AND #~( FNX0_INT01_SOL ) ; Start of Line
            STA @l INT_MASK_REG0

            LDA @l INT_MASK_REG0
            AND #~( FNX0_INT02_TMR0 ) ; Timer 0
            STA @l INT_MASK_REG0

            LDA @l INT_MASK_REG0
            AND #~( FNX0_INT07_MOUSE ) ; Mouse
            STA @l INT_MASK_REG0

            LDA @l INT_MASK_REG1
            AND #~( FNX1_INT00_KBD ) ; Keyboard
            STA @l INT_MASK_REG1

            ;LDA #~( FNX1_INT00_KBD ) ; Keyboard
            ;STA @l INT_MASK_REG1

            CLI

    GAME_LOOP
            BRA GAME_LOOP


;
;
; IINITKEYBOARD
; Author: Stefany
; Note: We assume that A & X are 16Bits Wide when entering here.
; Initialize the Keyboard Controler (8042) in the SuperIO.
; Inputs:
;   None
; Affects:
;   Carry (c)

Success_kb_init .text "Keyboard Present", $0D, $00
Failed_kb_init  .text "No Keyboard Attached or Failed Init...", $0D, $00

IINITKEYBOARD	  PHD
				        PHP
				        PHA
				        PHX

                setas				;just make sure we are in 8bit mode
                setxl 					; Set 8bits

				; Setup Foreground LUT First
                CLC

                JSR Poll_Inbuf ;
;; Test AA
				        LDA #$AA			;Send self test command
				        STA KBD_CMD_BUF
								;; Sent Self-Test Code and Waiting for Return value, it ought to be 0x55.
                JSR Poll_Outbuf ;

				        LDA KBD_OUT_BUF		;Check self test result
				        CMP #$55
				        BEQ	passAAtest

                BRL initkb_loop_out

passAAtest      ;LDX #<>pass_tst0xAAmsg
                ;JSL IPRINT      ; print Message
;; Test AB
				        LDA #$AB			;Send test Interface command
				        STA KBD_CMD_BUF

                JSR Poll_Outbuf ;

				        LDA KBD_OUT_BUF		;Display Interface test results
				        CMP #$00			;Should be 00
				        BEQ	passABtest

                BRL initkb_loop_out

passABtest      ;LDX #<>pass_tst0xABmsg
;                JSL IPRINT       ; print Message

                ;LDA #$A8        ; Enable Second PS2 Port
                ;STA KBD_DATA_BUF
                ;JSR Poll_Outbuf ;

;; Program the Keyboard & Enable Interrupt with Cmd 0x60
                LDA #$60            ; Send Command 0x60 so to Enable Interrupt
                STA KBD_CMD_BUF
                JSR Poll_Inbuf ;
                LDA #%01101001      ; Enable Interrupt
                ;LDA #%01001011      ; Enable Interrupt for Mouse and Keyboard
                STA KBD_DATA_BUF
                JSR Poll_Inbuf ;
                ;LDX #<>pass_cmd0x60msg
                ;JSL IPRINT       ; print Message
; Reset Keyboard
                LDA #$FF      ; Send Keyboard Reset command
                STA KBD_DATA_BUF
                ; Must wait here;
                LDX #$FFFF
DLY_LOOP1       DEX
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                NOP
                CPX #$0000
                BNE DLY_LOOP1
                JSR Poll_Outbuf ;

                LDA KBD_OUT_BUF   ; Read Output Buffer

;                LDX #<>pass_cmd0xFFmsg
;                JSL IPRINT       ; print Message
DO_CMD_F4_AGAIN
                JSR Poll_Inbuf ;
				        LDA #$F4			; Enable the Keyboard
				        STA KBD_DATA_BUF
                JSR Poll_Outbuf ;

				        LDA KBD_OUT_BUF		; Clear the Output buffer
                CMP #$FA
                BNE DO_CMD_F4_AGAIN
                ; Till We Reach this point, the Keyboard is setup Properly
                JSR INIT_MOUSE

                ; Unmask the Keyboard interrupt
                ; Clear Any Pending Interrupt
                LDA @lINT_PENDING_REG0  ; Read the Pending Register &
                AND #FNX0_INT07_MOUSE
                STA @lINT_PENDING_REG0  ; Writing it back will clear the Active Bit

                LDA @lINT_PENDING_REG1  ; Read the Pending Register &
                AND #FNX1_INT00_KBD
                STA @lINT_PENDING_REG1  ; Writing it back will clear the Active Bit
                ; Disable the Mask
                LDA @lINT_MASK_REG1
                AND #~FNX1_INT00_KBD
                STA @lINT_MASK_REG1

                LDA @lINT_MASK_REG0
                AND #~FNX0_INT07_MOUSE
                STA @lINT_MASK_REG0


                LDX #<>Success_kb_init
                SEC
                BCS InitSuccess

initkb_loop_out LDX #<>Failed_kb_init
InitSuccess     ;JSL IPRINT       ; print Message
                setal 					; Set 16bits
                setxl 					; Set 16bits

                PLX
                PLA
				        PLP
				        PLD
                RTL

Poll_Inbuf	    .as
                LDA STATUS_PORT		; Load Status Byte
				        AND	#<INPT_BUF_FULL	; Test bit $02 (if 0, Empty)
				        CMP #<INPT_BUF_FULL
				        BEQ Poll_Inbuf
                RTS

Poll_Outbuf	    .as
                LDA STATUS_PORT
                AND #OUT_BUF_FULL ; Test bit $01 (if 1, Full)
                CMP #OUT_BUF_FULL
                BNE Poll_Outbuf
                RTS

INIT_MOUSE      .as

                JSR Poll_Inbuf
                LDA #$A8          ; Enable the second PS2 Channel
                STA KBD_CMD_BUF

;                LDX #$4000
;DLY_MOUSE_LOOP  DEX
                ;CPX #$0000
                ;BNE DLY_MOUSE_LOOP
DO_CMD_A9_AGAIN
                JSR Poll_Inbuf
                LDA #$A9          ; Tests second PS2 Channel
                STA KBD_CMD_BUF
                JSR Poll_Outbuf ;
				        LDA KBD_OUT_BUF		; Clear the Output buffer
                CMP #$00
                BNE DO_CMD_A9_AGAIN
                ; IF we pass this point, the Channel is OKAY, Let's move on

                JSR Poll_Inbuf
                LDA #$20
                STA KBD_CMD_BUF
                JSR Poll_Outbuf ;

                LDA KBD_OUT_BUF
                ORA #$02
                PHA
                JSR Poll_Inbuf
                LDA #$60
                STA KBD_CMD_BUF
                JSR Poll_Inbuf ;
                PLA
                STA KBD_DATA_BUF

                LDA #$F6        ;Tell the mouse to use default settings
                JSR MOUSE_WRITE
                JSR MOUSE_READ

                ; Set the Mouse Resolution 1 Clicks for 1mm - For a 640 x 480, it needs to be the slowest
                LDA #$E8
                JSR MOUSE_WRITE
                JSR MOUSE_READ
                LDA #$00
                JSR MOUSE_WRITE
                JSR MOUSE_READ

                ; Set the Refresh Rate to 60
;                LDA #$F2
;                JSR MOUSE_WRITE
;                JSR MOUSE_READ
;                LDA #60
;                JSR MOUSE_WRITE
;                JSR MOUSE_READ


                LDA #$F4        ; Enable the Mouse
                JSR MOUSE_WRITE
                JSR MOUSE_READ
                ; Let's Clear all the Variables Necessary to Computer the Absolute Position of the Mouse
                LDA #$00
                STA MOUSE_PTR
                RTS

MOUSE_WRITE     .as
                PHA
                JSR Poll_Inbuf
                LDA #$D4
                STA KBD_CMD_BUF
                JSR Poll_Inbuf
                PLA
                STA KBD_DATA_BUF
                RTS

MOUSE_READ      .as
                JSR Poll_Outbuf ;
                LDA KBD_INPT_BUF
                RTS

.include "menu_display.asm"
.include "BMP_Lib.asm"
.include "Kernel_lib.asm"
.include "stdlib.asm"
.include "interrupt_handler.asm"
.include "timer_def.asm"
.include "vgm-player.asm"
.include "display.asm"

;* = $170000
;.binary "assets/songs/11 - Unknown (Sound Test 8B).vgm"
;.binary "assets/songs/sega - Copy.vgm"
;.binary "assets/songs/dubstep.vgm"
