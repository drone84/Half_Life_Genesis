.cpu "65816"
.include "Math_def.asm"

;
; IBMP_PARSER  (indexed File Only)
; Go Parse and Update LUT and Transfer Data to Video Memory (Active Memory)
; Author: Stefany
;
; Verify that the Math Block Works
; Inputs:
; None
IBMP_PARSER     setaxl
                ; First Check the BMP Signature
                LDY #$0000
                LDA [BMP_PRSE_SRC_PTR],Y
                CMP #$4D42
                BEQ IBMP_PARSER_CONT
                BRL BMP_PARSER_END_WITH_ERROR
IBMP_PARSER_CONT
                LDY #$0002
                LDA [BMP_PRSE_SRC_PTR],Y    ; File Size Low Short
                STA @lADDER32_A_LL          ; Store in 32Bit Adder (A)
                ; File Size
                LDY #$0004
                LDA [BMP_PRSE_SRC_PTR],Y    ; File Size High Short
                STA @lADDER32_A_HL          ; Store in 32Bit Adder (A)
                LDA #$FFFF                  ; Store -1 in Adder (B)
                STA @lADDER32_B_LL
                STA @lADDER32_B_HL
                ; File Size - 1
                CLC
                LDA @lADDER32_R_LL
                STA BMP_FILE_SIZE
                LDA @lADDER32_R_HL
                STA BMP_FILE_SIZE+2
                ; If the signature is valid, Save the Size of the Image
                LDY #$0012
                LDA [BMP_PRSE_SRC_PTR],Y    ; The X SIze is 32bits in BMP, but 16bits will suffice
                STA BMP_X_SIZE
                ; Y Size
                LDY #$0016
                LDA [BMP_PRSE_SRC_PTR],Y    ; The X SIze is 32bits in BMP, but 16bits will suffice
                STA BMP_Y_SIZE
                ; Number of Indexed Color in the Image (number of colors in the LUT)
                LDY #$002E
                LDA [BMP_PRSE_SRC_PTR],Y    ; The X SIze is 32bits in BMP, but 16bits will suffice
                ;INC A; Add 1
                ASL A; Multiply by 2
                ASL A; Multiply by 2
                STA BMP_COLOR_PALET         ;
                ;CPX #$0000
                ;BNE BMP_LUT1_PICK
                JSR BMP_PARSER_UPDATE_LUT0   ; Go Upload the LUT0
                BRA DONE_TRANSFER_LUT;
  BMP_LUT1_PICK
                CPX #$0001
                BNE BMP_LUT2_PICK
                JSR BMP_PARSER_UPDATE_LUT1   ; Go Upload the LUT1
  BMP_LUT2_PICK
               ; Let's Compute the Pointer for the BITMAP (The Destination)
               ; Let's use the Internal Mutliplier to Find the Destination Address
               ; Let's Compute the Hight First
               ; Y x Stride + X
  DONE_TRANSFER_LUT
                LDA BMP_POSITION_Y
                STA @lM0_OPERAND_A
                LDA SCRN_X_STRIDE
                STA @lM0_OPERAND_B
                LDA @lM0_RESULT
                STA @lADDER32_A_LL          ; Store in 32Bit Adder (A)
                LDA @lM0_RESULT+2
                STA @lADDER32_A_HL          ; Store in 32Bit Adder (A)
                LDA BMP_POSITION_X
                STA @lADDER32_B_LL          ; Put the X Position Adder (B)
                LDA #$0000
                STA @lADDER32_B_HL
                LDA @lADDER32_R_LL          ; Put the Results in TEMP
                STA USER_TEMP
                LDA @lADDER32_R_HL          ; Put the Results in TEMP
                STA USER_TEMP+2
                ; Let's Add the X,Y Memory Point to the Actual Address where the bitmap begins
                LDA BMP_PRSE_DST_PTR
                STA @lADDER32_A_LL          ; Store in 32Bit Adder (A)
                LDA BMP_PRSE_DST_PTR+2
                STA @lADDER32_A_HL          ; Store in 32Bit Adder (A)
                LDA USER_TEMP
                STA @lADDER32_B_LL          ; Store in 32Bit Adder (B)
                LDA USER_TEMP+2
                STA @lADDER32_B_HL          ; Store in 32Bit Adder (B)
                ; Results of Requested Position (Y x Stride + X) + Start Address
                LDA @lADDER32_R_LL          ; Put the Results in BMP_PRSE_DST_PTR
                STA BMP_PRSE_DST_PTR
                LDA @lADDER32_R_HL          ; Put the Results in BMP_PRSE_DST_PTR
                STA BMP_PRSE_DST_PTR+2
                ; Let's Compute the Pointer for the FILE (The Source)
                ; My GOD I love this 32Bits ADDER ;o) Makes my life so simple...
                ; Imagine when we are going to need the 16Bit Multiplier, hum... it is going to be fun
                ; Load Absolute Location in Adder32 Bit Reg A
                LDA BMP_PRSE_SRC_PTR        ; Right now it is set @ $020000 (128K)
                STA @lADDER32_A_LL
                LDA BMP_PRSE_SRC_PTR+2        ; Right now it is set @ $020000 (128K)
                STA @lADDER32_A_HL
                ; Load File Size in Adder32bits Reg B
                LDA BMP_FILE_SIZE
                STA @lADDER32_B_LL
                LDA BMP_FILE_SIZE+2
                STA @lADDER32_B_HL
                ; Spit the Answer Back into the SRC Pointer (this should Point to last Pixel in memory)
                LDA @lADDER32_R_LL
                STA BMP_PRSE_SRC_PTR
                LDA @lADDER32_R_HL
                STA BMP_PRSE_SRC_PTR+2
                ; Now Take the Last Results and put it in Register A of ADDER32
                LDA BMP_PRSE_SRC_PTR        ; Right now it is set @ $020000 (128K) + File Size
                STA @lADDER32_A_LL
                LDA BMP_PRSE_SRC_PTR+2      ; Right now it is set @ $020000 (128K)
                STA @lADDER32_A_HL
                CLC
                LDA BMP_X_SIZE              ; Load The Size in X of the image and Make it negative
                EOR #$FFFF                  ; Inverse all bit
                ADC #$0001                  ; Add 0 ()
                STA @lADDER32_B_LL          ; Store the Results in reg B of ADDER32
                LDA #$FFFF
                STA @lADDER32_B_HL          ; Store in the Reminder of the 32Bits B Register
                                            ; We are now ready to go transfer the Image
                LDA @lADDER32_R_LL
                STA BMP_PRSE_SRC_PTR
                LDA @lADDER32_R_HL
                STA BMP_PRSE_SRC_PTR+2
                                            ; The Starting Pointer is in Results of the ADDER32
                ; Here The Pointer "BMP_PRSE_SRC_PTR" ought to point to the graphic itself (0,0)
                JSR BMP_PARSER_DMA_SHIT_OUT  ; We are going to start with the slow method
                LDX #<>bmp_parser_msg0
                BRA BMP_PARSER_END_NO_ERROR

BMP_PARSER_END_WITH_ERROR
                LDX #<>bmp_parser_err0

BMP_PARSER_END_NO_ERROR
                ;JSL IPRINT       ; print the first line
                RTL

; This transfer the Palette Directly
; Will have to be improved, so it can load the LUT Data in any specific LUT - TBC
BMP_PARSER_UPDATE_LUT0
                SEC
                   ; And this is offset to where the Color Palette Begins
                LDY #$0036 ; #$007A
                LDX #$0000
                setas
BMP_PARSER_UPDATE_LOOP
                ; RED Pixel
                LDA [BMP_PRSE_SRC_PTR],Y    ; First Pixel is Red
                STA @l GRPH_LUT0_PTR+0, X      ; The look-up Table point to a pixel Red
                STA @l $040000+0, X      ; The look-up Table point to a pixel Red
                INY
                ; Green Pixel
                LDA [BMP_PRSE_SRC_PTR],Y    ; Second Pixel is Green
                STA @l GRPH_LUT0_PTR+1, X      ; The look-up Table point to a pixel Green
                STA @l $050000+1, X      ; The look-up Table point to a pixel Green
                INY
                ; Blue Pixel
                LDA [BMP_PRSE_SRC_PTR],Y    ; Third Pixel is Blue
                STA @l GRPH_LUT0_PTR+2, X      ; The look-up Table point to a pixel Blue
                STA @l $040000+2, X      ; The look-up Table point to a pixel Blue
                INY
                LDA #$80
                STA @l GRPH_LUT0_PTR+3, X      ; The look-up Table point to a pixel alpha?
                STA @l $040000+3, X      ; The look-up Table point to a pixel alpha?
                INY ; For the Alpha Value, nobody cares
                INX
                INX
                INX
                INX
                CPX #$03FC ; BMP_COLOR_PALET         ; Apparently sometime there is less than 256 Values in the lookup
                BNE BMP_PARSER_UPDATE_LOOP
                setal
                RTS


;
; This transfer the Palette Directly
; Will have to be improved, so it can load the LUT Data in any specific LUT - TBC
BMP_PARSER_UPDATE_LUT1
                SEC
                   ; And this is offset to where the Color Palette Begins
                LDY #$0036
                LDX #$0000
                setas
PALETTE_LUT1_LOOP
                ; RED Pixel
                LDA [BMP_PRSE_SRC_PTR],Y    ; First Pixel is Red
                STA @lGRPH_LUT1_PTR+0, X      ; The look-up Table point to a pixel Blue
                INY
                ; Green Pixel
                LDA [BMP_PRSE_SRC_PTR],Y    ; Second Pixel is Green
                STA @lGRPH_LUT1_PTR+1, X      ; The look-up Table point to a pixel Blue
                INY
                ; Blue Pixel
                LDA [BMP_PRSE_SRC_PTR],Y    ; Third Pixel is Blue
                STA @lGRPH_LUT1_PTR+2, X      ; The look-up Table point to a pixel Blue
                INY
                LDA #$80
                STA @lGRPH_LUT1_PTR+3, X      ; The look-up Table point to a pixel Blue
                INY ; For the Alpha Value, nobody cares
                INX
                INX
                INX
                INX
                CPX BMP_COLOR_PALET         ; Apparently sometime there is less than 256 Values in the lookup
                BNE PALETTE_LUT1_LOOP
                setal
                RTS

; Let's do it the easy way first, then we will implement a DMA Controller
BMP_PARSER_DMA_SHIT_OUT
                LDX #$0000
BMP_PARSER_LOOPY
                LDY #$0000
                setas
BMP_PARSER_LOOPX
                LDA [BMP_PRSE_SRC_PTR],Y    ; Load First Pixel Y (will be linear)
                STA [BMP_PRSE_DST_PTR],Y    ; This is where the Pixel Go, Video Memory
                INY
                CPY BMP_X_SIZE              ; Transfer the First line
                BNE BMP_PARSER_LOOPX
                JSR BMP_PARSER_COMPUTE_Y_SRC
                JSR BMP_PARSER_COMPUTE_Y_DST
                INX
                CPX BMP_Y_SIZE
                BNE BMP_PARSER_LOOPY
                RTS
; BMP_PRSE_SRC_PTR = BMP_PRSE_SRC_PTR + BMP_X_SIZE
BMP_PARSER_COMPUTE_Y_SRC
                setal
                ; The 32Bit ADDER is already Setup with Reg B with -(BMP_X_SIZE)
                ; So just load the Actual Value so it can be substracted again from BMP_X_SIZE
                LDA BMP_PRSE_SRC_PTR        ; Right now it is set @ $020000 (128K) + File Size
                STA @lADDER32_A_LL
                LDA BMP_PRSE_SRC_PTR+2      ; Right now it is set @ $020000 (128K)
                STA @lADDER32_A_HL
                ; And Zooom... The new Value is calculated... Yeah, Fuck I love the 32Bit Adder
                LDA @lADDER32_R_LL
                STA BMP_PRSE_SRC_PTR
                LDA @lADDER32_R_HL
                STA BMP_PRSE_SRC_PTR+2
                RTS
;BMP_PRSE_DST_PTR = BMP_PRSE_DST_PTR + Screen_Stride
BMP_PARSER_COMPUTE_Y_DST
                setal
                CLC
                LDA BMP_PRSE_DST_PTR
                ADC BMP_X_SIZE ; use SCRN_X_STRIDE instead of BMP_X_SIZE if the data is send in the VRAM to get the pixed properly set on the curent BM mode ;ADC SCRN_X_STRIDE        ; In Normal Circumstances, it is 640
                STA BMP_PRSE_DST_PTR
                LDA BMP_PRSE_DST_PTR+2
                ADC #$0000
                STA BMP_PRSE_DST_PTR+2
                RTS

bmp_parser_err0 .text "NO SIGNATURE FOUND.", $00
bmp_parser_msg0 .text "BMP LOADED.", $00
bmp_parser_msg1 .text "EXECUTING BMP PARSER", $00
