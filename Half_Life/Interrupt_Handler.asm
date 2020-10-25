;////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////
; Interrupt Handler
;////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////////////////////////

check_irq_bit  .macro
                LDA \1
                AND #\2
                CMP #\2
                BNE END_CHECK
                STA \1
                JSR \3
END_CHECK
                .endm

check_irq_bit_2  .macro
                LDA \3  ; get the mask register value
                AND #\2 ; extract the Int mask value
                BNE END_CHECK ; exit id the IS isent activates, look like at the moment the INT bit is set regardless of the mask balue
                LDA \1
                AND #\2
                CMP #\2
                BNE END_CHECK
                STA \1
                JSR \4
END_CHECK
                .endm

IRQ_HANDLER
; First Block of 8 Interrupts
                .as
                setdp 0

                .as
                LDA #0  ; set the data bank register to 0
                PHA
                PLB
                LDA INT_PENDING_REG0
                BEQ CHECK_PENDING_REG1

; Mouse IRQ
                EMPTY_KBD_BUFFER
                check_irq_bit INT_PENDING_REG0, FNX0_INT07_MOUSE, MOUSE_INTERRUPT
                check_irq_bit_2 INT_PENDING_REG1, FNX1_INT00_KBD, INT_MASK_REG1, KEYBOARD_INTERRUPT

                LDA @lSTATUS_PORT
                BIT #1
                BNE EMPTY_KBD_BUFFER
; Start of Frame
                ;JSR SOL_INTERRUPT
                check_irq_bit_2 INT_PENDING_REG0, FNX0_INT00_SOF, INT_MASK_REG0, SOF_INTERRUPT
; Start of line
                ;check_irq_bit_2 INT_PENDING_REG0, FNX0_INT01_SOL, INT_MASK_REG0, SOL_INTERRUPT
; Timer 0
                check_irq_bit_2 INT_PENDING_REG0, FNX0_INT02_TMR0, INT_MASK_REG0, TIMER0_INTERRUPT
; FDC Interrupt
                ;check_irq_bit INT_PENDING_REG0, FNX0_INT06_FDC, FDC_INTERRUPT


; Second Block of 8 Interrupts
CHECK_PENDING_REG1
                setas
                LDA INT_PENDING_REG1
                BEQ CHECK_PENDING_REG2   ; BEQ EXIT_IRQ_HANDLE
; Keyboard Interrupt
                check_irq_bit_2 INT_PENDING_REG1, FNX1_INT00_KBD, INT_MASK_REG1, KEYBOARD_INTERRUPT
; COM2 Interrupt
                ;check_irq_bit INT_PENDING_REG1, FNX1_INT03_COM2, COM2_INTERRUPT
; COM1 Interrupt
                ;check_irq_bit INT_PENDING_REG1, FNX1_INT04_COM1, COM1_INTERRUPT
; MPU401 - MIDI Interrupt
                ;check_irq_bit INT_PENDING_REG1, FNX1_INT05_MPU401, MPU401_INTERRUPT
; LPT Interrupt
                ;check_irq_bit INT_PENDING_REG1, FNX1_INT06_LPT, LPT1_INTERRUPT

; Third Block of 8 Interrupts
CHECK_PENDING_REG2
                setas
                LDA INT_PENDING_REG2
                BEQ CHECK_PENDING_REG3

; OPL2 Right Interrupt
                ;check_irq_bit INT_PENDING_REG2, FNX2_INT00_OPL2R, OPL2R_INTERRUPT
; OPL2 Left Interrupt
                ;check_irq_bit INT_PENDING_REG2, FNX2_INT01_OPL2L, OPL2L_INTERRUPT

CHECK_PENDING_REG3
                setas
                LDA INT_PENDING_REG3
                BEQ EXIT_IRQ_HANDLE

EXIT_IRQ_HANDLE
                ; Exit Interrupt Handler

                RTL

; ****************************************************************
; ****************************************************************
;
;  KEYBOARD_INTERRUPT
;
; ****************************************************************
; ****************************************************************
; * Todo: rewrite this to use indirect or indexed jumps
KEYBOARD_INTERRUPT
                .as
                LDA @l $000060
                INC A
                INC A
                INC A
                INC A
                CMP #$30
                BNE no_clipping_1
                LDA #0
  no_clipping_1:  STA @l $000060
                STA SP01_ADDY_PTR_M

                LDA KBD_INPT_BUF        ; Get Scan Code from KeyBoard
                STA KEYBOARD_SC_TMP     ; Save Code Immediately
                AND #$7F ; get the key only and remove the pressed or relased state
        CHECK_W CMP #$11 ; W key
                BNE CHECK_A
                ;-------------------- W key process ----------------------------
                LDA KEYBOARD_SC_TMP ; get the original scan code back
                AND #$80 ; extract the key pressed or relased state
                CMP #$80
                BEQ KEY_W_RE
                LDA #1
                STA PLAYER_Y_MOV
                BRA KBD_DONE
      KEY_W_RE  LDA #0
                STA PLAYER_Y_MOV
                BRA KBD_DONE
                ;---------------------------------------------------------------
        CHECK_A CMP #$1E
                BNE CHECK_S
                ;-------------------- A key process ----------------------------
                LDA KEYBOARD_SC_TMP ; get the original scan code back
                AND #$80 ; extract the key pressed or relased state
                CMP #$80
                BEQ KEY_A_RE
                LDA #2
                STA PLAYER_X_MOV
                BRA KBD_DONE
      KEY_A_RE  LDA #0
                STA PLAYER_X_MOV
                BRA KBD_DONE
                ;---------------------------------------------------------------
        CHECK_S CMP #$1F
                BNE CHECK_D
                ;-------------------- S key process ----------------------------
                LDA KEYBOARD_SC_TMP ; get the original scan code back
                AND #$80 ; extract the key pressed or relased state
                CMP #$80
                BEQ KEY_S_RE
                LDA #2
                STA PLAYER_Y_MOV
                BRA KBD_DONE
      KEY_S_RE  LDA #0
                STA PLAYER_Y_MOV
                BRA KBD_DONE
                ;---------------------------------------------------------------
        CHECK_D CMP #$20
                BNE CHECK_SPACE
                ;-------------------- D key process ----------------------------
                LDA KEYBOARD_SC_TMP ; get the original scan code back
                AND #$80 ; extract the key pressed or relased state
                CMP #$80
                BEQ KEY_D_RE
                LDA #1
                STA PLAYER_X_MOV
                BRA KBD_DONE
      KEY_D_RE  LDA #0
                STA PLAYER_X_MOV
                BRA KBD_DONE
                ;---------------------------------------------------------------
        CHECK_SPACE
                CMP #$39
                BNE SKIP_KEY
                LDA #$1F
                BRA KBD_DONE

        SKIP_KEY
                LDA #$9F
        KBD_DONE
                ;JSR UPDATE_DISPLAY
                RTS
;
; ///////////////////////////////////////////////////////////////////
; ///
; /// Start of Frame Interrupt
; /// 60Hz, 16ms Cyclical Interrupt
; ///
; ///////////////////////////////////////////////////////////////////
SOF_INTERRUPT
                .as
                LDA @l $000061
                INC A
                INC A
                INC A
                INC A
                CMP #$30
                BNE no_clipping_2
                LDA #0
  no_clipping_2:  STA @l $000061
                STA SP02_ADDY_PTR_M
                ;-----
                .setal
                LDA @l $000064
                CLC
                ADC #64
                CMP #150+150*1-1
                BMI no_clipping_4
                LDA #150
  no_clipping_4:  STA @l $000064

                JSR TEST_MOUSE_MENUE_BUTON
                CMP #1

                ; CMP #1
                ; BEQ SOF_INTERRUPT__ACTIVE_SPRIT
                ; JSR DEACTIVE_SPTIR_MENU
                ; BRA SOF_INTERRUPT__SPRIT_DEACTIVATED
  SOF_INTERRUPT__ACTIVE_SPRIT:
                JSR Set_Sprit_256x64_Position_on_Screen ;
                JSR Set_Sprit_256x64_Pixel_position
                JSR ACTIVE_SPTIR_MENU
  SOF_INTERRUPT__SPRIT_DEACTIVATED:

                .setas
                ;JSR MOUSE_INTERRUPT
                ;check_irq_bit_2 INT_PENDING_REG0, FNX0_INT07_MOUSE, INT_MASK_REG0, MOUSE_INTERRUPT
                .setas
                ;-----
                LDA JOYSTICK0
                ;JSR UPDATE_DISPLAY

                ;.as
                ;JSR VGM_WRITE_REGISTER

                RTS

;
; ///////////////////////////////////////////////////////////////////
; ///
; /// Start of Line (Programmable)
; ///
; ///
; ///////////////////////////////////////////////////////////////////
SOL_INTERRUPT

                .as
                LDA @l $000062
                INC A
                INC A
                INC A
                INC A
                CMP #$30
                BNE no_clipping_3
                LDA #0
  no_clipping_3:  STA @l $000062
                STA SP03_ADDY_PTR_M
                ;LDA JOYSTICK0
                ;JSR UPDATE_DISPLAY
                RTS
;
; ****************************************************************
; ****************************************************************
; * Play VGM files
; ****************************************************************
; ****************************************************************
TIMER0_INTERRUPT
                .as
                                                          LDA @l $000066
                                                          INC A
                                                          INC A
                                                          INC A
                                                          INC A
                                                          CMP #$30
                                                          BNE no_clipping_6
                                                          LDA #0
                                                          no_clipping_6:  STA @l $000066
                                                          STA SP06_ADDY_PTR_M
                                                          LDA @l $000061
                                                          STA SP07_ADDY_PTR_M
                JSR VGM_WRITE_REGISTER
                RTS
;
; ///////////////////////////////////////////////////////////////////
; ///
; /// Mouse Interrupt
; /// Desc: Basically Assigning the 3Bytes Packet to Vicky's Registers
; ///       Vicky does the rest
; ///////////////////////////////////////////////////////////////////

MOUSE_INTERRUPT_2
                .as
                ; LDA @l $000065
                ; INC A
                ; INC A
                ; INC A
                ; INC A
                ; CMP #$30
                ; BNE no_clipping_5
                ; LDA #0
                ; no_clipping_5:  STA @l $000065
                ; STA SP05_ADDY_PTR_M
                RTS

MOUSE_INTERRUPT
                .as

                LDA @l $000065
                INC A
                INC A
                INC A
                INC A
                CMP #$30
                BNE no_clipping_5
                LDA #0
                no_clipping_5:  STA @l $000065
                STA SP05_ADDY_PTR_M


                LDA KBD_INPT_BUF
                PHA
                LDX #$0000
                setxs
                LDX MOUSE_PTR
                BNE MOUSE_BYTE_GT1

                ; copy the buttons to another address
                AND #%0111
                STA MOUSE_BUTTONS_REG

    MOUSE_BYTE_GT1
                PLA
                STA @lMOUSE_PTR_BYTE0, X
                INX
                CPX #$03
                BNE EXIT_FOR_NEXT_VALUE

                ; Create Absolute Count from Relative Input
                LDA @lMOUSE_PTR_X_POS_L
                STA MOUSE_POS_X_LO
                LDA @lMOUSE_PTR_X_POS_H
                STA MOUSE_POS_X_HI

                LDA @lMOUSE_PTR_Y_POS_L
                STA MOUSE_POS_Y_LO
                LDA @lMOUSE_PTR_Y_POS_H
                STA MOUSE_POS_Y_HI


                ; print the character on the upper-right of the screen
                ; this is temporary
                CLC
                LDA MOUSE_BUTTONS_REG

                JSR MOUSE_BUTTON_HANDLER

                LDX #$00
 EXIT_FOR_NEXT_VALUE
                STX MOUSE_PTR

                setxl
                RTS

MOUSE_BUTTON_HANDLER
                setas

                LDA @lMOUSE_BUTTONS_REG
                BEQ MOUSE_CLICK_DONE

                ; set the cursor position ( X/8 and Y/8 ) and enable blinking
                setal
                CLC
                LDA @lMOUSE_PTR_X_POS_L
                LSR
                LSR
                LSR
                STA CURSORX
                STA @lVKY_TXT_CURSOR_X_REG_L

                CLC
                LDA @lMOUSE_PTR_Y_POS_L
                LSR
                LSR
                LSR
                STA CURSORY
                STA @lVKY_TXT_CURSOR_Y_REG_L

                setas
                LDA #$03      ;Set Cursor Enabled And Flash Rate @1Hz
                STA @lVKY_TXT_CURSOR_CTRL_REG

MOUSE_CLICK_DONE
                RTS
;
; ///////////////////////////////////////////////////////////////////
; ///
; /// Floppy Controller
; /// Desc: Interrupt for Data Rx/Tx or Process Commencement or Termination
; ///
; ///////////////////////////////////////////////////////////////////
FDC_INTERRUPT   .as

;; PUT YOUR CODE HERE
                RTS
;
;
; ///////////////////////////////////////////////////////////////////
; ///
; /// Serial Port COM2
; /// Desc: Interrupt for Data Rx/Tx or Process Commencement or Termination
; ///
; ///////////////////////////////////////////////////////////////////
COM2_INTERRUPT  .as

;; PUT YOUR CODE HERE
                RTS
;
; ///////////////////////////////////////////////////////////////////
; ///
; /// Serial Port COM1
; /// Desc: Interrupt for Data Rx/Tx or Process Commencement or Termination
; ///
; ///////////////////////////////////////////////////////////////////
COM1_INTERRUPT  .as

;; PUT YOUR CODE HERE
                RTS
;
;
; ///////////////////////////////////////////////////////////////////
; ///
; /// Parallel Port LPT1
; /// Desc: Interrupt for Data Rx/Tx or Process Commencement or Termination
; ///
; ///////////////////////////////////////////////////////////////////
LPT1_INTERRUPT  .as

;; PUT YOUR CODE HERE
                RTS

NMI_HANDLER
                RTL


; ///////////////////////////////////////////////////////////////////
; ///
; /// Load SPRIT_X_SCREEN_START  and SPRIT_X_SCREEN_START then set
; /// all the sprit offset to display a 8*2 sprit grid
; ///
; ///////////////////////////////////////////////////////////////////
SPRIT_X_SCREEN_START .dword 64+31
SPRIT_Y_SCREEN_START .dword 150+32
Set_Sprit_256x64_Position_on_Screen:
            ; write the position of the sprit on the screen (640x480)
            TAX; save the menue block to display
            .setal
            LDA @l SPRIT_X_SCREEN_START
            STA SP01_X_POS_L
            CLC
            ADC #32
            STA SP02_X_POS_L
            ADC #32
            STA SP03_X_POS_L
            ADC #32
            STA SP04_X_POS_L
            ADC #32
            STA SP05_X_POS_L
            ADC #32
            STA SP06_X_POS_L
            ADC #32
            STA SP07_X_POS_L
            ADC #32
            STA SP08_X_POS_L

            LDA @l SPRIT_Y_SCREEN_START
            STA SP01_Y_POS_L
            STA SP02_Y_POS_L
            STA SP03_Y_POS_L
            STA SP04_Y_POS_L
            STA SP05_Y_POS_L
            STA SP06_Y_POS_L
            STA SP07_Y_POS_L
            STA SP08_Y_POS_L


            LDA @l SPRIT_X_SCREEN_START
            STA SP09_X_POS_L
            CLC
            ADC #32
            STA SP10_X_POS_L
            ADC #32
            STA SP11_X_POS_L
            ADC #32
            STA SP12_X_POS_L
            ADC #32
            STA SP13_X_POS_L
            ADC #32
            STA SP14_X_POS_L
            ADC #32
            STA SP15_X_POS_L
            ADC #32
            STA SP16_X_POS_L

            LDA @l SPRIT_Y_SCREEN_START
            CLC
            ADC #32
            STA SP09_Y_POS_L
            STA SP10_Y_POS_L
            STA SP11_Y_POS_L
            STA SP12_Y_POS_L
            STA SP13_Y_POS_L
            STA SP14_Y_POS_L
            STA SP15_Y_POS_L
            STA SP16_Y_POS_L
            TXA
            RTS

; ///////////////////////////////////////////////////////////////////
; ///
; /// Read the start address of the sprit set in VRAM (B0:0000).
; /// Each sprit is 32*32 so eache adfdress is incremented by 0x400
; /// to pint to eache individual sprit
; /// Use only _ADDY_PTR_L for now as all the Sprit fit in B2 banck
; ///
; ///////////////////////////////////////////////////////////////////
SPRIT_PIXEL_ADDRESS_START    .dword 0
Set_Sprit_256x64_Pixel_position:
            .setal
            LDA SPRIT_PIXEL_ADDRESS_START
            STA SP01_ADDY_PTR_L
            ADC #$400
            STA SP02_ADDY_PTR_L
            ADC #$400
            STA SP03_ADDY_PTR_L
            ADC #$400
            STA SP04_ADDY_PTR_L
            ADC #$400
            STA SP05_ADDY_PTR_L
            ADC #$400
            STA SP06_ADDY_PTR_L
            ADC #$400
            STA SP07_ADDY_PTR_L
            ADC #$400
            STA SP08_ADDY_PTR_L
            ADC #$400
            STA SP09_ADDY_PTR_L
            ADC #$400
            STA SP10_ADDY_PTR_L
            ADC #$400
            STA SP11_ADDY_PTR_L
            ADC #$400
            STA SP12_ADDY_PTR_L
            ADC #$400
            STA SP13_ADDY_PTR_L
            ADC #$400
            STA SP14_ADDY_PTR_L
            ADC #$400
            STA SP15_ADDY_PTR_L
            ADC #$400
            STA SP16_ADDY_PTR_L
            RTS

; ///////////////////////////////////////////////////////////////////
; ///
; /// Function testing the mouse position and set the sprit pointer
; /// source address and posistion on screen acording to where is the
; /// mouse
; ///
; ///////////////////////////////////////////////////////////////////
MOUSE_CROSSING_BUTON_AREA .dword 0; this variable is used to detect when the mouse is going in the buton area so we can start playing sond only one time instead of everytime the mouse is detected in the byton area
TEST_MOUSE_MENUE_BUTON:
              .setal
              LDA @l MOUSE_POS_X_LO
              TAX
              CMP #98 ; x min                           ; test if the mouse is far enoug from the left side of the screen
              BMI TEST_MOUSE_MENUE_BUTON__OUT_Temp
              LDA @l MOUSE_POS_Y_LO
              ;---------------------------------------- PLAY
              CMP #174 ; Play Y min
              BMI TEST_MOUSE_MENUE_BUTON__OUT_Temp
              CMP #191  ; play Y max
              BMI TEST_MOUSE_MENUE_BUTON__PLAY
              ;---------------------------------------- LOAD
              CMP #238 ; LOAD Y min
              BMI TEST_MOUSE_MENUE_BUTON__OUT_Temp
              CMP #255  ; LOAD Y max
              BMI TEST_MOUSE_MENUE_BUTON__LOAD
              ;---------------------------------------- OPTIONS
              CMP #300 ; OPTIONS Y min
              BMI TEST_MOUSE_MENUE_BUTON__OUT_Temp
              CMP #318  ; OPTIONS Y max
              BMI TEST_MOUSE_MENUE_BUTON__OPTIONS
              ;---------------------------------------- CREDIT
              CMP #366 ; CREDIT Y min
              BMI TEST_MOUSE_MENUE_BUTON__OUT_Temp
              CMP #383  ; CREDIT Y max
              BMI TEST_MOUSE_MENUE_BUTON__CREDITS
              ;---------------------------------------- EXIT
   TEST_MOUSE_MENUE_BUTON__OUT_Temp BRA TEST_MOUSE_MENUE_BUTON__OUT ; no Y position is with in a button shape

   TEST_MOUSE_MENUE_BUTON__PLAY:
              TXA
              CMP #187 ; x max for Play buton                           ; test if the mouse is far enoug from the left side of the screen
              BPL TEST_MOUSE_MENUE_BUTON__OUT
              LDA #$0000
              STA @l SPRIT_PIXEL_ADDRESS_START
              LDA #150+32
              STA @l SPRIT_Y_SCREEN_START
              BRA TEST_MOUSE_MENUE_BUTON__OUT_BUTON_DETECTED
   TEST_MOUSE_MENUE_BUTON__LOAD:
              TXA
              CMP #193 ; x max for Play buton                           ; test if the mouse is far enoug from the left side of the screen
              BPL TEST_MOUSE_MENUE_BUTON__OUT
              LDA #$4000
              STA @l SPRIT_PIXEL_ADDRESS_START
              LDA #150+32+64
              STA @l SPRIT_Y_SCREEN_START
              BRA TEST_MOUSE_MENUE_BUTON__OUT_BUTON_DETECTED
   TEST_MOUSE_MENUE_BUTON__OPTIONS:
              TXA
              CMP #267 ; x max for Play buton                           ; test if the mouse is far enoug from the left side of the screen
              BPL TEST_MOUSE_MENUE_BUTON__OUT
              LDA #$8000
              STA @l SPRIT_PIXEL_ADDRESS_START
              LDA #150+32+64*2
              STA @l SPRIT_Y_SCREEN_START
              BRA TEST_MOUSE_MENUE_BUTON__OUT_BUTON_DETECTED
   TEST_MOUSE_MENUE_BUTON__CREDITS:
              TXA
              CMP #262 ; x max for Play buton                           ; test if the mouse is far enoug from the left side of the screen
              BPL TEST_MOUSE_MENUE_BUTON__OUT
              LDA #$C000
              STA @l SPRIT_PIXEL_ADDRESS_START
              LDA #150+32+64*3
              STA @l SPRIT_Y_SCREEN_START
              BRA TEST_MOUSE_MENUE_BUTON__OUT_BUTON_DETECTED
              ; set and reset the mouse crossing area flag

   TEST_MOUSE_MENUE_BUTON__OUT_BUTON_DETECTED:
              LDA @l MOUSE_CROSSING_BUTON_AREA
              CMP #0
              BNE TEST_MOUSE_MENUE_BUTON__SOUND_ALREADDY_TRIGGERED
              JSR VGM_SET_SONG_POINTERS
              .setal
   TEST_MOUSE_MENUE_BUTON__SOUND_ALREADDY_TRIGGERED:
              JSR ACTIVE_SPTIR_MENU
              .setal
              LDA #1
              STA @l MOUSE_CROSSING_BUTON_AREA
              BRA TEST_MOUSE_MENUE_BUTON__EXIT
   TEST_MOUSE_MENUE_BUTON__OUT:
              JSR DEACTIVE_SPTIR_MENU
              .setal
              LDA #0 ; return 0 and reset the mouse entering area flag
              STA @l MOUSE_CROSSING_BUTON_AREA
   TEST_MOUSE_MENUE_BUTON__EXIT:
              RTS
; ///////////////////////////////////////////////////////////////////
ACTIVE_SPTIR_MENU:
              .setas
              ;LDA #0
              LDA #SPRITE_Enable +$00
              STA SP01_CONTROL_REG
              STA SP02_CONTROL_REG
              STA SP03_CONTROL_REG
              STA SP04_CONTROL_REG
              STA SP05_CONTROL_REG
              STA SP06_CONTROL_REG
              STA SP07_CONTROL_REG
              STA SP08_CONTROL_REG
              STA SP09_CONTROL_REG
              STA SP10_CONTROL_REG
              STA SP11_CONTROL_REG
              STA SP12_CONTROL_REG
              STA SP13_CONTROL_REG
              STA SP14_CONTROL_REG
              STA SP15_CONTROL_REG
              STA SP16_CONTROL_REG
              RTS
; ///////////////////////////////////////////////////////////////////
DEACTIVE_SPTIR_MENU:
              .setas
              LDA #0
              ;LDA #SPRITE_Enable +$00
              STA SP01_CONTROL_REG
              STA SP02_CONTROL_REG
              STA SP03_CONTROL_REG
              STA SP04_CONTROL_REG
              STA SP05_CONTROL_REG
              STA SP06_CONTROL_REG
              STA SP07_CONTROL_REG
              STA SP08_CONTROL_REG
              STA SP09_CONTROL_REG
              STA SP10_CONTROL_REG
              STA SP11_CONTROL_REG
              STA SP12_CONTROL_REG
              STA SP13_CONTROL_REG
              STA SP14_CONTROL_REG
              STA SP15_CONTROL_REG
              STA SP16_CONTROL_REG
              RTS
