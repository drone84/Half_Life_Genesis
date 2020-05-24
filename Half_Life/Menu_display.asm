
LOAD_MAIN_MENU
                  ;-------------------------------------------------------------
                  ;-------------------------------------------------------------
                  ;-------------------------------------------------------------
                  ;----- Extract the backgroubd pixel from the BMP picture -----
                  ;-------------------------------------------------------------
                  ;-------------------------------------------------------------
                  .setas
                  LDA #0
                  STA BMP_POSITION_X
                  STA BMP_POSITION_Y
                  ; load the BMP file source adressv and BMP decoded destination address
                  LDA #>HL_BMP        ; TILES_NB[0]
                  STA BMP_PRSE_SRC_PTR
                  STA BMP_PRSE_DST_PTR

                  LDA #<HL_BMP        ; TILES_NB[1]
                  STA BMP_PRSE_SRC_PTR+1
                  STA BMP_PRSE_DST_PTR+1

                  LDA #`HL_BMP        ; TILES_NB[2]
                  STA BMP_PRSE_SRC_PTR+2
                  LDA #`HL_PIXEL ; write the result on the next page
                  STA BMP_PRSE_DST_PTR+2

                  ; Parse the BMP file to extract the data in a Byte array
                  ; of the picture resolution whide*hight*bpp (byte per pixel)
                  JSL IBMP_PARSER
                  ;-------------------------------------------------------
                  ; Load the pallet
                  ;-------------------------------------------------------
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
                  ;-------------------------------------------------------
                  ; Load the Pixel extracted from the BMP to the VRAM from @B6:0000
                  ;-------------------------------------------------------
                  .setaxl
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

                  ;-------------------------------------------------------------
                  ;-------------------------------------------------------------
                  ;-------------------------------------------------------------
                  ;- Extract the Sprite Gordon Sientistpixel from the BMP picture -
                  ;-------------------------------------------------------------
                  ;-------------------------------------------------------------
                  ;-------------------------------------------------------------
                  .setas
                  LDA #0
                  STA BMP_POSITION_X
                  STA BMP_POSITION_Y
                  ; load the BMP file source adressv and BMP decoded destination address
                  LDA #<MENU_PLAY_SELECTED
                  STA BMP_PRSE_SRC_PTR
                  LDA #<MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR

                  LDA #>MENU_PLAY_SELECTED
                  STA BMP_PRSE_SRC_PTR+1
                  LDA #>MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR+1

                  LDA #`MENU_PLAY_SELECTED
                  STA BMP_PRSE_SRC_PTR+2
                  LDA #`MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR+2

                  ; Parse the BMP file to extract the data in a Byte array
                  ; of the picture resolution whide*hight*bpp (byte per pixel)
                  JSL IBMP_PARSER

                  ;---------------------------
                  ;Load the graphics in VRAM
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
                  ;-------------------------------------------------------
                  ;- Extract the Sprite Gordon Sientistpixel from the BMP picture -
                  ;-------------------------------------------------------
                  setas
                  setxl
                  LDA #0
                  STA BMP_POSITION_X
                  STA BMP_POSITION_Y
                  ; load the BMP file source adressv and BMP decoded destination address
                  LDA #<MENU_LOAD_SELECTED        ; TILES_NB[0]
                  STA BMP_PRSE_SRC_PTR
                  LDA #<MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR

                  LDA #<MENU_LOAD_SELECTED        ; TILES_NB[1]
                  STA BMP_PRSE_SRC_PTR+1
                  LDA #>MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR+1

                  LDA #`MENU_LOAD_SELECTED        ; TILES_NB[2]
                  STA BMP_PRSE_SRC_PTR+2
                  LDA #`MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR+2

                  ; Parse the BMP file to extract the data in a Byte array
                  ; of the picture resolution whide*hight*bpp (byte per pixel)
                  JSL IBMP_PARSER

                  ;---------------------------
                  ;Load the graphics in VRAM
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
                  LDA #$4000
                  STA @l SPRIT_DES
                  LDA #$00B2
                  STA @l SPRIT_DES+2
                  JSR LOAD_TILED_SPRITES
                  ;-------------------------------------------------------
                  ;- Extract the Sprite Gordon Sientistpixel from the BMP picture -
                  ;-------------------------------------------------------
                  setas
                  setxl
                  LDA #0
                  STA BMP_POSITION_X
                  STA BMP_POSITION_Y
                  ; load the BMP file source adressv and BMP decoded destination address
                  LDA #<MENU_OPTIONS_SELECTED        ; TILES_NB[0]
                  STA BMP_PRSE_SRC_PTR
                  LDA #<MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR

                  LDA #>MENU_OPTIONS_SELECTED        ; TILES_NB[1]
                  STA BMP_PRSE_SRC_PTR+1
                  LDA #>MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR+1

                  LDA #`MENU_OPTIONS_SELECTED        ; TILES_NB[2]
                  STA BMP_PRSE_SRC_PTR+2
                  LDA #`MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR+2

                  ; Parse the BMP file to extract the data in a Byte array
                  ; of the picture resolution whide*hight*bpp (byte per pixel)
                  JSL IBMP_PARSER

                  ;---------------------------
                  ;Load the graphics in VRAM
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
                  LDA #$8000
                  STA @l SPRIT_DES
                  LDA #$00B2
                  STA @l SPRIT_DES+2
                  JSR LOAD_TILED_SPRITES
                  ;-------------------------------------------------------
                  ;- Extract the Sprite Gordon Sientistpixel from the BMP picture -
                  ;-------------------------------------------------------
                  setas
                  setxl
                  LDA #0
                  STA BMP_POSITION_X
                  STA BMP_POSITION_Y
                  ; load the BMP file source adressv and BMP decoded destination address
                  LDA #<MENU_CREDITS_SELECTED        ; TILES_NB[0]
                  STA BMP_PRSE_SRC_PTR
                  LDA #<MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR

                  LDA #>MENU_CREDITS_SELECTED        ; TILES_NB[1]
                  STA BMP_PRSE_SRC_PTR+1
                  LDA #>MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR+1

                  LDA #`MENU_CREDITS_SELECTED        ; TILES_NB[2]
                  STA BMP_PRSE_SRC_PTR+2
                  LDA #`MENU_PLAY + $80000 ; write the result on the next page
                  STA BMP_PRSE_DST_PTR+2

                  ; Parse the BMP file to extract the data in a Byte array
                  ; of the picture resolution whide*hight*bpp (byte per pixel)
                  JSL IBMP_PARSER

                  ;---------------------------
                  ;Load the graphics in VRAM
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
                  LDA #$C000
                  STA @l SPRIT_DES
                  LDA #$00B2
                  STA @l SPRIT_DES+2
                  JSR LOAD_TILED_SPRITES

                  ;-------------------------------------------------------------
                  ;--------- All the sprit are loades in VRAM now --------------
                  ;----- we need to activate the sprit engine and tell him -----
                  ;-------- what sprit to draw and where to display it ---------
                  ;---- that will be don by the Start of Frame interruption ----
                  ;-------------- acording to the mouse position ---------------
                  ;-------------------------------------------------------------

                  ; Deactive the sprit as the Splash screen got the unsellected Menu
                  ; graphics
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
                  ;for now all the sprit are in page B20000 (B2-B0)
                  LDA #$02
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
                  RTS

CLEAR_VRAM_B0_BA
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
                  RTS
