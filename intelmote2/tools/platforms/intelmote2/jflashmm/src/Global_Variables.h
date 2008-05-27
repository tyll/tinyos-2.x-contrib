/******************************************************************************
**
**  COPYRIGHT (C) 2000, 2001, 2002 Intel Corporation.
**
**  The information in this file is furnished for informational use 
**  only, is subject to change without notice, and should not be construed as 
**  a commitment by Intel Corporation. Intel Corporation assumes no 
**  responsibility or liability for any errors or inaccuracies that may appear 
**  in this document or any software that may be provided in association with 
**  this document. 
**
**  FILENAME:       Global_Variables.h
**
**  PURPOSE:        declares all global varibales used by the Jflash software
**
**  LAST MODIFIED:  $Modtime: 2/27/03 11:26a $
******************************************************************************/


/*
*******************************************************************************
Globals
*******************************************************************************
*/

int lpt_address;									// Global variable assigned to parallel port address
int lpt_ECR;										// global for LPT extended control register
int lpt_CTL;										// global for the LPT control port
int lpt_STAT;										// global for LPT status register
DWORD MILLISECOND_COUNT = 0;						// global to keep an approx loop count for a ms
int block_number = 0;								// Global variable for determining the block number
char filename[MAX_IN_LENGTH] = "download.bin";		// Global variable for storing the file name
char data_filename[MAX_IN_LENGTH] = "DBPXA250";     // Global variable for the platform data file
char flash_data_filename[MAX_IN_LENGTH] = "Flash_18_2_32.dat";     // Global variable for the flash data file
char AppHome[_MAX_PATH];							// Global variable with application home
char PathInformation[4][_MAX_PATH];					// Global variable with the path information

char VERSION_LOCK[11] =       "VL00000001";
char FLASH_VERSION_LOCK[11] = "VLF0000001";

CABLE_TYPES CableType = Insight_Jtag;				// Global variable for specifying the Cable type
DWORD ChipSelect0		= 0;						// Global variable for chip select 0
DWORD ChipSelect1		= 0;						// Global variable for chip select 1
DWORD ChipSelect2		= 0;						// Global variable for chip select 2
DWORD ChipSelect3		= 0;						// Global variable for chip select 3
DWORD ChipSelect4		= 0;						// Global variable for chip select 4
DWORD ChipSelect5		= 0;						// Global variable for chip select 5

DWORD OutputEnable		= 0;    // Global variable for output enable
DWORD WriteEnable		= 0;    // Global variable for write enable
DWORD MdUpperControl	= 0;    // Global variable for MD upper control
DWORD MdLowerControl	= 0;    // Global variable for MD lower control
DWORD ReadWriteMode		= 0;    // Global variable for Read Write access mode

DWORD IR_Idcode		= 0;	    // Global variable for the IDCODE instruction of the IR
DWORD IR_Bypass		= 0;	    // Global variable for the BYPASS instruction of the IR
DWORD IR_Extest		= 0;	    // Global variable for the EXTEST instruction of the IR
DWORD ChainLength	= 0;		// Global variable for the chain length of the selected platform
DWORD UnlockFlashCtrl1 = 0;		// unlock flash control pin 1
DWORD UnlockFlashCtrl1Lev = 0;	// unlock flash control pin 1 level for unlock
DWORD LockFlashCtrl1Lev = 0;	// lock1 flash level
DWORD UnlockFlashCtrl2 = 0;		// unlock flash control pin 2
DWORD UnlockFlashCtrl2Lev = 0;	// unlock flash control pin 2 level for unlock
DWORD LockFlashCtrl2Lev = 0;	// lock2 flash level
DWORD UnlockFlashCtrl3 = 0;		// unlock flash control pin 3
DWORD UnlockFlashCtrl3Lev = 0;	// unlock flash control pin 3 level for unlock
DWORD LockFlashCtrl3Lev = 0;	// lock3 flash level
DWORD UnlockFlashCtrl4 = 0;		// unlock flash control pin 4
DWORD UnlockFlashCtrl4Lev = 0;	// unlock flash control pin 4 level for unlock
DWORD LockFlashCtrl4Lev = 0;	// lock4 flash level

DWORD CSR_LADDR[6];				// array of chip select region low addresses 
DWORD CSR_HADDR[6];				// array of chip select regions high addresses

DWORD CSR1 = 6;	// the chip select for region 1. 6 is illegal and is here to flag an error if not defined.
DWORD CSR2 = 6;	// the chip select for region 2
DWORD CSR3 = 6;	// the chip select for region 3
DWORD CSR4 = 6;	// the chip select for region 4
DWORD CSR5 = 6;	// the chip select for region 5
DWORD CSR6 = 6;	// the chip select for region 6

// some flash related globals

DWORD BlockEraseTime = 10;
DWORD FlashBufferSize = 32;
DWORD FlashDeviceSize = 0;
bool  REGION_STATUS[10];		// array of region status
DWORD REGION_NUM_BLOCKS[10];	// number of blocks in the  region
DWORD REGION_BLOCKSIZE[10];		// The size of the blocks in that  region
DWORD REGION_START_ADDR[10];	// The start address of the region
DWORD REGION_END_ADDR[10];		// the end address of the region
DWORD BLOCK_ADDRESS[512];		// up to 512 unique block addresses
int ADDR_MULT = 4;				// addressing multiplier or divider for flash

int WorkBufSize	= 0;		    // Global variable for setting the work buffer size
int IrLength   	= 0;			// Global variable for setting the correct IR length

// Chain device data
bool  DEVICESTATUS[5];	  // enabled or disabled
DWORD DEVICEIRLENGTH[5];  // length of IR to set bypass
bool  DEVICETYPE[5];	  // true if controller
bool  DEVICEISLAST[5];
int DEVICE_CONTROLLER = 0; // which device is the controller 
int DEVICES_BEFORE = 0;
int DEVICES_AFTER = 0;
int DEVICES_IN_CHAIN = 0;

#define MAX_HANDLER_SIZE 0x200

bool PlatformIs16bit = false;						// Global variable for diferentiating between 16bit and 32bit platforms
bool PlatformIsBulverdeOrDimebox = true;			// Global variable to determine if the selected platform is bulverde or dimebox
bool PlatformIsBulverdeDimeboxShortChain = false;	// Global variable for determining whether it's a short chain or not
bool PlatformIsBulverdeDimeboxLongChain = true;		// Global variable for determining whether it's a long chain or not
bool Debug_Mode = false;
bool UsageShown = false;
bool AskQuestions = true;

unsigned long gpdr[4] = {0x40e0000c,0x40e00010,0x40e00014,0x40e0010c};
unsigned long gpsr[4] = {0x40e00018,0x40e0001c,0x40e00020,0x40e00118};
unsigned long gpcr[4] = {0x40e00024,0x40e00028,0x40e0002c,0x40e00124};


// Globals for flash commands and query codes. Assumes 32 bit as default

DWORD F_READ_ARRAY = 		0x00FF00FFL;
DWORD F_READ_IDCODES =   	0x00900090L;
DWORD F_READ_QUERY =     	0x00980098L;
DWORD F_READ_STATUS =    	0x00700070L;
DWORD F_CLEAR_STATUS =   	0x00500050L;
DWORD F_WRITE_BUFFER =   	0x00E800E8L;
DWORD F_WORDBYTE_PROG =  	0x00400040L;

DWORD F_BLOCK_ERASE =    	0x00200020L;
DWORD F_BLOCK_ERASE_2ND =	0x00D000D0L; 

DWORD F_BLK_ERASE_PS =       0x00B000B0L;
DWORD F_BLK_ERASE_PR =       0x00D000D0L;
DWORD F_CONFIGURATION =      0x00B800B8L;

DWORD F_SET_READ_CFG_REG =   0x00600060L;
DWORD F_SET_READ_CFG_REG_2ND = 0x00030003L;

DWORD F_SET_BLOCK_LOCK =      0x00600060L;
DWORD F_SET_BLOCK_LOCK_2ND =  0x00010001L;

DWORD F_CLEAR_BLOCK_LOCK =    0x00600060L;
DWORD F_CLEAR_BLOCK_LOCK_2ND =0x00D000D0L;

DWORD F_PROTECTION =          0x00C000C0L;

DWORD F_ATTR_Q =              0x00510051L;
DWORD F_ATTR_R =              0x00520052L;
DWORD F_ATTR_Y =              0x00590059L;

DWORD F_BLOCK_LOCKED =        0x00010001L;
DWORD F_STATUS_READY =        0x00800080L;


FILE *in_file;
FILE *data_file_pointer;
FILE *flash_file_pointer;
int out_dat[MAX_DR_SIZE];
bool UNLOCKBLOCK = false;
bool HASLOCKCONTROLS = false;	// Is there external locking for the flash?
unsigned long MAX_DATA = 230;
unsigned long MAX_FLASH_DATA = 60;

char WORDARRAY[230][132];  // the capture of all strings from the data file
char FLASHWORDARRAY[60][132];  // the capture of all strings from the data file
DWORD addr_order[27];
DWORD input_dat_order[33];
DWORD dat_order[33];
DWORD pin[1000]; // max JTAG boundary length of 1000 bits

// The following hardcoded values need to be moved to the data files. 
// hardcode here for now

// bulverde only:
DWORD IR_DCSR		= 0x9;
DWORD IR_DBGrx		= 0x2;
DWORD IR_DBGtx		= 0x10;
DWORD IR_LDIC		= 0x7;

// Position of data in the platform data file

#define p_processor 	0
#define p_devsys		1
#define p_dataver		2
#define p_verlock		3
#define p_blength		4
#define p_irlength		5
#define p_extest		6
#define p_idcode		7
#define p_bypass		8
#define p_cs0			9
#define p_cs1			10
#define p_cs2			11
#define p_cs3			12
#define p_cs4			13
#define p_cs5			14
#define p_nOE_OUT		15
#define p_nWE_OUT	   	16
#define p_mdupper_ctrl	17
#define p_mdlower_ctrl	18
#define p_RD_nWR_OUT	19
#define	p_cp1			20
#define	p_a0			21
#define	p_a1			22
#define	p_a2			23
#define	p_a3			24
#define	p_a4			25
#define	p_a5			26
#define	p_a6			27
#define	p_a7			28
#define	p_a8			29
#define	p_a9			30
#define	p_a10			31
#define	p_a11			32
#define	p_a12			33
#define	p_a13			34
#define	p_a14			35
#define	p_a15			36
#define	p_a16			37
#define	p_a17			38
#define	p_a18			39
#define	p_a19			40
#define	p_a20			41
#define	p_a21			42
#define	p_a22			43
#define	p_a23			44
#define	p_a24			45
#define	p_a25			46
#define	p_d0in			47
#define	p_d1in			48
#define	p_d2in			49
#define	p_d3in			50
#define	p_d4in			51
#define	p_d5in			52
#define	p_d6in			53
#define	p_d7in			54
#define	p_d8in			55
#define	p_d9in			56
#define	p_d10in			57
#define	p_d11in			58
#define	p_d12in			59
#define	p_d13in			60
#define	p_d14in			61
#define	p_d15in			62
#define	p_d16in			63
#define	p_d17in			64
#define	p_d18in			65
#define	p_d19in			66
#define	p_d20in			67
#define	p_d21in			68
#define	p_d22in			69
#define	p_d23in			70
#define	p_d24in			71
#define	p_d25in			72
#define	p_d26in			73
#define	p_d27in			74
#define	p_d28in			75
#define	p_d29in			76
#define	p_d30in			77
#define	p_d31in			78
#define	p_d0out			79
#define	p_d1out			80
#define	p_d2out			81
#define	p_d3out			82
#define	p_d4out			83
#define	p_d5out			84
#define	p_d6out			85
#define	p_d7out			86
#define	p_d8out			87
#define	p_d9out			88
#define	p_d10out		89
#define	p_d11out		90
#define	p_d12out		91
#define	p_d13out		92
#define	p_d14out		93
#define	p_d15out		94
#define	p_d16out	   	95
#define	p_d17out		96
#define	p_d18out		97
#define	p_d19out		98
#define	p_d20out		99
#define	p_d21out		100
#define	p_d22out		101
#define	p_d23out		102
#define	p_d24out		103
#define	p_d25out		104
#define	p_d26out		105
#define	p_d27out		106
#define	p_d28out		107
#define	p_d29out		108
#define	p_d30out		109
#define	p_d31out		110
#define p_cp2			111
#define	p_datawidth		112
#define	p_m_reg1_low	113
#define	p_m_reg1_high	114
#define	p_m_reg1_cs		115
#define	p_m_reg2_low	116
#define	p_m_reg2_high	117
#define	p_m_reg2_cs		118
#define	p_m_reg3_low	119
#define	p_m_reg3_high	120
#define	p_m_reg3_cs		121
#define	p_m_reg4_low	122
#define	p_m_reg4_high	123
#define	p_m_reg4_cs		124
#define	p_m_reg5_low	125
#define	p_m_reg5_high	126
#define	p_m_reg5_cs		127
#define	p_m_reg6_low	128
#define	p_m_reg6_high	129
#define	p_m_reg6_cs		130
#define	p_proc_id		131
#define	p_proc_mfg		132
#define	p_proc_std		133
#define	p_CID0			134
#define	p_CID1			135
#define	p_CID2			136
#define	p_CID3			137
#define	p_CID4			138
#define	p_CID5			139 
#define	p_CID6			140
#define	p_CID7			141
#define	p_CID8			142
#define	p_CID9			143
#define	p_CID10			144
#define	p_CID11			145
#define	p_CID12			146
#define	p_CID13			147
#define	p_CID14			148
#define	p_CID15			149
#define	p_nh1			150
#define	p_nh2			151
#define	p_nh3			152
#define	p_nh4			153
#define	p_nh5			154
#define	p_nh6			155
#define	p_nh7			156
#define	p_nh8			157
#define	p_nh9			158
#define	p_nh10			159
#define	p_nh11			160
#define	p_nh12			161
#define	p_nh13			162
#define	p_nh14			163
#define	p_nh15			164
#define	p_nh16			165
#define	p_nh17			166
#define	p_nh18			167
#define	p_nh19			168
#define	p_nh20			169
#define	p_nh21			170
#define	p_nh22			171
#define	p_nh23			172
#define	p_nh24			173
#define	p_nh25			174
#define	p_nh26			175
#define	p_nh27			176
#define	p_nh28			177
#define	p_nh29			178
#define	p_nh30			179
#define	p_nh31			180
#define	p_nh32			181
#define	p_nh33			182
#define	p_nh34			183
#define	p_nh35			184
#define	p_nh36			185
#define	p_nh37			186
#define	p_nh38			187
#define	p_nh39			188
#define	p_nh40			189
#define	p_nh41			190
#define	p_nh42			191
#define	p_nh43			192
#define	p_nh44			193
#define	p_nh45			194
#define	p_nh46			195
#define	p_nh47			196
#define	p_dev1_stat		197
#define	p_dev1_bits		198
#define	p_dev1_type		199
#define	p_dev1_islast	200
#define	p_dev2_stat		201
#define	p_dev2_bits		202
#define	p_dev2_type		203
#define	p_dev2_islast	204
#define	p_dev3_stat		205
#define	p_dev3_bits		206
#define	p_dev3_type		207
#define	p_dev3_islast	208
#define	p_dev4_stat		209
#define	p_dev4_bits		210
#define	p_dev4_type		211
#define	p_dev4_islast	212
#define	p_dev5_stat		213
#define	p_dev5_bits		214
#define	p_dev5_type		215
#define	p_dev5_islast	216
#define	p_unlctl1		217
#define	p_unlctl1_lev	218
#define	p_unlctl2		219
#define	p_unlctl2_lev	220
#define	p_unlctl3		221
#define	p_unlctl3_lev	222
#define	p_unlctl4		223
#define	p_unlctl4_lev	224
#define	p_cp3			225
#define p_fdevsacross	226
#define p_nsdcas		227
#define P_progmode		228

// position of data in the flash data file

#define pf_type			0
#define pf_dataver		1
#define pf_verlock		2
#define pf_ertime		3
#define pf_bufsize		4
#define pf_reg0status 	5
#define pf_reg0number	6
#define pf_reg0blsize	7
#define pf_reg0start	8
#define pf_reg0end		9
#define pf_reg1status 	10
#define pf_reg1number	11
#define pf_reg1blsize	12
#define pf_reg1start	13
#define pf_reg1end		14
#define pf_reg2status 	15
#define pf_reg2number	16
#define pf_reg2blsize	17
#define pf_reg2start	18
#define pf_reg2end		19
#define pf_reg3status 	20
#define pf_reg3number	21
#define pf_reg3blsize	22
#define pf_reg3start	23
#define pf_reg3end		24
#define pf_reg4status 	25
#define pf_reg4number	26
#define pf_reg4blsize	27
#define pf_reg4start	28
#define pf_reg4end		29
#define pf_reg5status 	30
#define pf_reg5number	31
#define pf_reg5blsize	32
#define pf_reg5start	33
#define pf_reg5end		34
#define pf_reg6status 	35
#define pf_reg6number	36
#define pf_reg6blsize	37
#define pf_reg6start	38
#define pf_reg6end		39
#define pf_reg7status 	40
#define pf_reg7number	41
#define pf_reg7blsize	42
#define pf_reg7start	43
#define pf_reg7end		44
#define pf_reg8status 	45
#define pf_reg8number	46
#define pf_reg8blsize	47
#define pf_reg8start	48
#define pf_reg8end		49
#define pf_reg9status 	50
#define pf_reg9number	51
#define pf_reg9blsize	52
#define pf_reg9start	53
#define pf_reg9end		54
#define pf_cp1			55


