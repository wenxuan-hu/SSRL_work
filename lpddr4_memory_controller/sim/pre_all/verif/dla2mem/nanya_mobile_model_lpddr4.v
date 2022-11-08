/******************************************************************************
###############################################################################
#  PROPERTY OF NANYA TECHNOLOGY -- FOR UNRESTRICTED INTERNAL USE ONLY --      #
#  UNAUTHORIZED REPRODUCTION AND/OR DISTRINBUTION IS STRICTLY PROHIBITED.     #
#  THIS PRODUCT IS PROTECTED UNDER COPYRIGHT LAW AS AN UNPUBLISHED WORK.      #
#  CREATED 2018(C) BY NANYA TECHNOLOGY CORPORATION.   ALL RIGHTS RESERVED.    #
###############################################################################
*
*  File Name: nanya_mobile_model_lpddr4.v
*
*  Rev     Date     Author  Changes
*  ---  ----------  ------  -----------------------------
*  0.1  2016:06:01   MCHL   -Initial LPDDR4 - Command Decode, RD/WR/MWR/MPC/CBT/WLEV working
*  0.2  2017:06:01   MCHL   -x16 functional version 1 - single channel only
*  0.3  2017:09:01   MCHL   -x8u/x8l functional - single channel only  
*  0.4  2018:02:23   SMP    -Synconized clocks, changed to TAB=8 deliniated for consistancy
*  0.5 	2018:02:01   MCHL   - _4x support (MR only) + Cleaninng / comments		
*  0.6  2018:05:30   MCHL	- added non-blocking delay to various pipe assignments to settle VCS/NC/Icarus deltas 	
*  0.7  2018:06:06   MCHL   - added Den_#Gb for 2, 4, 8 Gb .....			 
*  0.8  2018:07:02   MCHL   - inverted WLEV output polarity, removed uneeded registers, and added %m for path in MRW / MRR, added additional debug statements
*  0.9  2018:10:15   MCHL   - modified DQS_clk_wr to deal with VCS glitch generation 
*  0.10 2020:01:17   MCHL   - Removed Byte mode code - should not be able to enter x8 modes
*							- Updated ODT strength to be pull (from weak)
*							- Updated nWR tables for byte mode vs. x16
*  0.11 2020:06:27   MCHL   - Various updates to increas jitter tolerance
*  0.12 2020:07:13   MCHL   - Various updates to increas jitter tolerance , updated timescale to 1ps/1fs
*
*	"Multi_Step_Command" state table
*	0 = no command or 1st edge of command in progress - Idle , Bank Active, SREF
*	1 = 1st edge of command latched, 2nd edge of command in progress
*	2 = 3rd edge of command in progress - ex. CAS-2 , MRW-2 etc...
*	3 = 4th edge of command in progress
*
*	VALID Nanya_cmd_string states : RESET, NOP, DES, MPC, RD_FIFO_MPC, RD_FIFO_MPC, RD_DQ_MPC, +OSC+_MPC, -OSC-_MPC, +ZQ+_MPC, -ZQ-_MPC
*					ACT, MRW, MRR, RD, RDA, WR, WRA, MWR, MWRA, PR, PRA, RefPB, RefAB, SREF0, SREF, SRX, APD, PPD, SPD
*					Ill. RD & Ill.WR
*
*  NOTE ** When Running the model in Byte mode short DQS_t_A[0] to DQS_t_A[1] and similarly DQS_c_A[0] to DQS_c_A[0]
*  NOTE ** tCK should always be an even number of picoseconds
*  NOTE ** no illegals are blocked and the device must be reset
*  --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*--
*  --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*--
*  JEDEC SPEC 4.50 : any operation or timing not specified is illegal and a the device
*  must be power cycled or reset (RESET pulse sequence)  
*  --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*--
*  --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*-- --*--
*******************************************************************************/
`timescale 1 ps / 1 fs
`include "parm.v"

module L4_Model(CA_A, CKE_A, CK_c_A, CK_t_A, CS_A, DMI_A, DQ_A, DQS_t_A, DQS_c_A, ODT_CA_A, RESET); 
// Port Declarations
inout [`CA_Bits-1:0]        CA_A;       //, CA_B;
input                       CKE_A;      //, CKE_B;
inout                       CK_c_A;     //, CK_c_B;
inout                       CK_t_A;     //, CK_t_B;
inout                       CS_A;       //, CS_B;
inout [`Max_Data_Mask-1:0]  DMI_A;      //, DMI_B;
inout [`Max_Data_Width-1:0] DQ_A;       //, DQ_B;
inout [`Max_Data_Mask-1:0]  DQS_t_A;    //, DQS_t_B;
inout [`Max_Data_Mask-1:0]  DQS_c_A;    //, DQS_c_B;
input                       ODT_CA_A;   //, ODT_CA_B;
input                       RESET;

`ifdef X16
LPDDR4_Model chan0 (CA_A, CKE_A, CK_c_A, CK_t_A, CS_A, DMI_A, DQ_A, DQS_t_A, DQS_c_A, ODT_CA_A, RESET);
`endif
//`ifdef X8L
//LPDDR4_Model chan0 (CA_A, CKE_A, CK_c_A, CK_t_A, CS_A, {1'bz,DMI_A[0]}, {8'bz,DQ_A[7:0]}, {DQS_t_A[0],DQS_t_A[0]}, {DQS_c_A[0],DQS_c_A[0]}, ODT_CA_A, RESET);
//`endif
//`ifdef X8U
//LPDDR4_Model chan0 (CA_A, CKE_A, CK_c_A, CK_t_A, CS_A, {DMI_A[1],1'bz}, {DQ_A[15:8],8'bz}, {DQS_t_A[1],DQS_t_A[1]}, {DQS_c_A[1],DQS_c_A[1]}, ODT_CA_A, RESET);
//`endif
endmodule // L4_Model

//channel module
module LPDDR4_Model( CA, CKE, CLKF, CLK, CsF, DmPadIn, DqPadIn, DqsPadIn, DqsPadFIn, ODT, RESET);
// Port Declarations
inout [`CA_Bits-1:0]		CA;
input				CKE;
inout				CLKF;
inout				CLK;
inout				CsF;
inout [`Max_Data_Mask-1:0]	DmPadIn;
inout [`Max_Data_Width-1:0]	DqPadIn;
inout [`Max_Data_Mask-1:0]	DqsPadIn;
inout [`Max_Data_Mask-1:0]	DqsPadFIn;
input				ODT;
input				RESET;	

// ByModde Configuration.......
//#################################################################################################################
// one of the below has to be set for each run to select Byte mode or x16
// X16 , X8U , X8L are for the DQ configurations
// Customers should like comment out the below and only include the three register settings they want
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//`ifdef X8L
//    reg X=0;                   reg BYTE=0;                   reg CAS=0;
//`endif
//`ifdef X8U
//    reg X=0;                   reg BYTE=1;                   reg CAS=0;
//`endif
`ifdef X16
    reg X=1;                   reg BYTE=0;                   reg CAS=0;
`endif

// Addresses
//##################################################################################
parameter Max_RL=16;   	
parameter Max_BL=32;
parameter Pipe_Size=3*(Max_RL*2+Max_BL);                // Pipe size
parameter Max_Bits=`Bank_Bits+`Row_Bits+`Col_Bits-1;
reg   [`Row_Bits-1:0]	Radd [0:`Banks-1];              // Row  address in each bank
reg   [`Row_Bits-1:0]	ROW;                            // Row  address
reg   [`Row_Bits-1:0]	ROW_lat;                        // Row  address latched
reg   [`Row_Bits-1:0]	ROW_PIPE [0:Pipe_Size];         // Row  address PIPE
reg   [`Col_Bits-1:0]	COL;                            // Col  address
reg   [`Col_Bits-1:0]	COL_lat;                        // Col  address latched
reg   [`Col_Bits-1:0]	COL_PIPE [0:Pipe_Size];         // Col  address PIPE
reg   [`Col_Bits-1:0]	tmp_Cadd;                       // Temporary reg for col address		
reg   [`Bank_Bits-1:0]	WR_Bank_PIPE [0:Pipe_Size];     // Bank address PIPE 
reg   [`Bank_Bits-1:0]	Write_Bank;                     // Write Bank address
reg   [`Bank_Bits-1:0]	Read_Bank;                      // Read Bank address
reg   [`Bank_Bits-1:0]	BA;                             // Bank Address 
reg   [Pipe_Size:0]	MASK_PIPE ;                     // Mask Pipe
reg   [Pipe_Size:0]	BURST_PIPE_RD ;                 // Burst Length Pipe
reg   [Pipe_Size:0]	BURST_PIPE_WR ;	                // Burst Length Pipe
reg   [Pipe_Size:0]	RD_FIFO_PIPE ;                  // FIFO Pipe
reg   [Pipe_Size:0]	WR_FIFO_PIPE ;                  // FIFO Pipe
reg                     MASK_temp;                      // Mask flag latency adjusted
reg                     MASK_tempAAA;                   // Mask flag latency adjusted
reg                     MASK;                           // Mask flag timing exact (tDQSS etc....)
integer                 RD_FIFO_POINT ;                 // RD FIFO POINTER - 
integer                 WR_FIFO_POINT ;	                // WR FIFO POINTER - 

// Data
//##################################################################################
reg                     ODT_Force_DM;                   // ODT Forcing of DQ,DQS,DQSF
reg                     ODT_Force_DQ;                   // ODT Forcing of DQ,DQS,DQSF
reg                     ODT_Force_CA;                   // ODT Forcing of CA
reg                     ODT_Force_CS;                   // ODT Forcing of CS					
reg                     ODT_Force_CK;                   // ODT Forcing of CLK 					
reg                     Write_Leveling;                 // (MR flag) Write Leveling
reg                     CA_training_DQ;	      	        // CA Training DQ Mux Bit
reg   [`Data_Width-1:0] dqout;                         	// Data out
reg   [`Data_Width-1:0] dq_mask;                        // Data masked
reg   [`Data_Width-1:0] dq_prt;                         // Data print out
reg   [`Data_Width-1:0]	FIFO_DATA [79:0];               // Registers to store FIFO data
reg   [`Data_Mask-1:0]  FIFO_DM_DATA [79:0];            // Registers to store FIFO data
reg   [`DQS_Bits-1:0]  	DqPad_Int_WL;  	                // Write Levelization DQ Values
reg   [`DQS_Bits-1:0]	DqsPad_Int_temp;                // Temporary dqs variable
reg   [`DQS_Bits-1:0]	DqsPadF_Int_temp;               // Temporary dqsf variable
reg   [`Data_Width-1:0]	DqPad_Int_temp;                 // Temporary dq variable
reg   [`Data_Mask-1:0]	DmPad_Int_temp;                 // Temporary dm variable
reg   [`Data_Width-1:0]	DqPad_Int_CA;                   // DQ during CA training

// dynamic array - data construct
typedef struct packed {
	reg [`Bank_Bits-1:0]      bank; 
	reg [`Row_Bits-1:0]       row;
	reg [`Col_Bits-1:4]       col;
	reg [`Data_Width*16-1:0]  data;
    } UTYPE_DataEntry;

UTYPE_DataEntry array [];

// tracks where the next entry would go    
integer array_cnt; 

// below are the I/O pins that are also terminated async
assign (pull0, pull1)DmPadIn[`Data_Mask-1:0]  = ODT_Force_DM ? 2'b00	: DmPad_Int_temp;
assign (pull0, pull1)DqsPadIn[`DQS_Bits-1:0]  = ODT_Force_DQ ? 2'b00	: DqsPad_Int_temp;
assign (pull0, pull1)DqsPadFIn[`DQS_Bits-1:0] = ODT_Force_DQ ? 2'b00	: DqsPadF_Int_temp;
assign (pull0, pull1)DqPadIn[`Data_Width-1:0] = ODT_Force_DQ ? 16'h0000 : (Write_Leveling ? {{8{DqPad_Int_WL[1]}},{8{DqPad_Int_WL[0]}}} : (CA_training_DQ ?  DqPad_Int_CA : DqPad_Int_temp));

// CA, CLK, CLKF, CsF are all input only pins
assign (pull0, pull1)    CA[`CA_Bits-1:0] = ODT_Force_CA ? 6'h0 : 6'hz;  	   
assign (pull0, pull1)    CLK              = ODT_Force_CK ? 1'b0 : 1'bz;
assign (pull0, pull1)    CLKF             = ODT_Force_CK ? 1'b0 : 1'bz;
assign (pull0, pull1)    CsF              = ODT_Force_CS ? 1'b0 : 1'bz;
wire   [`Data_Width-1:0] DqPad            = DqPadIn[`Data_Width-1:0];
wire   [`DQS_Bits-1:0]   DqsPad           = DqsPadIn[`DQS_Bits-1:0]; 
wire   [`DQS_Bits-1:0]   DqsPadF          = DqsPadFIn[`DQS_Bits-1:0];
wire   [`Data_Mask-1:0]  DmPad            = DmPadIn[`Data_Mask-1:0]; 
wire   [`Data_Width-1:0] Exp_DQ           = DqPad_Int_temp;

// Control
//##################################################################################
integer             Dout_en_longtCK;             // LongtCK Data out offset
integer             Dout_en_offset;              // Offset for dataout based on tDQSCK
integer             Dout_en_real;                // Rounded offset of dataout based on tDQSCK
reg    [`Banks-1:0] Act_Banks;                   // Active Banks
reg           [5:0] Burst_Cnt;                   // Burst counter
reg                 Block_Command;               // When in PD, SREF, or DPD, block any other PD, SREF, or DPD commands until CKE rises again
reg    [`Banks-1:0] Block_Command_REF;           // Block commands from being entered after a refresh is initiated
integer             nWR;                         // Write to internal auto precharge
integer             nRTP;                        // READ .....
reg                 Read_IP;                     // Read in progress blocking for interrupts
reg [`Bank_Bits-1:0] Read_Bank_Pre;              // Bank last issued read command
reg                 Write_IP;                    // Write in progress blocking for interrupts
reg                 write_open;                  // Write to open banks only
reg                 write_open_temp;             // Write to open banks only temporary value
reg                 write_open_temp_BL16;        // Write to open banks only temporary value
reg                 write_open_temp_BL32;        // Write to open banks only temporary value
reg                 ODT_write;                   // FIFO CLK edge accurate results for ODT from writes
reg                 ODT_write_BL16;              // FIFO CLK edge accurate results for ODT from writes
reg                 ODT_write_BL32;              // FIFO CLK edge accurate results for ODT from writes
reg                 ODT_FIFO;                    // FIFO CLK edge accurate results for ODT from MPC writes
reg                 ODT_temp;                    // Temp value for debug, should be deleted ....
reg   [Pipe_Size:0] write_open_PIPE;             // Write pipe to force write open closed when no dqs is provided
reg   [Pipe_Size:0] write_open_PIPE_BL16;        // Write pipe to force write open closed when no dqs is provided
reg   [Pipe_Size:0] write_open_PIPE_BL32;        // Write pipe to force write open closed when no dqs is provided

// Control -- Data
//##################################################################################
reg		    	Din_en;			// Data in  enable
reg		    	Dout_en;		// Data out enable
reg		    	Dout_en_BL16;		// Data out enable
reg		    	Dout_en_BL32;		// Data out enable
reg		    	Dout_en_rd; 		// Data out enable
reg		    	Dout_en_rd_BL16;	// Data out enable
reg		    	Dout_en_rd_BL32;	// Data out enable
reg		    	Dout_en_rd_post;	// Data out enable
reg		    	Dout_en_rd_pre1;	// Data out enable
reg		    	Dout_en_rd_pre1_BL16;   // Data out enable
reg		    	Dout_en_rd_pre1_BL32;   // Data out enable
reg		    	Dout_en_rd_pre2;	// Data out enable
reg		    	Dout_en_rd_pre2_BL16;   // Data out enable
reg		    	Dout_en_rd_pre2_BL32;	// Data out enable
reg		    	MRR_en_rd;  		// Data out enable
reg		    	MRR_en_rd_a;  		// Data out enable
reg   [Pipe_Size:0] 	Dout_en_PIPE; 	   	// Data out enable pipe
reg   [Pipe_Size:0] 	Dout_en_PIPE_BL16; 	// Data out enable pipe
reg   [Pipe_Size:0] 	Dout_en_PIPE_BL32; 	// Data out enable pipe
reg		    	burst_rd;		// tracker for burst length of reads
reg		    	burst_rd_a;		// tracker for burst length of reads
reg		    	burst_wr;		// tracker for burst length of writes
reg		    	RD_FIFO_en;		// tracker for when the OR pipe is showing RD_FIFO
reg		    	RD_FIFO_en_a;		// tracker for when the OR pipe is showing RD_FIFO
reg		    	WR_FIFO_en;		// tracker for when the OR pipe is showing WR_FIFO
reg		    	WR_FIFO_en_adj;		// tracker for when the OR pipe is showing WR_FIFO
reg [`Data_Width*16-1:0]data_burst;		// will assemble DQ data in 16 burst quanta

// Control -- ModeReg
//##################################################################################
parameter     [5:0] MRR_Burst_Length=16;	// MRR Burst Length   
reg           [5:0] Burst_Length [1:0];		// Burst Length Register
integer		    Initialize;			// Initialization status									    
integer             Read_Latency;          	// Default Read Latency
integer             Write_Latency;         	// Default Write Latency
reg		    AP;				// Auto Precharge used in RD and WR 						    
reg                 SREF;			// SREF end / dis able signal
reg                 CA_training; 	   	// (MR flag) CA Training Enable Bit
reg		    RPT_Training;		// (MR flag) Read Preamble Training
reg                 CA_training_mode; 		// (MR flag) CA Training mode Bit 0/1 - only for X8 mode
reg		    BL; 			// (MR flag) Burst Length On The Fly					    
reg		    OTF;			// (MR flag) Burst Length On The Fly					    
reg		    DBI_WR;			// (MR flag) DBI-WR enable 
reg		    DBI_RD;			// (MR flag) DBI-RD enable
reg		    DM_DIS;			// (MR flag) Data Mask Enable
reg		    PPR;			// (MR flag) Post Package Repair Flag - 
reg		    TRR;			// (MR flag) Target Row Refresh Flag - 
reg  	      [2:0] Last_temp;         		// Mode Register Addressing
reg  	      [5:0] MA;    	           	// Mode Register Addressing
reg  	      [5:0] MA_lat;    	           	// Mode Register Addressing
reg           [7:0] mode_reg [255:0];      	// 256 8-bit Mode Registers
reg	     [60:0] FSP_OP_REG [1:0];		// Frequency Set Point Registers x2
reg		    FSP_OP;			// debug of FSP patterns
reg		    FSP_WR;			// debug of FSP patterns
reg           [1:0] MR_RW_enable [255:0];  	// set read/write status of each mode register
reg           [7:0] MRR_data [Pipe_Size:0];	// MRR read out data for DQ
reg		    MRR_en;			// MRR Read Enable
reg   [Pipe_Size:0] MRR_en_PIPE;	    	// MRR Data out enable pipe
reg           [7:0] OP;    	           	// Mode Register Data
reg           [7:0] part_config;           	// 8-bit Mode Registers with Device Config info
reg		    RTTval_dq;  		// (MR flag) MR11 RTT Termination value for DQ ODT
reg		    RTTval_ca;  		// (MR flag) MR11 RTT Termination value for CA ODT
reg                 MPC_LAT;               	// Latched Command Decoder Signals
reg                 MRW_LAT;               	// Latched Command Decoder Signals
reg                 MRR_LAT;		   	// Latched Command Decoder Signals
reg                 MRR4_READ;		   	// Has the MR4 address been read since power up / reset 
reg                 RefPB_LAT;		   	// Latched Command Decoder Signals
reg                 RefAB_LAT;		   	// Latched Command Decoder Signals
reg                 DESL_LAT;		   	// Latched Command Decoder Signals
reg                 NOP_LAT;		   	// Latched Command Decoder Signals
reg                 ACT_LAT;		   	// Latched Command Decoder Signals
reg                 WR_LAT;		   	// Latched Command Decoder Signals
reg		    MWR_LAT;			// Latched Command Decoder Signals
reg                 RD_LAT;		   	// Latched Command Decoder Signals
reg                 PRE_LAT;		   	// Latched Command Decoder Signals
reg                 SREF_LAT;		   	// Latched Command Decoder Signals
reg                 SRX_LAT;		   	// Latched Command Decoder Signals
reg                 CAS_LAT;		   	// Latched Command Decoder Signals
reg                 PD_LAT;			// Latched Command Decoder Signals
reg 		    RD_FIFO_LAT;		// Latched Command Decoder Signals
reg		    RD_DQ_LAT;			// Latched Command Decoder Signals
reg		    WR_FIFO_LAT;		// Latched Command Decoder Signals
reg		    DQ_O_STRT_LAT;		// Latched Command Decoder Signals
reg		    DQ_O_STOP_LAT;		// Latched Command Decoder Signals
reg		    MPC_DQS_OSC_ON;		// Signal for when DQS OSC Counter is on
integer		    MPC_DQS_OSC_CLK_COUNT;	// Counter of clock after MPC_DQS_OSC_START command
reg		    ZQ_C_STRT_LAT;		// Latched Command Decoder Signals
reg		    ZQ_C_STOP_LAT;		// Latched Command Decoder Signals

// Control -- Clocks
//##################################################################################
reg	CLK0;	           		// Internal clock

// Control -- temporary, index
//##################################################################################
integer i,j,k,kmk,m,b;			// Loop Counters
integer Multi_Step_Command;		// Counter of rising edges in multi step commands 

// Timing Check - Internal
//##################################################################################
time  tCH_meas;				// tCH current  value
time  tCH_meas_prev;			// tCH previous value
time  tCH_meas_stable;			// tCH last known stable value
time  tCH_calc;				// tCH current  duty cycle
time  tCL_meas;				// tCL current  value
time  tCL_meas_stable;			// tCL last known stable value
time  tCL_meas_prev;			// tCL previous value
time  tCL_calc;				// tCL current  duty cycle
time  tCK_meas;				// tCK current value
time  tCK_meas_stable;			// tCK last known stable value
time  tCK_half;				// tCK/2
time  tCK_half_stable;			// tCK/2
time  t_RD;				// Internal Read Check
time  t_RD_MPC;				// Internal Read Check
time  t_WR_FIFO;			// Internal Read Check
time  t_RD_FIFO;			// Internal Read Check
time  t_CCD;				// Internal CAS-CAS Check
time  t_MRR;				// Internal MRR Check
time  t_MRW;				// Internal MRW Check
time  t_MPC;				// Internal MPC Check
time  t_RefAB;				// Internal RefAB Check
time  t_Ref;				// Internal Ref Check
time  t_RefPB [`Bank_Bits-1 : 0];	// Internal RefPB Check
time  t_CKE;				// Internal CKE check
time  t_RESET;				// Internal RESET check
time  t_WRend;				// Internal tWR check
time  t_bankRD [`Bank_Bits-1 : 0];	// Internal tRTP check
time  t_bankWRend [`Bank_Bits-1 : 0];	// Internal tWR check
time  t_bankWR [`Bank_Bits-1 : 0];	// Internal tWR check
time  t_ACT;				// Internal Act check
time  t_bankACT [`Bank_Bits-1 : 0];	// Internal Act check
time  t_bankPRE [`Bank_Bits-1 : 0];	// Internal Precharge check
time  t_PRE_ALL;			// Internal Precharge all check
time  t_SREF;				// Internal SREF check
time  t_PD;				// Internal Power Down check
time  t_INIT3;  	                // measured tInit3 time
time  t_INIT4;  	                // measured tInit4 time
time  CLK0_neg; 	                // measured negative clock transition
time  CLK0_pos; 	                // measured positive clock transition
time  tODT_lockout;	                // AODT vs ODT lockout

// Spec Timing Parameters
//##################################################################################
integer tDQSCK    ;		// DQS output data access time from Clock
integer tDQSCK_adj;		// tDQSCK - (ru(tDQSCK/tCK_half)*tck)
integer tDQSQ     ;		// Data Strobe edge to output data edge
integer tDS       ;		// DQ and DM input setupt time
integer tDH       ;		// DQ and DM input hold time
integer tCK       ;		// Average Clock period
integer tCK_MIN	  ;		// Average Clock period
integer tIS       ;		// Address and Control Input Setup time
integer tIH       ;		// Address and Control Input Hold time
integer tRFCab    ;		// Refresh Cycle Time All Bank
integer tRFCpb    ;		// Refresh Cycle Time Per Bank
integer tRPRE     ;		// Read Preamble	- this is in tck
integer tRPSTc    ;		// Read Postamble 	- this is in 1/2 tck or DQS clk
integer tWTR      ;		// Internal Write to Read Delay
integer tWLO      ;		// Write leveling output delay
integer tADR      ;		// Data out delay after CA training calibration command
integer tMRZ      ;		// MRW CA exit command to DQ tri-state
integer tCAMRD    ;		// First CA calibration command after CA calibration
integer tAD2DQ7   ;		// CATRAINING MODE2 timing variables
integer tADSPW    ;		// CATRAINING MODE2 timing variables
integer tDQ7SH	  ;		// CATRAINING MODE2 timing variables
integer tRESET    ;		// RESET min pulse width
integer tCKE      ;		// CKE min pulse width
integer tCKESR    ;		// CKE min pulse width during SREF
integer tCH_min   ;		// tCH min
integer tCH_max   ;		// tCH max
integer tCL_min   ;		// tCL min
integer tCL_max   ;		// tCL max
integer tCCD	  ;		// CAS to CAS Delay
integer tDQSCK_max;		// DQS output access time from CK_t/CK_c
integer tDQSH	  ;		// DQS input high-level width
integer tDQSL	  ;		// DQS input high-level width
integer tDQSS	  ;		// Write command to 1st DQS latching transition			
integer tDQSSp	  ;		// Write command to 1st DQS latching transition
integer tDSS	  ;		// DQS falling edge to CK setup time
integer tDSH      ;		// DQS falling edge hold time from CK
integer tRAS      ;		// Row Active Time
integer tWPRE     ;		// Write preamble
integer tWPST     ;		// Write postamble
integer tISCKE    ;		// CKE input setup time
integer tIHCKE    ;		// CKE input hold time
integer tODTon    ;		// Asynchronous RTT turn on  delay from ODT input
integer tODToff   ;		// Asynchronous RTT turn off delay from ODT input
integer tAODTon   ;		// Automatic RTT turn on  delay after READ data
integer tAODToff  ;		// Automatic RTT turn off delay after READ data
integer tODTe	  ;		// RTT enable  delay from power down, SREF, and DPD
integer tODTd	  ;		// RTT disable delay from power down, SREF, and DPD
integer tRCD      ;		// RAS to CAS Delay
integer tRPab     ;		// Row Precharge Time, all banks
integer tRPpb     ;		// Row Precharge Time, single bank
integer tRC       ;		// Active bank A to Active bank A
integer tRRD      ;		// Active bank A to Active bank B
integer tRTP      ;		// Internal Read to Precharge command delay
integer tWR       ;		// Write Recovery Time
integer tXP       ;		// Exit power down to next valid command delay
integer tXSR      ;		// Self refresh exit to next valid command delay
integer tPGM	  ;		// tPGM
integer tPGM_exit ;		// tPGM_exit
integer tINIT1    ;		// Minimum CKE low time after completion of power ramp
integer tINIT3    ;		// Minimum idle time after first CKE assertion
integer tINIT4    ;		// Minimum idle time after Reset command
integer tINIT5    ;		// Minimum idle time after Reset command
integer tMRR      ;		// MRR command period
integer tMRD      ;		// MRR command period RD
integer tMRW      ;		// Mode Register Write Command Period
integer tINIT2    ;		// Minimum stable clock before first CKE high
integer tDQS2DQ	  ;		// DQS to DQ offset
integer tdiVW	  ;		// valid DQ pulse window for `ANALOG
integer ClockDutyCycle_p; 	// clock duty cycle - range should be 43 to 57 max
bit temp_update;
integer old_temp;

// Seperate tDQS2DQ and tDQSCK adjusted WRITE & READ clocks
reg 	DQS_clk_wr;		// Internal DQS_in clock
reg 	DQS_clk_rd;		// Internal DQS_in clock
reg 	DQSF_clk_rd;		// Internal DQS_in clock

// COMMAND DECODE: R1 + R2 Command Decode
//##################################################################################
wire  DESL_EN	= ~CsF							     &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  NOP_EN    =  CsF & ~CA[0] & ~CA[1] & ~CA[2] & ~CA[3] & ~CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  MPC_EN	=  CsF & ~CA[0] & ~CA[1] & ~CA[2] & ~CA[3] & ~CA[4] &  CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling 	      & ~PPR;
wire  PRE_EN_AB	=  CsF & ~CA[0] & ~CA[1] & ~CA[2] & ~CA[3] &  CA[4] &  CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  PRE_EN	=  CsF & ~CA[0] & ~CA[1] & ~CA[2] & ~CA[3] &  CA[4]          &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF ;
wire  REF_EN_AB	=  CsF & ~CA[0] & ~CA[1] & ~CA[2] &  CA[3] & ~CA[4] &  CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  REF_EN_PB	=  CsF & ~CA[0] & ~CA[1] & ~CA[2] &  CA[3] & ~CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  SREF_EN	=  CsF & ~CA[0] & ~CA[1] & ~CA[2] &  CA[3] &  CA[4]          &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  WR1_EN	=  CsF & ~CA[0] & ~CA[1] &  CA[2] & ~CA[3] & ~CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  WR1_BL_EN	=  CsF & ~CA[0] & ~CA[1] &  CA[2] & ~CA[3] & ~CA[4] &  CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  SRX_EN	=  CsF & ~CA[0] & ~CA[1] &  CA[2] & ~CA[3] &  CA[4]          &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling &  SREF & ~PPR;
wire  MWR1_EN	=  CsF & ~CA[0] & ~CA[1] &  CA[2] &  CA[3] & ~CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  RFU_1_EN	=  CsF & ~CA[0] & ~CA[1] &  CA[2] &  CA[3] &  CA[4]          &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  RD_EN	=  CsF & ~CA[0] &  CA[1] & ~CA[2] & ~CA[3] & ~CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  RD_BL_EN	=  CsF & ~CA[0] &  CA[1] & ~CA[2] & ~CA[3] & ~CA[4] &  CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  RFU_2_EN	=  CsF & ~CA[0] &  CA[1] & ~CA[2] &  CA[3] & ~CA[4]          &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  RFU_3_EN	=  CsF & ~CA[0] &  CA[1] & ~CA[2] &  CA[3] & ~CA[4]          &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  MRW1_EN	=  CsF & ~CA[0] &  CA[1] &  CA[2] & ~CA[3] & ~CA[4] 	     &  CKE  & RESET ;
wire  MRR_EN	=  CsF & ~CA[0] &  CA[1] &  CA[2] &  CA[3] & ~CA[4] 	     &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling	      & ~PPR;
wire  RFU_4_EN	=  CsF & ~CA[0] &  CA[1] &  CA[2] &  CA[3] &  CA[4] 	     &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF & ~PPR;
wire  ACT1_EN	=  CsF &  CA[0] & ~CA[1] 				     &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF;
wire  PD_EN	=  						       	       ~CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling	      & ~PPR;
wire  RESET_EN	= 								      ~RESET;
wire  RFU_EN	=  RFU_1_EN || RFU_2_EN || RFU_3_EN || RFU_4_EN		             & RESET;

// R2 Command decodes
wire MPC_RD_FIFO   = ~CsF &  CA[0] & ~CA[1] & ~CA[2] & ~CA[3] & ~CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~PPR;
wire MPC_RD_DQ     = ~CsF &  CA[0] &  CA[1] & ~CA[2] & ~CA[3] & ~CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & 		 ~Write_Leveling & ~PPR;
wire MPC_WR_FIFO   = ~CsF &  CA[0] &  CA[1] &  CA[2] & ~CA[3] & ~CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~PPR;
wire MPC_DQ_O_STRT = ~CsF &  CA[0] &  CA[1] & ~CA[2] &  CA[3] & ~CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~PPR;
wire MPC_DQ_O_STOP = ~CsF &  CA[0] & ~CA[1] &  CA[2] &  CA[3] & ~CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~PPR;
wire MPC_ZQ_C_STRT = ~CsF &  CA[0] &  CA[1] &  CA[2] &  CA[3] & ~CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~PPR;
wire MPC_ZQ_C_STOP = ~CsF &  CA[0] & ~CA[1] & ~CA[2] & ~CA[3] &  CA[4] & ~CA[5] &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~PPR;

// R3 Command decodes
wire  CAS2_EN      =  CsF & ~CA[0] &  CA[1] & ~CA[2] & ~CA[3] &  CA[4] 	        &  CKE  & RESET & ~CA_training & 		 ~Write_Leveling & ~PPR;
wire  MRW2_EN	   =  CsF & ~CA[0] &  CA[1] &  CA[2] & ~CA[3] &  CA[4] 	        &  CKE  & RESET;
// THIS IS THE LEGACY ACT2 - will not be valid for chips that use R17 | R18
wire  ACT2_EN	   =  CsF &  CA[0] &  CA[1] 				        			&  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~SREF;
wire  CAS2_non_EN  = ~CsF & ~CA[0] &  CA[1] & ~CA[2] & ~CA[3] &  CA[4] 	        &  CKE  & RESET & ~CA_training & ~RPT_Training & ~Write_Leveling & ~PPR;

// Internal Registers
//##################################################################################
// bus size = Number of Characters * 8
reg [(16*8)-1:0]  	Nanya_cmd_string;	// Command String
reg [(256*8)-1:0] 	debug_string;		// Debug String showing DQS_out state
reg [(256*8)-1:0] 	warning_string;		// Warning String
reg [(256*8)-1:0] 	timing_string;		// Timing Warning String
reg [(16*8)-1:0]  	CKE_cmd_string;		// CKE State

// Memory Arrays 	
//##################################################################################
`ifdef WRITE_TO_FILE
    $display("In WRITE_TO_FILE ... mem vs. DASD , do you want to be here ?? ");
    parameter FILE_BITS = `Data_Width;
    // %z format uses 8 bytes for every 32 bits or less
    parameter FILE_CHUNK = 8 * ((FILE_BITS*2)/32 + ((FILE_BITS*2)%32 ? 1 : 0));
    reg [1024:1] tempDir;
    integer memoryFileDesc [(1<<`Bank_Bits)-1:0];
    initial
    begin : fileIOopen
        integer curBank;
        if (!$value$plusargs("model_data+%s", tempDir)) tempDir = "/tmp"; 
	$display("%m: at time %t WARNING: no +model_data option specified, using /tmp.", $time );
        for (curBank = 0; curBank < (1<<`Bank_Bits); curBank = curBank + 1) memoryFileDesc[curBank] = openFile(curBank);
    end
`else
    parameter Memory_Size=`Mem_Size-1;
`endif

// Temperature senseor section 
//################################################################################################
// Temperature changes and different readouts from MR[4] are not supported

// Initialization - Main Loop
//##################################################################################
initial begin
    set_mode_register_params;
    $display("Memory_Size: %0d", Memory_Size);
    Initialize_Timings;
    erase_all;
    set_mode_register_rw;
    debug_string   = "Initializing";
    Initialize     = `Check_Initialization;
    Multi_Step_Command = 0; 							
    array = new[1000]; 			
    temp_update = 0;
    ODT_temp= 0;
// Customer Model Additions	
	tDQSCK 	= `tDQSCK; 
	tDQS2DQ = `tDQS2DQ;
	tCK    	= `tCK;
	tDQSSp  = `tDQSSp;
	tWLO	= `tWLO;  
	tADR	= `tADR;  
	tMRZ	= `tMRZ; 
	tAD2DQ7 = `tAD2DQ7;
	tADSPW	= `tADSPW;
	tDQ7SH 	= `tDQ7SH;
	tXP 	= `tXP;
	tCKESR	= `tCKESR;
	tODTon	= `tODTon;
	tODToff = `tODToff;
	ClockDutyCycle_p = `ClockDutyCycle_p ;
end

// ###################################
// Internal Clock Generation @negedge 
// ##################################
always @(negedge CLK) begin
    CLK0 = 0;
    CLK0_neg = $realtime;
    tCH_meas_prev = tCH_meas;
    tCH_meas = CLK0_neg - CLK0_pos;
    tCK_meas = tCH_meas + tCL_meas;
    tCK_half=tCK_meas/2;
    // Calculate tXP as max of 7.5ns or 5*tCK
    if( Block_Command == 1 && (tCL_meas < tCH_meas) && (tXP < 6*tCL_meas)) 
	tXP = 6*tCL_meas;
    else if(Block_Command == 1 && (tCH_meas < tCL_meas) && (tXP < 6*tCH_meas)) 
	tXP = 10*tCH_meas;
    else if(Block_Command == 0 && (tXP < 5*tCK_meas_stable))		   
	tXP = 5*tCK_meas_stable;   
// Calculate values for CKE exit with changing tCK 
    if(Block_Command == 1) begin 
	tCK   = 2*tCH_meas;
	tODTe = tDQSCK+tCK;
    end
    DQS_clk_rd <= #(tDQSCK) CLK;
    DQSF_clk_rd <= #(tDQSCK) !CLK; 
end // end "negedge CLK"


// ###################################
// Internal Clock Generation @posedge 
// ##################################
always @(posedge CLK) begin
// DQS OSCILLATOR COUNT STUFF BELOW
    if (MPC_DQS_OSC_ON) begin
	MPC_DQS_OSC_CLK_COUNT = MPC_DQS_OSC_CLK_COUNT +1;
	if (mode_reg[23] != 8'b0000_0000)begin
	    // CHECK FOR DQS OSC COUNTER STOP CONDITIONS ** 
	    if ((mode_reg[23][7:6] == 2'b11) && (MPC_DQS_OSC_CLK_COUNT > 8191)) MPC_DQS_OSC_ON = 1'b0;
	    if ((mode_reg[23][7:6] == 2'b10) && (MPC_DQS_OSC_CLK_COUNT > 4095)) MPC_DQS_OSC_ON = 1'b0;
	    if ((mode_reg[23][7:6] == 2'b01) && (MPC_DQS_OSC_CLK_COUNT > 2047)) MPC_DQS_OSC_ON = 1'b0;
	    if ((mode_reg[23][7:6] == 2'b00) && (MPC_DQS_OSC_CLK_COUNT > ((mode_reg[23][5:0]*16)-1))) MPC_DQS_OSC_ON = 1'b0;	    
	end
    end	
    else begin 
	    {mode_reg[19],mode_reg[18]} = ru( ((MPC_DQS_OSC_CLK_COUNT*tCK)-239) , ((2*tDQS2DQ)-80));
    end

    CLK0_pos = $realtime;
    tCL_meas_prev = tCL_meas;
    tCL_meas = CLK0_pos - CLK0_neg;
    tCK_meas = tCH_meas + tCL_meas;
    tCK_half=tCK_meas/2;
    tRPRE=2;					    
    if(Block_Command == 0) 
	tCK=tCK_meas;						
    // only calculate with stable clock
    if(tCL_meas == tCL_meas_prev && tCH_meas == tCH_meas_prev) begin
	tCK_meas_stable = tCK_meas;
	tCH_meas_stable = tCH_meas;
	tCL_meas_stable = tCL_meas;
	tODTd      = tDQSCK-300;
	tODTe      = tDQSCK+tCK;
    end 	
    tCK_half_stable=tCK_meas/2;
    b=(tDQS2DQ/(tCK_meas_stable/4)); 


//##################################################################################	
// TDQSCK resonance within model: this should adjust tDQSCK to block any exact matches between (tCK/2) and tDQSCK
//##################################################################################	
// If you are not running the set timing corners the below may be needed to avoid issues
//    if ((tDQSCK%(tCK_meas_stable /2)) < 3 ) tDQSCK = tDQSCK +2;				
//    if ((tDQSCK%(tCK_meas_stable /2)) > ((tCK_meas_stable /2)-3)) tDQSCK = tDQSCK -2;	
//##################################################################################	


// Deals with duty cycle and shifting windows of tDQSCK for reads
//##################################################################################	
    tDQSCK_adj = 0;
		
    // generate offset based on tdqsck
    if(Dout_en == 0) begin
	Dout_en_offset=ru(tDQSCK,tCK_half)-1;
	if(Dout_en_offset < 0) Dout_en_offset=0;
	if(tCK_half>tDQSCK && Dout_en == 0) Dout_en_longtCK = 1;
	else Dout_en_longtCK = 0;
    end 
    
//  COMMAND DECODE LATCHES:
//##################################################################################
    Increment_Pipes;	
    CLK0 = 1;
    DQS_clk_rd <= #(tDQSCK) CLK;
    DQSF_clk_rd <= #(tDQSCK) !CLK;    
end // end "always @ posedge 


// MODE: Enter / exit RESET
//##################################################################################
always @(RESET)begin
    if (~RESET) begin		
	Nanya_cmd_string = "RESET";
	debug_string   = "RESETing";
	erase_all;      								
        Reset_MR;
        Initialize     = `Check_Initialization;
	Multi_Step_Command =-1;										
	t_RESET = $time;
	if(DEBUG>6) $display("Trigger ~RESET: %t", $realtime);
    end 
    else if (RESET) begin 	    
	Multi_Step_Command =0;  									
	debug_string   = "NOT RESET";
	Reset_MR;
	Nanya_cmd_string <=  128'b0;		// Command String
	debug_string     <=  2048'b0;		// Debug String showing DQS_out state
	warning_string   <=  2048'b0;		// Warning String
	timing_string    <=  2048'b0;		// Timing Warning String
	CKE_cmd_string   <=  128'b0;		// CKE State
	Multi_Step_Command =0;
	if(DEBUG>6) $display("Trigger RESET: %t", $realtime);
	if($time - t_RESET < tRESET) begin
	    $display("    %t ### ERROR ### tRESET Timing Violation - min RESET pulse width", $time);
	    timing_string = "tRESET Timing Violation";
	end
    end
end // end always (@RESET)


// CKE Control Section - contains CA Training				
//##################################################################################
always begin	// negedge & posedge CKE
    @(negedge CKE) begin
	if (Initialize > 0) t_CKE  = $time;
	if (CA_training) begin
	    if (mode_reg[13][7]== 0) begin
		mode_reg[13][7]= 1;				// sets FSP_OP to 1 - toggle FSP_OP mode
		FSP_OP_2_MR;	
		apply_mr_settings; 
	    end 
	    else begin
		mode_reg[13][7]= 0;				// sets FSP_OP to 0 - toggle FSP_OP mode
		FSP_OP_2_MR;	
		apply_mr_settings;
	    end
	    if (mode_reg[22][5]== 0 && ODT)   ODT_Force_CA <= #(tODTon) RTTval_ca;	    // This may be turning ODT on / off or staying the same #(tODTon) vs #(tODToff) values be the same
	    if (mode_reg[22][4]== 1 && ODT)   ODT_Force_CS <= #(tODTon) RTTval_ca;	    // This may be turning ODT on / off or staying the same #(tODTon) vs #(tODToff) values be the same
	    if (mode_reg[22][3]== 1 && ODT)   ODT_Force_CK <= #(tODTon) RTTval_ca;	    // This may be turning ODT on / off or staying the same #(tODTon) vs #(tODToff) values be the same
	end	
	
// MODE: Power Down
//############################
	if (|Initialize && (Initialize < 5)) begin
	    $display("    %t ### ERROR ### PD   : Initialization not finished, command blocked", $realtime);
	    warning_string = "PD: Initialization not finished";
    	end 
	else if (|Block_Command_REF) begin
	    $display("    %t ### ERROR ### CKE : refresh in progress", $realtime);
	    warning_string = "CKE Illegal drop : wait for refresh to complete"; 
	end 
	else if ($time - t_MRW < tMRW*tCK_meas && $time > tMRW*tCK_meas) begin
	    $display("    %t ### ERROR ### PD   : MRR/MRW not finished yet, CKE cannot go low", $realtime);
	    warning_string = "PD: MRR/MRW not finished yet, CKE cannot go low";	
	end 
	else begin
	    if (SREF) begin
		Nanya_cmd_string <=  "SPD";
		CKE_cmd_string = "SPD";
		if(DEBUG>6) $display("    %t SPD ", $realtime);
	    end 
	    else if (Act_Banks>0) begin
		Nanya_cmd_string <=  "APD";
		CKE_cmd_string = "APD";
		if(DEBUG>6) $display("    %t APD ", $realtime);
	    end 
	    else begin
		Nanya_cmd_string <=  "PPD";
		CKE_cmd_string = "PPD";
		if(DEBUG>6) $display("    %t PPD ", $realtime);
	    end				
	    Timing_Error_Check;
	    Block_Command <= #(tCK_half) 1;		
	    t_CKE = $time;
	    RD_FIFO_POINT =0;			// RD FIFO POINTER reset 
	    WR_FIFO_POINT =0;			// WR FIFO POINTER reset 
	end //	@(posedge CLK) Nanya_cmd_string = "PDE"; 
    end
    @(posedge CKE) begin
	    if (Nanya_cmd_string == "APD" || Nanya_cmd_string == "PPD" || Nanya_cmd_string == "SPD" ) begin	
	        if ($time - t_CKE < tCKE) begin 
		    $display("    %t ### ERROR ### tCKE Timing Violation in PD transition", $realtime);
	    	    timing_string="tCKE Timing Violation"; 
	        end	
	        t_PD = $time;
		Nanya_cmd_string = "DES";
	    end
	if (CKE_cmd_string == "SREF") begin
	    if ($time - t_CKE < tCKESR) begin 
		$display("    %t ### ERROR ### tCKESR Timing Violation", $realtime);
	    	timing_string="tCKESR Timing Violation"; 
	    end	
	    t_SREF = $time;
	end
	if (CA_training) begin
	    if (mode_reg[13][7]== 1) begin
		mode_reg[13][7]= 0; // sets FSP_OP to 0 - Toggles FSP_OP mode
		FSP_OP_2_MR;	
		apply_mr_settings; 
	    end 
	    else begin
		mode_reg[13][7]= 1; // sets FSP_OP to 0 - Toggles FSP_OP mode
		FSP_OP_2_MR;	
		apply_mr_settings; 
	    end 
	    if (mode_reg[22][5]== 0 && ODT)   ODT_Force_CA <= #(tODTon) RTTval_ca;
	    if (mode_reg[22][4]== 1 && ODT)   ODT_Force_CS <= #(tODTon) RTTval_ca;
	    if (mode_reg[22][3]== 1 && ODT)   ODT_Force_CK <= #(tODTon) RTTval_ca;	
	    DqPad_Int_CA[13:8]	<= #(tMRZ) 6'bz;
	end	
	if (PPR) begin
	    if (Nanya_cmd_string == "ACT") $display(" In PPR mode ACT Command Received ");
	    if (Nanya_cmd_string == "PR")  $display(" In PPR mode PRE Command Received ");
	end		
	CKE_cmd_string="Exit";							
	Block_Command <= #(tXP) 0;
	t_CKE = $time;
    end // end "posedge CKE"
end


// Operation @ system clock
//##################################################################################
always @(posedge CLK) begin
    MRR_en_PIPE[0]     	    = 0;
    Dout_en_PIPE[0]    	    = 0;
    Dout_en_PIPE_BL16[0]    = 0;
    Dout_en_PIPE_BL32[0]    = 0;
    write_open_PIPE[0]      = 0;
    write_open_PIPE_BL16[0] = 0;
    write_open_PIPE_BL32[0] = 0;
    BURST_PIPE_RD[0]	    = 0; 
    BURST_PIPE_WR[0]	    = 0;
    MASK_PIPE[0]	    = 0;
    RD_FIFO_PIPE[0]	    = 0;
    WR_FIFO_PIPE[0]	    = 0;
    
    
//############################
//## Duty Cycle Measurement ##
//############################
    tCH_calc=((tCH_meas*100)/tCK_meas);
    tCL_calc=((tCL_meas*100)/tCK_meas);
    if(tCH_calc<tCH_min) begin
	$display("%m: at time %t Error: tCH_min violation",$time,tCH_calc);
	timing_string = "tCH_min Violation"; 
    end
    if(tCH_calc>tCH_max) begin
	$display("%m: at time %t Error: tCH_max violation",$time,tCH_calc);
	timing_string = "tCH_max Violation"; 
    end
    if(tCL_calc<tCL_min) begin
	$display("%m: at time %t Error: tCL_min violation",$time,tCL_calc);
	timing_string = "tCL_min Violation"; 
    end
    if(tCL_calc>tCL_max) begin
	$display("%m: at time %t Error: tCL_max violation",$time,tCL_calc);
	timing_string = "tCL_max Violation"; 
    end
    
    
//############################
//## Latch Commands on CLK  ##
//############################
    if (Multi_Step_Command ==0) begin  			
	MPC_LAT	      = MPC_EN;
	MRW_LAT       = MRW1_EN;
	MRR_LAT       = MRR_EN;
	RefPB_LAT     = REF_EN_PB; 
	RefAB_LAT     = REF_EN_AB;
	NOP_LAT	      = NOP_EN;
	ACT_LAT       = ACT1_EN;
	WR_LAT	      = WR1_EN || WR1_BL_EN;
	MWR_LAT	      = MWR1_EN;
	RD_LAT        = RD_EN || RD_BL_EN;
	PRE_LAT       = PRE_EN;
	SREF_LAT      = SREF_EN;
	SRX_LAT       = SRX_EN;
	PD_LAT        = PD_EN;
	DESL_LAT      = DESL_EN;
	CAS_LAT       = 0;
	RD_FIFO_LAT   = 0;
	RD_DQ_LAT     = 0;
	WR_FIFO_LAT   = 0;
	DQ_O_STRT_LAT = 0;
	DQ_O_STOP_LAT = 0;
	ZQ_C_STRT_LAT = 0;
	ZQ_C_STOP_LAT = 0;
    end 
    else if (Multi_Step_Command ==1 && MPC_LAT==1) begin  			
	RD_FIFO_LAT   = MPC_RD_FIFO;
	RD_DQ_LAT     = MPC_RD_DQ;
	WR_FIFO_LAT   = MPC_WR_FIFO;
	DQ_O_STRT_LAT = MPC_DQ_O_STRT;
	DQ_O_STOP_LAT = MPC_DQ_O_STOP;
	ZQ_C_STRT_LAT = MPC_ZQ_C_STRT;
	ZQ_C_STOP_LAT = MPC_ZQ_C_STOP;
    end 
    else if (Multi_Step_Command ==2 ) begin  			
	CAS_LAT = CAS2_EN;			
    end 


//############################
//##	CA Training Mode    ##
//############################
    if (CA_training & !CKE & CsF & X==1) begin	
	DqPad_Int_CA[15:14] = 2'bx;
	DqPad_Int_CA[13]    <= #(tADR) CA[5];
	DqPad_Int_CA[12]    <= #(tADR) CA[4];
	DqPad_Int_CA[11]    <= #(tADR) CA[3];
	DqPad_Int_CA[10]    <= #(tADR) CA[2];
	DqPad_Int_CA[9]	    <= #(tADR) CA[1];
	DqPad_Int_CA[8]	    <= #(tADR) CA[0];
	DqPad_Int_CA[7:0]   = 8'bx;
    end 
    else if (CA_training & !CKE & CsF & X==0 & mode_reg[12][7] == 0 & BYTE==0) begin
	DqPad_Int_CA[7:6] = 2'b00;
	DqPad_Int_CA[5]	  <= #(tADR) CA[5];
	DqPad_Int_CA[4]	  <= #(tADR) CA[4];
	DqPad_Int_CA[3]	  <= #(tADR) CA[3];
	DqPad_Int_CA[2]	  <= #(tADR) CA[2];
	DqPad_Int_CA[1]	  <= #(tADR) CA[1];
	DqPad_Int_CA[0]	  <= #(tADR) CA[0];	  
    end 
    else if (CA_training & !CKE & CsF & X==0 & mode_reg[12][7] == 0 & BYTE==1) begin
	DqPad_Int_CA[15:14] = 2'b00;
	DqPad_Int_CA[13]    <= #(tADR) CA[5];
	DqPad_Int_CA[12]    <= #(tADR) CA[4];
	DqPad_Int_CA[11]    <= #(tADR) CA[3];
	DqPad_Int_CA[10]    <= #(tADR) CA[2];
	DqPad_Int_CA[9]	    <= #(tADR) CA[1];
	DqPad_Int_CA[8]	    <= #(tADR) CA[0];	    
    end 
    else if (CA_training & !CKE & CsF & X==0 & mode_reg[12][7] == 1 & BYTE==0) begin
	DqPad_Int_CA[7]	<= #(2300+tADR) 1'b0;
	DqPad_Int_CA[7]	<= #(2300+tADR+tAD2DQ7)1'b1;
	DqPad_Int_CA[7]	<= #(2300+tADR+tAD2DQ7+tADSPW)1'b0;
	DqPad_Int_CA[7]	<= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[6]	<= #(2300+tADR) 1'b0;	DqPad_Int_CA[6]	<= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[5]	<= #(2300+tADR) CA[5];	DqPad_Int_CA[5]	<= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[4]	<= #(2300+tADR) CA[4];	DqPad_Int_CA[4]	<= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[3]	<= #(2300+tADR) CA[3];	DqPad_Int_CA[3]	<= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[2]	<= #(2300+tADR) CA[2];	DqPad_Int_CA[2]	<= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[1]	<= #(2300+tADR) CA[1];	DqPad_Int_CA[1]	<= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[0]	<= #(2300+tADR) CA[0];	DqPad_Int_CA[0]	<= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
    end
    else if (CA_training & !CKE & CsF & X==0 & mode_reg[12][7] == 1 & BYTE==1) begin
	DqPad_Int_CA[15] <= #(2300+tADR) 1'b0;
	DqPad_Int_CA[15] <= #(2300+tADR+tAD2DQ7)1'b1;
	DqPad_Int_CA[15] <= #(2300+tADR+tAD2DQ7+tADSPW)1'b0;
	DqPad_Int_CA[15] <= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[14] <= #(2300+tADR) 1'b0;   DqPad_Int_CA[14] <= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[13] <= #(2300+tADR) CA[5];  DqPad_Int_CA[13] <= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[12] <= #(2300+tADR) CA[4];  DqPad_Int_CA[12] <= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[11] <= #(2300+tADR) CA[3];  DqPad_Int_CA[11] <= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[10] <= #(2300+tADR) CA[2];  DqPad_Int_CA[10] <= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[9]	 <= #(2300+tADR) CA[1];  DqPad_Int_CA[9]  <= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
	DqPad_Int_CA[8]	 <= #(2300+tADR) CA[0];  DqPad_Int_CA[8]  <= #(2300+tADR+tAD2DQ7+tADSPW+tDQ7SH)1'bz;
    end
    
    
//############################
//##	MODE: Noop	    ##  				    
//############################
    if (NOP_LAT && CKE ) begin
	if (Multi_Step_Command==0) begin
	    Nanya_cmd_string = "NOP";
	    Multi_Step_Command=1;
	end 
	else if (Multi_Step_Command==1) begin
	    Multi_Step_Command=0;
	end
    end
    

//############################
//##	MODE: Deselect      ##  				    
//############################
    if (DESL_LAT  && Multi_Step_Command==0 && CKE) begin
	Nanya_cmd_string = "DES";
    end
    
    
//############################
//##	MODE: ACT	    ##  				    
//############################
    if (ACT_LAT && CKE) begin
	if (|Initialize) begin
            $display("    %t ### ERROR ### ACT   : Initialization not finished, command blocked", $time);
	    warning_string = "Act: Initialization not finished";
	end
	else if (Multi_Step_Command==0 )begin
    	    ROW_lat[13:12] = CA[3:2];
	    if (`Row_Bits >= 15) begin
	        for (i=14; i<`Row_Bits; i=i+1) begin
	    	    ROW_lat[i] = CA[i-10];
	        end
	    end
	    Nanya_cmd_string = "ACT";
	    Multi_Step_Command=1;
	end 
	else if (Multi_Step_Command==1 && ~CsF )begin
	    ROW_lat[11:10] = CA[5:4];
		`ifdef Den_8Gb
			ROW_lat[16] = CA[3];
		`endif		
	    BA=CA[2:0];
	    if (Act_Banks[BA]==1) begin
	        $display("    %t ### ERROR ### ACT   : BANK %d : activated already", $time, BA);
	        warning_string = "Act: Bank already active";
		Multi_Step_Command=0;
	    end 
	    else if(Block_Command_REF[BA] == 1) begin
	        $display("    %t ### ERROR ### ACT   : BANK %d : being refreshed", $time, BA);
	        warning_string = "Act: Bank already active for refresh";
		Multi_Step_Command=0;
	    end
	    Multi_Step_Command=2;
	end 
	else if (Multi_Step_Command==2 && ACT2_EN && CsF)begin
	    if (CA[1:0]!=2'b11) begin
	        $display("    %t ### ERROR ### ACT   : ACT2 command not received after ACT1, Illegal command", $time);
	    	warning_string = "Act: ACT2 CA[0:1]!=2'b11 not received on R3";
		Multi_Step_Command=0;
	    end
	    ROW_lat[9:6] = CA[5:2];
	    Multi_Step_Command=3;		
	end 
	else if (Multi_Step_Command==3 && ~CsF)begin
	    ROW_lat[5:0] = CA[5:0];	
	    Act_Banks[BA] = 1;
	    Radd[BA] = ROW_lat;
	    WR_Bank_PIPE[0] <= #1 BA;
	    Multi_Step_Command=0;
	    Timing_Error_Check;
	    t_ACT=$time;
	    t_bankACT[BA]=$time;
	    if(DEBUG>6)  $display("    %0t ACT   : BANK %d : ROW %h", t_ACT, BA, ROW_lat);
	end
    end	// end ACT_LAT
    

//##########################################
//##  MPC -  Multi-Purpose-Command - MPC  ##
//##########################################
    if (MPC_LAT ) begin
	if (Multi_Step_Command==0 ) begin
	    Nanya_cmd_string = "MPC";
	    Multi_Step_Command=1;
	end 
	else if (Multi_Step_Command==1) begin
	    if (RD_FIFO_LAT) begin
		Nanya_cmd_string = "RD_FIFO_MPC";
		Multi_Step_Command=2; 
	    end
	    if (RD_DQ_LAT) begin
		Nanya_cmd_string = "RD_DQ_MPC";
		Multi_Step_Command=2; 
	    end
	    if (WR_FIFO_LAT) begin
		Nanya_cmd_string = "WR_FIFO_MPC";
		Multi_Step_Command=2; 
	    end
	    if (DQ_O_STRT_LAT) begin
		Nanya_cmd_string = "+OSC+_MPC";
		Multi_Step_Command=0; 
		MPC_DQS_OSC_ON = 1'b1;
		MPC_DQS_OSC_CLK_COUNT = 0;
	    end
	    if (DQ_O_STOP_LAT) begin
		if (mode_reg[23] == 8'b0000_0000)begin
		    Nanya_cmd_string = "-OSC-_MPC";
		    MPC_DQS_OSC_ON = 1'b0;
		end	
		Multi_Step_Command=0;
	    end
	    if (ZQ_C_STRT_LAT) begin
		Nanya_cmd_string = "+ZQ+_MPC";
		Multi_Step_Command=0; 
	    end
	    if (ZQ_C_STOP_LAT) begin
		Nanya_cmd_string = "-ZQ-_MPC";
		Multi_Step_Command=0; 
		if (X)	mode_reg[0] =8'b0011_1000;
		else mode_reg[0] =8'b0011_1010;
	    end				
	end 
	else if (Multi_Step_Command==2 && CAS_LAT && CsF) begin
	    Multi_Step_Command=3;
	end 
	else if (Multi_Step_Command==3 && CAS_LAT && ~CsF && RD_DQ_LAT) begin // MPC RD DQ
	    if(DEBUG>6) $display("    %t MPC RD DQ,  ", $realtime);
	    ROW_PIPE[0] 			<= #1 Radd[BA];
	    COL_PIPE[0]				<= #1 6'b100000;
	    Dout_en_PIPE_BL16[0]	<= #1 1;
	    MRR_en_PIPE[0] 			<= #1 1;			
	    t_MRR = $time;
	    Multi_Step_Command=0;
	end 
	else if (Multi_Step_Command==3 && CAS_LAT && ~CsF && RD_FIFO_LAT) begin // MPC FIFO RD 
	    Write_IP = 0; 
	    if(|Dout_en_PIPE_BL16[6:0] || Write_IP ||(|Dout_en_PIPE_BL32[6:0])) begin //read interrupt read
		$display("    %t ### ERROR ### READ : BANK %d : illegal interrupt Read", $realtime, BA);
		warning_string = "Read: Illegal Read Interrupt";
		Nanya_cmd_string = "Ill. RD";
		Multi_Step_Command=0;
	    end 
	    else begin
		Dout_en_PIPE_BL16[0]	<= #1 1;	 
		BURST_PIPE_RD[0] 		<= #1 0;	 
		RD_FIFO_PIPE[0]			<= #1 1;
		Multi_Step_Command	= 0;	 
		Timing_Error_Check;		 
		t_RD_FIFO 		= $time; // load time of this command
		if(DEBUG>6) $display("    %t MPC FIFO Read", $realtime);		
	    end		
	end 
	else if (Multi_Step_Command==3 && CAS_LAT && ~CsF && WR_FIFO_LAT) begin // MPC FIFO WR
	    Read_IP = 0; 
	    if(|write_open_PIPE_BL16[6:0] || Read_IP || (|write_open_PIPE_BL32[6:0])) begin //write interrupt write
		$display("    %t ### ERROR ### WRITE : BANK %d : illegal interrupt Write", $realtime, BA);
		warning_string = "Illegal Write Interrupt";
		Nanya_cmd_string = "Ill. WR";
		Multi_Step_Command=0;
	    end	
	    else begin
		write_open_PIPE[0] 		<= #1 1;
		write_open_PIPE_BL16[0]	<= #1 1;
		BURST_PIPE_WR[0]		<= #1 0;
		WR_FIFO_PIPE[0]			<= #1 1;
		Multi_Step_Command	= 0;
		Timing_Error_Check;	
		t_WR_FIFO 		= $time;
		if(DEBUG>6) $display("    %t MPC FIFO WRITE", $realtime);		
	    end
	end
    end	
    

//############################
//##   MODE REGISTER WRITE  ##  						    
//############################      
    if (MRW_LAT && CKE) begin
    	if (Multi_Step_Command==0) begin
	    Nanya_cmd_string = "MRW";
	    OP[7]=CA[5];
	    Multi_Step_Command=1;
	end 
	else if ( Multi_Step_Command==1 && ~CsF) begin
	    MA=CA[5:0];	    
	    Multi_Step_Command=2;
	end 
	else if ( Multi_Step_Command==2 && MRW2_EN && CsF) begin
	    OP[6]=CA[5];
	    Multi_Step_Command=3;
	end 
	else if ( Multi_Step_Command==3 && ~CsF) begin
	    OP[5:0]=CA[5:0];  
	    if (MA==4)		OP = {mode_reg[4][7],OP[6:3],mode_reg[4][2:0]};
	    if (MA==12 && X==1)	OP = {1'b0,OP[6:0]}; 					// OP[7] is CBT_MODE no register to store value if not in BYTE MODE...
	    if (MA==14)		OP = {1'b0,OP[6:0]}; 					// OP[7] is RFU no register to store value...
	    if (MA==24)		OP = {OP[7:4],4'b1000};
	    if (MR_RW_enable[MA] == 0 || MR_RW_enable[MA] == 1) begin
		$display("     %t ### ERROR ### MRW : mode register %0d is not writeable", $realtime, MA);
	    end 
	    else if (|Block_Command_REF & MA==13 & OP[0]) begin
		$display("    %t ### ERROR ### CA Training entry  : refresh in progress", $realtime);
		warning_string = "CA Train: wait for refresh to complete"; 
		Multi_Step_Command=0;
	    end	
	    else if (MA==13) begin
		if (OP[7]!==(mode_reg[13][7])) begin // Modify MR13 - Switching FSP-OP tables
		    mode_reg[MA] =OP; // MA selects which mode register to program, OP is the data written to that mode register
		    FSP_OP_2_MR;
		    if(DEBUG>6) $display("    %t ### in FSP_OP_2_MR ### FSP_OP_REG0 = %b", $time, FSP_OP_REG[0] );
		    if(DEBUG>6) $display("    %t ### in FSP_OP_2_MR ### FSP_OP_REG1 = %b", $time, FSP_OP_REG[1] );	
		    if(DEBUG>6) $display("     %t MR13 Switching FSP OP table now should be %d ", $realtime, OP[7] );
		end 
		else begin
		    mode_reg[MA] =OP;
		    if(DEBUG>6) $display("     %t Setting MR13:FSP settings are FSP-OP = %d  and FSP-WR %d ", $realtime, mode_reg[13][7], mode_reg[13][6]  );
		end
	    end 
	    else begin // Updating Mode Registers - active FSP / alternate FSP / non FSP
		FSP_WR_2_MR; // bring write tables into MR
		if(DEBUG>6) $display("    %t ### in FSP_WR_2_MR ### FSP_OP_REG0 = %b", $time, FSP_OP_REG[0] );
		if(DEBUG>6) $display("    %t ### in FSP_WR_2_MR ### FSP_OP_REG1 = %b", $time, FSP_OP_REG[1] );
		mode_reg[MA] =OP;	// updates MR
		MR_2_FSP_WR;		// put MR into write FSP reg
		if(DEBUG>6) $display("    %t ### in MR_2_FSP_WR ### FSP_OP_REG0 = %b", $time, FSP_OP_REG[0] );
		if(DEBUG>6) $display("    %t ### in MR_2_FSP_WR ### FSP_OP_REG1 = %b", $time, FSP_OP_REG[1] );
		FSP_OP_2_MR;						// put active FSP reg into MR
		if(DEBUG>6) $display("    %t ### in FSP_OP_2_MR ### FSP_OP_REG0 = %b", $time, FSP_OP_REG[0] );
		if(DEBUG>6) $display("    %t ### in FSP_OP_2_MR ### FSP_OP_REG1 = %b", $time, FSP_OP_REG[1] );				
	    end
	    apply_mr_settings;		// Load active MR into variables & verbose
	    Dout_en_PIPE_BL16 = 0; 	// Reset PIPE because RL can change
	    Dout_en_PIPE_BL32 = 0; 	// Reset PIPE because RL can change
	    MRR_en_PIPE  = 0; 		// Reset PIPE because RL can change
	    Multi_Step_Command=0;
	    Timing_Error_Check;		// Timing Error Check should be at final CMD CLK rising edge
	    t_MRW = $time;
	    if(DEBUG>6) $display("    %t MRW,  MA: %d  OP: %b", $realtime, MA, OP);
    	end // end else if MSC==3
    end // end MRW_LAT
    

//############################
//##   MODE REGISTER READ   ##  					    
//############################
    if (MRR_LAT && CKE & CLK) begin
    	if (Multi_Step_Command==0)begin
	    Multi_Step_Command=1;
	    Nanya_cmd_string = "MRR";	    		    	
	end
     	else if (Multi_Step_Command==1 & ~CsF) begin
     	    MA=CA[5:0]; 				    
     	    MRR_data[0]=mode_reg[MA];
     	    if (MR_RW_enable[MA] == 0 || MR_RW_enable[MA] == 2) 
     		$display("     %t ### ERROR ### MRR : mode register %0d is not readable", $realtime, MA);
     		Multi_Step_Command=2;
     	    end 
     	    else if (Multi_Step_Command==2 && CAS_LAT && CsF) begin
     		Multi_Step_Command=3;
     	    end
     	else if (Multi_Step_Command==3 && CAS_LAT && ~CsF) begin
     	    if(DEBUG>6) $display("    %t MRR,  MA: %0d", $realtime, MA);
     	    COL_PIPE[0]			<= #1 MA;
     	    MRR_en_PIPE[0] 		<= #1 1;
     	    Dout_en_PIPE_BL16[0] <= #1 1;	    
     	    Timing_Error_Check; 	    
     	    t_MRR = $time;
     	    Multi_Step_Command=0;
     	    if (MA==4) begin 
     		MRR4_READ = 1'b1; 
     		if (Last_temp == mode_reg[4][2:0]) mode_reg[4][7]=1'b0;
     		Last_temp= mode_reg[4][2:0];	    
     	    end
     	end	    
    end
    

//############################
//## MODE: Read 	    ##  									    
//############################
    if (RD_LAT) begin
	if (|Initialize) begin
	    $display("    %t ### ERROR ### RD   : Initialization not finished, command blocked", $realtime);
	    warning_string = "Read: Initialization not finished";
	end 
	else if (Multi_Step_Command==0)begin
	    if (OTF == 1)  BL = CA[5];		
	    Nanya_cmd_string = "RD";
	    Multi_Step_Command=1;
	end 
	else if (Multi_Step_Command==1 && ~CsF)begin
	    BA=CA[2:0];
	    if (Act_Banks[BA]==0) begin
		$display("    %t ### ERROR ### READ : BANK %d : not Activated", $realtime, BA);
		warning_string = "Read: Bank not Activated";	Nanya_cmd_string = "Ill. RD";
		Multi_Step_Command=0;
	    end
	    t_bankRD[BA]  = $time;
	    Read_Bank_Pre = BA;
	    AP=CA[5];
	    COL_lat[9]=CA[4];	    
	    if (!AP) Nanya_cmd_string = "RD";
	    if (AP)  Nanya_cmd_string = "RDA";
	    Multi_Step_Command=2;
	end 
	else if (Multi_Step_Command==2 && CAS_LAT && CsF) begin
	    COL_lat[8]=CA[5];
            Multi_Step_Command=3;
	end 
	else if (Multi_Step_Command==3 && CAS_LAT && ~CsF) begin
	    COL_lat[7:2]=CA[5:0];
	    Write_IP = 0; 
	    if(|Dout_en_PIPE_BL16[6:0] || Write_IP || (|Dout_en_PIPE_BL32[6:0])) begin //read interrupt read
		$display("    %t ### ERROR ### READ : BANK %d : illegal interrupt Read", $realtime, BA);
		warning_string = "Read: Illegal Read Interrupt";
		Nanya_cmd_string = "Ill. RD";
		Multi_Step_Command=0;
	    end 
	    else begin
		ROW_PIPE[0] <= #1 Radd[BA];
		COL_PIPE[0] <= #1 COL_lat;
		WR_Bank_PIPE[0] <= #1 BA;
		if (Act_Banks) Dout_en_PIPE[0] <= #1 1;
		if (Act_Banks && BL)  Dout_en_PIPE_BL32[0] <= #1 1;
		if (Act_Banks && !BL) Dout_en_PIPE_BL16[0] <= #1 1;
		BURST_PIPE_RD[0] <= #1 BL;
		Multi_Step_Command=0;
		Timing_Error_Check;
		t_RD = $time;
		if (Act_Banks) if(DEBUG>5) $display("    %t Read", $realtime);	
		if (AP) Act_Banks[BA] <= 0; // at end of command close bank...
	    end
        end
    end // end RD_LAT
    

//############################
//## MODE: Write	    ##
//############################
     if (WR_LAT) begin
	if (|Initialize) begin
	    $display("    %t ### ERROR ### Write   : Initialization not finished, command blocked", $realtime);
	    warning_string = "Write: Initialization not finished";
	end
     	else if (Multi_Step_Command==0)begin
     	    if (OTF == 1)  BL = CA[5];
     	    Nanya_cmd_string = "WR";
     	    Multi_Step_Command=1;
     	end 
     	else if (Multi_Step_Command==1 && ~CsF)begin
     	    BA=CA[2:0];     
     	    if (Act_Banks[BA]==0) begin
     		$display("    %t ### ERROR ### WRITE : BANK %d : not Activated", $realtime, BA);
     		warning_string = "Write: Bank not Activated";	    Nanya_cmd_string = "Ill. WR";
     		Multi_Step_Command=0;			    
     	    end
     	    AP=CA[5];		
     	    COL_lat[9]=CA[4]; 
     	    if (!AP) Nanya_cmd_string = "WR";
     	    if (AP)  Nanya_cmd_string = "WRA";      
     	    Multi_Step_Command=2;
     	end 
     	else if (Multi_Step_Command==2 && CAS_LAT && CsF) begin
     	    COL_lat[8]=CA[5];
     	    Multi_Step_Command=3;
     	end 
     	else if (Multi_Step_Command==3 && CAS_LAT && ~CsF) begin
			//bit row_pipe;
     	    COL_lat[7:2]=CA[5:0];
     	    ROW_PIPE[0] <= #1 Radd[BA];
			//row_pipe<=Radd[BA];
     	    Read_IP = 0; 
     	    if(|write_open_PIPE_BL16[6:0] || Read_IP ||(|write_open_PIPE_BL32[6:0])) begin //write interrupt write
     		$display("    %t ### ERROR ### WRITE : BANK %d : illegal interrupt Write", $realtime, BA);
     		warning_string = "Illegal Write Interrupt";
     		Nanya_cmd_string = "Ill. WR";
     		Multi_Step_Command=0;
     	    end
     	    else begin
     		COL_PIPE[0] <= #1 COL_lat;
     		WR_Bank_PIPE[0] <= #1 BA;
     		if (Act_Banks) write_open_PIPE[0] <= #1 1;
     		if (Act_Banks && BL)  write_open_PIPE_BL32[0] <= #1 1;
     		if (Act_Banks && !BL) write_open_PIPE_BL16[0] <= #1 1;
     		BURST_PIPE_WR[0] <= #1 BL;
     		Multi_Step_Command=0;
     		Timing_Error_Check;	
     		t_CCD = $time;
     		t_bankWR[BA] = $time;
     		if (Act_Banks) if(DEBUG>5) $display("	 %t WRITE : BANK %d : ROW %h : COL %h", $realtime, BA, ROW_PIPE[0], COL_lat);
     		if (AP) Act_Banks[BA] <= 0;  // at end of command close bank...
     	    end 		
     	end	
    end
    

//############################
//## MODE: MASKED Write     ##
//############################
     if (MWR_LAT) begin
	if (|Initialize) begin
	    $display("    %t ### ERROR ### Mask Write   : Initialization not finished, command blocked", $realtime);
	    warning_string = "Write: Initialization not finished";
	end
	else if (DM_DIS==1)begin	
	    $display("    %t ### ERROR ### Mask Write Decoded but MR13[5] = 1 - Data Mask Operation Disable", $realtime);
	    warning_string = "Mask Write: MR13[5] = 1";
	end
	else if (Multi_Step_Command==0)begin
	    Nanya_cmd_string = "MWR";
	    Multi_Step_Command=1;
	end 
	else if (Multi_Step_Command==1 && ~CsF)begin
	    BA=CA[2:0];	
	    if (Act_Banks[BA]==0) begin
		$display("    %t ### ERROR ### WRITE : BANK %d : not Activated", $realtime, BA);
		warning_string = "MWrite: Bank not Activated"; 	Nanya_cmd_string = "Ill. MWR";
		Multi_Step_Command=0;			
	    end
	    AP=CA[5];		
	    COL_lat[9]=CA[4];	    
    	    if (!AP) Nanya_cmd_string = "MWR";
	    if (AP)  Nanya_cmd_string = "MWRA";      
	    Multi_Step_Command=2;
	end 
	else if (Multi_Step_Command==2 && CAS_LAT && CsF) begin
	    COL_lat[8]=CA[5];
            Multi_Step_Command=3;
	end
	else if (Multi_Step_Command==3 && CAS_LAT && ~CsF) begin
	    COL_lat[7:2]=CA[5:0];
	    ROW_PIPE[0] <= #1 Radd[BA];
	    Read_IP = 0; 
	    if(|write_open_PIPE_BL16[6:0] || Read_IP || (|write_open_PIPE_BL32[6:0])) begin //write interrupt write
		$display("    %t ### ERROR ### WRITE : BANK %d : illegal interrupt Write", $realtime, BA);
		warning_string = "Illegal Write Interrupt";
		Nanya_cmd_string = "Ill. MWR";
		Multi_Step_Command=0;
	    end	
	    else begin
		COL_PIPE[0] <= #1 COL_lat;
		WR_Bank_PIPE[0] <= #1 BA;
		if (Act_Banks) write_open_PIPE_BL16[0] <= #1 1;	
		MASK_PIPE[0] <= #1 1;
		Multi_Step_Command=0;
		Timing_Error_Check;	
		t_CCD = $time;
		t_bankWR[BA] = $time;
		if (Act_Banks) if(DEBUG>5) $display("    %t MASK_WRITE", $realtime);
		if (AP)	Act_Banks[BA] <= 0; // at end of command close bank...
	    end		    
	end	    
    end
    
   
//############################ 
//##	MODE: Precharge     ##  							    
//############################
    if (PRE_LAT) begin
	if (|Initialize) begin
	    $display("    %t ### ERROR ### PRE   : Initialization not finished, command blocked", $realtime);
	    warning_string = "";
	    warning_string = "PRE: Initialization not finished";
	end 
	else begin
	    if (!CA[5] && Multi_Step_Command==0) begin
		Nanya_cmd_string = "PR";
		Multi_Step_Command=1;
	    end 
	    else if (CA[5] && Multi_Step_Command==0) begin
		Nanya_cmd_string = "PRA";
		Multi_Step_Command=1;	    
	    end 
	    else if (Multi_Step_Command==1)begin
		BA=CA[2:0];
		for (j=0 ; j<=(`Banks-1) ; j=j+1) begin // Bank Precharge
		    if ((Nanya_cmd_string == "PRA" || (!(Nanya_cmd_string == "PRA") && BA==j)) && Act_Banks[j]) begin
			// PRE ignored if Auto Precharge is already scheduled for that bank.
			Act_Banks[j] = 0;
		    end
		end	        	
		Timing_Error_Check;
		Multi_Step_Command=0;
		if (Nanya_cmd_string == "PRA") begin 	
		    t_PRE_ALL = $time;
		    if(DEBUG>6) $display("    %t PRE   : ALL BANKS", $realtime);
		end
		if (Nanya_cmd_string == "PRE") begin
		    t_bankPRE[BA] = $time;
		    if(DEBUG>6) $display("    %t PRE   : BANK %d", $realtime, BA);
		end
	    end	
	end
    end // END if (PRE_LAT)
    
   
//############################ 
//##   MODE: RefPB	    ##  					    
//############################
    if (RefPB_LAT) begin
        if (|Initialize) begin
	    $display("    %t ### ERROR ### RefPB   : Initialization not finished, command blocked", $realtime);
	    warning_string = "RefPB: Initialization not finished";
	end 
	else if (Multi_Step_Command==0) begin
	    Multi_Step_Command=1;
	    Nanya_cmd_string = "RefPB";
	end 
	else if (Multi_Step_Command==1 & ~CsF)begin
	    BA=CA[2:0];
	    if (Act_Banks[BA]) begin
		$display("    %t ### ERROR ### RefPB   : Must precharge bank %0d before RefPB", $realtime, BA);
		warning_string="RefPB: precharge bank before RefPB";
	    end
	    Block_Command_REF[BA] = 1'b1;
	    Block_Command_REF[BA] <= #(tRFCpb/2) 1'b0;
	    Multi_Step_Command=0;
	    if(DEBUG>6)  $display("    %t RefPB  Bank : %0d ", $realtime, BA);
	    Timing_Error_Check;
	    t_RefPB[BA] = $time;
	    t_Ref = $time;
	end
    end // end REFPB_LAT
    

//############################ 
//##   MODE: RefAB	    ##  					    
//############################
    if (RefAB_LAT) begin
	if(DEBUG>6)  $display("    %t ### in if (RefAB_LAT) ### - MSC = %d , CSF = %d , ACT_BANKS = %d , RefAB_LAT = %d , REF_EN_AB = %d", $realtime, Multi_Step_Command, CsF, Act_Banks, RefAB_LAT, REF_EN_AB);
	if (|Initialize) begin
	    $display("    %t ### ERROR ### RefAB   : Initialization not finished, command blocked", $realtime);
	    warning_string = "RefAB: Initialization not finished";
	end 
	else if (Multi_Step_Command==0 & CsF) begin
	    Nanya_cmd_string = "RefAB";
	    Multi_Step_Command=1;
	end 
	else if (Multi_Step_Command==1 & ~CsF) begin
	    if (|Act_Banks) begin
	    	$display("    %t ### ERROR ### RefAB   : Must precharge all banks before RefAB - MSC = %d , CSF = %d , ACT_BANKS = %d , RefAB_LAT = %d , REF_EN_AB = %d", $realtime, Multi_Step_Command, CsF, Act_Banks, RefAB_LAT, REF_EN_AB);
	    	warning_string = "RefAB: precharge all banks before RefAB";
	    	Multi_Step_Command=0;
	    end 
	    else begin
	    	if(DEBUG>6)  $display("    %t RefAB", $realtime);
	    	Timing_Error_Check;
	    	t_RefAB = $time;
	    	Block_Command_REF = 8'hff;
	    	Block_Command_REF <= #(tRFCab/2) 8'h00;
	    	Multi_Step_Command=0;
	    end
	end
    end // end REFAB_LAT
    

//############################ 
//##   MODE: Self Refresh   ##
//############################
    if (SREF_LAT) begin
	if (|Initialize) begin
	    $display("    %t ### ERROR ### SREF   : Initialization not finished, command blocked", $realtime);
	    warning_string = "SREF: Initialization not finished";
	end 
	else if (|Act_Banks) begin
	    $display("    %t ### ERROR ### SREF   : precharge all banks first", $realtime);
	    warning_string = "SREF: precharge all banks first";
	end 
	else if (|Block_Command_REF) begin
	    $display("    %t ### ERROR ### MRW : refresh in progress", $realtime);
	    warning_string = "SREF: wait for refresh to complete"; 
	end 
	else if (Multi_Step_Command==0) begin
	    Nanya_cmd_string = "SREF0"; 
	    CKE_cmd_string = "SREF0";
	    Multi_Step_Command=1;
	end 
	else if (Multi_Step_Command==1 && ~CsF) begin
	    Nanya_cmd_string = "SREF";
	    CKE_cmd_string = "SREF";
	    if(DEBUG>6) $display("    %t SREF abc", $realtime);
	    Timing_Error_Check;
	    t_SREF = $time;					 
	    SREF = 1;
	    Multi_Step_Command=0;
	end
    end // end sref_lat
    

//################################ 
//##   MODE: Self Refresh Exit  ##
//################################
    if (SRX_LAT) begin
	if (Multi_Step_Command==0) begin
	    Nanya_cmd_string = "SRX";
	    CKE_cmd_string = "SRX";
	    Multi_Step_Command=1;
	end 
	else if (Multi_Step_Command==1 && ~CsF) begin	
	    if(DEBUG>6) $display("    %t SREF_exit", $realtime);
	    Timing_Error_Check;
	    t_CKE = $time;
	    SREF = 0;
	    Multi_Step_Command=0;
	end
    end // end sref_lat
end // 	always @(posedge CLK) begin	

bit [31:0] clk_count=0;

always @(CLK) begin	   
	if((CLK==1'b1) || (CLK==1'b0)) begin
	clk_count+=1;
	/* 
    for (j=Pipe_Size; j>=1; j=j-1) begin // Increment "OR" PIPES
    MRR_data[j]             = MRR_data[j-1];
    MRR_en_PIPE[j]          = MRR_en_PIPE[j-1];
    Dout_en_PIPE[j]         = Dout_en_PIPE[j-1];
    Dout_en_PIPE_BL16[j]    = Dout_en_PIPE_BL16[j-1];
    Dout_en_PIPE_BL32[j]    = Dout_en_PIPE_BL32[j-1];
    write_open_PIPE[j]      = write_open_PIPE[j-1];
    write_open_PIPE_BL16[j] = write_open_PIPE_BL16[j-1];
    write_open_PIPE_BL32[j] = write_open_PIPE_BL32[j-1];
    BURST_PIPE_RD[j]        = BURST_PIPE_RD[j-1];
    BURST_PIPE_WR[j]        = BURST_PIPE_WR[j-1];
    MASK_PIPE[j]            = MASK_PIPE[j-1];
    RD_FIFO_PIPE[j]         = RD_FIFO_PIPE[j-1];	
    WR_FIFO_PIPE[j]         = WR_FIFO_PIPE[j-1];	
    end
	*/
	MRR_data[Pipe_Size:1]   = MRR_data[Pipe_Size-1:0];
    MRR_en_PIPE[Pipe_Size:1]          = MRR_en_PIPE[Pipe_Size-1:0];
    Dout_en_PIPE[Pipe_Size:1]         = Dout_en_PIPE[Pipe_Size-1:0];
    Dout_en_PIPE_BL16[Pipe_Size:1]    = Dout_en_PIPE_BL16[Pipe_Size-1:0];
    Dout_en_PIPE_BL32[Pipe_Size:1]    = Dout_en_PIPE_BL32[Pipe_Size-1:0];
    write_open_PIPE[Pipe_Size:1]      = write_open_PIPE[Pipe_Size-1:0];
    write_open_PIPE_BL16[Pipe_Size:1] = write_open_PIPE_BL16[Pipe_Size-1:0];
    write_open_PIPE_BL32[Pipe_Size:1] = write_open_PIPE_BL32[Pipe_Size-1:0];
    BURST_PIPE_RD[Pipe_Size:1]        = BURST_PIPE_RD[Pipe_Size-1:0];
    BURST_PIPE_WR[Pipe_Size:1]        = BURST_PIPE_WR[Pipe_Size-1:0];
    MASK_PIPE[Pipe_Size:1]            = MASK_PIPE[Pipe_Size-1:0];
    RD_FIFO_PIPE[Pipe_Size:1]         = RD_FIFO_PIPE[Pipe_Size-1:0];	
    WR_FIFO_PIPE[Pipe_Size:1]         = WR_FIFO_PIPE[Pipe_Size-1:0];

    MRR_en_PIPE[0]          = 0;
    Dout_en_PIPE[0]         = 0;
    Dout_en_PIPE_BL16[0]    = 0;
    Dout_en_PIPE_BL32[0]    = 0;
    write_open_PIPE[0]      = 0;
    write_open_PIPE_BL16[0] = 0;
    write_open_PIPE_BL32[0] = 0;
    BURST_PIPE_RD[0]        = 0; 
    BURST_PIPE_WR[0]        = 0;
    MASK_PIPE[0]            = 0;
    WR_FIFO_PIPE[0]         = 0;
    RD_FIFO_PIPE[0]         = 0;

// Pipes work in DQS clk quanta
// BL independant PIPES
//##################################################################################
    OR_Pipes(MASK_temp,    (Write_Latency*2),                (Write_Latency*2+Burst_Length[0]),                            MASK_PIPE);
    OR_Pipes(ODT_FIFO,     ((tAODTon*2+(tODTon/tCK_half))),  (((tAODToff*2+(tODToff/tCK_half)))  + Burst_Length[0]-16-1),  WR_FIFO_PIPE);
    OR_Pipes(WR_FIFO_en,   (Write_Latency*2),                (Write_Latency*2+Burst_Length[0]-1),                          WR_FIFO_PIPE);	


    OR_Pipes(MRR_en,        (Read_Latency*2-4),      (Read_Latency*2+MRR_Burst_Length + Dout_en_offset-Dout_en_longtCK),   MRR_en_PIPE);
    OR_Pipes(MRR_en_rd_a,   (Read_Latency*2),        ((Read_Latency*2) + MRR_Burst_Length-1),                              MRR_en_PIPE);
    OR_Pipes(RD_FIFO_en_a,  (Read_Latency*2),        ((Read_Latency*2) + MRR_Burst_Length-1),                              RD_FIFO_PIPE);  		
    OR_Pipes(burst_rd_a,    (Read_Latency*2),        ((Read_Latency*2) + Burst_Length[1]-1),                               BURST_PIPE_RD);

MRR_en_rd   <= #(tDQSCK-2)  MRR_en_rd_a;     
RD_FIFO_en  <= #(tDQSCK)  RD_FIFO_en_a;   
burst_rd    <= #(tDQSCK)  burst_rd_a;      
    
    if (RTTval_dq) OR_Pipes(burst_wr,   (Write_Latency*2+2+(b/2)),  (Write_Latency*2+Burst_Length[1]+1+(b/2)+2+(tODToff/tCK_half)), BURST_PIPE_WR);
    else           OR_Pipes(burst_wr,   (Write_Latency*2+2+(b/2)),  (Write_Latency*2+Burst_Length[1]+1+(b/2)+4),                    BURST_PIPE_WR);

// BL dependant pipes
//##################################################################################	
    OR_Pipes(write_open_temp_BL16,  (Write_Latency*2),                  (Write_Latency*2+Burst_Length[0]-1),                        write_open_PIPE_BL16);
    OR_Pipes(ODT_write_BL16,        ((tAODTon*2+(tODTon/tCK_half))),    (((tAODToff*2+(tODToff/tCK_half)))+Burst_Length[0]-16-1),    write_open_PIPE_BL16);
    OR_Pipes(write_open_temp_BL32,  (Write_Latency*2),                  (Write_Latency*2+Burst_Length[1]-1),                        write_open_PIPE_BL32);
    OR_Pipes(ODT_write_BL32,        ((tAODTon*2+(tODTon/tCK_half))),    (((tAODToff*2+(tODToff/tCK_half)))+Burst_Length[1]-16-1),   write_open_PIPE_BL32);

    OR_Pipes(Dout_en_BL16,          (Read_Latency*2-4),                 (Read_Latency*2+Burst_Length[0]+Dout_en_offset+tRPSTc),     Dout_en_PIPE_BL16);
    OR_Pipes(Dout_en_BL32,          (Read_Latency*2-4),                 (Read_Latency*2+Burst_Length[1]+Dout_en_offset+tRPSTc),     Dout_en_PIPE_BL32);

    OR_Pipes(Dout_en_rd_BL16,       (Read_Latency*2),                   (Read_Latency*2 + Burst_Length[0]-1),                       Dout_en_PIPE_BL16);
    OR_Pipes(Dout_en_rd_BL32,       (Read_Latency*2),                   (Read_Latency*2 + Burst_Length[1]-1),                       Dout_en_PIPE_BL32);
			
    OR_Pipes(Dout_en_rd_pre1_BL16,  (Read_Latency*2-(tRPRE*2)),         (Read_Latency*2 -3),                                        Dout_en_PIPE_BL16);
    OR_Pipes(Dout_en_rd_pre2_BL16,  (Read_Latency*2-(tRPRE*2)+2),       (Read_Latency*2 -1),                                        Dout_en_PIPE_BL16);
    OR_Pipes(Dout_en_rd_pre1_BL32,  (Read_Latency*2-(tRPRE*2)),         (Read_Latency*2 -3),                                        Dout_en_PIPE_BL32);
    OR_Pipes(Dout_en_rd_pre2_BL32,  (Read_Latency*2-(tRPRE*2)+2),       (Read_Latency*2 -1),                                        Dout_en_PIPE_BL32);

	
// Combine bl16 and BL32 pipes
//##################################################################################
    write_open_temp  = (write_open_temp_BL16 || write_open_temp_BL32);
    ODT_write        = (ODT_write_BL16 || ODT_write_BL32);
    Dout_en          = (Dout_en_BL16 || Dout_en_BL32);
    Dout_en_rd      <= #(tDQSCK) (Dout_en_rd_BL16 || Dout_en_rd_BL32);
    Dout_en_rd_pre1 <= #(tDQSCK) (Dout_en_rd_pre1_BL16 || Dout_en_rd_pre1_BL32); 
    Dout_en_rd_pre2 <= #(tDQSCK) (Dout_en_rd_pre2_BL16 || Dout_en_rd_pre2_BL32);  

    if (($time - t_CCD)%(4) == 0 && Din_en) begin
    for (j=0; j<`Bank_Bits; j=j+1) begin
        if ((($time-t_bankWR[i])/tCK_meas) <= Write_Latency+1) begin
        t_WRend = $time;
        t_bankWRend[j] = $time;
        end
    end
	end
    end
end  // END "always @(CLK) begin"


// Makes time adjusted pipe windows for write: for reference : b=(tDQS2DQ/(tCK/4));
//##################################################################################
always begin	// pos & neg edge write_open_temp
    @(posedge write_open_temp) begin
    write_open <= #(tCL_meas-tIS) write_open_temp;
    Din_en     <= #(tDQS2DQ+(tDQSSp*tCK_meas/100)-tCK/4) write_open_temp;
    end
    @(negedge write_open_temp) begin
    write_open <= #(tCL_meas-tIS) write_open_temp;
    Din_en     <= #(tDQS2DQ+(tDQSSp*tCK_meas/100)-tCK/4) write_open_temp;

    Burst_Cnt  <= #(tDQS2DQ+(tDQSSp*tCK_meas/100)-tCK/4) 0;
    end
end
always begin	// pos & neg edge MASK_temp
    @(posedge MASK_temp) begin
	MASK <= #(tDQS2DQ+(tDQSSp*tCK_meas/100)-tCK/4) MASK_temp;
    end
    @(negedge MASK_temp) begin
	MASK <= #(tDQS2DQ+(tDQSSp*tCK_meas/100)-tCK/4) MASK_temp;
    end
end


// Makes time adjusted pipe windows for WR_FIFO_en_adj: for reference : b=(tDQS2DQ/(tCK/4));
//##################################################################################
always begin	// pos & neg WR_FIFO_en
    @(posedge WR_FIFO_en) begin
        WR_FIFO_en_adj <= #(tDQS2DQ+(tDQSSp*tCK_meas/100)-tCK/4)  WR_FIFO_en;
    end
    @(negedge WR_FIFO_en) begin
        WR_FIFO_en_adj <= #(tDQS2DQ+(tDQSSp*tCK_meas/100)-tCK/4)  WR_FIFO_en;
    end
end // always begin
always begin	// pos & neg ODT_write
    @(posedge ODT_write) begin
        if (Write_Latency>8) begin
            ODT_Force_DQ <= #(tODTon%tCK_half)	RTTval_dq;
            if (!( DM_DIS &&  !(DBI_WR) )) ODT_Force_DM <= #(tODTon%tCK_half) RTTval_dq;
        end
    end
    @(negedge ODT_write) begin
        if (Write_Latency>8) begin
            ODT_Force_DQ <= #(tODToff%tCK_half)	0;
            if (!( DM_DIS  && !(DBI_WR) )) ODT_Force_DM	<= #(tODToff%tCK_half)	0;
        end
    end
end // always begin
always begin	// pos & neg ODT_FIFO
    @(posedge ODT_FIFO) begin
        if (Write_Latency>8) begin
            if ( !(DM_DIS)  || DBI_WR  || DBI_RD ) ODT_Force_DM <= #(tODTon%tCK_half)	RTTval_dq;
        end
    end
    @(negedge ODT_FIFO) begin
        if (Write_Latency>8) begin
            if ( !(DM_DIS)  || DBI_WR  || DBI_RD ) ODT_Force_DM	<= #(tODToff%tCK_half)	0;
        end
    end
end // Always Begin


// Operation at system clock for read dq/dqs
//##################################################################################
always @(DQS_clk_rd)
begin
    #(0) // make this evaluated after Burst_Cnt has been incremented
    if ((Dout_en_rd) && ((Burst_Cnt!=0)||(Dout_en_rd_pre2)))  begin 
        debug_string = "Debug: DQS rd "; //Normal DQS Toggling
        if(Burst_Cnt%2 == 1)  DqsPad_Int_temp  <= #(tCH_meas) 2'b00; //DqsPadF_Int_temp;
        else                  DqsPad_Int_temp  <= #(tCL_meas) 2'b11; //DqsPadF_Int_temp;
    if(Burst_Cnt%2 == 1)      DqsPadF_Int_temp <= #(tCH_meas) 2'b11; //DqsPad_Int_temp;  
    else                      DqsPadF_Int_temp <= #(tCL_meas) 2'b00; //DqsPad_Int_temp;   
    end 

    #(1) // wait for dqs to load read data
    if(Dout_en_rd )  begin
        DqPad_Int_temp = dqout; // load data onto DQ for output
    end 
    else begin
        DqPad_Int_temp <=  16'bz;
        DmPad_Int_temp =  2'bz;
    end
end

// Enable DQS Preamble - 1 - only hits if non intersection post/pre ambles
always @(posedge Dout_en_rd_pre1) begin
    #(1)
    if (!Dout_en_rd ) begin
	debug_string = "DQS PRE1 Debug:DQS";	
	DqsPad_Int_temp  <=  4'h0;        
	DqsPadF_Int_temp <=  4'hf;
    end  
end

// Enable DQS Preamble - 2 - only hits if non intersection post/pre ambles
always @(posedge Dout_en_rd_pre2) begin
    #(1)
    if (!Dout_en_rd && !Dout_en_rd_post ) begin
	debug_string = "DQS PRE2 Debug:DQS";
	if (mode_reg[1][3]== 1) begin
	    DqsPad_Int_temp  <=  4'hf; 
	    DqsPadF_Int_temp <=  4'h0;
	    DqsPad_Int_temp  <= #(tCH_meas) 4'h0; 
	    DqsPadF_Int_temp <= #(tCH_meas) 4'hf;
	end
    end  
end

// Enable DQS RD
always @(posedge Dout_en_rd) begin
    debug_string = "Debug: DQS Drv 1"; //Normal DQS Toggling
    if(Burst_Cnt%2 == 1) DqsPad_Int_temp  <=  DqsPadF_Int_temp; 
    else		 DqsPad_Int_temp  <=  DqsPadF_Int_temp;
    if(Burst_Cnt%2 == 1) DqsPadF_Int_temp <=  DqsPad_Int_temp;  
    else		 DqsPadF_Int_temp <=  DqsPad_Int_temp;
end

// Enable DQ
always @(negedge Dout_en_rd) begin
    DqPad_Int_temp   <=  16'bz;
    DmPad_Int_temp   <=  2'bz;
    Dout_en_rd_post  <= 1'b1;
    Dout_en_rd_post  <= #(tCH_meas_stable*tRPSTc) 1'b0;
    debug_string = "Tri 1 Debug:DQ high Z ";
end

// Intersecting Pre / Post amble below
always @(posedge Dout_en_rd_post) begin
    #(1)
    if (mode_reg[1][7]== 0 && mode_reg[1][3]== 0 && tDQSCK_adj ==0) begin
	if (!Dout_en_rd_pre2 && !Dout_en_rd_pre1) begin
	    debug_string = "Tri 1 Debug:DQS _Dout a";
	    DqsPad_Int_temp  <=  4'bz;
	    DqsPadF_Int_temp <=  4'bz;
	end
    end
    else if (mode_reg[1][7]== 0 && mode_reg[1][3]== 0 && tDQSCK_adj ==1) begin
	if (!Dout_en_rd_pre2 && !Dout_en_rd_pre1) begin
	    debug_string = "Tri 1 Debug:DQS _Dout b";
	    DqsPad_Int_temp  <= 4'bz;
	    DqsPadF_Int_temp <= 4'bz;
	end
    end	
    else if (mode_reg[1][7]== 0 && mode_reg[1][3]== 1) begin
	if (!Dout_en_rd_pre2 && !Dout_en_rd_pre1) begin
	    debug_string = "Tri 1 Debug:DQS _Dout d";
	    DqsPad_Int_temp  <=  4'bz;
	    DqsPadF_Int_temp <=  4'bz;
	end
	if (Dout_en_rd_pre2) begin
	    DqsPad_Int_temp  <=  4'hf;
	    DqsPadF_Int_temp <=  4'h0;
	    #(tCK_meas/2)			
	    DqsPad_Int_temp  <=  4'h0;
	    DqsPadF_Int_temp <=  4'hf;					
	end
    end 
    else if (mode_reg[1][7]== 1 && mode_reg[1][3]== 0) begin
	debug_string = "Tri 1 Debug:DQS _Dout c";
	DqsPad_Int_temp  <=  4'hf; // used to be # -1
	DqsPadF_Int_temp <=  4'h0; // used to be # -1
	#(tCK_meas/2)
	DqsPad_Int_temp  <=  4'h0; // used to be # -1
	DqsPadF_Int_temp <=  4'hf; // used to be # -1
	#(tCK_meas/2)			
	if (!Dout_en_rd_pre2 && !Dout_en_rd_pre1 && !Dout_en_rd) begin
	    DqsPad_Int_temp  <=  4'bz;
	    DqsPadF_Int_temp <=  4'bz;
	end
    end
    if (mode_reg[1][7]== 1 && mode_reg[1][3]== 1) begin
	debug_string = "Tri 1 Debug:DQS _Dout e";
	DqsPad_Int_temp  <=  4'hf;
	DqsPadF_Int_temp <=  4'h0;		
	#(tCK_meas/2)
	DqsPad_Int_temp  <=  4'h0;
	DqsPadF_Int_temp <=  4'hf;
	#(tCK_meas/2)
	if (!Dout_en_rd_pre2 && !Dout_en_rd_pre1 && !Dout_en_rd) begin
	    debug_string = "Tri 1 Debug:DQS _Dout f";
	    DqsPad_Int_temp  <=  4'bz;
	    DqsPadF_Int_temp <=  4'bz;
	end 
	else if ( Dout_en_rd_pre2) begin
	    debug_string = "Tri 1 Debug:DQS _Dout g";
	    DqsPad_Int_temp  <=  4'hf;
	    DqsPadF_Int_temp <=  4'h0;
	    #(tCK_meas/2)
	    DqsPad_Int_temp  <=  4'h0;
	    DqsPadF_Int_temp <=  4'hf;
	end
    end 
end

	
	
// On Die Termination (ODT)
//##################################################################################
// -------------------------    Reference TABLE        -----------------------------       
// CATR - set at power up 			mode_reg[0][7]== X 
// MR11 - DQ ODT  				mode_reg[11][6:4]== 3b'XXX
// MR12 - DQ ODT  				mode_reg[11][2:0]== 3b'XXX
// MR13 - FSP-OP 				mode_reg[13][7]== X 
// MR13 - FSP-WR 				mode_reg[13][6]== X
// MR22 - ODT-CA Pad enable			mode_reg[22][5]== X
// MR22 - ODT- CS				mode_reg[22][4]== X
// MR22 - ODT-CK				mode_reg[22][3]== X 
// MR22 - SOC ODT 				mode_reg[22][2:0]== 3b'XXX
//##################################################################################
always @(posedge ODT)
begin
    if(ODT == 1 && RTTval_ca == 1 ) begin
	mode_reg[0][7]= 1'b1;
	if(ODT == 1 && RTTval_ca == 1) begin
	    if (mode_reg[22][5]== 0) ODT_Force_CA <= #(tODTon) 1;
	    if (mode_reg[22][4]== 1) ODT_Force_CS <= #(tODTon) 1;
	    if (mode_reg[22][3]== 1) ODT_Force_CK <= #(tODTon) 1;
	end 
	else begin
	    tODT_lockout = 0;
	    if(ODT == 1 && RTTval_ca == 1 ) begin
		if (mode_reg[22][5]== 0) ODT_Force_CA <= #(tODToff-tODT_lockout) 1;
		if (mode_reg[22][4]== 1) ODT_Force_CS <= #(tODToff-tODT_lockout) 1;
		if (mode_reg[22][3]== 1) ODT_Force_CK <= #(tODToff-tODT_lockout) 1;
	    end
	end
    end
end
always @(negedge ODT)
begin
    mode_reg[0][7]= 1'b0;
    if (mode_reg[22][5]== 0) ODT_Force_CA <= #(tODToff) 0;
    if (mode_reg[22][4]== 1) ODT_Force_CS <= #(tODToff) 0;
    if (mode_reg[22][3]== 1) ODT_Force_CK <= #(tODToff) 0;
end
always @(RTTval_ca) begin
    if (ODT && RTTval_ca) mode_reg[0][7]= 1'b1;
    else mode_reg[0][7]= 1'b0;
end


// Operation @ DQS for Write Leveling
//##################################################################################
always @(DqsPad[0]) begin 
// ML modified to deal with VCS glitch generation - 2018:10:15 - again 2020:07:06 - Jitter support
	DQS_clk_wr <= #((tDQS2DQ))  (DqsPad[0]);

 
    if(CA_training==1 && X==1) mode_reg[12][6:0] = DqPad[6:0];
    if(Write_Leveling == 1 && DqsPadIn[0] == 1) begin
	#((tCK_meas_stable/2) - 160) 					// this delay compensates offset between DQS and clock to where WLEV gets latched
	DqPad_Int_WL[0] <= #(tWLO+160) (!(CLK0)); 			// tWLO is the spec from pad to output - the minus amount is the above offset
    end
end
always @(DqsPad[1]) begin 
    if(Write_Leveling == 1 && DqsPadIn[1] == 1) begin
	#((tCK_meas_stable/2) - 160)
	DqPad_Int_WL[1] <= #(tWLO+160) (!(CLK0)); 
    end
end

// Operation @ DQS drive
//##################################################################################
// ML modified to deal with VCS glitch generation - 2018:10:15
always @(DQS_clk_wr) begin // Write CLK
    if(Burst_Cnt < Burst_Length[burst_wr]) begin
	if(Din_en == 1  && Dout_en == 0 ) begin
	    if (WR_FIFO_en_adj) begin
		FIFO_DATA[WR_FIFO_POINT]=DqPad;
		FIFO_DM_DATA[WR_FIFO_POINT]=DmPad;
		if (DEBUG>5) $display(" %t - Write Fifo @%d - Rd fifo@%d - Burst_cnt@%d DATA = %h", $time, WR_FIFO_POINT, RD_FIFO_POINT, Burst_Cnt, DqPad );
	    end 
	    else begin
		if(DEBUG>5) $display("    %t In DQS_WR_clk | DqsPad --> Din_en=1 ", $realtime);
		if(Burst_Cnt == 0) begin
		    ROW = ROW_PIPE[Write_Latency-1];
		    COL = COL_PIPE[Write_Latency-1];
		    Write_Bank = WR_Bank_PIPE[Write_Latency-1];
		end	    
                `ifdef WRITE_TO_FILE
		    memoryRead(Write_Bank, ROW, COL, dq_mask);
                `else if (Burst_Cnt==0 || Burst_Cnt==16 )	
		    for(int i=0 ; i <= array_cnt ; i++) begin
			if ( {array[i].bank,array[i].row,array[i].col} == {Write_Bank,ROW,COL[9:4]})begin			
			    data_burst = array[i].data;
			    break;
			end 
			else if (i==array_cnt) begin
			   if (i == array.size()-1) begin
			      array = new[i+1000](array);
			   end
			    array [i] = {Write_Bank,ROW,COL[9:4],256'bx};
			    data_burst = array[i].data;
			    if(DEBUG>0) $display("WR0 - New array entry # %d - %h - %h -%h ",array_cnt, array[i].bank, array[i].row, array[i].col[9:4]);
			    array_cnt = array_cnt +1;
			    break;
			end
		    end	// for (int i=0 ....
                `endif
		k = 0;
		for (kmk=k ; kmk<=`Data_Width-1 ; kmk=kmk+1) begin
		    if (Burst_Cnt < 16) dq_mask[kmk] = data_burst[kmk+Burst_Cnt*`Data_Width];
		    else                dq_mask[kmk] = data_burst[kmk+(Burst_Cnt-16)*`Data_Width];
		end					

		dq_prt = DqPad;
		k = 0;
		for (m=0 ; m<=(`Data_Mask-1) ; m=m+1) begin
		    if (DBI_WR) begin
			if (m==0) begin
			    if (DmPad[m]==1) dq_mask[(`Data_Width/`Data_Mask)-1:0]=~DqPad[(`Data_Width/`Data_Mask)-1:0]; 	// 3 cases (DBI)							
			    else if ((DqPad[2]+DqPad[3]+DqPad[4]+DqPad[5]+DqPad[6]+DqPad[7]>4)&&(MASK)) dq_mask[7:0]=dq_mask[7:0];
			    else dq_mask[7:0]=DqPad[7:0];
			end 
			else begin
			    if (DmPad[m]==1) dq_mask[`Data_Width-1:(`Data_Width/`Data_Mask)]=~DqPad[`Data_Width-1:(`Data_Width/`Data_Mask)];							
			    else if ((DqPad[10]+DqPad[11]+DqPad[12]+DqPad[13]+DqPad[14]+DqPad[15]>4)&&(MASK)) dq_mask[15:8]=dq_mask[15:8]; 
			    else dq_mask[15:8]=DqPad[15:8];
			end
		    end 
		    else begin // end (DBI_WR)
			if (!MASK) begin
	                    for (kmk=k ; kmk<=k+`Data_Width/`Data_Mask-1 ; kmk=kmk+1) begin
	                    	dq_mask[kmk] = dq_prt[kmk];
	                    end 						    
			end 
			else if (DmPad[m]==0) begin	// case with DM low - no mask
	                    for (kmk=k ; kmk<=k+`Data_Width/`Data_Mask-1 ; kmk=kmk+1) begin
	                    	dq_mask[kmk] = dq_prt[kmk];
	                    end
			end 
			else if (DmPad[m]!==1) begin // case with DM = x or z
	                    for (kmk=k ; kmk<=k+`Data_Width/`Data_Mask-1 ; kmk=kmk+1) begin
	                    	dq_mask[kmk] = 16'bx;
	                    end 						    
			end
		    end
		    k = k + `Data_Width/`Data_Mask;
	        end
		
	        // Write data to memory bank
                `ifdef WRITE_TO_FILE
		    memoryWrite(Write_Bank, ROW, COL, dq_mask);
                `else
		    data_build (1,data_burst,dq_mask);
		    if(DEBUG>5) $display("Post Data Build - DmPad = %h and DqPad = %h and dq_prt = %h and dq_mask = %h and data_burst = %h ", DmPad, DqPad, dq_prt, dq_mask ,data_burst );
		    if (Burst_Cnt==15 || Burst_Cnt==31) // data_burst is filled , write to array[i]
		    for(int i=0 ; i <= array_cnt ; i++) begin
		    	if ((array[i].bank == Write_Bank) && (array[i].row == ROW) && (array[i].col == COL[9:4])) begin  // if yes write to the correct entry, else write to new entry
		    	    array[i] = {Write_Bank,ROW,COL[9:4],data_burst};
		    	    if(DEBUG>5) $display("WR1 - %h -%h - %h - %h ", array[i].bank, array[i].row, array[i].col, array[i].data);
		    	    break;
		    	end 
		    end     // for (int i=0 ....
                `endif
	        if(DEBUG>0) $display("    %t WRITE : BANK %d : ROW %h : COL %h : DATA %h : MASK %b : DATA_NO_MASK %h", $realtime, Write_Bank, ROW, COL, dq_mask, DmPad, dq_prt);
		Burst_Cnt = Burst_Cnt+1;
		INC_BST_CNT_WR;
	    end
	end
// Increment FIFO counters in case of FIFO MPC commands - at the end of a burst...
	if (WR_FIFO_en_adj) WR_FIFO_POINT = WR_FIFO_POINT +1; 
	if (WR_FIFO_POINT>((5*16)-1)) WR_FIFO_POINT=0;
    end
end // end always @ (DQS_clk_wr | DqsPad_Int_temp)


// Operation @ DQS drive
//##################################################################################
always @(DQS_clk_rd) // Read CLK
begin
    Dout_en_real = ru(tDQSCK,tCK_meas)-2;   
    if(Dout_en_rd ) begin
     	if(Burst_Cnt < Burst_Length[burst_rd] ) begin
     	    if(Din_en == 0 && (Dout_en == 1 || MRR_en)) begin	    
     		// Read data from the MRR command
     		if(MRR_en_rd == 1 ) begin
     		    if(Burst_Cnt == 0) begin
     			MA_lat=COL_PIPE[Read_Latency+Dout_en_real];	
     		    end
     		    if(MA_lat == 32) begin
     			if(DEBUG>5) $display("  		MPC - MRR Takeover of DQs, reading from mode_reg[32/40]: ");
     			if (Burst_Cnt < 8)   begin
     			    if ( (CAS==1) && (X==0) ) dqout = {16{mode_reg[32][Burst_Cnt]}}^{mode_reg[15],mode_reg[20]};							    
     			    else dqout = {16{mode_reg[32][Burst_Cnt]}}^{mode_reg[20],mode_reg[15]}; 
     			    if (!DM_DIS || DBI_RD || DBI_WR) DmPad_Int_temp = {2{mode_reg[32][Burst_Cnt]}};
     			    if(DEBUG>5) $display("		    MPC RD-DQ BURST_CNT<8 : dqout = %h ",dqout);
     			end 
     			else if (Burst_Cnt>7) begin
     			    if ( (CAS==1) && (X==0) ) dqout = {16{mode_reg[40][Burst_Cnt-8]}}^{mode_reg[15],mode_reg[20]};
     			    else dqout = {16{mode_reg[40][Burst_Cnt-8]}}^{mode_reg[20],mode_reg[15]}; 
     			    if (!DM_DIS || DBI_RD || DBI_WR) DmPad_Int_temp = {2{mode_reg[40][Burst_Cnt-8]}};
     			    if(DEBUG>5) $display("		    MPC RD-DQ BURST_CNT>7 : dqout = %h ",dqout);
     			end
     		    end 
     		    else begin
     			if(DEBUG>5) $display("  		MRR Takeover of DQs, reading from MA: %0d", MA_lat);
     			warning_string = "MRR: MRR Takeover of DQs";
     			ROW = 'bx;
     			COL = 'bx;
     			Read_Bank = 'bx;
     			if(Burst_Cnt <16) begin 
     			    dqout = {mode_reg[MA_lat], mode_reg[MA_lat]};   if(DEBUG>5) $display("  MRR DQ load =%h ", mode_reg[MA_lat]);   
     			    if (MA_lat==4)  dqout = {mode_reg[MA_lat][7],4'b0, mode_reg[MA_lat][2:0], mode_reg[MA_lat][7],4'b0, mode_reg[MA_lat][2:0]};     if(DEBUG>5) $display(" MR4 special case  - MRR DQ load =%h ", mode_reg[MA_lat]);	    
     			    if (MA_lat==24) dqout = {4'b0, mode_reg[MA_lat][3:0],4'b0, mode_reg[MA_lat][3:0]};  					    if(DEBUG>5) $display(" MR24 special case -  MRR DQ load =%h ", mode_reg[MA_lat]);	    
     			end 
     			else begin 
     			    dqout = 16'bx;	
     			    if(DEBUG>5) $display("  MRR DQ load = 16'bx; ");	
     			end				    
     		    end
     		end 
     		else if (RD_FIFO_en) begin // load FIFO data onto DQ based on FIFO pointer and burst count
     		    if(DEBUG>5) $display("		    MPC RD-FIFO - Takeover of DQs, reading from FIFO, RD_DIDO_POINT = %d ", RD_FIFO_POINT);
     		    dqout = FIFO_DATA[RD_FIFO_POINT];
     		    if (DBI_RD || DBI_WR || !DM_DIS) DmPad_Int_temp = FIFO_DM_DATA[RD_FIFO_POINT];
     		end 
     		else begin // Read data directly from memory bank
     		    if(Burst_Cnt == 0) begin
     			ROW = ROW_PIPE[Read_Latency+Dout_en_real];
     			COL = COL_PIPE[Read_Latency+Dout_en_real];
     			Read_Bank = WR_Bank_PIPE[Read_Latency+Dout_en_real];
     			if(DEBUG>5) $display(" Read_Bank assigned from WR_Bank_PIPE %d , RD_LAT = %d, Dout_en_real = %d", Read_Latency+Dout_en_real ,Read_Latency, Dout_en_real);				
     		    end
                    `ifdef WRITE_TO_FILE
     			memoryRead(Read_Bank, ROW, COL,dqout);  	    
                    `else if (Burst_Cnt==0 || Burst_Cnt==16)	    
     			for(int i=array_cnt-1 ; i >= 0 ; i--) begin // check if array entry exists
     			    if ({array[i].bank,array[i].row,array[i].col} == {Read_Bank,ROW,COL[9:4]} ) begin // yes write to the correct entry, else write to new entry
     				data_burst = array[i];
     				break;
     			    end 
     			    if (i==0)	data_burst = 'x;
     			end // for (int i=0 ....
     			data_build (0,data_burst,dqout);
                    `endif
     		end
     		dq_prt = dqout ;
     		if (DBI_RD) begin
     		    if (!(RD_FIFO_en)) begin
     		    	if (!(MRR_en_rd && (MA_lat == 32))) begin
     		    	    DmPad_Int_temp[1:0]=2'b00;
     		    	    if ((dqout[0]+dqout[1]+dqout[2]+dqout[3]+dqout[4]+dqout[5]+dqout[6]+dqout[7])>4) begin
     		    		dqout[7:0]=~dqout[7:0];
     		    		DmPad_Int_temp[0]=1;
     		    	    end
     		    	    if (|dqout[7:0]===1'bx) DmPad_Int_temp[0]=1'bx;
     		    	    if ((dqout[8]+dqout[9]+dqout[10]+dqout[11]+dqout[12]+dqout[13]+dqout[14]+dqout[15])>4) begin
     		    		dqout[15:8]=~dqout[15:8];
     		    		DmPad_Int_temp[1]=1;
     		    	    end
     		    	    if (|dqout[15:8]===1'bx) DmPad_Int_temp[1]=1'bx;
     		    	end
     		    end
     		end
     		if(DEBUG>0)  $display("    %t READ  : BANK %d : ROW %h : COL %h : DATA %h : DATA_noDBI %h", $time, Read_Bank, ROW, COL, dqout, dq_prt);			
     		Burst_Cnt = Burst_Cnt+1;
     		INC_BST_CNT_RD; 	    
     	    end
     	end // end if burst count < burst_length
// increment FIFO counters for MPC commands after burst...
     	if (RD_FIFO_en) RD_FIFO_POINT = RD_FIFO_POINT +1;
     	if (RD_FIFO_POINT>((5*16)-1)) RD_FIFO_POINT=0;      
    end //  end if DOUT_en_RD
end // end always a@ DQS

				
// TASK DEFINITION
// Increment Burst Counter RD
//##################################################################################
task INC_BST_CNT_RD;
    integer mm;
    begin
     	if(DEBUG>6) $display("    %t - RD-INC_BST_CNT = %d ", $time, Burst_Cnt);	
     	tmp_Cadd = COL+1;   // Sequential	    
     	COL[3:0] = tmp_Cadd[3:0];
     	if (burst_rd) // meaning BL = 32 OTF or MR
     	    if (Burst_Cnt == 16)  begin
     	    	COL[4] = ~COL[4];
     	    	if(DEBUG>7) $display("INC_BST_CNT Burst=16 invert COL[4] " );				
     	    end
     	if(MRR_en_rd == 1 && Burst_Cnt == MRR_Burst_Length)
     	    Burst_Cnt = 0; 
     	else if(Burst_Cnt >= Burst_Length[burst_rd]) begin
     	    Burst_Cnt = 0;
     	    if(DEBUG>6) $display("INC_BST_CNT Burst Reset... @time:%0t , with Burst_cnt=%d , and Burst_length=%d", $time, Burst_Cnt, Burst_Length[burst_rd] );			
     	end	
    end        
endtask


// Increment Burst Counter WR
//##################################################################################
task INC_BST_CNT_WR;
    integer mm;
    begin
	if(DEBUG>6) $display("WR-INC_BST_CNT = %d ", Burst_Cnt);	
        tmp_Cadd = COL+1;   // Sequential	    
	case (burst_wr)
	    1'b0 : begin COL[3:0] = tmp_Cadd[3:0]; if(DEBUG>5) $display("INC_WR burst_wr(case=0)"); end
	    1'b1 : begin COL[4:0] = tmp_Cadd[4:0]; if(DEBUG>5) $display("INC_WR burst_wr(case=1)"); end 
	endcase
        if(Burst_Cnt >= Burst_Length[burst_wr]) begin
	    Burst_Cnt = 0;
        end	
   end        
endtask


// Data Assignment
//##################################################################################
task data_build;
    input IO;
    inout [`Data_Width*16-1:0]Ax;
    inout [`Data_Width-1:0] Ay;
    begin
	case (IO)
            0: // this would be for read
            begin
            	case (COL[3:0]) // depending on Burst_Cnt 16 bits get put in the needed location //
            	0:	Ay=Ax[15:0];
            	1:	Ay=Ax[31:16];
            	2:	Ay=Ax[47:32];
            	3:	Ay=Ax[63:48];
            	4:	Ay=Ax[79:64];
            	5:	Ay=Ax[95:80];
            	6:	Ay=Ax[111:96];
            	7:	Ay=Ax[127:112];
            	8:	Ay=Ax[143:128];
            	9:	Ay=Ax[159:144];
            	10:	Ay=Ax[175:160];
            	11:	Ay=Ax[191:176];
            	12:	Ay=Ax[207:192];
            	13:	Ay=Ax[223:208];
            	14:	Ay=Ax[239:224];
            	15:	Ay=Ax[255:240];
            	endcase 	
            end // 0:
            1: // this would be for write
            begin
            	case (Burst_Cnt) // depending on Burst_Cnt 16 bits get put in the needed location //
            	0:	Ax[15:0]=Ay;
            	1:	Ax[31:16]=Ay;
            	2:	Ax[47:32]=Ay;
            	3:	Ax[63:48]=Ay;
            	4:	Ax[79:64]=Ay;
            	5:	Ax[95:80]=Ay;
            	6:	Ax[111:96]=Ay;
            	7:	Ax[127:112]=Ay;
            	8:	Ax[143:128]=Ay;
            	9:	Ax[159:144]=Ay;
            	10:	Ax[175:160]=Ay;
            	11:	Ax[191:176]=Ay;
            	12:	Ax[207:192]=Ay;
            	13:	Ax[223:208]=Ay;
            	14:	Ax[239:224]=Ay;
            	15:	Ax[255:240]=Ay;
            	16:	Ax[15:0]=Ay;
            	17:	Ax[31:16]=Ay;
            	18:	Ax[47:32]=Ay;
            	19:	Ax[63:48]=Ay;
            	20:	Ax[79:64]=Ay;
            	21:	Ax[95:80]=Ay;
            	22:	Ax[111:96]=Ay;
            	23:	Ax[127:112]=Ay;
            	24:	Ax[143:128]=Ay;
            	25:	Ax[159:144]=Ay;
            	26:	Ax[175:160]=Ay;
            	27:	Ax[191:176]=Ay;
            	28:	Ax[207:192]=Ay;
            	29:	Ax[223:208]=Ay;
            	30:	Ax[239:224]=Ay;
            	31:	Ax[255:240]=Ay;
            	endcase 	// (Burst_Cnt)
            end // 1:
	endcase // case(IO)
    end
endtask

`ifdef WRITE_TO_FILE
    function integer openFile;
    	input integer bank;
	integer fileDesc;
	reg [2048:1] fileName;
	begin
	    $sformat( fileName, "%0s/%m.%0d", tempDir, bank );
	    fileDesc = $fopen(fileName, "w+");
	    if (fileDesc == 0)
	    begin
		$display("%m: at time %0t ERROR: failed to open %0s.", $time, fileName);
		$finish;
	    end
	    else
	    begin
		$display("%m: at time %0t INFO: opening %0s.", $time, fileName);
		openFile = fileDesc;
	    end
	end
    endfunction

    function [2*FILE_BITS:1] readFromFile;
	input integer fileDesc;
	input integer fileIndex;
	integer retCode;
	integer fileOffset;
	reg [1024:1] message;
	reg [2*FILE_BITS:1] readValue;
	begin
	    fileOffset = fileIndex * FILE_CHUNK;
	    retCode = $fseek( fileDesc, fileOffset, 0 );
	    // $fseek returns 0 on success, -1 on failure
	    if (retCode != 0)
	    begin
		$display("%m: at time %t ERROR: fseek to %d failed", $time, fileOffset);
		$finish;
	    end

	    retCode = $fscanf(fileDesc, "%z", readValue);
	    // $fscanf returns number of items read
	    if (retCode != 1)
	    begin
		if ($ferror(fileDesc,message) != 0)
	        begin
		    $display("%m: at time %t ERROR: fscanf failed at %d", $time, fileIndex);
		    $display(message);
		    $finish;
		end
		else
		    readValue = 'hx;
	    end

	    /* when reading from unwritten portions of the file, 0 will be returned.
	    * Use 0 in bit 1 as indicator that invalid data has been read.
	    * A true 0 is encoded as Z.
	    */
	    if (readValue[1] === 1'bz)
		// true 0 encoded as Z, data is valid
		readValue[1] = 1'b0;
	    else if (readValue[1] === 1'b0)
		// read from file section that has not been written
		readValue = 'hx;

	    readFromFile = readValue;
	end
    endfunction

    task writeToFile;
	input integer fileDesc;
	input integer fileIndex;
	input [2*FILE_BITS:1] inputData;
	integer retCode;
	integer fileOffset;
	begin
	    fileOffset = fileIndex * FILE_CHUNK;
	    retCode = $fseek( fileDesc, fileOffset, 0 );
	    if (retCode != 0) begin
			$display("%m: at time %t ERROR: fseek to %d failed", $time, fileOffset);
			$finish;
	    end
	    // encode a valid data
	    if (inputData[1] === 1'bz)      inputData[1] = 1'bx;
	    else if (inputData[1] === 1'b0) inputData[1] = 1'bz;
	    $fwrite( fileDesc, "%z", inputData );
	end
    endtask

    task eraseAllData;
	input  [(1<<`Bank_Bits)-1:0] allBanks; //one select bit per bank
	integer curBank;
	begin
	for (curBank = 0; curBank < (1<<`Bank_Bits); curBank = curBank + 1)
	    if (allBanks[curBank] === 1'b1) begin
		$fclose(memoryFileDesc[curBank]);
		memoryFileDesc[curBank]=openFile(curBank);
	    end
	end
    endtask

    task memoryWrite;
	input  [`Bank_Bits-1:0]  memWRbank;
	input  [`Row_Bits-1:0] memWRrow;
	input  [`Col_Bits-1:0] memWRcol;
	input  [2*`Data_Width-1:0] memWRdata;
	begin
	    writeToFile( memoryFileDesc[memWRbank], {memWRrow, memWRcol}, memWRdata );
	end
    endtask

    task memoryRead;
	input  [`Bank_Bits-1:0]  memRDbank;
	input  [`Row_Bits-1:0] memRDrow;
	input  [`Col_Bits-1:0] memRDcol;
	output [2*`Data_Width-1:0] memRDdata;
	begin
	    memRDdata= readFromFile( memoryFileDesc[memRDbank], {memRDrow, memRDcol});
	end
    endtask
`endif


task OR_Pipes;
    inout data;
    input loop_min;
    input loop_max;
    input [Pipe_Size:0] data_pipe;
    reg PIPE_INC;
    integer loop_min;
    integer loop_max;
    begin
        PIPE_INC = 0;
        for(j=loop_min; j<=loop_max; j=j+1) 
			PIPE_INC = data_pipe[j] | PIPE_INC;
        if(PIPE_INC == 0) 
			data = 0;
        else 
			data = 1;
    end
endtask 

task Increment_Pipes;
    begin
        for (j=Pipe_Size; j>0; j=j-1) begin
	    	ROW_PIPE[j]     = ROW_PIPE[j-1];	
	    	COL_PIPE[j]     = COL_PIPE[j-1];
	    	WR_Bank_PIPE[j] = WR_Bank_PIPE[j-1];
        end
    end
endtask

task Timing_Error_Check; 
begin
	// Empty on purpose - LPDDR4 spec does not make provisions for illegal commands - RESET is required if Illegal command
end
endtask

function integer ru; // FUNCTION TO ROUND NUMBERS - Rounds Up
input int num1;
input int num2;
    if (num1>0) begin
	if (num1%num2) ru = ((num1/num2) + 1); 
	else ru = (num1/num2);
    end 
    else ru = 0;
endfunction

task FSP_WR_2_MR; // Put all of the (FSP_WR) values of FSP_OP_REG into mode_reg
begin
    if (DEBUG) $display("    %t ### in FSP_WR_2_MR ### %m", $time); 
    mode_reg[1][7:0]    = FSP_OP_REG[mode_reg[13][6]][46:39];
    mode_reg[2][6:0]    = FSP_OP_REG[mode_reg[13][6]][38:32];
    mode_reg[3][7:3]    = FSP_OP_REG[mode_reg[13][6]][31:27];
    mode_reg[3][1]      = FSP_OP_REG[mode_reg[13][6]][26];
    mode_reg[11][6:4]   = FSP_OP_REG[mode_reg[13][6]][25:23];
    mode_reg[11][2:0]   = FSP_OP_REG[mode_reg[13][6]][22:20];
    mode_reg[12][6:0]   = FSP_OP_REG[mode_reg[13][6]][19:13];   // double size for second calibration point
    mode_reg[14][6:0]   = FSP_OP_REG[mode_reg[13][6]][12:6];    // double size for second calibration point
    mode_reg[22][5:0]   = FSP_OP_REG[mode_reg[13][6]][5:0];
end
endtask

task MR_2_FSP_WR; // put all of the (FSP_WR) values of mode_reg into FSP_OP_REG[FSP_WR - index]
begin	
    FSP_OP_REG[mode_reg[13][6]][46:0]={mode_reg[1][7:0],mode_reg[2][6:0],mode_reg[3][7:3],mode_reg[3][1],mode_reg[11][6:4],mode_reg[11][2:0],mode_reg[12][6:0],mode_reg[14][6:0],mode_reg[22][5:0]};
end
endtask

task FSP_OP_2_MR; // put all of the (FSP_OP) values of FSP_OP_REF into mode_reg
begin
    if (DEBUG) $display("    %t ### in FSP_WR_2_MR ### %m", $time); 
    mode_reg[1][7:0]    = FSP_OP_REG[mode_reg[13][7]][46:39];
    mode_reg[2][6:0]    = FSP_OP_REG[mode_reg[13][7]][38:32];
    mode_reg[3][7:3]    = FSP_OP_REG[mode_reg[13][7]][31:27];
    mode_reg[3][1]      = FSP_OP_REG[mode_reg[13][7]][26];
    mode_reg[11][6:4]   = FSP_OP_REG[mode_reg[13][7]][25:23];
    mode_reg[11][2:0]   = FSP_OP_REG[mode_reg[13][7]][22:20];
    mode_reg[12][6:0]   = FSP_OP_REG[mode_reg[13][7]][19:13];   // double size for second calibration point
    mode_reg[14][6:0]   = FSP_OP_REG[mode_reg[13][7]][12:6];    // double size for second calibration point
    mode_reg[22][5:0]   = FSP_OP_REG[mode_reg[13][7]][5:0];
end
endtask

task set_mode_register_params;
    begin
     	if(DEBUG>6)  $display("_set_mode_register_params_ sets module specific MR_Latches");	
     	for (i=0; i<256; i=i+1) begin
     	    mode_reg[i]=8'b00000000;
     	end
     	// Device Information
     	mode_reg[5]= 8'b0000_0101; // Manufacturer ID
     	mode_reg[6]= 8'b0000_0000; // Revision ID1
     	mode_reg[7]= 8'b0000_0000; // Revision ID2
     	part_config[1:0]= 2'b00;
     	`ifdef Den_2Gb
     	    part_config[5:2]= 4'b0000;
     	`elsif Den_3Gb
     	    part_config[5:2]= 4'b0001;
     	`elsif Den_4Gb
     	    part_config[5:2]= 4'b0010;
     	`elsif Den_6Gb
     	    part_config[5:2]= 4'b0011;
     	`elsif Den_8Gb
     	    part_config[5:2]= 4'b0100;
     	`elsif Den_12Gb
     	    part_config[5:2]= 4'b0101;      
     	`elsif Den_16Gb
     	    part_config[5:2]= 4'b0110;
     	`else
     	    part_config[5:2]= 4'b0010; // 4Gb default
     	`endif
     	if (X==1)      part_config[7:6]= 2'b00;
     	else if (X==0) part_config[7:6]= 2'b01;
     	mode_reg[8]=part_config;
    end
    if (X==1) 	mode_reg[0][1] =1'b0;  //  CATR & RZQI & REF MODE: mode_reg[0] =8'b0xx0_0xx0;
    else     	mode_reg[0][1] =1'b1;  //  CATR & RZQI & REF MODE: mode_reg[0] =8'b0xx0_0xx0;
endtask

task apply_mr_settings; 
    begin
	// Set the proper variables after the Mode Register has been written to.  All applicable mode registers are processed
 	// MR 0 - read only	
	//##################################################################################
	// CATR - set at power up - mode_reg[0][7]== X 
	if (X==1) 	mode_reg[0][1] =1'b0;  //  CATR & RZQI & REF MODE: mode_reg[0] =8'b0xx0_0xx0;
	else     	mode_reg[0][1] =1'b1;  //  CATR & RZQI & REF MODE: mode_reg[0] =8'b0xx0_0xx0;

	//   MR 1 -	 
	//################################################################################## 
	casex (mode_reg[1])
	    8'b1xxx_xxxx: begin if(DEBUG>5) $display("	MR1[7] = 1 - RD post amble = 1.5tck ");	tRPSTc=3; end
	    default:      begin if(DEBUG>5) $display("	MR1[7] = 0 - RD post amble = 0.5tck"); 	tRPSTc=1; end
	endcase 
	casex ({X,mode_reg[1]}) // MR1 - Check nWR
	    // X16  - ML 2020_01_17 updated comment and table below       
   	    9'b1_x000_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 000 - nWR :  6"); nWR =  6;  end
	    9'b1_x001_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 001 - nWR : 10"); nWR = 10;  end
	    9'b1_x010_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 010 - nWR : 16"); nWR = 16;  end
	    9'b1_x011_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 011 - nWR : 20"); nWR = 20;  end
	    9'b1_x100_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 100 - nWR : 24"); nWR = 24;  end
	    9'b1_x101_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 101 - nWR : 30"); nWR = 30;  end
	    9'b1_x110_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 110 - nWR : 34"); nWR = 34;  end
	    9'b1_x111_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 111 - nWR : 40"); nWR = 40;  end
	    // XByte Mode - Should not get here , Byte mode not supported - ML 2020_10_17
//	    9'b1_x000_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 000 - nWR :  6"); nWR =  6;  end
//	    9'b1_x001_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 001 - nWR : 12"); nWR = 12;  end
//	    9'b1_x010_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 010 - nWR : 16"); nWR = 16;  end
//	    9'b1_x011_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 011 - nWR : 22"); nWR = 22;  end
//	    9'b1_x100_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 100 - nWR : 28"); nWR = 28;  end
//	    9'b1_x101_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 101 - nWR : 32"); nWR = 32;  end
//	    9'b1_x110_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 110 - nWR : 38"); nWR = 38;  end
//	    9'b1_x111_xxxx: begin if(DEBUG>5) $display("    MR1[6-4] = 111 - nWR : 44"); nWR = 44;  end
	    default:        begin if(DEBUG>5) $display("    MR1[6-4] = ??? - nWR : Invalid, Default to nWR=6"); nWR = 6;  end
	endcase 
	casex (mode_reg[1]) // MR1 - Check RD-PRE 		- mode_reg[1][3]== X 
     	    8'bxxxx_1xxx: begin if(DEBUG>5) $display("        MR1[3] = 1 - RD pre amble = toggle"); end
    	    default:	  begin if(DEBUG>5) $display("        MR1[3] = 0 - RD pre amble = static"); end
	endcase 
	casex (mode_reg[1]) // MR1 - Check WR-PRE    
     	    8'bxxxx_x1xx: begin if(DEBUG>5)   $display("	MR1[2] = 1 - WR pre amble = 2*tck"); end
    	    default:	  begin if(DEBUG>5)   $display("	MR1[2] = 0 - Should not be here - reserved state"); end
	endcase      
	casex (mode_reg[1]) // MR1 - Check Burst Length	
	    8'bxxxx_xx00: begin if(DEBUG>5)   $display("	MR1[1:0] = 00 -	Burst length : 16"); OTF = 1'b0 ; BL = 1'b0; end
	    8'bxxxx_xx01: begin if(DEBUG>5)   $display("	MR1[1:0] = 01 -	Burst length : 32"); OTF = 1'b0 ; BL = 1'b1; end
	    8'bxxxx_xx10: begin if(DEBUG>5)   $display("	MR1[1:0] = 10 -	Burst length :  1"); OTF = 1'b1 ; BL = 1'bx; end
    	    default:  begin if(DEBUG>5)   $display("	Burst length : Invalid"); end
	endcase
	
	// MR2: When X=0 it is in BYTE MODE - when X=1 it is X16 mode
	//##################################################################################
	casex ({X,mode_reg[3],mode_reg[2]}) // MR2 - Check Read Latency   
	    // BYTE MODE:
	    17'b1_x0xx_xxxx_xxxx_x000: begin    Read_Latency =  6;  nRTP = 8; 	end
	    17'b1_x0xx_xxxx_xxxx_x001: begin    Read_Latency = 10;  nRTP = 8;  	end
	    17'b1_x0xx_xxxx_xxxx_x010: begin    Read_Latency = 14;  nRTP = 8;  	end
	    17'b1_x0xx_xxxx_xxxx_x011: begin    Read_Latency = 20;  nRTP = 8;  	end	    	    	    
    	    17'b1_x0xx_xxxx_xxxx_x100: begin    Read_Latency = 24;  nRTP = 10; 	end
    	    17'b1_x0xx_xxxx_xxxx_x101: begin    Read_Latency = 28;  nRTP = 12; 	end
    	    17'b1_x0xx_xxxx_xxxx_x110: begin    Read_Latency = 32;  nRTP = 14; 	end
    	    17'b1_x0xx_xxxx_xxxx_x111: begin    Read_Latency = 36;  nRTP = 16; 	end
    	    17'b1_x1xx_xxxx_xxxx_x000: begin    Read_Latency =  6;  nRTP = 8;  	end
    	    17'b1_x1xx_xxxx_xxxx_x001: begin    Read_Latency = 12;  nRTP = 8;  	end
    	    17'b1_x1xx_xxxx_xxxx_x010: begin    Read_Latency = 16;  nRTP = 8;  	end
    	    17'b1_x1xx_xxxx_xxxx_x011: begin    Read_Latency = 22;  nRTP = 8;  	end	    	    	    
    	    17'b1_x1xx_xxxx_xxxx_x100: begin    Read_Latency = 28;  nRTP = 10; 	end
    	    17'b1_x1xx_xxxx_xxxx_x101: begin    Read_Latency = 32;  nRTP = 12; 	end
	    17'b1_x1xx_xxxx_xxxx_x110: begin	Read_Latency = 36;  nRTP = 14;  end
    	    17'b1_x1xx_xxxx_xxxx_x111: begin    Read_Latency = 40;  nRTP = 16; 	end 
	    // X16:
    	    17'b0_x0xx_xxxx_xxxx_x000: begin    Read_Latency =  6;  nRTP = 8; 	end
    	    17'b0_x0xx_xxxx_xxxx_x001: begin    Read_Latency = 10;  nRTP = 8;  	end
    	    17'b0_x0xx_xxxx_xxxx_x010: begin    Read_Latency = 16;  nRTP = 8;  	end
    	    17'b0_x0xx_xxxx_xxxx_x011: begin    Read_Latency = 22;  nRTP = 8;  	end	    	    	    
    	    17'b0_x0xx_xxxx_xxxx_x100: begin    Read_Latency = 26;  nRTP = 10; 	end
    	    17'b0_x0xx_xxxx_xxxx_x101: begin    Read_Latency = 32;  nRTP = 12; 	end
    	    17'b0_x0xx_xxxx_xxxx_x110: begin    Read_Latency = 36;  nRTP = 14; 	end
    	    17'b0_x0xx_xxxx_xxxx_x111: begin    Read_Latency = 40;  nRTP = 16; 	end
    	    17'b0_x1xx_xxxx_xxxx_x000: begin    Read_Latency =  6;  nRTP = 8;  	end
    	    17'b0_x1xx_xxxx_xxxx_x001: begin    Read_Latency = 12;  nRTP = 8;  	end
    	    17'b0_x1xx_xxxx_xxxx_x010: begin    Read_Latency = 18;  nRTP = 8;  	end
    	    17'b0_x1xx_xxxx_xxxx_x011: begin    Read_Latency = 24;  nRTP = 8;  	end	    	    	    
    	    17'b0_x1xx_xxxx_xxxx_x100: begin    Read_Latency = 30;  nRTP = 10; 	end
    	    17'b0_x1xx_xxxx_xxxx_x101: begin    Read_Latency = 36;  nRTP = 12; 	end
	    17'b0_x1xx_xxxx_xxxx_x110: begin	Read_Latency = 40;  nRTP = 14;  end
    	    17'b0_x1xx_xxxx_xxxx_x111: begin    Read_Latency = 44;  nRTP = 16; 	end 		   
    	    default: begin if(DEBUG>5) $display("    Read latency  : Invalid"); end
	endcase
	casex (mode_reg[2]) // MR2 - Check Write Latency
	    8'bx000_0xxx: begin    Write_Latency =  4; tAODTon=0;   tAODToff=0;  end
	    8'bx000_1xxx: begin    Write_Latency =  6; tAODTon=0;   tAODToff=0;  end
	    8'bx001_0xxx: begin    Write_Latency =  8; tAODTon=0;   tAODToff=0;  end
	    8'bx001_1xxx: begin    Write_Latency = 10; tAODTon=4;   tAODToff=20; end
	    8'bx010_0xxx: begin    Write_Latency = 12; tAODTon=4;   tAODToff=22; end
	    8'bx010_1xxx: begin    Write_Latency = 14; tAODTon=6;   tAODToff=24; end
	    8'bx011_0xxx: begin    Write_Latency = 16; tAODTon=6;   tAODToff=26; end
	    8'bx011_1xxx: begin    Write_Latency = 18; tAODTon=8;   tAODToff=28; end	 
	    8'bx100_0xxx: begin    Write_Latency =  4; tAODTon=0;   tAODToff=0;  end
	    8'bx100_1xxx: begin    Write_Latency =  8; tAODTon=0;   tAODToff=0;  end
	    8'bx101_0xxx: begin    Write_Latency = 12; tAODTon=6;   tAODToff=22; end
	    8'bx101_1xxx: begin    Write_Latency = 18; tAODTon=12;  tAODToff=28; end
	    8'bx110_0xxx: begin    Write_Latency = 22; tAODTon=14;  tAODToff=32; end
	    8'bx110_1xxx: begin    Write_Latency = 26; tAODTon=18;  tAODToff=36; end
	    8'bx111_0xxx: begin    Write_Latency = 30; tAODTon=20;  tAODToff=40; end
	    8'bx111_1xxx: begin    Write_Latency = 34; tAODTon=24;  tAODToff=44; end 
	    default:      begin if(DEBUG>5)    $display("    Write latency  : Invalid"); end
	endcase
	casex ({mode_reg[2]}) // MR2 - Check Write Leveling					
    	    8'b0xxx_xxxx: begin  Write_Leveling <= #(4780) 0; end
    	    8'b1xxx_xxxx: begin  Write_Leveling <= #(4780) 1; DqPad_Int_WL <= #(4780) 2'b11; end// <= #(tMRZ)
    	    default: 	  begin if(DEBUG>5) $display("    Write Leveling  : Invalid, default to Disable Write Leveling"); Write_Leveling = 0; end
	endcase
	if(DEBUG>5)  $display("    Read latency  : %0d  Write latency  : %0d  nWR : %0d   nRTP : %0d   OTFen  %0d  : BL  %d", Read_Latency, Write_Latency, nWR, nRTP, OTF, BL);


	// MR3
	//##################################################################################
	casex (mode_reg[3]) // MR3 - Check DBI Write 
            8'b0xxx_xxxx: begin if(DEBUG>5) $display("	MR3[7] = 0 - DBI Write disabled"); DBI_WR = 0; end
     	    default:      begin if(DEBUG>5) $display("	MR3[7] = 1 - DBI Write enabled");  DBI_WR = 1; end
	endcase 
	casex (mode_reg[3]) // MR3 - Check DBI Read 
            8'bx0xx_xxxx: begin if(DEBUG>5) $display("	MR3[6] = 0 - DBI Read disabled"); DBI_RD = 0; end
     	    default:	  begin if(DEBUG>5) $display("  MR3[6] = 1 - DBI Read enabled");  DBI_RD = 1; end
	endcase     
	casex (mode_reg[3]) // MR3 - Check PDDS 
    	    8'bxx11_0xxx: begin if(DEBUG>5) $display("	MR3[5:3] = PDDS = RZQ/6 "); end
    	    8'bxx00_1xxx: begin if(DEBUG>5) $display("	MR3[5:3] = PDDS = RZQ/1 "); end
    	    8'bxx01_0xxx: begin if(DEBUG>5) $display("	MR3[5:3] = PDDS = RZQ/2 "); end
    	    8'bxx01_1xxx: begin if(DEBUG>5) $display("	MR3[5:3] = PDDS = RZQ/3 "); end	    
    	    8'bxx10_0xxx: begin if(DEBUG>5) $display("	MR3[5:3] = PDDS = RZQ/4 "); end	    
    	    8'bxx10_1xxx: begin if(DEBUG>5) $display("	MR3[5:3] = PDDS = RZQ/5 "); end
	    8'bxx11_1xxx: begin if(DEBUG>5) $display("	MR3[5:3] = 111 - should not be here Resreved"); end		    
	    default:	  begin if(DEBUG>5) $display("  MR3[5:3] - reserved state, should not be here"); end
	endcase 
	casex (mode_reg[3])
            8'bxxxx_x0xx: begin if(DEBUG>5) $display("  MR3[2] = 0 - Post Package Repair protection disabled"); end
     	    default:	  begin if(DEBUG>5) $display("  MR3[2] = 1 - Post Package Repair protection enabled");  end
	endcase
	casex (mode_reg[3])
            8'bxxxx_xx0x: begin if(DEBUG>5) $display("  MR3[1] = 0 - WR Post Amble = 0.5 tck"); end
     	    default:	  begin if(DEBUG>5) $display("  MR3[1] = 1 - WR Post Amble = 1.5 tck"); end
	endcase
	casex (mode_reg[3])
            8'bxxxx_xxx1: begin if(DEBUG>5) $display("  MR3[0] = 1 - Pull up call point = (VDDQ / 3)"); end
     	    default: 	  begin if(DEBUG>5) $display("	MR3[0] = 0 - Pull up call point = (VDDQ / 2.5)"); end
	endcase  
	      
	// MR4
	//##################################################################################
	casex (mode_reg[4]) // MR4 - Thermal Offset
    	    8'bx00x_xxxx: begin if(DEBUG>5) $display("	MR4 - Thermal Offset 0-5  ");	 end
	    8'bx01x_xxxx: begin if(DEBUG>5) $display("  MR4 - Thermal Offset 5-10" );    end
	    8'bx10x_xxxx: begin if(DEBUG>5) $display("  MR4 - Thermal Offset 10-15");    end
    	    default:	  begin if(DEBUG>5) $display("	MR4 - Thermal Offset Reserved, should not be here"  );  end					
	endcase
    
	casex (mode_reg[4]) // MR4 - Post Package Repair entry / exit  
     	    8'bxxx0_xxxx: begin if(DEBUG>5) $display("	MR4[4] = 0 - Exit post package repair - Part must be RESET now for normal operation");	PPR = 0; end
    	    8'bxxx1_xxxx: begin if(DEBUG>5) $display("	MR4[4] = 1 - Enter post package repair"); PPR = 1; end
	    default:	  begin if(DEBUG>5) $display("  MR4[4] Post Package Repair, should not be here");  end
	endcase 
	casex (mode_reg[4]) // MR4 - SR Abort 
     	    8'bxxxx_1xxx: begin if (part_config[5:2]> 4'b0010) 
	    			    if(DEBUG>5) $display("### illegal MR4[3] for channel density"); 
				    else if(DEBUG>5) $display("	MR4[3] = 1 - Enable SR Abort");		
			  end
    	    default:	  begin if(DEBUG>5) $display("	MR4[3] = 0 - Disable SR Abort"); end
	endcase  
        
	// MR10
	//##################################################################################   
	casex (mode_reg[10]) // MR10 - ZQ Reset: mode_reg[10][0]== X  
     	    8'bxxxx_xxx0: begin if(DEBUG>5) $display("	MR10[0] = 0 - ZQ normal opt");	end
    	    8'bxxxx_xxx1: begin 
			      if(DEBUG>5) $display("  MR10[0] = 1 - ZQCal Reset  ");	      
			      mode_reg[10][0]  = 1'b0;
			      mode_reg[3][5:3] = 3'b110;
			      if(DEBUG>5) $display("  ZQCal Reset - MR3[5:3] = PDDS = RZQ/6 ");
			      mode_reg[3][0]   = 1'b1;
			      if(DEBUG>5) $display("  ZQCal Reset - MR3[0] = 1 - Pull up call point = (VDDQ / 3)");
			  end
	endcase  
	    
	// MR11 
	//################################################################################## 
	casex (mode_reg[11]) // MR11 - CA ODT: mode_reg[11][6:4]== 3b'XXX
    	    8'bx000_xxxx: begin if(DEBUG>5) $display("	MR11[6:4] = Disabled ");        RTTval_ca = 0; end 
    	    8'bx001_xxxx: begin if(DEBUG>5) $display("	MR11[6:4] = CA ODT = RZQ/1 "); 	RTTval_ca = 1; end
    	    8'bx010_xxxx: begin if(DEBUG>5) $display("	MR11[6:4] = CA ODT = RZQ/2 "); 	RTTval_ca = 1; end
    	    8'bx011_xxxx: begin if(DEBUG>5) $display("	MR11[6:4] = CA ODT = RZQ/3 "); 	RTTval_ca = 1; end	   
    	    8'bx100_xxxx: begin if(DEBUG>5) $display("	MR11[6:4] = CA ODT = RZQ/4 "); 	RTTval_ca = 1; end	   
    	    8'bx101_xxxx: begin if(DEBUG>5) $display("	MR11[6:4] = CA ODT = RZQ/5 "); 	RTTval_ca = 1; end
   	    8'bx110_xxxx: begin if(DEBUG>5) $display("  MR11[6:4] = CA ODT = RZQ/6 ");  RTTval_ca = 1; end 		
            default:	  begin if(DEBUG>5) $display("  MR11[6:4] - reserved state, should not be here"); end
	endcase 
	casex (mode_reg[11]) // MR12 - DQ ODT: mode_reg[11][2:0]== 3b'XXX
    	    8'bxxxx_x000: begin if(DEBUG>5) $display("	MR11[2:0] = Disabled "); 	RTTval_dq = 0; end 
    	    8'bxxxx_x001: begin if(DEBUG>5) $display("	MR11[2:0] = DQ ODT = RZQ/1 "); 	RTTval_dq = 1; end
    	    8'bxxxx_x010: begin if(DEBUG>5) $display("	MR11[2:0] = DQ ODT = RZQ/2 "); 	RTTval_dq = 1; end
    	    8'bxxxx_x011: begin if(DEBUG>5) $display("	MR11[2:0] = DQ ODT = RZQ/3 "); 	RTTval_dq = 1; end	   
    	    8'bxxxx_x100: begin if(DEBUG>5) $display("	MR11[2:0] = DQ ODT = RZQ/4 "); 	RTTval_dq = 1; end	   
    	    8'bxxxx_x101: begin if(DEBUG>5) $display("	MR11[2:0] = DQ ODT = RZQ/5 "); 	RTTval_dq = 1; end
   	    8'bxxxx_x110: begin if(DEBUG>5) $display("  MR11[2:0] = DQ ODT = RZQ/6 ");  RTTval_dq = 1; end 		
            default:	  begin if(DEBUG>5) $display("  MR11[2:0] - reserved state, should not be here"); end
	endcase  
	
	// MR12 
	//##################################################################################
	casex (mode_reg[12])
     	    8'b1xxx_xxxx: begin if(DEBUG>5)  $display("	MR12[7] = 1 - CBT-mode [1]");	CA_training_mode = 1; end				
    	    default:	  begin if(DEBUG>5)  $display("	MR12[7] = 0 - CBT-mode [0]");  	CA_training_mode = 0; end
	endcase     
	
	// MR13:  switch/set multi mr simultaneously
	//##################################################################################  	
	casex (mode_reg[13])// ## MR13 - FSP-OP - mode_reg[13][7]== X
     	    8'b0xxx_xxxx: begin if(DEBUG>5)  $display("	MR13[7] = 0 - Frequency set point op-mode [0]"); FSP_OP = 0; end				
    	    default:	  begin if(DEBUG>5)  $display("	MR13[7] = 1 - Frequency set point op-mode [1]"); FSP_OP = 1; end
	endcase     
	casex (mode_reg[13]) // MR13 - FSP-WR: mode_reg[13][6]== X 
     	    8'bx0xx_xxxx: begin if(DEBUG>5)  $display("	MR13[6] = 0 - Frequency set point write [0]"); FSP_WR = 0; end
    	    default:	  begin if(DEBUG>5)  $display("	MR13[6] = 1 - Frequency set point write [1]"); FSP_WR = 1; end
	endcase  
	casex (mode_reg[13]) // MR13 - Data Mask Disable: mode_reg[13][5]== X 
     	    8'bxx1x_xxxx: begin if(DEBUG>5)  $display("	MR13[5] = 1 - Data Mask Operation Disable"); DM_DIS = 1; end			
    	    default:	  begin if(DEBUG>5)  $display("	MR13[5] = 0 - Data Mask Operation Enable "); DM_DIS = 0; end			
	endcase
	casex (mode_reg[13]) // MR13 - Refresh Rate Option: mode_reg[13][4]== X 
     	    8'bxxx0_xxxx: begin if(DEBUG>5)  $display("	MR13[4] = 0 - Disable codes 001 and 0101 in MR4[2:0]");	end
    	    default:	  begin if(DEBUG>5)  $display("	MR13[4] = 1 - Enable all codes in MR4[2:0]");   	end
	endcase
	casex (mode_reg[13]) // MR13 - Vref Current Option: mode_reg[13][3]== X 
     	    8'bxxxx_0xxx: begin if(DEBUG>5)  $display("	MR13[3] = 0 - Normal Vref Current ");	   end
    	    default:	  begin if(DEBUG>5)  $display("	MR13[3] = 1 - Fasdt Vref Current Option"); end
	endcase    
	casex (mode_reg[13]) // MR13 - VRO: mode_reg[13][2]== X 
     	    8'bxxxx_x0xx: begin if(DEBUG>5)   $display(" MR13[2] = 0 - VRO Normal Operation "); 			 end
    	    default:	  begin if(DEBUG>5)   $display(" MR13[2] = 1 - Output Vref(ca) and Vref(dq) values on DQ bits"); end
	endcase     
	casex (mode_reg[13]) // MR13 - RPT: mode_reg[13][1]== X
     	    8'bxxxx_xx0x: begin if(DEBUG>5)  $display("	MR13[1] = 0 - Read Preamble training Disabled "); RPT_Training = 0; end
    	    default:	  begin if(DEBUG>5)  $display("	MR13[1] = 1 - Read Preamble training Enabled ");  RPT_Training = 1; end
	endcase      
	casex (mode_reg[13]) // MR13 - CBT: mode_reg[13][0]== X 
     	    8'bxxxx_xxx1: begin if(DEBUG>5)  $display("	MR13[0] = 1 - Command Bus training Enabled "); CA_training=1;	CA_training_DQ <= #(tCAMRD) 1; 	end
			8'bxxxx_xxx0: begin if(DEBUG>5)  $display(" MR13[0] = 0 - Command Bus training Disabled "); CA_training=0;  CA_training_DQ <= #(tMRZ) 0; DqPad_Int_CA <= #(tMRZ) 16'hz; end
    	    default:	              begin if(DEBUG>5)  $display(" MR13[0] = 0 - Command Bus training Disabled "); CA_training=0;  end
	endcase     

	// MR22 
	//##################################################################################    
	casex (mode_reg[22]) // MR22 - ODT-CA Pad enable: mode_reg[22][5]== X 
     	    8'bxx0x_xxxx: begin if(DEBUG>5)  $display("	MR22[5] = 0 - ODT-CA tracks ODT-CA Bond Pad ");	if (ODT) ODT_Force_CA = RTTval_ca; end
    	    default:	  begin if(DEBUG>5)  $display("	MR22[5] = 1 - ODT-CA disabled "); end
	endcase
	casex (mode_reg[22]) // MR22 - ODT- CS: mode_reg[22][4]== X 
     	    8'bxxx0_xxxx: begin if(DEBUG>5)  $display("	MR22[4] = 0 - ODT-CS over ride disabled "); ODT_Force_CS = RTTval_ca; end
    	    default:	  begin if(DEBUG>5)  $display("	MR22[4] = 1 - ODT-CS enabled "); if (ODT) ODT_Force_CS = RTTval_ca; end		
	endcase
	casex (mode_reg[22]) // MR22 - ODT-CK: mode_reg[22][3]== X 
     	    8'bxxxx_0xxx: begin if(DEBUG>5)  $display("	MR22[3] = 0 - ODT-CK over ride disabled "); ODT_Force_CK = RTTval_ca; end
    	    default:	  begin if(DEBUG>5)  $display("	MR22[3] = 1 - ODT-CK enabled"); if (ODT) ODT_Force_CK = RTTval_ca; end
	endcase     
	casex (mode_reg[22]) // MR22 - SOC ODT: - MA == 22 && mode_reg[MA]== 8'bxxxx_xXXX 
    	    8'bxxxx_x000: begin  if(DEBUG>5) $display(" MR22[2:0] = CA ODT for VOH CAL Disabled "); end
    	    8'bxxxx_x001: begin  if(DEBUG>5) $display(" MR22[2:0] = CA ODT for VOH CAL= RZQ/1 "); end
    	    8'bxxxx_x010: begin  if(DEBUG>5) $display(" MR22[2:0] = CA ODT for VOH CAL= RZQ/2 "); end
    	    8'bxxxx_x011: begin  if(DEBUG>5) $display(" MR22[2:0] = CA ODT for VOH CAL= RZQ/3 "); end	    
    	    8'bxxxx_x100: begin  if(DEBUG>5) $display(" MR22[2:0] = CA ODT for VOH CAL= RZQ/4 "); end	    
    	    8'bxxxx_x101: begin  if(DEBUG>5) $display(" MR22[2:0] = CA ODT for VOH CAL= RZQ/5 "); end
   	    8'bxxxx_x110: begin  if(DEBUG>5) $display(" MR22[2:0] = CA ODT for VOH CAL= RZQ/6 "); end		    
	    default:	  begin  if(DEBUG>5) $display(" MR22[2:0] - reserved state, should not be here"); end
	endcase  
	    
	// MR24 
	//################################################################################## 
	casex (mode_reg[24]) // MR24 - TRR MODE enable: mode_reg[24][7]== X  
     	    8'b0xxx_xxxx: begin if(DEBUG>5) $display(" MR24[7] = 0 - TRR Mode Disabled "); TRR = 0; end
    	    8'b1xxx_xxxx: begin if(DEBUG>5) $display(" MR24[7] = 1 - TRR Mode Enabled ");  TRR = 1; end
    	    default:	  begin if(DEBUG>5) $display(" MR24[7] - should not be here"); end
	endcase 
	casex (mode_reg[24]) // MR24 - TRR Mode BAn: - MA == 24 && mode_reg[MA]== 8'bxXXX_xxxx
    	    8'bx000_xxxx: begin if(DEBUG>5) $display(" TRR Mode Bank 0"); end
    	    8'bx001_xxxx: begin if(DEBUG>5) $display(" TRR Mode Bank 1"); end
    	    8'bx010_xxxx: begin if(DEBUG>5) $display(" TRR Mode Bank 2"); end
    	    8'bx011_xxxx: begin if(DEBUG>5) $display(" TRR Mode Bank 3"); end	   
    	    8'bx100_xxxx: begin if(DEBUG>5) $display(" TRR Mode Bank 4"); end	   
    	    8'bx101_xxxx: begin if(DEBUG>5) $display(" TRR Mode Bank 5"); end
	    8'bx110_xxxx: begin if(DEBUG>5) $display(" TRR Mode Bank 6"); end		   
    	    default:	  begin if(DEBUG>5) $display(" TRR Mode Bank 7"); end
	endcase     
    end
endtask

task Reset_MR;
begin
    // Only need to reset the writeable mode registers
    if(DEBUG>6) $display("Reset!  All Mode Register values have been reset to their default states"); 
    if (X==1 ) 	mode_reg[0] =8'b0010_0000;  //  CATR & RZQI & REF MODE: mode_reg[0] =8'b0xx0_0xx0;
    else     	mode_reg[0] =8'b0010_0010;  //  CATR & RZQI & REF MODE: mode_reg[0] =8'b0xx0_0xx0;
    mode_reg[1] =8'b0000_0100;  //  nWR & RD-PRE & WR-PRE & Burst Length: mode_reg[1] =8'b0000_0100;
    mode_reg[2] =8'b0000_0000;  //  WR-LEV & WLS & WL & RL: mode_reg[2] =8'b0000_0000;
    mode_reg[3] =8'b0011_0001;  //  DBI-WR & DBI-RD & PDDS & PPRP & WR_PST & PU-CAL: mode_reg[3] =8'b0011_0001;
    mode_reg[4] =8'b0000_0011;  //  Thermal Offset & PPRE & SR Abort // mixed RD only / WR ONLY: mode_reg[4] =8'bx000_0xxx;
    mode_reg[5] =8'b0000_0101;  //  LPDDR4 Manufacturer ID									     
    mode_reg[9] =8'b0000_0000;  //  Vendor-specific Test Mode: mode_reg[9] =8'b0000_0000;
    mode_reg[10]=8'b0000_0000;  //  ZQ-RESET: mode_reg[10]=8'bxxxx_xxx0;
    mode_reg[11]=8'b0000_0000;  //  CA ODT & DQ ODT: mode_reg[11]=8'bx000_x000;
`ifdef _4x
    mode_reg[12]=8'b0101_1101;  //  CR-CA  & CREF(ca) // This reg is read / write ....: mode_reg[12]=8'bx100_1101;
`else
    mode_reg[12]=8'b0100_1101;  //  CR-CA  & CREF(ca) // This reg is read / write ....: mode_reg[12]=8'bx100_1101;
`endif
    mode_reg[13]=8'b0000_0000;  //  FSP-OP & DWP-WR & DMD & RFU & VRCG & VRO & RPT & CBT: mode_reg[13]=8'b000x_0000;     
`ifdef _4x
    mode_reg[14]=8'b0101_1101;  //  VREF(dq)		    // This reg is read / write ....: mode_reg[14]=8'bx100_1101;
`else
    mode_reg[14]=8'b0100_1101;  //  VREF(dq)		    // This reg is read / write ....: mode_reg[14]=8'bx100_1101;
`endif
    mode_reg[15]=8'b0101_0101;  //  lower byte invert register for DQ calibration: mode_reg[15]=8'b0101_0101;
    mode_reg[16]=8'b0000_0000;  //  PASR_Bank : mode_reg[16]=8'b0000_0000;
    mode_reg[17]=8'b0000_0000;  //  PASR_Seg : mode_reg[17]=8'b0000_0000;
    mode_reg[18]=8'b0000_0000;  //  DQS OSC LSB : mode_reg[18]=8'b0000_0000;
    mode_reg[19]=8'b0000_0000;  //  DQS OSC MSB : mode_reg[19]=8'b0000_0000;
    mode_reg[20]=8'b0101_0101;  //  upper byte invert register for dq calibration: mode_reg[20]=8'b0101_0101;
    mode_reg[22]=8'b0000_0000;  //  ODTD-CA & ODTE-CS & ODTE-CK & CODT: mode_reg[22]=8'bxx00_0000;
    mode_reg[23]=8'b0000_0000;  //  DQS interval timer run time setting: mode_reg[23]=8'b0000_0000;
    mode_reg[24]=8'b0000_1000;  //  TRR MODE & TRR MODE BAn // This reg is mixed RD only / WR ONLY: mode_reg[24]=8'b0000_xxxx;
    mode_reg[25]=8'b1111_1111;  //  PPR Resources - read only 
    mode_reg[32]=8'b0101_1010;  //  DQ calibration pattern "A": mode_reg[32]=8'b0101_1010;
    mode_reg[40]=8'b0011_1100;  //  DQ calibration pattern "B": mode_reg[40]=8'b0011_1100;
    
    // initialize FSP tables
    FSP_OP_REG[0]={mode_reg[1][7:0],mode_reg[2][6:0],mode_reg[3][7:3],mode_reg[3][1],mode_reg[11][6:4],mode_reg[11][2:0],mode_reg[12][6:0],mode_reg[14][6:0],mode_reg[22][5:0]};
    FSP_OP_REG[1]={mode_reg[1][7:0],mode_reg[2][6:0],mode_reg[3][7:3],mode_reg[3][1],mode_reg[11][6:4],mode_reg[11][2:0],mode_reg[12][6:0],mode_reg[14][6:0],mode_reg[22][5:0]};
				
    Act_Banks=0;
    RD_FIFO_POINT =0; // RD FIFO POINTER - should only use shift commands to move '1'
    WR_FIFO_POINT =0; // WR FIFO POINTER - should only use shift commands to move '1'
    MPC_DQS_OSC_CLK_COUNT=0;
    if (Initialize==0)  Initialize=5*`Check_Initialization;

// Temperature read out set at 85 degress    
    mode_reg[4][2:0] = 3'b011;
    mode_reg[4][7]=1'b0; // set TUF bit to zero after RESET
    MRR4_READ = 1'b0;

    apply_mr_settings;							
end
endtask

task set_mode_register_rw;	
    begin
	// Initialize all mode registers to "do not use" 
        for(i=0; i<=255; i=i+1) MR_RW_enable[i] = 'b0;
	
        // DNU/Res    00  (Do not use or reserved)
        // Read  only 01
        // Write only 10
        // Read/Write 11
        MR_RW_enable[0] =2'b01; 
        MR_RW_enable[1] =2'b10; 
        MR_RW_enable[2] =2'b10; 
        MR_RW_enable[3] =2'b10; 
        MR_RW_enable[4] =2'b11;
        MR_RW_enable[5] =2'b01; 
        MR_RW_enable[6] =2'b01; 
        MR_RW_enable[7] =2'b01; 
        MR_RW_enable[8] =2'b01;
        MR_RW_enable[9] =2'b10;
        MR_RW_enable[10]=2'b10; 
        MR_RW_enable[11]=2'b10; 
        MR_RW_enable[12]=2'b11; 
        MR_RW_enable[13]=2'b10; 
        MR_RW_enable[14]=2'b11; 
        MR_RW_enable[15]=2'b10; 
        MR_RW_enable[16]=2'b10;
        MR_RW_enable[17]=2'b10;
        MR_RW_enable[18]=2'b01;
        MR_RW_enable[19]=2'b01;
        MR_RW_enable[20]=2'b10;
        MR_RW_enable[22]=2'b10; 
        MR_RW_enable[23]=2'b10;
        MR_RW_enable[24]=2'b11;
        MR_RW_enable[25]=2'b01;
        MR_RW_enable[30]=2'b10;
        MR_RW_enable[32]=2'b10;
        MR_RW_enable[39]=2'b10;
        MR_RW_enable[40]=2'b10; 			  
    end
endtask

task Initialize_Timings;
    begin
	MPC_DQS_OSC_ON = 1'b0;
	Burst_Length[0]= 16;
	Burst_Length[1]= 32;
	DqsPad_Int_temp='bz;
	DqsPadF_Int_temp='bz;
	DqPad_Int_temp='bz;
	DqPad_Int_CA='bz;
	DmPad_Int_temp='bz;
	RTTval_dq=0;
	RTTval_ca=0;
	ODT_Force_DM=1'b0;
	ODT_Force_DQ=1'b0;
	ODT_Force_CA=1'b0;
	ODT_Force_CS=1'b0;
	ODT_Force_CK=1'b0;
	MPC_LAT=1'b0;
	MRW_LAT=1'b0;
	MRR_LAT=1'b0;
	RefPB_LAT=1'b0;
	RefAB_LAT=1'b0;
	DESL_LAT=1'b0;
	NOP_LAT=1'b0;
	ACT_LAT=1'b0;
	WR_LAT=1'b0;
	RD_LAT=1'b0;
	PRE_LAT=1'b0;
	SREF_LAT=1'b0;
	SRX_LAT=1'b0;
	CAS_LAT=1'b0;
	PD_LAT=1'b0;
	Write_Latency=1;
	Read_Latency=3;
	CA_training = 0;
	RPT_Training = 0; 
	SREF = 0; 
	CA_training_DQ = 0;
	Write_Leveling=0;
	DBI_WR = 0;
	DBI_RD = 0;
	DM_DIS = 0;
	MRR_en_rd=0;
	MRR_en=0;
	Block_Command  = 0;
	Block_Command_REF = 0;
	Din_en=0;
	Initialize=`Check_Initialization;
	t_RefAB=0;
	t_Ref=0;
	t_CKE=0;
	t_RESET=0;
	t_MRW=0;
	t_RD=0;
	t_WRend=0;
	t_ACT=0;
	t_PRE_ALL=0;
	t_SREF=0;
	t_PD=0;
	t_CCD      =       0;   // tCCD measure
	CLK0_neg   =       0;   // measured negative clock transition
	CLK0_pos   =       0;   // measured positive clock transition
	tODT_lockout =     0;   // Temp val for ODT lockout with AODT
	t_INIT3    =       0;   // Measured tInit3 value
	t_INIT4    =       0;   // Measured tInit4 value
	tdiVW = 25;	
	tDQSCK_adj = 0;
	for (i=0; i<`Bank_Bits; i=i+1) begin
	    t_RefPB[i]=0;
	    t_bankRD[i]=0;
	    t_bankWR[i]=0;
	    t_bankWRend[i]=0;			
	    t_bankACT[i]=0;
	    t_bankPRE[i]=0; 
        end 
    end
endtask

task erase_all;		
    begin
	CLK0 <=  0;
	//CLK0       <=  0;
	Initialize <=  `Check_Initialization;
	// Erase all data stored in the array
        `ifdef WRITE_TO_FILE
	    eraseAllData({(1<<`Bank_Bits){1'b1}});
        `else								

            // Make array the correct size
	    array.delete();
	    array = new[1000];
	    array_cnt =0;
        `endif
	Act_Banks            <=  0;
	BA	             <=  0;
	Burst_Cnt            <=  0;
	MRR_en_PIPE          <=  0;
	Dout_en_PIPE         <=  0;
	Dout_en_PIPE_BL16    <=  0;
	Dout_en_PIPE_BL32    <=  0;
	Dout_en              <=  0;
	Read_IP	    	     <=  0;
	Write_IP	     <=  0;
	write_open           <=  0;
	write_open_PIPE      <=  0;
	write_open_PIPE_BL16 <=  0;
	write_open_PIPE_BL32 <=  0;
	BURST_PIPE_RD	     <=  0;
	BURST_PIPE_WR	     <=  0;
	RD_FIFO_PIPE	     <=  0;  
	WR_FIFO_PIPE	     <=  0;
	ROW                  <=  0;
	ROW_lat              <=  0;
	tmp_Cadd             <=  0;
	COL                  <=  0;
	COL_lat              <=  0;
	Read_Bank_Pre        <=  0;
  	  CA_training        <=  0;
	RPT_Training	     <=  0;
	CA_training_DQ       <=  0;
	for (i=0; i<`Banks; i=i+1) begin
	    Radd[i]	   <=  'b0;
	    Write_Bank[i]  <=  'b0;
	    Read_Bank[i]   <=  'b0;
	end
	for (i=0; i<=Pipe_Size; i=i+1) begin
	    ROW_PIPE[i]     <=  'b0;
	    COL_PIPE[i]     <=  'b0;
	    WR_Bank_PIPE[i] <=  'b0;
	end
    end
endtask

endmodule
