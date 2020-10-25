;Internal VICKY Registers and Internal Memory Locations (LUTs)
MASTER_CTRL_REG_L       = $AF0000
;Control Bits Fields
Mstr_Ctrl_Text_Mode_En  = $01       ; Enable the Text Mode
Mstr_Ctrl_Text_Overlay  = $02       ; Enable the Overlay of the text mode on top of Graphic Mode (the Background Color is ignored)
Mstr_Ctrl_Graph_Mode_En = $04       ; Enable the Graphic Mode
Mstr_Ctrl_Bitmap_En     = $08       ; Enable the Bitmap Module In Vicky
Mstr_Ctrl_TileMap_En    = $10       ; Enable the Tile Module in Vicky
Mstr_Ctrl_Sprite_En     = $20       ; Enable the Sprite Module in Vicky
Mstr_Ctrl_GAMMA_En      = $40       ; this Enable the GAMMA correction - The Analog and DVI have different color value, the GAMMA is great to correct the difference
Mstr_Ctrl_Disable_Vid   = $80       ; This will disable the Scanning of the Video hence giving 100% bandwith to the CPU
MASTER_CTRL_REG_H       = $AF0001
; Reserved - TBD
VKY_RESERVED_00         = $AF0002
VKY_RESERVED_01         = $AF0003
BORDER_CTRL_REG         = $AF0004   ; Bit[0] - Enable (1 by default)  Bit[4..6]: X Scroll Offset ( Will scroll Left) (Acceptable Value: 0..7)
Border_Ctrl_Enable      = $01

BORDER_COLOR_B          = $AF0005
BORDER_COLOR_G          = $AF0006
BORDER_COLOR_R          = $AF0007
BORDER_X_SIZE           = $AF0008   ; X-  Values: 0 - 32 (Default: 32)
BORDER_Y_SIZE           = $AF0009   ; Y- Values 0 -32 (Default: 32)

BACKGROUND_COLOR_B      = $AF000D ; When in Graphic Mode, if a pixel is "0" then the Background pixel is chosen
BACKGROUND_COLOR_G      = $AF000E
BACKGROUND_COLOR_R      = $AF000F ;

VKY_TXT_CURSOR_CTRL_REG = $AF0010   ;[0]  Enable Text Mode
Vky_Cursor_Enable       = $01
Vky_Cursor_Flash_Rate0  = $02
Vky_Cursor_Flash_Rate1  = $04
Vky_Cursor_FONT_Page0   = $08       ; Pick Font Page 0 or Font Page 1
Vky_Cursor_FONT_Page1   = $10       ; Pick Font Page 0 or Font Page 1
VKY_TXT_RESERVED        = $AF0011   ;Not in Use
VKY_TXT_CURSOR_CHAR_REG = $AF0012

VKY_TXT_CURSOR_COLR_REG = $AF0013
VKY_TXT_CURSOR_X_REG_L  = $AF0014
VKY_TXT_CURSOR_X_REG_H  = $AF0015
VKY_TXT_CURSOR_Y_REG_L  = $AF0016
VKY_TXT_CURSOR_Y_REG_H  = $AF0017

TXT_CLR_START_DISPLAY_PTR = $AF0018  ; (0 to 255) (this Add a X Offset to the Display Start Address)

VKY_INFO_CHIP_NUM_L     = $AF001C
VKY_INFO_CHIP_NUM_H     = $AF001D
VKY_INFO_CHIP_VER_L     = $AF001E
VKY_INFO_CHIP_VER_H     = $AF001F

;
; Bit Field Definition for the Control Register
TILE_LUT0               = $02
TILE_LUT1               = $04
TILE_LUT2               = $08
TILESHEET_256x256_En    = $80   ; 0 -> Sequential, 1-> 256x256 Tile Sheet Striding
;



; DMA Controller $AF0400 - $AF04FF
VDMA_CONTROL_REG        = $AF0400
; Bit Field Definition
VDMA_CTRL_Enable        = $01
VDMA_CTRL_1D_2D         = $02     ; 0 - 1D (Linear) Transfer , 1 - 2D (Block) Transfer
VDMA_CTRL_TRF_Fill      = $04     ; 0 - Transfer Src -> Dst, 1 - Fill Destination with "Byte2Write"
VDMA_CTRL_Int_Enable    = $08     ; Set to 1 to Enable the Generation of Interrupt when the Transfer is over.
VDMA_CTRL_Start_TRF     = $80     ; Set to 1 To Begin Process, Need to Cleared before, you can start another

VDMA_BYTE_2_WRITE       = $AF0401 ; Write Only - Byte to Write in the Fill Function
VDMA_STATUS_REG         = $AF0401 ; Read only
;Status Bit Field Definition
VDMA_STAT_Size_Err      = $01     ; If Set to 1, Overall Size is Invalid
VDMA_STAT_Dst_Add_Err   = $02     ; If Set to 1, Destination Address Invalid
VDMA_STAT_Src_Add_Err   = $04     ; If Set to 1, Source Address Invalid
VDMA_STAT_VDMA_IPS      = $80     ; If Set to 1, VDMA Transfer in Progress (this Inhibit CPU Access to Mem)
                                  ; Let me repeat, don't Access the Video Memory then there is a VDMA in progress
VDMA_SRC_ADDY_L         = $AF0402 ; Pointer to the Source of the Data to be stransfered
VDMA_SRC_ADDY_M         = $AF0403 ; This needs to be within Vicky's Range ($00_0000 - $3F_0000)
VDMA_SRC_ADDY_H         = $AF0404

VDMA_DST_ADDY_L         = $AF0405 ; Destination Pointer within Vicky's video memory Range
VDMA_DST_ADDY_M         = $AF0406 ; ($00_0000 - $3F_0000)
VDMA_DST_ADDY_H         = $AF0407

; In 1D Transfer Mode
VDMA_SIZE_L             = $AF0408 ; Maximum Value: $40:0000 (4Megs)
VDMA_SIZE_M             = $AF0409
VDMA_SIZE_H             = $AF040A
VDMA_IGNORED            = $AF040B
; In 2D Transfer Mode
VDMA_X_SIZE_L           = $AF0408 ; Maximum Value: 65535
VDMA_X_SIZE_H           = $AF0409
VDMA_Y_SIZE_L           = $AF040A ; Maximum Value: 65535
VDMA_Y_SIZE_H           = $AF040B

VDMA_SRC_STRIDE_L       = $AF040C ; Always use an Even Number ( The Engine uses Even Ver of that value)
VDMA_SRC_STRIDE_H       = $AF040D ;
VDMA_DST_STRIDE_L       = $AF040E ; Always use an Even Number ( The Engine uses Even Ver of that value)
VDMA_DST_STRIDE_H       = $AF040F ;

; Mouse Pointer Graphic Memory
MOUSE_PTR_GRAP0_START    = $AF0500 ; 16 x 16 = 256 Pixels (Grey Scale) 0 = Transparent, 1 = Black , 255 = White
MOUSE_PTR_GRAP0_END      = $AF05FF ; Pointer 0
MOUSE_PTR_GRAP1_START    = $AF0600 ;
MOUSE_PTR_GRAP1_END      = $AF06FF ; Pointer 1

MOUSE_PTR_CTRL_REG_L    = $AF0700 ; Bit[0] Enable, Bit[1] = 0  ( 0 = Pointer0, 1 = Pointer1)
MOUSE_PTR_CTRL_REG_H    = $AF0701 ;
MOUSE_PTR_X_POS_L       = $AF0702 ; X Position (0 - 639) (Can only read now) Writing will have no effect
MOUSE_PTR_X_POS_H       = $AF0703 ;
MOUSE_PTR_Y_POS_L       = $AF0704 ; Y Position (0 - 479) (Can only read now) Writing will have no effect
MOUSE_PTR_Y_POS_H       = $AF0705 ;
MOUSE_PTR_BYTE0         = $AF0706 ; Byte 0 of Mouse Packet (you must write 3 Bytes)
MOUSE_PTR_BYTE1         = $AF0707 ; Byte 1 of Mouse Packet (if you don't, then )
MOUSE_PTR_BYTE2         = $AF0708 ; Byte 2 of Mouse Packet (state Machine will be jammed in 1 state)
                                  ; (And the mouse won't work)
C256F_MODEL_MAJOR       = $AF070B ;
C256F_MODEL_MINOR       = $AF070C ;
FPGA_DOR                = $AF070D ;
FPGA_MOR                = $AF070E ;
FPGA_YOR                = $AF070F ;

;                       = $AF0800 ; the RTC is Here
;                       = $AF1000 ; The SuperIO Start is Here
;                       = $AF13FF ; The SuperIO Start is Here

FG_CHAR_LUT_PTR         = $AF1F40
BG_CHAR_LUT_PTR         = $AF1F80

GRPH_LUT0_PTR           = $AF2000
GRPH_LUT1_PTR           = $AF2400
GRPH_LUT2_PTR           = $AF2800
GRPH_LUT3_PTR           = $AF2C00
GRPH_LUT4_PTR           = $AF3000
GRPH_LUT5_PTR           = $AF3400
GRPH_LUT6_PTR           = $AF3800
GRPH_LUT7_PTR           = $AF3C00

GAMMA_B_LUT_PTR         = $AF4000
GAMMA_G_LUT_PTR         = $AF4100
GAMMA_R_LUT_PTR         = $AF4200

TILE_MAP0               = $AF5000     ;$AF5000 - $AF57FF
TILE_MAP1               = $AF5800     ;$AF5800 - $AF5FFF
TILE_MAP2               = $AF6000     ;$AF6000 - $AF67FF
TILE_MAP3               = $AF6800     ;$AF6800 - $AF6FFF

FONT_MEMORY_BANK0       = $AF8000     ;$AF8000 - $AF87FF
FONT_MEMORY_BANK1       = $AF8800     ;$AF8800 - $AF8FFF
CS_TEXT_MEM_PTR         = $AFA000
CS_COLOR_MEM_PTR        = $AFC000


BTX_START               = $AFE000     ; BEATRIX Registers
BTX_END                 = $AFFFFF
