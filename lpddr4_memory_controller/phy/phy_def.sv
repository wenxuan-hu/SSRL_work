   // ------------------------------------------------------------------------
   // Enumerations
   // ------------------------------------------------------------------------

   typedef enum logic [1:0] {
      WCK_STATIC_LOW  = 2'b00,
      WCK_STATIC_HIGH = 2'b01,
      WCK_TOGGLE      = 2'b10,
      WCK_FAST_TOGGLE = 2'b11
   } wck_t;

   // DFI GearBox
   parameter DFIGBWIDTH = 4;
   parameter DEC_DFIGBWIDTH = 10;

   typedef enum logic [DFIGBWIDTH-1:0] {
      DFIWGB_32TO16 = 'd8,
      DFIWGB_32TO8  = 'd7,
      DFIWGB_16TO8  = 'd6,
      DFIWGB_8TO8   = 'd5,
      DFIWGB_8TO4   = 'd4,
      DFIWGB_8TO2   = 'd3,   // Not Supported
      DFIWGB_4TO4   = 'd2,
      DFIWGB_4TO2   = 'd1,   // Not Supported
      DFIWGB_2TO2   = 'd0
   } dwgb_t;

   function automatic dwgb_t cast_dwgb_t (logic [DFIGBWIDTH-1:0] bits);
      dwgb_t cast;
      case(bits)
        'd8    : cast_dwgb_t = DFIWGB_32TO16;
        'd7    : cast_dwgb_t = DFIWGB_32TO8;
        'd6    : cast_dwgb_t = DFIWGB_16TO8;
        'd5    : cast_dwgb_t = DFIWGB_8TO8;
        'd4    : cast_dwgb_t = DFIWGB_8TO4;
        'd3    : cast_dwgb_t = DFIWGB_8TO2;
        'd2    : cast_dwgb_t = DFIWGB_4TO4;
        'd1    : cast_dwgb_t = DFIWGB_4TO2;
        'd0    : cast_dwgb_t = DFIWGB_2TO2;
        default: cast_dwgb_t = DFIWGB_2TO2;
      endcase
      return cast_dwgb_t;
   endfunction : cast_dwgb_t

   typedef enum logic [DFIGBWIDTH-1:0] {
      DFIRGB_16TO32 = 'd9,
      DFIRGB_8TO32  = 'd8,
      DFIRGB_8TO16  = 'd7,
      DFIRGB_8TO8   = 'd6,
      DFIRGB_4TO8   = 'd5,
      DFIRGB_4TO4   = 'd4,
      DFIRGB_2TO8   = 'd3,
      DFIRGB_2TO4   = 'd2,
      DFIRGB_2TO2   = 'd1,
      DFIRGB_1TO1   = 'd0
   } drgb_t;

   function automatic drgb_t cast_drgb_t(logic [DFIGBWIDTH-1:0] bits);
      case(bits)
        'd9    : cast_drgb_t = DFIRGB_16TO32;
        'd8    : cast_drgb_t = DFIRGB_8TO32;
        'd7    : cast_drgb_t = DFIRGB_8TO16;
        'd6    : cast_drgb_t = DFIRGB_8TO8;
        'd5    : cast_drgb_t = DFIRGB_4TO8;
        'd4    : cast_drgb_t = DFIRGB_4TO4;
        'd3    : cast_drgb_t = DFIRGB_2TO8;
        'd2    : cast_drgb_t = DFIRGB_2TO4;
        'd1    : cast_drgb_t = DFIRGB_2TO2;
        'd0    : cast_drgb_t = DFIRGB_1TO1;
        default: cast_drgb_t = DFIRGB_1TO1;
      endcase
      return cast_drgb_t;
   endfunction : cast_drgb_t