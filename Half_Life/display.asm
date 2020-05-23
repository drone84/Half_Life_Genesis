INIT_DISPLAY
                .as
                ; set the display size - 128 x 64
                ;LDA #128
                ;STA COLS_PER_LINE
                ;LDA #64
                ;STA LINES_MAX

                ; set the visible display size - 80 x 60
                ;LDA #80
                ;STA COLS_VISIBLE
                ;LDA #60
                ;STA LINES_VISIBLE
                ;LDA #32
                ;STA BORDER_X_SIZE
                ;STA BORDER_Y_SIZE

                ; set the border to purple
                setas
                ;LDA #$20
                ;STA BORDER_COLOR_B
                ;STA BORDER_COLOR_R
                ;LDA #0
                ;STA BORDER_COLOR_G

                ; diable the border
                LDA #0
                STA BORDER_CTRL_REG

                ; enable graphics, tiles and sprites display
                LDA #Mstr_Ctrl_Graph_Mode_En + Mstr_Ctrl_Bitmap_En + Mstr_Ctrl_TileMap_En + Mstr_Ctrl_Sprite_En; + Mstr_Ctrl_Text_Mode_En + Mstr_Ctrl_Text_Overlay
                STA MASTER_CTRL_REG_L

                ; display intro screen
                ; wait for user to press a key or joystick button


                setaxl
                LDX #<>$0

                LDX #<>$0
                LDA #$0
              erase_Byte_00:
                STA @l $B00000,x
                INX
                CPX #0
                BNE erase_Byte_00
              erase_Byte_01:
                STA @l $B10000,x
                INX
                CPX #0
                BNE erase_Byte_01
              erase_Byte_02:
                STA @l $B20000,x
                INX
                CPX #0
                BNE erase_Byte_02
              erase_Byte_03:
                STA @l $B30000,x
                INX
                CPX #0
                BNE erase_Byte_03
              erase_Byte_04:
                STA @l $B40000,x
                INX
                CPX #0
                BNE erase_Byte_04
              erase_Byte_05:
                STA @l $B50000,x
                INX
                CPX #0
                BNE erase_Byte_05
              erase_Byte_06:
                STA @l $B60000,x
                INX
                CPX #0
                BNE erase_Byte_06
              erase_Byte_07:
                STA @l $B70000,x
                INX
                CPX #0
                BNE erase_Byte_07
              erase_Byte_08:
                STA @l $B80000,x
                INX
                CPX #0
                BNE erase_Byte_08
              erase_Byte_09:
                STA @l $B90000,x
                INX
                CPX #0
                BNE erase_Byte_09
              erase_Byte_0A:
                STA @l $BA0000,x
                INX
                CPX #0
                BNE erase_Byte_0A


                setaxl
                ; load LUT
                LDX #<>PALETTE
                LDY #<>GRPH_LUT0_PTR
                LDA #1024
                MVN <`PALETTE,<`GRPH_LUT0_PTR

                LDX #<>PALETTE
                LDY #<>GRPH_LUT1_PTR
                LDA #1024
                MVN <`PALETTE,<`GRPH_LUT1_PTR

                LDX #<>PALETTE_TILE_SET_LEVEL_0
                LDY #<>GRPH_LUT2_PTR
                LDA #1024
                MVN <`PALETTE_TILE_SET_LEVEL_0,<`GRPH_LUT2_PTR

                LDX #<>SPRIT_GORDON_SCIENTIST_PAL
                LDY #<>GRPH_LUT3_PTR
                LDA #1024
                MVN <`SPRIT_GORDON_SCIENTIST_PAL,<`GRPH_LUT3_PTR
                ; load the tiles pixel extracted from the BMP to the VRAM from @B0:0000
                ; Load the Pixel
                ;---------------------- B0
                setaxl
                LDX #<>TILE_SET_LEVEL_0_PIXEL+1
                LDY #0
                LDA #$8000 ; 256 * 128 - this is 8 rows of tiles
                MVN <`TILE_SET_LEVEL_0_PIXEL,$B0

                ; load the strit pixel extracted from the BMP to the VRAM from @B1:0000
                ; Load the Pixel
                ;---------------------- B1
                setaxl
                LDX #<>SPRIT_GORDON_SCIENTIST_PIXEL+1
                LDY #0
                LDA #$0400 ; 32 * 32
                MVN <`SPRIT_GORDON_SCIENTIST_PIXEL,$B1

                ;-----------------------------------------------------------------
                ;Load the menue graphics
                ;---------------------- B2
                setaxl
                LDA #256
                STA @l SPRIT_SIZE_TILE_X
                LDA #64
                STA @l SPRIT_SIZE_TILE_Y
                LDA#<>MENU_PLAY + $80000
                STA @l SPRIT_SRC
                LDA #`MENU_PLAY + $80000
                STA @l SPRIT_SRC+2
                LDA #$0000
                STA @l SPRIT_DES
                LDA #$00B2
                STA @l SPRIT_DES+2
                JSR LOAD_TILED_SPRITES
                .setas


                LDA #02
                STA SP01_ADDY_PTR_H
                STA SP02_ADDY_PTR_H
                STA SP03_ADDY_PTR_H
                STA SP04_ADDY_PTR_H
                STA SP05_ADDY_PTR_H
                STA SP06_ADDY_PTR_H
                STA SP07_ADDY_PTR_H
                STA SP08_ADDY_PTR_H
                STA SP09_ADDY_PTR_H
                STA SP10_ADDY_PTR_H
                STA SP11_ADDY_PTR_H
                STA SP12_ADDY_PTR_H
                STA SP13_ADDY_PTR_H
                STA SP14_ADDY_PTR_H
                STA SP15_ADDY_PTR_H
                STA SP16_ADDY_PTR_H

                ; write the position of the sprit on the screen (640x480)
                .setal
                LDA #$0
                STA SP01_X_POS_L
                LDA #$0
                STA SP01_Y_POS_L
                LDA #$20
                STA SP02_X_POS_L
                LDA #$0
                STA SP02_Y_POS_L
                LDA #$40
                STA SP03_X_POS_L
                LDA #$0
                STA SP03_Y_POS_L
                LDA #$60
                STA SP04_X_POS_L
                LDA #0
                STA SP04_Y_POS_L
                LDA #$80
                STA SP05_X_POS_L
                LDA #$0
                STA SP05_Y_POS_L
                LDA #$A0
                STA SP06_X_POS_L
                LDA #$0
                STA SP06_Y_POS_L
                LDA #$C0
                STA SP07_X_POS_L
                LDA #0
                STA SP07_Y_POS_L
                LDA #$E0
                STA SP08_X_POS_L
                LDA #0
                STA SP08_Y_POS_L
        				LDA #$0
                STA SP09_X_POS_L
                LDA #$20
                STA SP09_Y_POS_L
                LDA #$20
                STA SP10_X_POS_L
                LDA #$20
                STA SP10_Y_POS_L
                LDA #$40
                STA SP11_X_POS_L
                LDA #$20
                STA SP11_Y_POS_L
                LDA #$60
                STA SP12_X_POS_L
                LDA #$20
                STA SP12_Y_POS_L
                LDA #$80
                STA SP13_X_POS_L
                LDA #$20
                STA SP13_Y_POS_L
                LDA #$A0
                STA SP14_X_POS_L
                LDA #$20
                STA SP14_Y_POS_L
                LDA #$C0
                STA SP15_X_POS_L
                LDA #$20
                STA SP15_Y_POS_L
                LDA #$E0
                STA SP16_X_POS_L
                LDA #$20
                STA SP16_Y_POS_L

                .setas
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
                .setal
                LDA #64
                STA SPRIT_X_SCREEN_START
                LDA #150
                STA SPRIT_Y_SCREEN_START

                ; Load the Pixel extracted from the BMP to the VRAM from @B6:0000
                ;---------------------- B6
                LDX #<>HL_PIXEL
                LDY #<>$B60000
                LDA #$8000
                MVN <`HL_PIXEL,<`$B60000

                LDX #<>HL_PIXEL + $8000
                LDY #<>$B68000
                LDA #$8000
                MVN <`HL_PIXEL,<`$B68000
                ;---------------------- B7
                LDX #<>HL_PIXEL + $10000
                LDY #<>$B70000
                LDA #$8000
                MVN <`HL_PIXEL + $10000,<`$B70000

                LDX #<>HL_PIXEL + $18000
                LDY #<>$B78000
                LDA #$8000
                MVN <`HL_PIXEL + $18000,<`$B78000
                ;---------------------- B8
                LDX #<>HL_PIXEL + $20000
                LDY #<>$B80000
                LDA #$8000
                MVN <`HL_PIXEL + $20000,<`$B80000

                LDX #<>HL_PIXEL + $28000
                LDY #<>$B88000
                LDA #$8000
                MVN <`HL_PIXEL + $28000,<`$B88000
                ;---------------------- B9
                LDX #<>HL_PIXEL + $30000
                LDY #<>$B90000
                LDA #$8000
                MVN <`HL_PIXEL  + $30000,<`$B90000

                LDX #<>HL_PIXEL + $38000
                LDY #<>$B98000
                LDA #$8000
                MVN <`HL_PIXEL + $38000,<`$B98000
                ;---------------------- BA
                LDX #<>HL_PIXEL + $40000
                LDY #<>$BA0000
                LDA #$B000 ; left over of the picture's pixel
                MVN <`HL_PIXEL + $40000,<`$BA0000
                ;----------------------

                ; enable the bitmap engine
                setas
                LDA #1+2
                STA @l BM_CONTROL_REG

                LDA #00
                STA @l BM_START_ADDY_L
                STA @l BM_START_ADDY_M
                LDA #06
                STA @l BM_START_ADDY_H

                setal
                LDA #640
                STA @l BM_X_SIZE_L
                LDA #480
                STA @l BM_Y_SIZE_L

                ; enable the tile engine 0
                setas
                LDA #TILE_Enable + $4 + TILESHEET_256x256_En
                STA @lTL0_CONTROL_REG
                STA @lTL1_CONTROL_REG
                ; enable tiles
                ;LDA #TILE_Enable + TILESHEET_256x256_En
                ;STA @lTL0_CONTROL_REG

                ; load tileset
                JSR LOAD_TILE_MAP_0
                JSR LOAD_TILE_MAP_1

                ; enable the sprit engine
                ; set the address of the sprit in the VRAM from VICKY point of vue
                LDA #00
                STA SP00_ADDY_PTR_L
                STA SP00_ADDY_PTR_M
                LDA #01
                STA SP00_ADDY_PTR_H
                ; write the position of the sprit on the screen (640x480)
                setal
                LDA PLAYER_X
                STA SP00_X_POS_L
                LDA PLAYER_Y
                STA SP00_Y_POS_L

                ; active the sprit 0
                LDA #SPRITE_Enable +$04
                STA SP00_CONTROL_REG


                ; render the first frame
                ;JSR LOAD_SPRITES

                ;JSR INIT_PLAYER
                ;JSR INIT_NPC

                ;LDA #$9F ; - joystick in initial state
                ;JSR UPDATE_DISPLAY
                RTS

; *********************************************************
; * Copy the Tile map into the tile map register area
; *********************************************************
;NB_TILE_MAP_X = 3
;NB_TILE_MAP_Y = 2
;CURENT_TILE_MAP_X = 0
;CURENT_TILE_MAP_Y = 0

LOAD_TILE_MAP_0
                .setaxl
                ; the tile map is saved as:
                ; @ XX:4B0*X_size*0 : X0:Y0 X1:Y0 X2:Y0 X3:Y0
                ; @ XX:4B0*X_size*1 : X0:Y1 X1:Y1 X2:Y1 X3:Y1
                ; @ XX:4B0*X_size*2 : X0:Y1 X1:Y1 X2:Y1 X3:Y1
                ; comput the Y ofset
                LDA #40*30 ; tile map size
                STA @l M0_OPERAND_A
                LDA @l NB_TILE_MAP_X
                STA @l M0_OPERAND_B
                LDA @l M0_RESULT ; we know how many X block we need to skyp to advamce from one line only
                STA @l M0_OPERAND_A
                LDA @l CURENT_TILE_MAP_Y
                STA @l M0_OPERAND_B
                LDA @l M0_RESULT ; now we have the Y offset computed
                TAX
                ; Comput the ofset in the X direction
                LDA #40*30 ; tile map size
                STA @l M0_OPERAND_A
                LDA @l CURENT_TILE_MAP_X
                STA @l M0_OPERAND_B
                LDA @l M0_RESULT
                ; add the to ofset to get the addreess of the right map to load
                STA @l ADDER_A
                TXA
                STA @l ADDER_B
                LDA @l ADDER_R ; now we have the rightr offset in the tile map
                ; lets comput the ofset to use with LDA
                ; BRA LOAD_TILE_MAP_0
                STA @l ADDER_A
                LDA #<>game_board_0
                STA LOAD_TILE_MAP_0_LDA_INSTR+1
                STA @l ADDER_B
                LDA @l ADDER_R
                STA LOAD_TILE_MAP_0_LDA_INSTR+1
                ; the 16bits ofset is recomputed
                LDX #0
                LDY #0
                setdbr $AF
                setas
    GET_TILE_0
    LOAD_TILE_MAP_0_LDA_INSTR:
                LDA game_board_0,X
                STA TILE_MAP0,Y
                INY
                setal
                TYA
                AND #$3F
                CMP #40 ; 1 line is 40 tile
                BNE LT_NEXT_TILE_0
                TYA
                CLC
                ADC #24
                TAY

    LT_NEXT_TILE_0
                setas
                INX
                CPX #(640/16) * (480 / 16)
                BNE GET_TILE_0
                RTS
;
; *********************************************************
; * Copy the Tile map into the tile map register area
; *********************************************************
LOAD_TILE_MAP_1
                .setaxl
                ; the tile map is saved as:
                ; @ XX:4B0*X_size*0 : X0:Y0 X1:Y0 X2:Y0 X3:Y0
                ; @ XX:4B0*X_size*1 : X0:Y1 X1:Y1 X2:Y1 X3:Y1
                ; @ XX:4B0*X_size*2 : X0:Y1 X1:Y1 X2:Y1 X3:Y1
                ; comput the Y ofset
                LDA #40*30 ; tile map size
                STA @l M0_OPERAND_A
                LDA @l NB_TILE_MAP_X
                STA @l M0_OPERAND_B
                LDA @l M0_RESULT ; we know how many X block we need to skyp to advamce from one line only
                STA @l M0_OPERAND_A
                LDA @l CURENT_TILE_MAP_Y
                STA @l M0_OPERAND_B
                LDA @l M0_RESULT ; now we have the Y offset computed
                TAX
                ; Comput the ofset in the X direction
                LDA #40*30 ; tile map size
                STA @l M0_OPERAND_A
                LDA @l CURENT_TILE_MAP_X
                STA @l M0_OPERAND_B
                LDA @l M0_RESULT
                ; add the to ofset to get the addreess of the right map to load
                STA @l ADDER_A
                TXA
                STA @l ADDER_B
                LDA @l ADDER_R ; now we have the rightr offset in the tile map
                ; lets comput the ofset to use with LDA
                ; BRA LOAD_TILE_MAP_0
                STA @l ADDER_A
                LDA #<>game_board_1
                STA LOAD_TILE_MAP_1_LDA_INSTR+1
                STA @l ADDER_B
                LDA @l ADDER_R
                STA LOAD_TILE_MAP_1_LDA_INSTR+1
                ; the 16bits ofset is recomputed
                LDX #0
                LDY #0
                setdbr $AF
                setas
    GET_TILE_1
    LOAD_TILE_MAP_1_LDA_INSTR:
                LDA game_board_1,X
                STA TILE_MAP1,Y
                INY
                setal
                TYA
                AND #$3F
                CMP #40 ; 1 line is 40 tile
                BNE LT_NEXT_TILE_1
                TYA
                CLC
                ADC #24
                TAY

    LT_NEXT_TILE_1
                setas
                INX
                CPX #(640/16) * (480 / 16)
                BNE GET_TILE_1
                RTS
; *************************************************************
; Load tiled sprite in VRAM
; *************************************************************
; input
SPRIT_SIZE_TILE_X .word $0 ; the size of the pictur in pixel
SPRIT_SIZE_TILE_Y .word $0
SPRIT_SRC .dword 0        ; address where to get and load the sata
SPRIT_DES .dword 0

; variable to reset / set every time the function is used
CURENT_SPRIT_X_LINE .word 0 ; curent line beeing copyed, it gos from 0 to 31

SPRIT_NB_TILE_X .word $0  ; the number of Sprit. SPRIT_SIZE_TILE/32
SPRIT_NB_TILE_Y .word $0
SPRIT_X_LEFT .word 0
SPRIT_Y_LEFT .word 0

SPRIT_X_TEMP .word $0  ; Will save the previous X position where we started the copy the data

LOAD_TILED_SPRITES
                ;---------------------------------------------------------------
                ; reset variable
                ;---------------------------------------------------------------
                .setaxl
                LDA #0
                STA @l CURENT_SPRIT_X_LINE
                ; set sprit X size so we can jump from one x line to an other one
                LDA @l SPRIT_SIZE_TILE_X
                STA @l LOAD_TILED_SPRITES_ADC_1+1
                LSR
                LSR
                LSR
                LSR
                LSR
                STA @l SPRIT_NB_TILE_X ; constant needed to reset CURENT_SPRIT_X when the first line of sprit is copyed
                STA @l SPRIT_X_LEFT
                ; set sprit Y size so we can jump from one x line to an other one
                LDA @l SPRIT_SIZE_TILE_Y
                LSR
                LSR
                LSR
                LSR
                LSR
                STA @l SPRIT_NB_TILE_Y
                STA @l SPRIT_Y_LEFT
                ;---------------------------------------------------------------
                ; set the source and destination page of the sprit
                ;---------------------------------------------------------------
                setas
                LDA @l SPRIT_SRC+2
                STA @l LOAD_TILED_SPRITES_NVM +2
                LDA @l SPRIT_DES+2
                STA @l LOAD_TILED_SPRITES_NVM +1
                setal
                ;---------------------------------------------------------------
                ; load the address low of the sprit
                ;---------------------------------------------------------------
                LDA @l SPRIT_SRC
                TAX
                LDA @l SPRIT_DES
                TAY

                ;---------------------------------------------------------------
                ;---------------------------------------------------------------
                ;---------------------------------------------------------------
                ;---------------------------------------------------------------
                ;---------------------------------------------------------------
    LOAD_TILED_SPRITES__CPY_X_LINE:
                TXA
                STA @l SPRIT_X_TEMP
                LDA #32-1 ; load the single sprit size

        LOAD_TILED_SPRITES_NVM:
                MVN 00,#$B0
                ;---------------------------------------------------------------
                ;------------------ update the  buffer address -----------------
                ;---------------------------------------------------------------
                ;------ Source
                ;TXA
                LDA @l SPRIT_X_TEMP ; save the previous X position so if we have to load the next line we just need to do Xpos +32 and we have the next address to copy from
                CLC
        LOAD_TILED_SPRITES_ADC_1:
                ADC #$CAFE ; the value CAFE need to be changed to the sprit x size !!! evey loop the source buffer point to the next line
                TAX
                ;------ Destination, just need to be incremented by 32 every time
                ;;TYA
              ;;  CLC
                ;;ADC #32 ;
              ;;  TAY
                ;---------------------------------------------------------------
                ; test if all the sprit line is copyed
                ;---------------------------------------------------------------
                LDA @l CURENT_SPRIT_X_LINE
                INC A
                CMP #32
                STA @l CURENT_SPRIT_X_LINE
                BNE LOAD_TILED_SPRITES__CPY_X_LINE
                ;---------------------------------------------------------------
                ; reset the line counter
                ;---------------------------------------------------------------
                LDA #0
                STA @l CURENT_SPRIT_X_LINE
                ;---------------------------------------------------------------
                ; update the x ofset to copy the next sprit
                ; so we are readding the next sprit
                LDA @l SPRIT_SRC
                CLC
                ADC #32 ; get the next sprit
                STA @l SPRIT_SRC
                TAX
                ; no need to update the destination buffer at is automaticaly incremented by 32
                ;---------------------------------------------------------------
                ; test if we stilll have sprit on the curent line
                ;---------------------------------------------------------------
                LDA @l SPRIT_X_LEFT
                DEC A
                STA @l SPRIT_X_LEFT
                CMP #0
                BNE LOAD_TILED_SPRITES__CPY_X_LINE
                ;---------------------------------------------------------------
                ; get the previous X adress and add 32 so we are pointing to the next line
                ;---------------------------------------------------------------
                LDA @l SPRIT_X_TEMP
                CLC
                ADC #32 ; get the next sprit
                STA @l SPRIT_SRC ; save the address of the new line of sprit to copy
                TAX
                ;---------------------------------------------------------------
                ; Reset the X sprit counter wo we are copying a new line of X sprit
                ;---------------------------------------------------------------
                LDA @l SPRIT_NB_TILE_X
                STA @l SPRIT_X_LEFT
                ;---------------------------------------------------------------
                ; test if we stilll have a new line to copy
                ;---------------------------------------------------------------
                LDA @l SPRIT_Y_LEFT
                DEC A
                STA @l SPRIT_Y_LEFT
                CMP #0
                BNE LOAD_TILED_SPRITES__CPY_X_LINE
                RTS
; *************************************************************
;
; *************************************************************
LOAD_SPRITES
                .as

                LDA #0
                STA sprite_addr
                LDA #$B1
                STA sprite_addr + 2

                XBA
                LDX #0  ; X increments in steps of 8
    LS_LOOP
                ; enable sprites
                LDA #0
                STA @lSP00_ADDY_PTR_L,X
                LDA #SPRITE_Enable
                STA @lSP00_CONTROL_REG,X
                STA @lSP00_ADDY_PTR_H,X
                TXA
                LSR
                STA @lSP00_ADDY_PTR_M,X
                STA sprite_addr + 1
                ASL

                JSR READ_SPRITE

                CLC
                ADC #8
                TAX
                CPX #128
                BNE LS_LOOP

                RTS

; *************************************************************
; * Read a sprite from tile memory
; *************************************************************
sprite_line    = $6
sprite_addr    = $10
READ_SPRITE
                .as
                PHA
                setal
                ; in our tileset, we have 8 sprites per line
                LDA game_array+6,X ; 0 to 15
                AND #$7
                asl
                asl
                asl
                asl ; multiply by 32
                asl
                STA sprite_line
                LDA game_array+6,X ; 0 to 15
                AND #8
                BEQ LOAD_X

                LDA #$2000 ; add 32 lines at 256 pixels

        LOAD_X
                CLC
                ADC sprite_line
                TAX

                LDA #32 ; sprites are 32 lines high
                STA sprite_line


    NEXT_LINE

                LDY #0

        NEXT_PIXEL
                setas
                LDA TILES + 256 * 32,X
                STA [sprite_addr],Y
                INX
                INY
                CPY #32 ; sprites are 32 pixels wide
                BNE NEXT_PIXEL
                setal
                TXA
                CLC
                ADC #256-32
                TAX

                LDA sprite_addr
                CLC
                ADC #32
                STA sprite_addr

                DEC sprite_line
                BNE NEXT_LINE
                LDA #0

                setas
                PLA
                RTS

; *************************************************************
; * Initialize player position
; *************************************************************
INIT_PLAYER
                ; start at position (100,100)
                setal
                LDA #8 * 32 + 32
                STA PLAYER_X
                STA @lSP15_X_POS_L
                LDA #10 * 32 + 64
                STA PLAYER_Y
                STA @lSP15_Y_POS_L
                setas
                RTS

; *************************************************************
; * Initialize non-player components, from the game_array
; *************************************************************
INIT_NPC
                .as
                setal
                LDX #0

        INIT_NPC_LOOP
                LDA game_array + 2,X ; X POSITION
                STA @lSP00_X_POS_L,X
                LDA game_array + 4,X ; Y POSITION
                STA @lSP00_Y_POS_L,X

                TXA
                CLC
                ADC #8
                TAX
                CPX #120
                BNE INIT_NPC_LOOP

                setas
                RTS

; ****************************************************
; * A contains the joystick byte
; ****************************************************
UPDATE_DISPLAY
                .as
                ;PHA
                ;JSR UPDATE_HOME_TILES
                ;JSR UPDATE_WATER_TILES
                ;PLA
                setal

        JOY_UP
                LDA PLAYER_Y_MOV
                CMP #1 ; up
                BNE JOY_DOWN
                LDA #0
                ;STA PLAYER_Y_MOV
                JSR PLAYER_MOVE_UP
                BRA JOY_LEFT

        JOY_DOWN
                CMP #2 ; down
                BNE JOY_LEFT
                LDA #0
                ;STA PLAYER_Y_MOV
                JSR PLAYER_MOVE_DOWN


                ; BRA JOY_DONE i want to test the left/right key aswell

        JOY_LEFT
                LDA PLAYER_X_MOV
                CMP #2
                BNE JOY_RIGHT
                LDA #0
                ;STA PLAYER_X_MOV
                JSR PLAYER_MOVE_LEFT
                BRA JOY_DONE

        JOY_RIGHT
                CMP #1
                BNE JOY_DONE
                LDA #0
                ;STA PLAYER_X_MOV
                JSR PLAYER_MOVE_RIGHT
                BRA JOY_DONE

        JOY_DONE
                setas
                ;JSR UPDATE_NPC_POSITIONS
                ;JSR COLLISION_CHECK
                RTS

; ****************************************************
; * Update non-players
; ****************************************************
UPDATE_NPC_POSITIONS
                .as
                setal
                LDX #0

        UNPC_LOOP
                LDA game_array + 2,X ; X POSITION
                CLC
                ADC game_array,X ; add the speed
                BCC GRT_LFT_MRG

                CMP #16
                BCS GRT_LFT_MRG
                LDA #640-32 ; right edge
                BRA LESS_RGT_MRG

        GRT_LFT_MRG
                CMP #640 - 32
                BCC LESS_RGT_MRG
                LDA #0

        LESS_RGT_MRG
                STA @lSP00_X_POS_L,X
                STA game_array + 2,X


                TXA
                CLC
                ADC #8
                TAX
                CPX #120
                BNE UNPC_LOOP

                setas
                RTS

; ********************************************
; * Player movements
; ********************************************
PLAYER_MOVE_DOWN
                .al
                LDA @l PLAYER_Y
                CLC
                ADC #2
                ; check for collisions and out of screen
                CMP #480 - 32
                BCC PMD_DONE
                ; load the new tile map and replace the player
                LDA @l CURENT_TILE_MAP_Y;
                CLC
                ADC #1
                CMP NB_TILE_MAP_Y
                BNE PMD_NO_NEED_TO_CLEEP
                SEC
                SBC #1
        PMD_NO_NEED_TO_CLEEP:
                STA @l CURENT_TILE_MAP_Y;
                .setal
                JSR LOAD_TILE_MAP_0
                .setal
                JSR LOAD_TILE_MAP_1
                LDA #2 ;LDA #480 - 32 ; the lowest position on screen
        PMD_DONE
                STA @l PLAYER_Y
                STA @l SP00_Y_POS_L
                RTS

PLAYER_MOVE_UP
                LDA @l PLAYER_Y
                SEC
                SBC #2
                ; check for collisions and out of screen
                CMP #02
                BCS PMU_DONE
                ; load the new tile map and replace the player
                LDA @l CURENT_TILE_MAP_Y;
                SEC
                SBC #1
                CMP #$FFFF
                BNE PMU_NO_NEED_TO_CLEEP
                LDA #0
       PMU_NO_NEED_TO_CLEEP:
                STA @l CURENT_TILE_MAP_Y;
                .setal
                JSR LOAD_TILE_MAP_0
                .setal
                JSR LOAD_TILE_MAP_1
                .setal
                LDA #480 - 32; LDA #02

        PMU_DONE
                STA @l PLAYER_Y
                STA @l SP00_Y_POS_L
                RTS

PLAYER_MOVE_RIGHT
                LDA @l PLAYER_X
                CLC
                ADC #2
                ; check for collisions and out of screen
                CMP #640-16
                BCC PMR_DONE
                ; load the new tile map and replace the player
                LDA @l CURENT_TILE_MAP_X;
                CLC
                ADC #1
                CMP NB_TILE_MAP_X
                BNE PMR_NO_NEED_TO_CLEEP
                SEC
                SBC #1
       PMR_NO_NEED_TO_CLEEP:
                STA @l CURENT_TILE_MAP_X;
                .setal
                JSR LOAD_TILE_MAP_0
                .setal
                JSR LOAD_TILE_MAP_1
                .setal
                LDA #2 ;LDA #640-16 ; the lowest position on screen

        PMR_DONE
                STA @l PLAYER_X
                STA @l SP00_X_POS_L
                RTS

PLAYER_MOVE_LEFT
                LDA @l PLAYER_X
                SEC
                SBC #2
                ; check for collisions and out of screen
                CMP #02
                BCS PML_DONE
                ; load the new tile map and replace the player
                LDA @l CURENT_TILE_MAP_X;
                SEC
                SBC #1
                CMP #$FFFF
                BNE PLAYER_MOVE_LEFT_NO_NEED_TO_CLEEP
                LDA #0
       PLAYER_MOVE_LEFT_NO_NEED_TO_CLEEP:
                STA @l CURENT_TILE_MAP_X;
                .setal
                JSR LOAD_TILE_MAP_0
                .setal
                JSR LOAD_TILE_MAP_1
                .setal
                LDA #640 - 32; LDA #02

        PML_DONE
                STA @l PLAYER_X
                STA @l SP00_X_POS_L
                RTS

; *****************************************************************
; * Compare the location of each sprite with the player's position
; * Sprites are 32 x 32 so the math is pretty simple.
; * Collisions occur with cars and buses and with water.
; * Frog can hop on logs.
; *****************************************************************
COLLISION_CHECK
                .as
                setal
                LDA PLAYER_Y
                CMP #256 ; mid-screen

                BCC WATER_COLLISION
                JSR STREET_COLLISION
                setas
                RTS

        WATER_COLLISION
                .al
        ; here do the water collision routine
                CMP #224
                BCS CCW_DONE

                CMP #128
                BCC HOME_LINE

                LDX #0

        NEXT_WATER_ROW
                LDA game_array+4,X  ; read the Y position
                CMP PLAYER_Y
                BNE CCW_CONTINUE

                LDA PLAYER_X
                CMP game_array+2,X  ; read the X position
                BEQ FLOAT
                BCC CHECK_RIGHT_BOUND_W
        CHECK_LEFT_BOUND_W
                LDA game_array+2,X
                ADC #32
                CMP PLAYER_X
                BCS FLOAT
                BRA CCW_CONTINUE
        CHECK_RIGHT_BOUND_W
                ADC #32
                CMP game_array+2,X  ; read the X position
                BCS FLOAT


        CCW_CONTINUE
                TXA
                CLC
                ADC #8
                TAX
                CPX #8*16-8
                BNE NEXT_WATER_ROW
                BRA COLLISION

        CCW_DONE
                setas
                RTS

        FLOAT
                .al
                ; move the frog with the NPC
                CLC
                LDA PLAYER_X
                ADC game_array,X
                CMP #32
                BCC COLLISION
                CMP #640-32
                BCS COLLISION

                STA PLAYER_X
                STA SP15_X_POS_L
                setas
                RTS

        HOME_LINE
                .al
                LDA PLAYER_X
                LSR
                LSR
                LSR
                LSR ; divide by 16
                TAX
                setas
                LDA game_board + 280,X
                AND #$FF
                CMP #'H'
                BNE COLLISION

                setas
                RTS

        COLLISION
                .al
                ; restart the player at first row
                setas
                JSR INIT_PLAYER
                RTS

STREET_COLLISION
                .al
                LDX #0
        NEXT_STREET_ROW
                LDA game_array+4,X  ; read the Y position
                CMP PLAYER_Y
                BNE CCS_CONTINUE

                LDA PLAYER_X
                CMP game_array+2,X  ; read the X position

                BEQ COLLISION
                BCC CHECK_RIGHT_BOUND
        CHECK_LEFT_BOUND
                LDA game_array+2,X
                ADC #32
                CMP PLAYER_X
                BCS COLLISION
                BRA CCS_CONTINUE

        CHECK_RIGHT_BOUND
                ADC #32
                CMP game_array+2,X  ; read the X position
                BCS COLLISION

        CCS_CONTINUE
                TXA
                CLC
                ADC #8
                TAX
                CPX #8*16-8
                BNE NEXT_STREET_ROW
        CC_DONE
                setas
                RTS

HOME_CYCLE      .byte 0
EVEN_TILE_VAL   .byte $12
ODD_TILE_VAL    .byte $13
UPDATE_HOME_TILES
                .as
                ; alternate the HOME tiles to imitate wind motion
                LDA HOME_CYCLE
                INC A
                CMP #15 ; only update every N SOF cycle
                BNE UT_SKIP
                LDA #0
                STA HOME_CYCLE

                LDX #280 ; line 8 in the game board`
                LDY #7 * 64 ; line 8 in the tileset
                setdbr $AF

        UT_GET_TILE
                LDA game_board,X
                CMP #'H'
                BNE UT_DONE

                TXA
                AND #1
                BEQ UT_EVEN_TILE
                LDA EVEN_TILE_VAL

                STA TILE_MAP0,Y
                BRA UT_DONE

        UT_EVEN_TILE
                LDA ODD_TILE_VAL
                STA TILE_MAP0,Y

        UT_DONE
                INY
                INX
                CPX #320
                BNE UT_GET_TILE

                ; alternate the tiles
                LDA EVEN_TILE_VAL
                CMP #$12
                BEQ ALT_ODD
                ; A is $13
                STA ODD_TILE_VAL
                LDA #$12
                STA EVEN_TILE_VAL
                RTS

        ALT_ODD
                ; A is 12
                STA ODD_TILE_VAL
                LDA #$13
                STA EVEN_TILE_VAL

                RTS

    UT_SKIP
                STA HOME_CYCLE
                RTS



WATER_CYCLE     .byte 0
EVEN_WTILE_VAL  .byte $4
ODD_WTILE_VAL   .byte $14
UPDATE_WATER_TILES
                .as
                ; alternate the HOME tiles to imitate wind motion
                LDA WATER_CYCLE
                INC A
                CMP #12 ; only update every N SOF cycle
                BNE UW_SKIP
                LDA #0
                STA WATER_CYCLE

                LDX #8 * 40 ; line 9 in the game board`
                LDY #8 * 64 ; line 8 in the tileset
                setdbr $AF

        UW_GET_TILE
                LDA game_board,X
                CMP #'W'
                BNE UW_DONE

                ;check if X is even/odd
                TXA
                AND #1
                BEQ UW_EVEN_TILE
                LDA EVEN_WTILE_VAL

                STA TILE_MAP0,Y
                BRA UW_DONE

        UW_EVEN_TILE
                LDA ODD_WTILE_VAL
                STA TILE_MAP0,Y

        UW_DONE
                INY
                setal
                TYA
                AND #$3F
                CMP #40
                BNE WT_NEXT_TILE
                TYA
                CLC
                ADC #24
                TAY

    WT_NEXT_TILE
                setas

                INX
                CPX #14 * 40
                BNE UW_GET_TILE

                ; alternate the tiles
                LDA EVEN_WTILE_VAL
                CMP #4
                BEQ W_ALT_ODD
                ; A is $14
                STA ODD_WTILE_VAL
                LDA #$4
                STA EVEN_WTILE_VAL
                RTS

        W_ALT_ODD
                ; A is 4
                STA ODD_WTILE_VAL
                LDA #$14
                STA EVEN_WTILE_VAL

                RTS

    UW_SKIP
                STA WATER_CYCLE
                RTS
; ****************************************************
; * Write a Hex Value to the position specified by Y
; * Y contains the screen position
; * A contains the value to display
HEX_MAP         .text '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
LOW_NIBBLE      .byte 0
HIGH_NIBBLE     .byte 0
WRITE_HEX
                .as
                .xl
        PHA
            PHX
                PHY
                PHA
                    AND #$F0
                    lsr A
                    lsr A
                    lsr A
                    lsr A
                    setxs
                    TAX
                    LDA HEX_MAP,X
                    STA @lLOW_NIBBLE

                PLA
                AND #$0F
                TAX
                LDA HEX_MAP,X
                STA @lHIGH_NIBBLE

                setaxl
                PLY
                LDA @lLOW_NIBBLE
                STA [SCREENBEGIN], Y
                ; change the foreground color of the text
                LDA #$1010
                TYX
                STA @lCS_COLOR_MEM_PTR, X
                setas
            PLX
        PLA
                RTS

; *********************************************************
; * Convert the game_board to a tile set
; *********************************************************
LOAD_TILESET
                LDX #0
                LDY #0
                setdbr $AF
                setas
    GET_TILE
                LDA game_board,X

        ;DOT
                CMP #$2e ; #'.'
                BNE GRASS
                LDA #0
                STA TILE_MAP0,Y
                BRA LT_DONE

        GRASS
                CMP #'G'
                BNE HOME
                LDA #2
                STA TILE_MAP0,Y
                BRA LT_DONE

        HOME
                CMP #'H'
                BNE WATER

                TXA
                AND #1
                BEQ EVEN_TILE
                LDA #$13
                STA TILE_MAP0,Y
                BRA LT_DONE

            EVEN_TILE
                LDA #$12
                STA TILE_MAP0,Y
                BRA LT_DONE

        WATER
                CMP #'W'
                BNE CONCRETE
                LDA #4
                STA TILE_MAP0,Y
                BRA LT_DONE

        CONCRETE
                CMP #'C'
                BNE ASHPHALT
                LDA #1
                STA TILE_MAP0,Y
                BRA LT_DONE

        ASHPHALT
                CMP #'A'
                BNE DIRT
                LDA #5
                STA TILE_MAP0,Y
                BRA LT_DONE

        DIRT
                CMP #'D'
                BNE LT_DONE
                LDA #3
                STA TILE_MAP0,Y
                BRA LT_DONE

    LT_DONE
                INY
                setal
                TYA
                AND #$3F
                CMP #40
                BNE LT_NEXT_TILE
                TYA
                CLC
                ADC #24
                TAY

    LT_NEXT_TILE
                setas
                INX
                CPX #(640/16) * (480 / 16)
                BNE GET_TILE
                RTS

; our resolution is 640 x 480 - tiles are 16 x 16 - therefore 40 x 30
NB_TILE_MAP_X .word $3; will be updatad by the code the day I will load the map from the SD or IDE
NB_TILE_MAP_Y .word $2
CURENT_TILE_MAP_X .word $0
CURENT_TILE_MAP_Y .word $0
game_board
* = $164C00
game_board_0
game_board_0__00_00
.binary "assets/HL_V2_Tile_map_layer_1__00_00.map"
* = game_board_0 + 40*30*1
game_board_0__00_01
.binary "assets/HL_V2_Tile_map_layer_1__00_01.map"
* = game_board_0 + 40*30*2
game_board_0__00_02
.binary "assets/HL_V2_Tile_map_layer_1__00_02.map"

* = game_board_0 + 40*30*3
game_board_0__01_00
.binary "assets/HL_V2_Tile_map_layer_1__01_00.map"
* = game_board_0 + 40*30*4
game_board_0__01_01
.binary "assets/HL_V2_Tile_map_layer_1__01_01.map"
* = game_board_0 + 40*30*5
game_board_0__01_02
.binary "assets/HL_V2_Tile_map_layer_1__01_02.map"



* = game_board_0 + 40*30*6
game_board_1
.binary "assets/HL_V2_Tile_map_layer_0__00_00.map"
* = game_board_1 + 40*30*1
.binary "assets/HL_V2_Tile_map_layer_0__01_00.map"
* = game_board_1 + 40*30*2
.binary "assets/HL_V2_Tile_map_layer_0__00_00.map"

* = game_board_1 + 40*30*3
.binary "assets/HL_V2_Tile_map_layer_0__00_01.map"
* = game_board_1 + 40*30*4
.binary "assets/HL_V2_Tile_map_layer_0__01_01.map"
* = game_board_1 + 40*30*5
.binary "assets/HL_V2_Tile_map_layer_0__00_01.map"
* = game_board_1 + 40*30*6


PALETTE
.binary "assets/menu/HLC256_Menu.pal"
;.binary "assets/halflife.pal"
PALETTE_TILE_SET_LEVEL_0
.binary "assets/HL_V2_tile_shifted_256.data.pal"
;.binary "assets/HL_V2_tile_set_256.pal"HL_V2_tile_shifted_256.data
* = $1a0000
TILES ; just there to keep the Sprit code not complaining, wont be used for enyting at the moment
TILE_SET_LEVEL_0_BMP
.binary "assets/HL_V2_tile_set_256.bmp"
* = TILE_SET_LEVEL_0_BMP + $20000
TILE_SET_LEVEL_0_PIXEL



* = $1B0000
TILE_SET_LEVEL_1_BMP
.binary "assets/HL_V2_tile_shifted_256.bmp"
SPRIT_GORDON_SCIENTIST_BMP
.binary "assets/HL_V2_tile_shifted_Gordon_sientist.bmp"
* = TILE_SET_LEVEL_1_BMP + $20000
TILE_SET_LEVEL_1_PIXEL
* = SPRIT_GORDON_SCIENTIST_BMP +$20000
SPRIT_GORDON_SCIENTIST_PIXEL
.binary "assets/HL_V2_tile_shifted_Gordon_sientist_256.data"
SPRIT_GORDON_SCIENTIST_PAL
.binary "assets/HL_V2_tile_shifted_Gordon_sientist_256.data.pal"
;* = $1B0000
;HL_1
;.binary "assets/halflife_1.pixel"
;* = $1C0000
;HL_2
;.binary "assets/halflife_2.pixel"
;* = $1D0000
;HL_3
;.binary "assets/halflife_3.pixel"
;* = $1E0000
;HL_4
;.binary "assets/halflife_4.pixel"
;* = $1F0000
;HL_5
;.binary "assets/halflife_5.pixel"
* = $200000
HL_BMP
.binary "assets/menu/menu_main.bmp"
;.binary "assets/halflife.bmp"
* = $250000
MENU_PLAY
.binary "assets/menu/menu_play-select.bmp"
MENU_PLAY_SELECTED
.binary "assets/menu/menu_play-select.bmp"
MENU_LOAD
.binary "assets/menu/menu_load.bmp"
* = $260000
MENU_LOAD_SELECTED
.binary "assets/menu/menu_load-select.bmp"
MENU_OPSIONS
.binary "assets/menu/menu_options.bmp"
MENU_OPSIONS_SELECTED
.binary "assets/menu/menu_options-select.bmp"
* = $270000
MENU_CREDIT
.binary "assets/menu/menu_credits.bmp"
MENU_CREDIT_SELECTED
.binary "assets/menu/menu_credits-select.bmp"


* = HL_BMP + $80000
HL_PIXEL
