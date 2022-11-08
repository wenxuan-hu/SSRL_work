/******************************************************************************
###############################################################################
#  PROPERTY OF NANYA TECHNOLOGY -- FOR UNRESTRICTED INTERNAL USE ONLY --      #
#  UNAUTHORIZED REPRODUCTION AND/OR DISTRINBUTION IS STRICTLY PROHIBITED.     #
#  THIS PRODUCT IS PROTECTED UNDER COPYRIGHT LAW AS AN UNPUBLISHED WORK.      #
#  CREATED 2018(C) BY NANYA TECHNOLOGY CORPORATION.   ALL RIGHTS RESERVED.    #
###############################################################################*
*    File Name: parm.v
*
*  Rev     Date     Author  Changes
*  ---  ----------  ------  -----------------------------
*  0.1  2016:08:01  MCHL	-Initial modifications for LPDDR4 
*  0.2  2017:04:01  MchL 	-Initial Internal Release
*  0.3  2018:01:15	MCHL	-Initial Customer Release version
*  0.4  2019:02:14  MchL    -Set DEBUG=0 for released version, set as needed for runs and debug
******************************************************************************
* Supports data rates up to 4266 
* Supports operational clocks from 100ns to 0.47ns 
* tCK / clock should be even # of pico seconds
* Model functionality tested to pico second scale
*/
// These must always be defined
`define Check_Initialization 0

// ==================================================================================
// The Goal / Purpose of the below is to provide the 'nanya_mobile_model_lpddr4.v' with
// all needed inputs. Various other parameters / `defines / etc... for patterns should
// be done inside of the 'nanya_mobile_model_lpddr4_top.v' 
// ==================================================================================



// ==================================================================================
parameter DEBUG=10;
// ==================================================================================
// mode registers - L4
parameter MODE_DEVICE_INFO	     = 6'h00;
parameter MODE_DEVICE_FEATURE1       = 6'h01;
parameter MODE_DEVICE_FEATURE2       = 6'h02;
parameter MODE_DEVICE_FEATURE3       = 6'h03;
parameter MODE_DEVICE_FEATURE4       = 6'h04;
parameter MODE_DEVICE_FEATURE5       = 6'h05;
parameter MODE_DEVICE_FEATURE8       = 6'h08;
parameter MODE_DEVICE_FEATURE10      = 6'h0a;
parameter MODE_DEVICE_FEATURE11      = 6'h0b;
parameter MODE_DEVICE_FEATURE12      = 6'h0c;	   
parameter MODE_DEVICE_FEATURE13      = 6'h0d;
parameter MODE_DEVICE_FEATURE14      = 6'h0e;
parameter MODE_DEVICE_FEATURE15      = 6'h0f;
parameter MODE_DEVICE_FEATURE18      = 6'h12;
parameter MODE_DEVICE_FEATURE19      = 6'h13;	   
parameter MODE_DEVICE_FEATURE20      = 6'h14;
parameter MODE_DEVICE_FEATURE22      = 6'h16;
parameter MODE_DEVICE_FEATURE23      = 6'h17;
parameter MODE_DEVICE_FEATURE24      = 6'h18;
parameter MODE_DEVICE_FEATURE25      = 6'h19;
parameter MODE_DEVICE_FEATURE30      = 6'h1e;
parameter MODE_DEVICE_FEATURE32      = 6'h20;
parameter MODE_DEVICE_FEATURE40      = 6'h28;
             
// default values for readable mr
parameter MODE_MR0_DEF  = 8'b0000_0000;
  
// default values for all writable mode registers - L4
parameter MODE_MR1_DEF  = 8'b0000_0100;
parameter MODE_MR2_DEF  = 8'b0000_0000;
parameter MODE_MR3_DEF  = 8'b0011_0001;
parameter MODE_MR4_DEF  = 8'b0000_0xxx;
parameter MODE_MR10_DEF = 8'b0000_0000;
parameter MODE_MR11_DEF = 8'b0000_0000;
parameter MODE_MR12_DEF = 8'b0100_1101;
parameter MODE_MR13_DEF = 8'b0000_0000;
parameter MODE_MR14_DEF = 8'b0100_1101;
parameter MODE_MR15_DEF = 8'b0101_0101;
parameter MODE_MR16_DEF = 8'b0000_0000;
parameter MODE_MR17_DEF = 8'b0000_0000;
parameter MODE_MR20_DEF = 8'b0101_0101;
parameter MODE_MR22_DEF = 8'b0000_0000;
parameter MODE_MR23_DEF = 8'b0000_0000;
parameter MODE_MR24_DEF = 8'b0000_xxxx;
parameter MODE_MR32_DEF = 8'b0101_1010;
parameter MODE_MR40_DEF = 8'b0011_1100;

// mode bits MR1     - L4
parameter MODE_BL16  = 8'h00; 
parameter MODE_BL32  = 8'h01;
parameter MODE_BLOTF = 8'h02;
parameter MR_RPR_0_RPS_0 = 8'b0000_0100;
parameter MR_RPR_0_RPS_1 = 8'b1000_0100;
parameter MR_RPR_1_RPS_0 = 8'b0000_1100;
parameter MR_RPR_1_RPS_1 = 8'b1000_1100;

// mode bits MR2 - L4
parameter MODE_WLSETB = 8'h40;      
parameter MODE_WRLEV = 8'h80;

// mode bits MR3 - L4
parameter MR3_RDBI_0_WDBI_0 = 8'b0011_0001;   
parameter MR3_RDBI_0_WDBI_1 = 8'b1011_0001;
parameter MR3_RDBI_1_WDBI_0 = 8'b0111_0001;
parameter MR3_RDBI_1_WDBI_1 = 8'b1111_0001;

// mode bits MR13 - L4
parameter MR13_FSP_OP0_CAT_ENTER = 8'b0000_0001;   
parameter MR13_FSP_OP0_CAT_EXIT  = 8'b0000_0000;
parameter MR13_FSP_OP1_CAT_ENTER = 8'b1000_0001;   
parameter MR13_FSP_OP1_CAT_EXIT  = 8'b1000_0000;
parameter MR13_DMDIS_ON 	 = 8'b0010_0000;
        	
parameter MODE_NWRE = 8'h10;

// mode bit MR10
parameter MODE_ZQINIT = 8'hff;
parameter MODE_ZQCL = 8'hab;
parameter MODE_ZQCS = 8'h56;
parameter MODE_ZQRESET = 8'hc3;


// LPDDR4_533 - 100ns > tck > 3.76 ns with RL = 6 and WL = 4 @ WLSET=0
`ifdef LPDDR4_533
	`define tCK     3760
    `define tWLO    10000 
    `define tADR    10000
    `define tMRZ    3000
    `define tCAMRD  25000			// tCK dependant - same as tMRD
    `define tXP     7500			// tCK dependant
    `define tCKE    7500			// tCK dependant	
    `define tCKESR  15000
	`define	tDQSCK	3320 
	`define tDQS2DQ 620
	`define	tDQSSp  100
	`define	tAD2DQ7	7260
	`define	tADSPW	6320
	`define	tDQ7SH	32180
	`define	tODTon  2535
	`define	tODToff 2535
	`define ClockDutyCycle_p 50
`endif
// LPDDR4_1066 - 3.76ns > tck > 1.878 ns with RL = 10 and WL = 6 @ WLSET=0
`ifdef LPDDR4_1066
 	`define tCK     1878
    `define tWLO    10000 
    `define tADR    10000
    `define tMRZ    3000
    `define tCAMRD  25000
    `define tXP     7500
    `define tCKE    7500	
    `define tCKESR  15000
	`define	tDQSCK	3320 
	`define tDQS2DQ 620
	`define	tDQSSp  100
	`define	tAD2DQ7	7260
	`define	tADSPW	6320
	`define	tDQ7SH	32180
	`define	tODTon  2535
	`define	tODToff 2535
	`define ClockDutyCycle_p 50
`endif
`ifdef LPDDR4_1600
 	`define tCK     1250
    `define tWLO    10000 
    `define tADR    10000
    `define tMRZ    3000
    `define tCAMRD  25000
    `define tXP     7500
    `define tCKE    7500	
    `define tCKESR  15000
	`define	tDQSCK	3320 
	`define tDQS2DQ 620
	`define	tDQSSp  100
	`define	tAD2DQ7	7260
	`define	tADSPW	6320
	`define	tDQ7SH	32180
	`define	tODTon  2535
	`define	tODToff 2535
	`define ClockDutyCycle_p 50
`endif
`ifdef LPDDR4_2132
 	`define tCK     940
    `define tWLO    10000 
    `define tADR    10000
    `define tMRZ    3000
    `define tCAMRD  25000
    `define tXP     7500
    `define tCKE    7500	
    `define tCKESR  15000
	`define	tDQSCK	3320 
	`define tDQS2DQ 620
	`define	tDQSSp  100
	`define	tAD2DQ7	7260
	`define	tADSPW	6320
	`define	tDQ7SH	32180
	`define	tODTon  2535
	`define	tODToff 2535
	`define ClockDutyCycle_p 50
`endif
`ifdef LPDDR4_2666
 	`define tCK     750
    `define tWLO    10000 
    `define tADR    10000
    `define tMRZ    3000
    `define tCAMRD  25000
    `define tXP     7500
    `define tCKE    7500	
    `define tCKESR  15000
	`define	tDQSCK	3320 
	`define tDQS2DQ 620
	`define	tDQSSp  100
	`define	tAD2DQ7	7260
	`define	tADSPW	6320
	`define	tDQ7SH	32180
	`define	tODTon  2535
	`define	tODToff 2535
	`define ClockDutyCycle_p 50
`endif
`ifdef LPDDR4_3200
 	`define tCK     626
    `define tWLO    10000 
    `define tADR    10000
    `define tMRZ    3000
    `define tCAMRD  25000
    `define tXP     7500
    `define tCKE    7500	
    `define tCKESR  15000
	`define	tDQSCK	3320 
	`define tDQS2DQ 620
	`define	tDQSSp  100
	`define	tAD2DQ7	7260
	`define	tADSPW	6320
	`define	tDQ7SH	32180
	`define	tODTon  2535
	`define	tODToff 2535
	`define ClockDutyCycle_p 50
`endif
`ifdef LPDDR4_3732
 	`define tCK     536
    `define tWLO    10000 
    `define tADR    10000
    `define tMRZ    3000
    `define tCAMRD  25000
    `define tXP     7500
    `define tCKE    7500	
    `define tCKESR  15000
	`define	tDQSCK	3320 
	`define tDQS2DQ 620
	`define	tDQSSp  100
	`define	tAD2DQ7	7260
	`define	tADSPW	6320
	`define	tDQ7SH	32180
	`define	tODTon  2535
	`define	tODToff 2535
	`define ClockDutyCycle_p 50
`endif
`ifdef LPDDR4_4266
 	`define tCK     476
    `define tWLO    10000 
    `define tADR    10000
    `define tMRZ    3000
    `define tCAMRD  25000
    `define tXP     7500
    `define tCKE    7500	
    `define tCKESR  15000
	`define	tDQSCK	3320 
	`define tDQS2DQ 620
	`define	tDQSSp  100
	`define	tAD2DQ7	7260
	`define	tADSPW	6320
	`define	tDQ7SH	32180
	`define	tODTon  2535
	`define	tODToff 2535
	`define ClockDutyCycle_p 50
`endif
// The below does not change between X16 , X8u or X8l
	`define Max_Data_Width		16
	`define	Max_Data_Mask		2
	`define Max_DQS_Bits		2
	`define Data_Width   		16    // Data bus
	`define Data_Mask    		2    // DM bus   
	`define DQS_Bits			2    // DQS bus	

//  Desnity Specific parms - Density = per Channel
`ifdef Den_2Gb
    `define tRFCab         130000	// Refresh Cycle time, ps
    `define tRFCpb          60000     	// Refresh Cycle time, ps
    `define Row_Bits	       15    	// Row address bus (RA13:0)
`endif
`ifdef Den_4Gb
    `define tRFCab         180000     	// Refresh Cycle time, ps
    `define tRFCpb          90000     	// Refresh Cycle time, ps
    `define Row_Bits	       16     	// Row address bus (RA14:0)
`endif
`ifdef Den_6Gb
    `define tRFCab         280000     	// Refresh Cycle time, ps
    `define tRFCpb         140000     	// Refresh Cycle time, ps
    `define Row_Bits	       17     	// Row address bus (RA14:0)
`endif
`ifdef Den_8Gb
    `define tRFCab         280000     	// Refresh Cycle time, ps
    `define tRFCpb         140000     	// Refresh Cycle time, ps
    `define Row_Bits	       17     	// Row address bus (RA14:0)
`endif

`define CA_Bits				6		// Number of bits in the Command/Address bus
`define Col_Bits			10		// Column address bus (CA9:0)
`define Banks				8		// Bank Size
`define Bank_Bits			3		// Bank address bus (BA2:0)
`define Mem_Bits (`Col_Bits+`Row_Bits) 
`define Mem_Size (1<<`Mem_Bits)
