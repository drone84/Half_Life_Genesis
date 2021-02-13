INIT_DISPLAY
                .setas
                LDA #0
                STA BORDER_CTRL_REG

                ; enable graphics, tiles and sprites display
                LDA #Mstr_Ctrl_Graph_Mode_En + Mstr_Ctrl_Bitmap_En + Mstr_Ctrl_TileMap_En + Mstr_Ctrl_Sprite_En; + Mstr_Ctrl_Text_Mode_En + Mstr_Ctrl_Text_Overlay
                STA MASTER_CTRL_REG_L

                ; display intro screen
                ; wait for user to press a key or joystick button
                LDA #0
                STA @l DISPLAY_MENUE

;RTS
                .setaxl
                ; load LUT
                LDX #<>PALETTE_TILE_SET_LEVEL_0 ;PALETTE
                LDY #<>GRPH_LUT0_PTR
                LDA #1024
                MVN <`PALETTE_TILE_SET_LEVEL_0,<`GRPH_LUT0_PTR

                LDX #<>SPRIT_GORDON_SCIENTIST_PAL
                LDY #<>GRPH_LUT1_PTR
                LDA #1024
                MVN <`SPRIT_GORDON_SCIENTIST_PAL,<`GRPH_LUT1_PTR
;RTS
                LDX #<>PALETTE_TILE_SET_LEVEL_0
                LDY #<>GRPH_LUT2_PTR
                LDA #1024
                MVN <`PALETTE_TILE_SET_LEVEL_0,<`GRPH_LUT2_PTR

                LDX #<>PLAYER_1_PAL
                LDY #<>GRPH_LUT3_PTR
                LDA #1024
                MVN <`PALETTE_TILE_SET_LEVEL_0,<`GRPH_LUT3_PTR
                ;-------------------------------------------------------
                ;- Extract the tile level 0 pixel from the BMP picture -
                ;-------------------------------------------------------
                setas
                setxl
                LDA #0
                STA BMP_POSITION_X
                STA BMP_POSITION_Y
                ; load the BMP file source adressv and BMP decoded destination address
                LDA #>TILE_SET_LEVEL_1_BMP        ; TILES_NB[0]
                STA BMP_PRSE_SRC_PTR
                STA BMP_PRSE_DST_PTR

                LDA #<TILE_SET_LEVEL_1_BMP        ; TILES_NB[1]
                STA BMP_PRSE_SRC_PTR+1
                STA BMP_PRSE_DST_PTR+1

                LDA #`TILE_SET_LEVEL_1_BMP        ; TILES_NB[2]
                STA BMP_PRSE_SRC_PTR+2
                LDA #`TILE_SET_LEVEL_1_PIXEL ; write the result on the next page
                STA BMP_PRSE_DST_PTR+2

                ; Parse the BMP file to extract the data in a Byte array
                ; of the picture resolution whide*hight*bpp (byte per pixel)
                JSL IBMP_PARSER

                ; load the tiles pixel extracted from the BMP to the VRAM from @B0:0000
                ; Load the Pixel
                ;---------------------- B0
                setaxl
                LDX #<>TILE_SET_LEVEL_1_PIXEL+1
                LDY #0
                LDA #$8000 ; 256 * 128 - this is 8 rows of tiles
                MVN <`TILE_SET_LEVEL_1_PIXEL,$B0


                ;-------------------------------------------------------
                ;- Extract the player pixel from the BMP picture -
                ;-------------------------------------------------------
                setas
                setxl
                LDA #0
                STA BMP_POSITION_X
                STA BMP_POSITION_Y
                ; load the BMP file source adressv and BMP decoded destination address
                LDA #>PLAYER_1        ; TILES_NB[0]
                STA BMP_PRSE_SRC_PTR
                STA BMP_PRSE_DST_PTR

                LDA #<PLAYER_1        ; TILES_NB[1]
                STA BMP_PRSE_SRC_PTR+1
                STA BMP_PRSE_DST_PTR+1

                LDA #`PLAYER_1        ; TILES_NB[2]
                STA BMP_PRSE_SRC_PTR+2
                LDA #`PLAYER_1_PIXEL ; write the result on the next page
                STA BMP_PRSE_DST_PTR+2

                ; Parse the BMP file to extract the data in a Byte array
                ; of the picture resolution whide*hight*bpp (byte per pixel)
                JSL IBMP_PARSER


                ;-----------------------------------------------------------------
                ;Load the menue graphics
                ;---------------------- B2
                setaxl
                LDA #256
                STA @l SPRIT_SIZE_TILE_X
                LDA #192
                STA @l SPRIT_SIZE_TILE_Y
                LDA#<>PLAYER_1_PIXEL
                STA @l SPRIT_SRC
                LDA #`PLAYER_1_PIXEL
                STA @l SPRIT_SRC+2
                LDA #$0000
                STA @l SPRIT_DES
                LDA #$00BC
                STA @l SPRIT_DES+2
                JSR LOAD_TILED_SPRITES

                .setal
                LDA #00 ;SPRIT_PIXEL_ADDRESS_START
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
                LDA #$0C
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

                LDX #<>PLAYER_1_PAL
                LDY #<>GRPH_LUT3_PTR
                LDA #1024
                MVN <`PLAYER_1_PAL,<`GRPH_LUT3_PTR
                .setas
                ;LDA #0
                LDA #SPRITE_Enable + SPRITE_LUT3
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

                LDA #$20
                STA SP01_X_POS_L
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
                ADC #32
                STA SP09_X_POS_L
                ADC #32
                STA SP10_X_POS_L

                LDA #$80
                STA SP01_Y_POS_L
                STA SP02_Y_POS_L
                STA SP03_Y_POS_L
                STA SP04_Y_POS_L
                STA SP05_Y_POS_L
                STA SP06_Y_POS_L
                STA SP07_Y_POS_L
                STA SP08_Y_POS_L
                STA SP09_Y_POS_L
                STA SP10_Y_POS_L

                LDA PLAYER_Y
                STA SP00_Y_POS_L

                ; load LUT0 at the end as the BMP fuction modify it
                .setaxl
                LDX #<>PALETTE_TILE_SET_LEVEL_0 ;PALETTE
                LDY #<>GRPH_LUT0_PTR
                LDA #1024
                MVN <`PALETTE_TILE_SET_LEVEL_0,<`GRPH_LUT0_PTR

                ; load the strit pixel extracted from the BMP to the VRAM from @B1:0000
                ; Load the Pixel
                ;---------------------- B1
                setaxl
                LDX #<>SPRIT_GORDON_SCIENTIST_PIXEL+1
                LDY #0
                LDA #$0400 ; 32 * 32
                MVN <`SPRIT_GORDON_SCIENTIST_PIXEL,$B1

                ; enable the tile engine 0
                setas

                LDA #0
                STA @l TL0_CONTROL_REG
                STA @l TL1_CONTROL_REG
                STA @l TL2_CONTROL_REG
                STA @l TL3_CONTROL_REG

                LDA #TILE_Enable
                LDA #1

                STA @l TL0_CONTROL_REG
                ;STA @l TL1_CONTROL_REG
                STA @l TL2_CONTROL_REG
                ;STA @l TL3_CONTROL_REG



                ; load tileset
                JSR LOAD_TILE_MAP_0
                ;JSR LOAD_TILE_MAP_1 dont contain displayable content for now
                JSR LOAD_TILE_MAP_2

                ; enable the sprit engine
                ; set the address of the sprit in the VRAM from VICKY II point of vue
                LDA #00
                STA SP00_ADDY_PTR_L
                STA SP00_ADDY_PTR_M
                LDA #01
                STA SP00_ADDY_PTR_H
                ; write the position of the sprit on the screen (640x480)
                setal

                LDA #640/2
                STA PLAYER_X
                STA SP00_X_POS_L
                STA PLAYER_SPRIT_X

                LDA #480/2
                STA PLAYER_Y
                STA SP00_Y_POS_L
                STA PLAYER_SPRIT_Y

                ; need to make a funcrion to comput the position of ther player
                ; and tile map
                LDA #640/2 ; clamp the sprit player position to the middle of the screen
                STA SP00_X_POS_L
                LDA #640/2 ; set the position
                STA PLAYER_X
                STA PLAYER_SPRIT_X
                LDA #0 ; player pos - (screen whide)/2
                STA @l TL0_WINDOW_X_POS_L
                STA @l TL1_WINDOW_X_POS_L
                STA @l TL2_WINDOW_X_POS_L

                LDA #480/2 ; clamp the sprit player position to the middle of the screen
                STA SP00_Y_POS_L
                LDA #480 ; player pos - (screen whide)/2
                STA PLAYER_Y
                STA PLAYER_SPRIT_Y
                LDA #480/2 ; player pos - (screen whide)/2
                STA @l TL0_WINDOW_Y_POS_L
                STA @l TL1_WINDOW_Y_POS_L
                STA @l TL2_WINDOW_Y_POS_L
                ; active the sprit 0
                LDA # SPRITE_Enable + SPRITE_LUT1
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

                LDA #$00
                STA @l TL0_START_ADDY_L
                LDA #$00
                STA @l TL0_START_ADDY_M
                LDA #$04
                STA @l TL0_START_ADDY_H

                LDA #64
                STA @l TL0_TOTAL_X_SIZE_L
                LDA #$00    ; The Size of the Map is 64 Tiles Wide
                STA @l TL0_TOTAL_X_SIZE_H
                LDA #64
                STA @l TL0_TOTAL_Y_SIZE_L
                LDA #$00    ; The Size of the Map is 32 Rows
                STA @l TL0_TOTAL_Y_SIZE_H

                LDA #$00
                STA @l TL0_WINDOW_X_POS_L
                LDA #$00    ; The position of the Window looking in to the MAP is 1 (X)
                STA @l TL0_WINDOW_X_POS_H
                LDA #$00
                STA @l TL0_WINDOW_Y_POS_L
                LDA #$00  ; The position of the Window Looking in to the the Map 1 (Y)
                STA @l TL0_WINDOW_Y_POS_H
                LDA #$08 ; The tile set is a 256x256 and the LUT0
                ;STA @l TILESET0_ADDY_CFG
                ; the 16bits ofset is recomputed
                LDX #0
                LDY #0
                setdbr $B4
                setas
    GET_TILE_0
                LDA @l TILE_MAP_LAYER_0,X
                STA $B40000,Y
                INY
                LDA #00 ; LUT0 and Tileset 0
                STA $B40000,Y
                INY
                INX
                CPX #(64) * (64); CPX #(640/16) * (480 / 16)
                BNE GET_TILE_0
                RTS

LOAD_TILE_MAP_2
                .setaxl

                LDA #$00
                STA @l TL2_START_ADDY_L
                LDA #$00
                STA @l TL2_START_ADDY_M
                LDA #$06
                STA @l TL2_START_ADDY_H

                LDA #64
                STA @l TL2_TOTAL_X_SIZE_L
                LDA #$00    ; The Size of the Map is 64 Tiles Wide
                STA @l TL2_TOTAL_X_SIZE_H
                LDA #64
                STA @l TL2_TOTAL_Y_SIZE_L
                LDA #$00    ; The Size of the Map is 32 Rows
                STA @l TL2_TOTAL_Y_SIZE_H

                LDA #$00
                STA @l TL2_WINDOW_X_POS_L
                LDA #$00    ; The position of the Window looking in to the MAP is 1 (X)
                STA @l TL2_WINDOW_X_POS_H
                LDA #$00
                STA @l TL2_WINDOW_Y_POS_L
                LDA #$00  ; The position of the Window Looking in to the the Map 1 (Y)
                STA @l TL2_WINDOW_Y_POS_H
                LDA #$08 ; The tile set is a 256x256 and the LUT0
                STA @l TILESET0_ADDY_CFG
                ; the 16bits ofset is recomputed
                LDX #0
                LDY #0
                setdbr $B6
                setas
    GET_TILE_2
                LDA @l TILE_MAP_LAYER_2,X
                STA $B60000,Y
                INY
                LDA #00 ; LUT0 and Tileset 0
                STA $B60000,Y
                INY
                INX
                CPX #(64) * (64); CPX #(128) * (60)
                BNE GET_TILE_2
                RTS
; *********************************************************
; * Copy the Tile map into the tile map register area
; *********************************************************

LOAD_TILE_MAP_1
                .setaxl

                LDA #$00
                STA @l TL1_START_ADDY_L
                LDA #$00
                STA @l TL1_START_ADDY_M
                LDA #$05
                STA @l TL1_START_ADDY_H

                LDA #40
                STA @l TL1_TOTAL_X_SIZE_L
                LDA #$00    ; The Size of the Map is 64 Tiles Wide
                STA @l TL1_TOTAL_X_SIZE_H
                LDA #30
                STA @l TL1_TOTAL_Y_SIZE_L
                LDA #$00    ; The Size of the Map is 32 Rows
                STA @l TL1_TOTAL_Y_SIZE_H

                LDA #$20
                STA @l TL1_WINDOW_X_POS_L
                LDA #$00    ; The position of the Window looking in to the MAP is 1 (X)
                STA @l TL1_WINDOW_X_POS_H
                LDA #$00
                STA @l TL1_WINDOW_Y_POS_L
                LDA #$00  ; The position of the Window Looking in to the the Map 1 (Y)
                STA @l TL1_WINDOW_Y_POS_H

                LDA #$08 ; The tile set is a 256x256 and the LUT0
                STA @l TILESET0_ADDY_CFG
                ; the 16bits ofset is recomputed
                LDX #0
                LDY #0
                setdbr $B5
                setas
    GET_TILE_1
                LDA @l TILE_MAP_LAYER_1,X ; first layer (floor rail etc)
                STA $B50000,Y
                INY
                LDA #$00 ; LUT0 and Tileset 0
                STA $B50000,Y
                INY
                INX
                CPX #(640/16) * (480 / 16)
                BNE GET_TILE_1
                RTS

; LOAD_TILE_MAP_1_old
;                 .setaxl
;                 ; the tile map is saved as:
;                 ; @ XX:4B0*X_size*0 : X0:Y0 X1:Y0 X2:Y0 X3:Y0
;                 ; @ XX:4B0*X_size*1 : X0:Y1 X1:Y1 X2:Y1 X3:Y1
;                 ; @ XX:4B0*X_size*2 : X0:Y1 X1:Y1 X2:Y1 X3:Y1
;                 ; comput the Y ofset
;                 LDA #40*30 ; tile map size
;                 STA @l M0_OPERAND_A
;                 LDA @l NB_TILE_MAP_X
;                 STA @l M0_OPERAND_B
;                 LDA @l M0_RESULT ; we know how many X block we need to skyp to advamce from one line only
;                 STA @l M0_OPERAND_A
;                 LDA @l CURENT_TILE_MAP_Y
;                 STA @l M0_OPERAND_B
;                 LDA @l M0_RESULT ; now we have the Y offset computed
;                 TAX
;                 ; Comput the ofset in the X direction
;                 LDA #40*30 ; tile map size
;                 STA @l M0_OPERAND_A
;                 LDA @l CURENT_TILE_MAP_X
;                 STA @l M0_OPERAND_B
;                 LDA @l M0_RESULT
;                 ; add the to ofset to get the addreess of the right map to load
;                 STA @l ADDER_A
;                 TXA
;                 STA @l ADDER_B
;                 LDA @l ADDER_R ; now we have the rightr offset in the tile map
;                 ; lets comput the ofset to use with LDA
;                 ; BRA LOAD_TILE_MAP_0
;                 STA @l ADDER_A
;                 LDA #<>game_board_1
;                 STA LOAD_TILE_MAP_1_LDA_INSTR_old+1
;                 STA @l ADDER_B
;                 LDA @l ADDER_R
;                 STA LOAD_TILE_MAP_1_LDA_INSTR_old+1
;                 ; the 16bits ofset is recomputed
;                 LDX #0
;                 LDY #0
;                 setdbr $AF
;                 setas
;     GET_TILE_1_old
;     LOAD_TILE_MAP_1_LDA_INSTR_old:
;                 LDA game_board_1,X
;                 STA TILE_MAP1,Y
;                 INY
;                 setal
;                 TYA
;                 AND #$3F
;                 CMP #40 ; 1 line is 40 tile
;                 BNE LT_NEXT_TILE_1_old
;                 TYA
;                 CLC
;                 ADC #24
;                 TAY
;
;     LT_NEXT_TILE_1_old
;                 setas
;                 INX
;                 CPX #(640/16) * (480 / 16)
;                 BNE GET_TILE_1_old
;                 RTS

; *************************************************************
; Will compare the tilemap 2 against the player position to make sure the player
; can move towart the direction requested by the keyboard
; *************************************************************

TEST_PLAYER_MOUVEMENT_TILE_X_SIXE .word 64
TEST_PLAYER_MOUVEMENT_TILE_Y_SIXE .word 64

TEST_PLAYER_MOUVEMENT_X
                .setaxl
                ; convert the player Y position to tile ofset
                PHA
                LDA @l PLAYER_Y
                LSR
                LSR
                LSR
                LSR
                ; comput the linera ofset to get the tile type the player is/will be on
                STA @l UNSIGNED_MULT_A_LO
                LDA @l TEST_PLAYER_MOUVEMENT_TILE_X_SIXE
                STA @l UNSIGNED_MULT_B_LO

                LDA @l UNSIGNED_MULT_AL_LO
                STA @l ADDER32_A_LL
                LDA @l UNSIGNED_MULT_AH_LO
                STA @l ADDER32_A_HL
                ; convert the player X position to tile ofset
                PLA
                ;LDA @l PLAYER_X
                LSR
                LSR
                LSR
                LSR
                STA @l ADDER32_B_LL
                LDA #0000
                STA @l ADDER32_B_HL

                LDA @l ADDER32_R_LL
                TAX
                LDA TILE_MAP_MOVEMENT,X
                AND #$FF
                RTS

TEST_PLAYER_MOUVEMENT_Y
                .setaxl
                ; convert the player Y position to tile ofset
                ;LDA @l PLAYER_Y
                LSR
                LSR
                LSR
                LSR
                ; comput the linera ofset to get the tile type the player is/will be on
                STA @l UNSIGNED_MULT_A_LO
                LDA @l TEST_PLAYER_MOUVEMENT_TILE_X_SIXE
                STA @l UNSIGNED_MULT_B_LO

                LDA @l UNSIGNED_MULT_AL_LO
                STA @l ADDER32_A_LL
                LDA @l UNSIGNED_MULT_AH_LO
                STA @l ADDER32_A_HL
                ; convert the player X position to tile ofset
                LDA @l PLAYER_X
                LSR
                LSR
                LSR
                LSR
                STA @l ADDER32_B_LL
                LDA #0000
                STA @l ADDER32_B_HL

                LDA @l ADDER32_R_LL
                TAX
                LDA TILE_MAP_MOVEMENT,X
                AND #$FF
                RTS

; *************************************************************
; Load tiled sprite in VRAM
; *************************************************************
; input
SPRIT_SIZE_TILE_X .word $0 ; the size of the picture in pixel
SPRIT_SIZE_TILE_Y .word $0
SPRIT_SRC .dword 0        ; address where to get and load the data
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
                STA @l SP15_X_POS_L
                LDA #10 * 32 + 64
                STA PLAYER_Y
                STA @l SP15_Y_POS_L
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
; * Determine the movement to do
; ****************************************************
JOYSTICK_VAL .word 0
UPDATE_DISPLAY
                setal
                LDA JOYSTICK0
                AND #$1F
                CMP #$1F
                BNE JOYSTICK_NOT_DONE
                BRL JOYSTICK_DONE
JOYSTICK_NOT_DONE:
                LDA JOYSTICK0
                STA JOYSTICK_VAL
                AND #$04              ; Check what value is cleared
                CMP #$00
                BNE JOYSTICK_TEST_RIGHT
                JSR PLAYER_MOVE_LEFT
JOYSTICK_TEST_RIGHT:
                LDA JOYSTICK_VAL
                AND #$08
                CMP #$00
                BNE JOYSTICK_TEST_UP
                JSR PLAYER_MOVE_RIGHT
JOYSTICK_TEST_UP:
                LDA JOYSTICK_VAL
                AND #$01
                CMP #$00
                BNE JOYSTICK_TEST_DOWN
                JSR PLAYER_MOVE_UP
JOYSTICK_TEST_DOWN:
                LDA JOYSTICK_VAL
                AND #$02
                CMP #$00
                BNE JOYSTICK_DONE
                JSR PLAYER_MOVE_DOWN


JOYSTICK_DONE:
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

PLAYER_MOVE_UP
                .setal
                LDA @l PLAYER_Y
                SEC
                SBC #2 ;; need to test here if we can move then comput the position of th eplayer
                PHA
                JSR TEST_PLAYER_MOUVEMENT_Y
                CMP #0
                BEQ PMU_PLAYER_CAN_MOVE
                PLA ; dont do anyting player stuck against a wall/door etc
                RTS
       PMU_PLAYER_CAN_MOVE:
                PLA
                CMP #(64*16) - (480/2)  ; make sure we can go bacl on the center
                BCC PMU_TEST_MOVING_AREA      ; of the screen if we are all the way on the botum
                STA @l PLAYER_Y
                CLC
                ADC #(480)
                SEC
                SBC #(64*16)
                STA @l SP00_Y_POS_L
                RTS
       PMU_TEST_MOVING_AREA:
                CMP #480/2
                BCC PMU_TEST_SCREEN_COLISION ;
                STA @l PLAYER_Y
                SEC
                SBC #(480/2)
                AND #$3FFF  ; 9 Byte only for the movement , the scrol part seam to move the tile map on the wrong axes
                STA @l TL0_WINDOW_Y_POS_L
                STA @l TL1_WINDOW_Y_POS_L
                STA @l TL2_WINDOW_Y_POS_L
                LDA #(480/2)
                STA @l SP00_Y_POS_L
                RTS
       PMU_TEST_SCREEN_COLISION:
                ; check for collisions and out of screen
                CMP #02+32 ; need to be at least bigger that 2 to be sure PLAYER_Y dont fo in the negatif (0xFFFx)
                BCS PMU_MOVE_SPRIT ;
                RTS
       PMU_MOVE_SPRIT:
                ; we are inbeetween the end/start of the tile map and the midle
                ; of the screen so move the sprit instead of the tile map
                STA @l SP00_Y_POS_L
                STA @l PLAYER_Y
                RTS
; ********************************************
PLAYER_MOVE_DOWN
                .setal
                LDA @l PLAYER_Y
                CLC
                ADC #2 ;; need to test here if we can move then comput the position of th eplayer
                PHA
                JSR TEST_PLAYER_MOUVEMENT_Y
                CMP #0
                BEQ PMD_PLAYER_CAN_MOVE
                PLA ; dont do anyting player stuck against a wall/door etc
                RTS
       PMD_PLAYER_CAN_MOVE:
                PLA
                CMP #480/2
                BCS PMD_TEST_MOVING_AREA ;
                STA @l PLAYER_Y
                STA @l SP00_Y_POS_L
                RTS
       PMD_TEST_MOVING_AREA:
                CMP #(64*16) - (480/2)
                BCS PMD_TEST_SCREEN_COLISION ;
                STA @l PLAYER_Y
                SEC
                SBC #(480/2)
                AND #$3FFF  ; 9 Byte only for the movement , the scrol part seam to move the tile map on the wrong axes
                STA @l TL0_WINDOW_Y_POS_L
                STA @l TL1_WINDOW_Y_POS_L
                STA @l TL2_WINDOW_Y_POS_L
                LDA #(480/2)
                STA @l SP00_Y_POS_L
                RTS
       PMD_TEST_SCREEN_COLISION:
                ; check for collisions and out of screen
                CMP  #(64*16)
                BCC PMD_MOVE_SPRIT ;
                RTS
       PMD_MOVE_SPRIT:
                ; we are inbeetween the end/start of the tile map and the midle
                ; of the screen so move the sprit instead of the tile map
                STA @l PLAYER_Y
                CLC
                ADC #(480)
                SEC
                SBC #(64*16)
                STA @l SP00_Y_POS_L
                RTS
; ********************************************
PLAYER_MOVE_LEFT
                .setal
                LDA @l PLAYER_X
                SEC
                SBC #2
                PHA
                JSR TEST_PLAYER_MOUVEMENT_X
                CMP #0
                BEQ PML_PLAYER_CAN_MOVE
                PLA ; dont do anyting player stuck against a wall/door etc
                RTS
       PML_PLAYER_CAN_MOVE:
                PLA
                CMP #(64*16) - (640/2)
                BCC PML_TEST_MOVING_AREA ;
                STA @l PLAYER_X
                CLC
                ADC #(640)
                SEC
                SBC #(64*16)
                STA @l SP00_X_POS_L
                RTS
       PML_TEST_MOVING_AREA:
                CMP #640/2
                BCC PML_TEST_SCREEN_COLISION ;
                STA @l PLAYER_X
                SEC
                SBC #(640/2)
                AND #$3FFF  ; 9 Byte only for the movement , the scrol part seam to move the tile map on the wrong axes
                STA @l TL0_WINDOW_X_POS_L
                STA @l TL1_WINDOW_X_POS_L
                STA @l TL2_WINDOW_X_POS_L
                LDA #(640/2)
                STA @l SP00_X_POS_L
                RTS
       PML_TEST_SCREEN_COLISION:
                ; check for collisions and out of screen
                CMP #02+32
                BCS PML_MOVE_SPRIT ;
                RTS
       PML_MOVE_SPRIT:
                ; we are inbeetween the end/start of the tile map and the midle
                ; of the screen so move the sprit instead of the tile map
                STA @l SP00_X_POS_L
                STA @l PLAYER_X
                RTS

; ********************************************
PLAYER_MOVE_RIGHT
                .setal
                LDA @l PLAYER_X
                CLC
                ADC #2
                PHA
                JSR TEST_PLAYER_MOUVEMENT_X
                CMP #0
                BEQ PMR_PLAYER_CAN_MOVE
                PLA ; dont do anyting player stuck against a wall/door etc
                RTS
       PMR_PLAYER_CAN_MOVE:
                PLA
                CMP #640/2
                BCS PMR_TEST_MOVING_AREA ;
                STA @l SP00_X_POS_L
                STA @l PLAYER_X
                RTS
       PMR_TEST_MOVING_AREA:
                ; check for collisions and out of screen
                CMP #(64*16) - (640/2)
                BCS PMR_TEST_SCREEN_COLISION ;
                STA @l PLAYER_X
                SEC
                SBC #(640/2)
                AND #$3FFF  ; 9 Byte only for the movement , the scrol part seam to move the tile map on the wrong axes
                STA @l TL0_WINDOW_X_POS_L
                STA @l TL1_WINDOW_X_POS_L
                STA @l TL2_WINDOW_X_POS_L
                LDA #(640/2)
                STA @l SP00_X_POS_L
                RTS
       PMR_TEST_SCREEN_COLISION:
                ; check for collisions and out of screen
                CMP  #(64*16)
                BCC PMR_MOVE_SPRIT ;
                RTS
       PMR_MOVE_SPRIT:
                ; we are inbeetween the end/start of the tile map and the midle
                ; of the screen so move the sprit instead of the tile map
                STA @l PLAYER_X
                CLC
                ADC #(640)
                SEC
                SBC #(64*16)
                STA @l SP00_X_POS_L
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

; our resolution is 640 x 480 - tiles are 16 x 16 - therefore 40 x 30
NB_TILE_MAP_X .word $3; will be updatad by the code the day I will load the map from the SD or IDE
NB_TILE_MAP_Y .word $2
CURENT_TILE_MAP_X .word $0
CURENT_TILE_MAP_Y .word $0


TILE_MAP_LAYER_0
.binary "assets/Map/HL_V2_Tile_map_layer_2.map"
TILE_MAP_LAYER_1 ; used for pnj path finding and player movement
TILE_MAP_MOVEMENT
.binary "assets/Map/HL_V2_Tile_map_layer_1.map"
TILE_MAP_LAYER_2
.binary "assets/Map/HL_V2_Tile_map_layer_0.map"

PALETTE
.binary "assets/menu/HLC256_Menu.pal"
;.binary "assets/halflife.pal"
PALETTE_TILE_SET_LEVEL_0
.binary "assets/HL_V2_tile_shifted_256.data.pal"
;.binary "assets/HL_V2_tile_set_256.pal"HL_V2_tile_shifted_256.data


VGM_FILE
; YM2151
;.binary "assets/songs/04 Kalinka.vgm"
;.binary "assets/songs/peddler.vgm"
;.binary "assets/songs/05 Troika.vgm"
;.binary "assets/songs/test.vgm"
;.binary "assets/songs/02 Strolling Player.vgm"
;.binary "assets/songs/test_drone.vgm"
;.binary "assets/songs/11 - Unknown (Sound Test 8B).vgm"
;.binary "assets/songs/Sega.vgm"
VGM_BUTON_ROLLOVER
.binary "assets/sound/buttonrollover.vgm"
VGM_BUTON_CLICK
.binary "assets/sound/buttonclick.vgm"
VGM_BUTON_RELEASE
.binary "assets/sound/buttonclickrelease.vgm"

* = $1a0000
TILES ; just there to keep the Sprit code not complaining, wont be used for enyting at the moment


* = $1B0000
TILE_SET_LEVEL_1_BMP
.binary "assets/Map/HL_V2_tile_shifted_256.bmp"
SPRIT_GORDON_SCIENTIST_BMP
.binary "assets/HL_V2_tile_shifted_Gordon_sientist.bmp"
* = TILE_SET_LEVEL_1_BMP + $20000
TILE_SET_LEVEL_1_PIXEL
* = SPRIT_GORDON_SCIENTIST_BMP +$20000
SPRIT_GORDON_SCIENTIST_PIXEL
.binary "assets/HL_V2_tile_shifted_Gordon_sientist_256.data"
SPRIT_GORDON_SCIENTIST_PAL
.binary "assets/HL_V2_tile_shifted_Gordon_sientist_256.data.pal"
* = $300000
PLAYER_1
.binary "assets/pnj/Chaos_engine_spr_256.bmp" ; personage
PLAYER_1_PAL
.binary "assets/pnj/Chaos_engine_spr_256.pal"
* = PLAYER_1 +$20000
PLAYER_1_PIXEL
