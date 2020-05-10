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
.include "interrupt_def.asm"
.include "keyboard_def.asm"
.include "io_def.asm"

.include "dram_inc.asm"                     ; old Definition file that was supposed to be a Memory map used by kernel_lib.asm
.include "simulator_inc.asm"
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

PLAYER_X    .word 100
PLAYER_Y    .word 100

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

            ; Mask all Interrupt @ This Point
            LDA #$FF
            STA @lINT_MASK_REG0
            STA @lINT_MASK_REG1
            STA @lINT_MASK_REG2

            ;-------------------------------------------------------
            ;-- Extract the backgroubd pixel from the BMP picture --
            ;-------------------------------------------------------
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
            LDA #`TILE_SET_LEVEL_0_PIXEL ; write the result on the next page
            STA BMP_PRSE_DST_PTR+2

            ; Parse the BMP file to extract the data in a Byte array
            ; of the picture resolution whide*hight*bpp (byte per pixel)
            JSL IBMP_PARSER

            ;-------------------------------------------------------
            ;- Extract the Sprite Gordon Sientistpixel from the BMP picture -
            ;-------------------------------------------------------
            setas
            setxl
            LDA #0
            STA BMP_POSITION_X
            STA BMP_POSITION_Y
            ; load the BMP file source adressv and BMP decoded destination address
            LDA #>SPRIT_GORDON_SCIENTIST_BMP        ; TILES_NB[0]
            STA BMP_PRSE_SRC_PTR
            STA BMP_PRSE_DST_PTR

            LDA #<SPRIT_GORDON_SCIENTIST_BMP        ; TILES_NB[1]
            STA BMP_PRSE_SRC_PTR+1
            STA BMP_PRSE_DST_PTR+1

            LDA #`SPRIT_GORDON_SCIENTIST_BMP        ; TILES_NB[2]
            STA BMP_PRSE_SRC_PTR+2
            LDA #`SPRIT_GORDON_SCIENTIST_PIXEL ; write the result on the next page
            STA BMP_PRSE_DST_PTR+2

            ; Parse the BMP file to extract the data in a Byte array
            ; of the picture resolution whide*hight*bpp (byte per pixel)
            ; JSL IBMP_PARSER dosent seam to work on 32*32

            JSR INIT_DISPLAY

            ; Enable SOF
            ;LDA #~( FNX0_INT00_SOF )
            ;STA @lINT_MASK_REG0
            ;LDA #~( FNX1_INT00_KBD )
            ;STA @lINT_MASK_REG1
            ;CLI

    GAME_LOOP
            BRA GAME_LOOP

.include "BMP_Lib.asm"
.include "Kernel_lib.asm"
.include "interrupt_handler.asm"
.include "display.asm"
