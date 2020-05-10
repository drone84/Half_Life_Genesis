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
                LDA #Mstr_Ctrl_Graph_Mode_En + Mstr_Ctrl_Bitmap_En + Mstr_Ctrl_TileMap_En + Mstr_Ctrl_Sprite_En + Mstr_Ctrl_Text_Mode_En + Mstr_Ctrl_Text_Overlay
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
                LDA #0000
                STA SP00_X_POS_L
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
LOAD_TILE_MAP_0
                LDX #0
                LDY #0
                setdbr $AF
                setas
    GET_TILE_0
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
                LDX #0
                LDY #0
                setdbr $AF
                setas
    GET_TILE_1
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
                PHA
                JSR UPDATE_HOME_TILES
                JSR UPDATE_WATER_TILES
                PLA
                setal
        JOY_UP
                BIT #1 ; up
                BNE JOY_DOWN
                JSR PLAYER_MOVE_UP
                BRA JOY_DONE

        JOY_DOWN
                BIT #2 ; down
                BNE JOY_LEFT
                JSR PLAYER_MOVE_DOWN
                BRA JOY_DONE

        JOY_LEFT
                BIT #4
                BNE JOY_RIGHT
                JSR PLAYER_MOVE_LEFT
                BRA JOY_DONE

        JOY_RIGHT
                BIT #8
                BNE JOY_DONE
                JSR PLAYER_MOVE_RIGHT
                BRA JOY_DONE

        JOY_DONE
                setas
                JSR UPDATE_NPC_POSITIONS
                JSR COLLISION_CHECK
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
                LDA PLAYER_Y
                CLC
                ADC #32
                ; check for collisions and out of screen
                CMP #480 - 96
                BCC PMD_DONE
                LDA #480 - 96 ; the lowest position on screen

        PMD_DONE
                STA PLAYER_Y
                STA SP15_Y_POS_L
                RTS

PLAYER_MOVE_UP
                LDA PLAYER_Y
                SEC
                SBC #32
                ; check for collisions and out of screen
                CMP #96
                BCS PMU_DONE
                LDA #96

        PMU_DONE
                STA PLAYER_Y
                STA SP15_Y_POS_L
                RTS

PLAYER_MOVE_RIGHT
                LDA PLAYER_X
                CLC
                ADC #32
                ; check for collisions and out of screen
                CMP #640 - 64
                BCC PMR_DONE
                LDA #640 - 64 ; the lowest position on screen

        PMR_DONE
                STA PLAYER_X
                STA SP15_X_POS_L
                RTS

PLAYER_MOVE_LEFT
                LDA PLAYER_X
                SEC
                SBC #32
                ; check for collisions and out of screen
                CMP #32
                BCS PML_DONE
                LDA #32

        PML_DONE
                STA PLAYER_X
                STA SP15_X_POS_L
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
game_board
game_board_0
.binary "assets/HL_V2_Tile_map_layer_1__00_00.map"
game_board_1
.binary "assets/HL_V2_Tile_map_layer_0__00_00.map"


                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,6
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,6
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,6
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,6
                .byte $78,$00,$00,$00,$00,$00,$00,$00,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,6
                .byte $78,$00,$00,$00,$00,$00,$00,$00,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A,$5B,$5C,$5D,$5E,$5F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,6
                .byte $78,$00,$00,$00,$00,$00,$00,$00,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6E,$6F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,6
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7A,$7B,$7C,$7D,$7E,$7F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,6
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                .byte 3,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00


PALETTE
.binary "assets/halflife.pal"
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
.binary "assets/halflife.bmp"
* = HL_BMP + $50000
HL_PIXEL
