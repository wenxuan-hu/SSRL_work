typedef enum bit[1:0] {IDLE, BUSY, NONSEQ, SEQ} transfer_t;
typedef enum bit {READ, WRITE} rw_t;
typedef enum bit [2:0] {SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16} burst_t;
typedef enum bit [2:0] {BYTE, HALFWORD, WORD, WORDx2, WORDx4, WORDx8, WORDx16, WORDx32} size_t;
typedef enum bit [1:0] {OKAY, ERROR, RETRY, SPLIT} resp_t;

typedef enum bit [3:0] {PRECHARGE,ACTIVATE,COL_READ, COL_WRITE, MASKED_WRITE,COL_READ_AP,COL_WRITE_AP,MASKED_WRITE_AP,REFRESH_ALL,ERROR_0,ERROR_1,PRECHARGE_ALL,RSU_1,RSU_2,RSU_3,RSU_4} ddr_cmd_t;
string DDR_CMD[16]={"PRECHARGE","ACTIVATE","READ","WRITE","MASKED WRITE","READ_AP","WRITE_AP","MASKED_WRITE_AP","REFRESH_ALL","ERROR_0","ERROR_1","PRECHARGE_ALL","RSU_1","RSU_2","RSU_3","RSU_4"};

parameter tRP=12;
parameter tRP_db=1;
parameter tRP_ns=21;
parameter tRFC=97;
parameter tRFC_ns=180;
parameter tREFI_ns=3904; //32ms/8192row
parameter tPP_sb=1;
parameter tFAW_ns=30; //30 at 2133//40 at f<=1666
parameter tRCD_ns=18;
parameter tRCD=11;
parameter tRAS_ns=42;
parameter tRAS=24;
parameter tRC_ns=63;
parameter tRC=35;
parameter tRTP_ns=7.5;
parameter tRTP_sb=4;
parameter tCCD=2;
parameter tCCDMW=8;
parameter tRRD_ns=10;
parameter tRRD=7;
parameter tRTW_sb=10; //RL(40-DBI EN)+RU(tDQSCK/tCK)(3.5ns/7.5)+BL/2(8)-WL(18)+tWPRE(0.4)+RD(tRPSR)(1.8)=40
parameter tWTP_sb=17; //WL(18)+1+BL/2(8)+RT(tWR/tCK)(40)=67
parameter tWTR_sb=13; //WL(18)+1+BL/2(8)+RT(tWTR/tCK)(10ns/22)=49

typedef struct packed {
    time t;
    bit we;
    bit mw;
    bit[22:0] address;
} req_t;

typedef struct packed {
    time t;
    bit we;
    bit mw;
    bit[29:0] address;
    bit[7:0] length;
} dla_cmd_t;
typedef struct packed {
    time t;
    bit we;
    bit mw;
    bit[29:0] address;
    bit[7:0] length;
} nat_cmd_t;

typedef struct packed {
    bit [255:0] data;
    //bit [255:0] dla_data;
    bit channel;
    //bit [1:0] we;
    bit  we;
} dla_data_t;

typedef struct packed {
    bit [255:0] data;
    //bit [255:0] dla_data;
    bit [31:0] data_mask;
    bit we;
} data_t;

typedef struct packed {
    bit [383:0] data;
} rdi_data_t;


typedef struct packed {
    time t;
    ddr_cmd_t cmd;
    bit cas;
    bit ras;
    bit we;
    bit mw;
    bit[16:0] row;
    bit[16:0] address;
    bit[2:0] bank;
} cmd_t;

typedef struct packed {
    time t;
    ddr_cmd_t cmd;
    bit cas_n;
    bit ras_n;
    bit we_n;
    bit mw;
    bit[16:0] row;
    bit[16:0] address;
    bit[2:0] bank;
} dfi_cmd_t;

typedef struct packed{
    bit [511:0] data;
    bit [2:0] bank;
    bit [5:0] col;
    bit [16:0] row;
} dram_memory_space;
