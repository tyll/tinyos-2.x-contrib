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
**  FILENAME:       Jflash.cpp
**
**  PURPOSE:        A utility to program Intel flash devices from a PC parallel port.
**
**  LAST MODIFIED:  $Modtime: 2/27/03 11:31a $
******************************************************************************/
/*****************************************************************************
Note: Within these files there are porting instructions that are useful for 
adding additional platform support to this tool. These guides may be located by
searching for the string "PORTING_GUIDE".
*******************************************************************************/



#include <stdio.h>
#include <windows.h>
#include <time.h>
#include <conio.h>
#include "compile_switches.h"
#include "jflash.h"
#include "jtag.h"
#include "string.h"
#include "Global_Variables.h"

extern unsigned long dbg_handler[MAX_HANDLER_SIZE];
unsigned long debug_buf[1024];
extern unsigned int dh_size;
unsigned long dh_pos;
unsigned long r14;
unsigned long ispbuf[128];
int dstbit;
int dstidx;
int rdstat;
struct {
	DWORD addr;
	DWORD romdat;
	DWORD filedat;
} verify_error;

/*
*******************************************************************************
Forward declarations
*******************************************************************************
*/

int putp(int,int, int); // writes the JTAG data on the parallel port
void id_command(void);	// issues the JTAG command to read the device ID for all 3 chips
//void bypass_all(void);	// issues the JTAG command to put all 3 device in bypass mode
//void extest(void);		// issues the JTAG command EXTEST to the Processor

DWORD access_rom(int, DWORD, DWORD, int);	// Passes read/write/setup data for the Flash memory
DWORD access_bus(int, DWORD, DWORD, int);	// Read/write access to the Processor pins
void Write_Rom(DWORD address, DWORD data);	// Writes to ROM
DWORD Read_Rom(DWORD address);				// Reads from ROM

int test_port(void);	// Looks for and finds a valid parallel port address
int check_id(char*);	// Compares the device IDs for the 3 JTAG chips to expected values
void error_out(char*);	// Prints error and exits program
//void erase_flash(DWORD, DWORD, DWORD, DWORD, int);
void program_flash(DWORD, DWORD, DWORD);
void verify_flash(DWORD, DWORD);
void test_logic_reset(void);
//void test_lock_flash(DWORD, DWORD, DWORD, DWORD, int);
void set_lock_flash(DWORD, DWORD, DWORD, DWORD, int);
void set_address (DWORD);
int PZ_scan_code(int, int, int);
int controller_scan_code(int, int, int);
void pre_DRSCAN(void);
void post_DRSCAN(void);
void pre_IRSCAN(void);
void post_IRSCAN(void);
void mem_rw_mode(int);
void mem_data_driver(int);
void mem_write_enable(int);
void mem_output_enable(int);
void clear_chip_selects(void);
void set_chip_select(DWORD);
DWORD shift_data(int);
void set_data(DWORD);
void jtag_test(void);
void dump_chain(void);
void init_workbuf(void);
void invert_workbuf(void);
void set_pin_chip_select(DWORD);
void gpio_unlock_flash(void);
void gpio_lock_flash(void);
void ParseAndLoad(void);
void ParseAndLoadFlashData(void);
DWORD convert_to_dword(char*);
void AnalyzeChain (void);
void InitPinArray (void);
void InitLockUnlock(void);
void InitAddressOrder(void);
void InitInputDataOrder(void);
void InitOutputDataOrder(void);
void InitChipSelectRegions(void);
void InitFlashGlobals(void);
void UnlockAndEraseBlock(DWORD);
DWORD GetChipSelect(DWORD);
void EraseBlocks(DWORD, DWORD);
void check_file_info(DWORD *fsize , DWORD *last_non_zero, DWORD *last_non_ff, DWORD rom_size);
void check_rom_info(DWORD *max_erase_time, DWORD * dsize, DWORD * max_write_buffer );
int other_bypass(int rp, int ct, int length);
void IR_Command(int command);
void usage(void);
void Set_Platform_Global_Variables(void);
void DeclareDefaults(int);
void xilinx_mode(int reset);
void itp_mode(void);
void get_time_scale(void);
void ms_delay(DWORD milliseconds);
int xscale_tx_rd(unsigned long *dst);
void xscale_load_line(unsigned long addr, unsigned long *l);
void jtag_dr_wr(unsigned long *dst, unsigned long *src, int bitcount);
void jtag_rti(void); 
unsigned long scan(int bits, unsigned long tms, unsigned long tdi);
int calc_parity(unsigned int v); 
int xscale_init_handler(void);
unsigned long xscale_dcsr(unsigned long v, int xbreak, int hold_rst); 
int xscale_rx_wr(unsigned long d);
int xscale_rx_wr_nir(unsigned long d);
bool xscale_program_flash(FILE *in_file, DWORD start_addr, DWORD rom_size, int bus_width);
bool SetGPIOState(int nGPIO, int nState);
int xscale_mem_wr(unsigned long addr, unsigned long data);
int xscale_mem_rd(unsigned long addr, unsigned long *dst);
void IssueProcInst( int command );

errno_t Set_Application_Path_Variable();
void Split_File_Paths(char*, char[][_MAX_PATH]);
/*
*******************************************************************************
*
* FUNCTION:         main
*
* DESCRIPTION:      Entry point for utility
*
* INPUT PARAMETERS: uses optional input parameters:
*						argv[1] = Platform to which the binary file will be downloaded
*                       argv[2] = filename to flash (binary files only)
*                       argv[3] = program options, currently only 'P' for Program
*                       argv[4] = Byte Address     
*						argv[5] = INS or PAR or WIG (Insight or parallel cable or Wiggler)
						argv[6] = Debug mode on or off
* RETURNS:          void
*
*******************************************************************************
*/

void main( int argc, char *argv[] )
{
    time_t start;
	DWORD fsize = 0;
	DWORD last_non_zero = 0;
	DWORD last_non_ff = 0;
	DWORD base_address;
    DWORD max_erase_time, dsize, max_write_buffer;
	char base_address_string[12];
	DWORD hexaddress; 
	char plat_name[MAX_IN_LENGTH];
	int i = 0;
//	DWORD block_size;

	strcpy(base_address_string, "");
	
	Set_Application_Path_Variable(); //grabs the application path
	Split_File_Paths(AppHome,PathInformation);

	if(argc >= 2)
	{
		//Copy the first argument into a character array
		strcpy(plat_name, argv[1]);
		// Convert the name of the platform to uppercase
		for(unsigned int i = 0; i < strlen(plat_name); i++)
			plat_name[i] = toupper(plat_name[i]);
		
		// use the parameter to construct a filename to parse
		sprintf(data_filename, "%s.dat", plat_name);
	}
	else
	{
		if(!UsageShown) usage();
		printf("\nEnter platform data file name: ");
		gets(plat_name);
		// Convert the name of the platform to uppercase
		for(unsigned int i = 0; i < strlen(plat_name); i++)
			plat_name[i] = toupper(plat_name[i]);
		// use the parameter to construct a filename to parse
		sprintf(data_filename, "%s.dat", plat_name);
	}
	if(data_filename){		
		Split_File_Paths(data_filename,PathInformation);

		 if(*PathInformation[0] == 0){
			char data_filename_tmp[_MAX_PATH];
			Split_File_Paths(AppHome,PathInformation);

			 sprintf(data_filename_tmp, "%s%s%s",PathInformation[0],PathInformation[1],data_filename);
			 strcpy(data_filename,data_filename_tmp);
		 }
		 printf("%s",data_filename);
	}

	char DebugMode[4] = "NOD";			// Either NODebug or DEBug

	if(argc >= 7)
	{
		// Copy the sixth argument into a character array
		strcpy(DebugMode, argv[6]);
		// Convert the parameter to uppercase
		for(int i = 0; i < 4; i++)
			DebugMode[i] = toupper(DebugMode[i]);

		// Compare the mode with list of modes
		if(!strcmp("DEB", DebugMode))
		{
			Debug_Mode = true;
		}
		else if(!strcmp("NOD", DebugMode))
		{
			 Debug_Mode = false;
		}
	}

	// Inhibit questions from being asked. This is to assist in automation scripts

	char AskMe[2] = "A";

	if(argc >= 8)
	{
		// Copy the  argument into a character array
		strcpy(AskMe, argv[7]);
		// Convert the parameter to uppercase
		for(int i = 0; i < 2; i++)
			AskMe[i] = toupper(AskMe[i]);

		// Compare the mode with list of modes
		if(!strcmp("A", AskMe))
		{
			AskQuestions = true;
		}
		else if(!strcmp("D", AskMe))
		{
			 AskQuestions = false;
		}
	}


	ParseAndLoad();
	Set_Platform_Global_Variables();
	InitPinArray();
	InitLockUnlock();
	InitAddressOrder();
	InitInputDataOrder();
	InitOutputDataOrder();
	InitChipSelectRegions();
	AnalyzeChain();


	printf("\nJFLASH Version %s\n",  VERSION);
    printf("COPYRIGHT (C) 2000 - 2003 Intel Corporation\n\n");
	printf("PLATFORM SELECTION:\n");
	printf(" Processor= \t\t%s\n", &WORDARRAY[p_processor][0]);
	printf(" Development System= \t%s\n", &WORDARRAY[p_devsys][0]);
	printf(" Data Version= \t\t%s\n\n", &WORDARRAY[p_dataver][0]);

	// Use the function below for 100% OS independence
	//get_time_scale();  // test the speed of this computer to compute a loop delay

    //Test operating system, if WinNT or Win2000 then get device driver handle
	OSVERSIONINFO osvi;
	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
	GetVersionEx(&osvi);
	if(osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
	{
        HANDLE h;

		h = CreateFile("\\\\.\\giveio", GENERIC_READ, 0, NULL,
					OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
		if(h == INVALID_HANDLE_VALUE)
			error_out("Couldn't access giveio device");
		CloseHandle(h);
	}

	lpt_address = test_port();	// find a valid parallel port address
	if(!lpt_address)
		error_out("Error, unable to find parallel port");

 	// set the extended control register and others for the parallel port
	lpt_ECR = lpt_address + 0x402;
	lpt_CTL = lpt_address + 0x02;
	lpt_STAT = lpt_address + 0x01;
	#define STATUS_READ _inp(lpt_STAT)
	#define CONTROL_READ _inp(lpt_CTL)

    test_logic_reset();
 
    // Jtag test appears to have a bug that is preventing use of the Blackstone cable.   
//		{
//			//	jtag_test();  I want everyone to use blackstone so this needs to be out
//		}
	if(argc >= 3)
		strcpy(filename,argv[2]);
	else
		{
			if(!UsageShown) usage();
			printf("Enter binary file name: ");
			gets(filename);
		}

	char Cable_Type[4] = "INS";			// Either INS or PAR
	if(argc >= 6)
	{
		// Copy the fifth argument into a character array
		strcpy(Cable_Type, argv[5]);
		// Convert the name of the cable to uppercase
		for(int i = 0; i < 4; i++)
			Cable_Type[i] = toupper(Cable_Type[i]);

		// Compare the selected cable name with all supported cables
		if(!strcmp("INS", Cable_Type))
		{
			CableType = Insight_Jtag;
		}
		else if(!strcmp("PAR", Cable_Type))
		{
			 CableType = Parallel_Jtag;
		}
		else if(!strcmp("WIG", Cable_Type))
		{
			CableType = Wiggler_Jtag;
		}
	}
	test_logic_reset();

	id_command();
	//bypass_all();
	IR_Command(IR_Bypass);
    test_logic_reset();
	gpio_unlock_flash();

    //check_rom_info(&max_erase_time, &dsize, &max_write_buffer, &block_size, &nblocks);
    check_rom_info(&max_erase_time, &dsize, &max_write_buffer);

	if( (in_file = fopen(filename, "rb" )) == NULL)
    {
		error_out("error, can not open binary input file");
    }

	check_file_info(&fsize , &last_non_zero, &last_non_ff, dsize);
    
    // Don't waste time programming ff's at the end of the file this is the erase state
    fsize = last_non_ff;  

	if(argc >= 5)
    {
		sscanf(argv[4],"%x", &hexaddress);
		if(hexaddress & 0x3)
		{
			printf("Start address must be 32 bit aligned!\n");
   			printf("Changing start address to: %x\n",hexaddress & 0xFFFFFFFCul);
   			base_address = (hexaddress & 0xFFFFFFFCul);
   		}	
   			// adjust address for flash addressing mode
   			base_address = (hexaddress & 0xFFFFFFFCul)/ADDR_MULT;

	}
    else
    {
    	base_address = 0;
    }		 


	if(100 - (last_non_zero * 100)/last_non_ff > 20)
	{
		if(AskQuestions)
		{
			printf("The last %2ld percent of image file is all zeros\n",100 - (last_non_zero * 100)/last_non_ff);
			printf("Would you like to save time by not programming that area? [y/n]: ");
			if(toupper(_getche()) == 'Y')
			fsize = last_non_zero;
		}
		else
		{
			fsize = last_non_zero;
		}
	}

	printf("\n");
	char option = 'P';
	if(argc >= 4)
	{
    	option = toupper(*argv[3]);
    }
	
    if(option == 'P')
	{
		EraseBlocks(base_address, fsize);
		program_flash(max_write_buffer, base_address, fsize);
//		test_logic_reset();
		
		Write_Rom(0, F_READ_ARRAY);				// put back into read mode
		// try forcing asynchronous read mode
   //		Write_Rom(0, F_SET_READ_CFG_REG);
   //		Write_Rom(0, F_SET_READ_CFG_REG_2ND);
		// force the flash into read mode again
   //		Write_Rom(0, F_READ_ARRAY);	// put back into read mode
		access_rom(READ, base_address, 0x0L, IGNORE_PORT); //extra read to get the pipeline going
		time(&start);
		gpio_lock_flash();

		verify_flash(base_address, fsize);

	}
	else if(option == 'V')
	{

		Write_Rom(0, F_READ_ARRAY);				// put back into read mode
		access_rom(READ, base_address, 0x0L, IGNORE_PORT); //extra read to get the pipeline going
		time(&start);
		gpio_lock_flash();
		verify_flash(base_address, fsize);
	}
	else if(option == 'E')
	{
		if(AskQuestions)
		{
			printf("About to erase the entire flash memory..... \n");
			printf("Is this what you want to do? (Y or N)\n");
			if(toupper(_getche()) == 'Y')
			{
				fsize = dsize - 1;
				EraseBlocks(0, fsize);
			}
			else
			{
				error_out("Cancelling the erase....\n");
			}
		}
		else
		{
			fsize = dsize - 1;
			EraseBlocks(0, fsize);
		}
	}
	else
	{
		printf("error specifying programming option. \n");
		error_out("P: to program, V: to verify, E: to erase all\n");
	}

	fclose(in_file);

	test_logic_reset();
}

/*
*******************************************************************************
*
* FUNCTION:         Set_Application_Path_Variable
*
* DESCRIPTION:    Retrieves the path of the executable to allow jflash to be
*				  in an arbitrary folder
*                   
*
* INPUT PARAMETERS: none
					
* RETURNS:          None
*
* GLOBAL EFFECTS:   sets the global AppHome variable in Global_Variables.h
*
*******************************************************************************
*/
errno_t Set_Application_Path_Variable()
{
	errno_t err;
	err = GetModuleFileName (NULL, AppHome, _MAX_PATH);
    if (err == 0)
    {
       printf("Error getting the path. Error code %d.\n", err);
       exit(1);
    }
	return err;
}

/*
*******************************************************************************
*
* FUNCTION:         Split_File_Paths
*
* DESCRIPTION:    Splits the passed in variable into drive, folder, file, 
*				  extension.
*				  
*                   
*
* INPUT PARAMETERS: char array inputString Holds the string to be parsed
*					char array returnArray Returns array with parts of path
*						returnArray[0] = Drive
						returnArray[1] = Folders
						returnArray[2] = Filename
						returnArray[3] = Extension

* RETURNS:          None
*
* GLOBAL EFFECTS:   None
*
*******************************************************************************
*/
void Split_File_Paths(char* inputString, char returnArray[][_MAX_PATH])
{
	errno_t err;

	//Void old Path Information
	strcpy(returnArray[0],"");
	strcpy(returnArray[1],"");
	strcpy(returnArray[2],"");
	strcpy(returnArray[3],"");

	err = _splitpath_s( inputString, returnArray[0], _MAX_PATH, returnArray[1], _MAX_PATH,
		returnArray[2], _MAX_PATH, returnArray[3], _MAX_PATH );

	if (err != 0)
	{
		printf("Error splitting the path. Error code %d.\n", err);
		exit(1);
	}
}

/*
*******************************************************************************
*
* FUNCTION:         Set_Platform_Global_Variables
*
* DESCRIPTION:    Evaluates some global variables based on the selected platform             
*                   
*
* INPUT PARAMETERS: none
					
* RETURNS:          None
*
* GLOBAL EFFECTS:   sets the global varibales in Global_Variables.h
*
*******************************************************************************
*/
void Set_Platform_Global_Variables()
{

	// Evaluate the following variables based on the selected platform
	ChipSelect0		= convert_to_dword(&WORDARRAY[p_cs0][0]); 	// Global variable for chip select 0
	ChipSelect1		= convert_to_dword(&WORDARRAY[p_cs1][0]); 	// Global variable for chip select 1
	ChipSelect2		= convert_to_dword(&WORDARRAY[p_cs2][0]);	// Global variable for chip select 2
	ChipSelect3		= convert_to_dword(&WORDARRAY[p_cs3][0]);	// Global variable for chip select 3
	ChipSelect4		= convert_to_dword(&WORDARRAY[p_cs4][0]);	// Global variable for chip select 4
	ChipSelect5		= convert_to_dword(&WORDARRAY[p_cs5][0]);	// Global variable for chip select 5
	OutputEnable	= convert_to_dword(&WORDARRAY[p_nOE_OUT][0]);	// Global variable for output enable
	WriteEnable		= convert_to_dword(&WORDARRAY[p_nWE_OUT][0]);	// Global variable for write enable
	MdUpperControl	= convert_to_dword(&WORDARRAY[p_mdupper_ctrl][0]);	// Global variable for MD upper control
	MdLowerControl	= convert_to_dword(&WORDARRAY[p_mdlower_ctrl][0]);	// Global variable for MD lower control
	ReadWriteMode	= convert_to_dword(&WORDARRAY[p_RD_nWR_OUT][0]);	// Global variable for Read Write access mode
	IR_Idcode		= convert_to_dword(&WORDARRAY[p_idcode][0]);	// Global variable for the IDCODE instruction of the IR
	IR_Bypass		= convert_to_dword(&WORDARRAY[p_bypass][0]);	// Global variable for the BYPASS instruction of the IR
	IR_Extest		= convert_to_dword(&WORDARRAY[p_extest][0]);  	// Global variable for the EXTEST instruction of the IR
	ChainLength		= convert_to_dword(&WORDARRAY[p_blength][0]);  	// Global variable for the chain length of the selected platform
	IrLength		= convert_to_dword(&WORDARRAY[p_irlength][0]);  	// Global variable for setting the correct IR length

	if(!strcmp("16", &WORDARRAY[p_datawidth][0] ))
		PlatformIs16bit = true;
	else
		PlatformIs16bit = false;

	// set 16 and 32 bit command and query values

	if (PlatformIs16bit)
	{
	     F_READ_ARRAY = 		0x00FFL;
	     F_READ_IDCODES =   	0x0090L;
	     F_READ_QUERY =     	0x0098L;
	     F_READ_STATUS =    	0x0070L;
	     F_CLEAR_STATUS =   	0x0050L;
	     F_WRITE_BUFFER =   	0x00E8L;
	     F_WORDBYTE_PROG =  	0x0040L;

	     F_BLOCK_ERASE =    	0x0020L;
	     F_BLOCK_ERASE_2ND =	0x00D0L; 

	     F_BLK_ERASE_PS =       0x00B0L;
	     F_BLK_ERASE_PR =       0x00D0L;
	     F_CONFIGURATION =      0x00B8L;

	     F_SET_READ_CFG_REG =   0x0060L;
	     F_SET_READ_CFG_REG_2ND = 0x0003L;

	     F_SET_BLOCK_LOCK =      0x0060L;
	     F_SET_BLOCK_LOCK_2ND =  0x0001L;

	     F_CLEAR_BLOCK_LOCK =    0x0060L;
	     F_CLEAR_BLOCK_LOCK_2ND =0x00D0L;

	     F_PROTECTION =          0x00C0L;

	     F_ATTR_Q =              0x0051L;
	     F_ATTR_R =              0x0052L;
	     F_ATTR_Y =              0x0059L;

	     F_BLOCK_LOCKED =        0x0001L;
	     F_STATUS_READY =        0x0080L;
	}
	else
	{ 
	     F_READ_ARRAY = 		0x00FF00FFL;
	     F_READ_IDCODES =   	0x00900090L;
	     F_READ_QUERY =     	0x00980098L;
	     F_READ_STATUS =    	0x00700070L;
	     F_CLEAR_STATUS =   	0x00500050L;
	     F_WRITE_BUFFER =   	0x00E800E8L;
	     F_WORDBYTE_PROG =  	0x00400040L;

	     F_BLOCK_ERASE =    	0x00200020L;
	     F_BLOCK_ERASE_2ND =	0x00D000D0L; 

	     F_BLK_ERASE_PS =       0x00B000B0L;
	     F_BLK_ERASE_PR =       0x00D000D0L;
	     F_CONFIGURATION =      0x00B800B8L;

	     F_SET_READ_CFG_REG =   0x00600060L;
	     F_SET_READ_CFG_REG_2ND = 0x00030003L;

	     F_SET_BLOCK_LOCK =      0x00600060L;
	     F_SET_BLOCK_LOCK_2ND =  0x00010001L;

	     F_CLEAR_BLOCK_LOCK =    0x00600060L;
	     F_CLEAR_BLOCK_LOCK_2ND =0x00D000D0L;

	     F_PROTECTION =          0x00C000C0L;

	     F_ATTR_Q =              0x00510051L;
	     F_ATTR_R =              0x00520052L;
	     F_ATTR_Y =              0x00590059L;

	     F_BLOCK_LOCKED =        0x00010001L;
	     F_STATUS_READY =        0x00800080L;

	}

	if (PlatformIs16bit)
	{
		ADDR_MULT = 2;
	}
	else
	{
		ADDR_MULT = 4;
	}

}

/*
*******************************************************************************
*
* FUNCTION:         get_rom_info
*
* DESCRIPTION:      get the flash information such as max erase time, flash size, 
*                   max write buffer, block number               
*                   
*
* INPUT PARAMETERS: DWORD *max_erase_time	: max erase time, number of seconds
*					DWORD *dsize			: each flash size, number of 16-bit word
*					DWORD *max_write_buffer : each flash max write buffer, number of 16-bit word
					DWORD *block_size		: each block size, number of 16-bit word
*					DWORD *nblocks			: number of erase blocks in each Flash*
					
* RETURNS:          None
*
* GLOBAL EFFECTS:   None
*
*******************************************************************************
*/
void check_rom_info(DWORD *max_erase_time, DWORD * dsize, DWORD * max_write_buffer)

{	
	DWORD FlashId;
	char constructed_string[150];
	char FlashIdString[5];
	bool IDFound = false;
	int IDAttempts = 5;

	do // Check for a recognized Flash ID a few times. Some devices are harder to read
	{
		Write_Rom(0x0, F_READ_ARRAY);	
		Write_Rom(0x0, F_READ_IDCODES);	
	   	
	  	FlashId = (Read_Rom(0x1) & 0xFFFF);
	    FlashId = (Read_Rom(0x1) & 0xFFFF); // buggy K flash needs another read



		// open the data file for the flash device. If there is no file, then
		// either the flash is not supported, not released, or there was an error
		// reading the Device ID.

		// construct the filename
		strcpy(FlashIdString,"");
		sprintf(FlashIdString, "%x", FlashId);
		strcpy(constructed_string,"");
		strcpy(flash_data_filename,"");

		// construct the processor ID
		sprintf(constructed_string, "Flash_%s_%s_%s.dat",FlashIdString,&WORDARRAY[p_fdevsacross][0],&WORDARRAY[p_datawidth][0]);

		Split_File_Paths(AppHome,PathInformation);

		sprintf(flash_data_filename,"%s%s%s",PathInformation[0],PathInformation[1],constructed_string);

		printf("%s\n",flash_data_filename);

		// See if the file exists. If not then try again to confirm the flash ID
		if((flash_file_pointer = fopen(flash_data_filename, "rb")) == NULL)
		{
			printf("Failed to read the Flash ID. Retrying %d more times...\n", IDAttempts -1);
			IDAttempts--;
			if (IDAttempts == 0)
			{
				printf("Cannot open input file: %s\n\n", flash_data_filename);
				printf("This program supports flash devices defined by DAT files\n");
				printf("contained in the same directory as the executable program. \n\n");
				printf("If the file cannot be opened, there are three possibilities:\n\n");
				printf(" 1 - The flash device installed is not supported.\n");
				printf(" 2 - The flash device is a licensed product.\n");
				printf(" 3 - The device ID could not be read, resulting in a poorly\n");
				printf("     constructed filename. The first numeric value in the\n");
				printf("     filename is the device ID. Verify this value with the\n");
				printf("     component specification.\n");
				printf(" 4 - The memory bus is not functional. Check all CPLD and FPGA\n");
				printf("     devices. Make sure that you are using the correct \n");
				printf("     platform data file. \n"); 
				exit(1);

			}
			else
			{
				// hit the system with a JTAG reset and try again
				test_logic_reset();
				// try putting the flash into read mode again
				Write_Rom(0, F_READ_ARRAY);	// put back into read mode
				
				// try forcing asynchronous read mode
				Write_Rom(0x8000, F_SET_READ_CFG_REG);
				Write_Rom(0x8000, F_SET_READ_CFG_REG_2ND);

				
//				Write_Rom(0x0, F_READ_ARRAY);	// put back into read mode
//				Write_Rom(0x0, F_READ_IDCODES);	
			   	
//			  	FlashCR = (Read_Rom(0x5) & 0xFFFF);
//			    FlashCR = (Read_Rom(0x5) & 0xFFFF); // buggy K flash needs another read
	
//				printf("configuration register = %X\n",FlashCR);
				
				Write_Rom(0, F_READ_ARRAY);	// put back into read mode

				access_rom(READ, 0x0L, 0x0L, IGNORE_PORT); //extra read to get the pipeline going
			}
		}
		else
		{
			IDFound = true;	
		}
	 } while(!IDFound);	

	ParseAndLoadFlashData();
	InitFlashGlobals();
	printf("Found flash type: %s\n", &FLASHWORDARRAY[pf_type][0]); 

	// set the required variables by using the previousely defined globals

	*max_erase_time = BlockEraseTime;
	*dsize = FlashDeviceSize;
	*max_write_buffer = FlashBufferSize;
}

/*
*******************************************************************************
*
* FUNCTION:         check_file_info
*
* DESCRIPTION:      get the file information and check with rom size
*                   
*
* INPUT PARAMETERS: DWORD *fsize			: file size
					DWORD *last_non_zero	: the point where only 0 or FF remain
					DWORD *last_non_ff		: the point where only ff remain
										
										    if LUBBOCK_SABINAL or
										    LUBBOCK_DBPXA262 is defined,
										    the upper 3 parameters 
											are in 16-bit word number
											else they are in 32-bit DWORD number

					DWORD rom_size			: the rom size in 
*					
					
* RETURNS:          None
*
* GLOBAL EFFECTS:   None
*
*******************************************************************************
*/
void check_file_info(DWORD *fsize , DWORD *last_non_zero, DWORD *last_non_ff, DWORD rom_size)
{	
	
	WORD li_WORD;
	DWORD li_DWORD;

    if(PlatformIs16bit)
	{
		for(;;)
		{
			int n = fread((WORD *)&li_WORD, sizeof(WORD) , 1, in_file);

    		if(feof(in_file))break; // Any bytes not on a 4 byte boundry at end-of-file will be ignored
			{
				(*fsize)++;
			}
			if(li_WORD != 0 && li_WORD != -1) // Find point in file were only 0's and ff's remain
			{						// For 32 bit data bus, -1 is 0xffffffff, for 16 bit data bus -1 is 0xffff
        		*last_non_zero = *fsize;
			}
			if(li_WORD != -1)  // Find point in file were only ff's remain
			{
        		*last_non_ff = *fsize;
			}
		}

		rewind(in_file);

		// if 16-bit data width used, it assume only one 16-bit flash installed
		if ((*fsize) > rom_size)
			error_out("error, file size is bigger than device size");
	}
	else
	{
		for(;;)
		{
			int n = fread((DWORD *)&li_DWORD, sizeof(DWORD) , 1, in_file);

    		if(feof(in_file))break; // Any bytes not on a 4 byte boundry at end-of-file will be ignored
			{
				(*fsize)++;
			}
			if(li_DWORD != 0 && li_DWORD != -1) // Find point in file were only 0's and ff's remain
			{						// For 32 bit data bus, -1 is 0xffffffff, for 16 bit data bus -1 is 0xffff
        		*last_non_zero = *fsize;
			}
			if(li_DWORD != -1)  // Find point in file were only ff's remain
			{
        		*last_non_ff = *fsize;
			}
		}

		rewind(in_file);

		// if 32-bit data width used. It assume 2 16-bit flash installed. each flash size=fsize
		if ((*fsize) * 2 > rom_size * 2)
			error_out("error, file size is bigger than device size");
	}
}


/*
*******************************************************************************
*
* FUNCTION:         putp
*
* DESCRIPTION:      Drives TCK, TDI, and TMS signals and reads TDO signal 
*                   via _outp and _inp calls.
*                   
*                   Cable used had 100 ohm resistors between the following pins
*                   (Cable shipped as part of SA-1110 Development Kit)
*                   Output pins (LPT driving)
*                       LPT D0 Pin 2 and TCK J10 Pin 4
*                       LPT D1 Pin 3 and TDI J10 Pin 11
*                       LPT D2 Pin 4 and TMS J10 Pin 9
*
*                   Input pin (SA-1110 board drives)
*                       LPT Busy Pin 11 and TDO J10 Pin 13
*
*
*
* INPUT PARAMETERS: int tdi - test data in
*
* RETURNS:          int - TDO (Test Data Out)
*
* GLOBAL EFFECTS:   None
*
*******************************************************************************
*/
// Future work: this procedure needs to be cleaned up and extended. There is a 
// strong possibility that that the Altera Byte-Blaster cable could also be
// supported. 

int putp(int tdi, int tms, int rp)
{
	int tdo = -1;
	if (CableType == Wiggler_Jtag)
	{
		// -- Wiggler Configuration --
		// S_TRST is D0    Note: Is configured open-drain on Wiggler and is internally pulled
		//						 up on iMote2.
		// TMS is D1, TCK is D2, TDI is D3, TRST_N is D4

		// Input's are sampled on rising edge
		_outp(lpt_address, tms << 1 | tdi << 3 | 1 << 4);		// TCK low 
		_outp(lpt_address, tms << 1 | tdi << 3 | 1 << 4 | 1 << 2);		// TCK high 

		// Output is sampled on falling edge
		if (rp == READ_PORT)
		{
			_outp(lpt_address, tms << 1 | tdi << 3 | 1 << 4);				// TCK low 
			tdo = !((int)_inp(lpt_address + 1) >> 7);	// get TDO data
		}

	}
	else if(CableType == Parallel_Jtag)
	{
		// TMS is D2, TDI is D1, and TCK is D0, so construct an output by creating a 
		// rising edge on TCK with TMS and TDI data set.
		_outp(lpt_address, tms*4+tdi*2);				// TCK low 
		_outp(lpt_address, tms*4+tdi*2+1);				// TCK high 

		// if we want to read the port, set TCK low because TDO is sampled on the 
		// TCK falling edge.
		if(rp == READ_PORT)
			_outp(lpt_address, tms*4+tdi*2);			// TCK low
		if(rp == READ_PORT)
			tdo = !((int)_inp(lpt_address + 1) >> 7);	// get TDO data
	}
	else if (CableType == Insight_Jtag)
	{
		// There's some bit clearing here that isn't needed. It should make this 
		// code easier to understand.

		//defines for the INSIGHT IJC-1 JTAG cable

		/* the output port (lpt_address) */
		#define INSIGHT_DIN		0x01
		#define INSIGHT_CLK		0x02
		#define INSIGHT_TMS_IN  0x04  
		
		/* Output Enable for the standard JTAG outputs 
		(not TDO since this is an output from the 
		chip we want to talk to */
		#define nINSIGHT_CTRL	0x08
		#define nINSIGHT_PROG	0x10  /* This causes the TDO line to be driven. We'll leave it high.*/


		/*the input port (lpt_address + 1)*/
		#define TDO_INPUT			0x10
		#define TDO_INPUT_BITPOS	4

		int lpt_data;

		//form the data we want to write to the parallel port
		lpt_data = nINSIGHT_PROG;   //Output to TDO off
		lpt_data &= ~nINSIGHT_CTRL;	//Enable the outputs

		if(tms == 1) lpt_data |= INSIGHT_TMS_IN;
		if(tdi == 1) lpt_data |= INSIGHT_DIN;

   		// construct an output by creating a 
		// rising edge on TCK with TMS and TDI data set.
		lpt_data &= ~INSIGHT_CLK;
		_outp(lpt_address, lpt_data);	// TCK low

		lpt_data |= INSIGHT_CLK;
		_outp(lpt_address, lpt_data);	// TCK high

		// if we want to read the port, set TCK low because TDO is sampled on the 
		// TCK falling edge.
		if(rp == READ_PORT)
		{
			lpt_data &= ~INSIGHT_CLK;
			_outp(lpt_address, lpt_data);	// TCK high ??? Low?
			tdo = ((int)_inp(lpt_address + 1) & TDO_INPUT) >> TDO_INPUT_BITPOS;	// get TDO data
		}
	}

//	#ifdef DEBUG
//    printf("TDI = %d, TMS = %d, TDO = %d\n",tdi,tms,tdo);
//  #endif

    return tdo;
}
/*
*******************************************************************************
*
* FUNCTION:         id_command
*
* DESCRIPTION:      extract and verify the id codes of the devices in the chain
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/

void id_command(void)
{
    char constructed_string[50];
//    int device;
   	int bitscount = 0;
    
	IR_Command(IR_Idcode);

    pre_DRSCAN();
	
	strcpy(constructed_string, "");

	// construct the processor ID
	strcat(constructed_string, "**** ");
	strcat(constructed_string, &WORDARRAY[p_proc_id][0]);
	strcat(constructed_string, " ");
	strcat(constructed_string, &WORDARRAY[p_proc_mfg][0]);
	strcat(constructed_string, " ");
	strcat(constructed_string, &WORDARRAY[p_proc_std][0]);

	if(check_id(constructed_string))
		error_out("failed to read device ID for this Platform");
	

    post_DRSCAN();
}


/*
*******************************************************************************
*
* FUNCTION:         IR_Command
*
* DESCRIPTION:      sends an instruction to the controller and puts all other 
*                   devices into bypass mode.
*
* INPUT PARAMETERS: int	command
*
* RETURNS:          void
*
*******************************************************************************
*/

void IR_Command(int command)
{
    int device;

    pre_IRSCAN();

	for(device = DEVICES_IN_CHAIN -1 ; device >= 0; device--)
	{
		if(device == DEVICE_CONTROLLER)
		{
			if(DEVICEISLAST[device])
			{
				controller_scan_code(command, IGNORE_PORT, TERMINATE);
			}
			else // controller is not the last in the chain
			{
				controller_scan_code(command, IGNORE_PORT, CONTINUE);
			}
		}
		else
		{
			if(DEVICEISLAST[device])
			{
				    other_bypass(IGNORE_PORT, TERMINATE, (int)DEVICEIRLENGTH[device]);
			}
			else 
			{
				    other_bypass(IGNORE_PORT, CONTINUE, (int)DEVICEIRLENGTH[device]);
			}
		} 
	}

    post_IRSCAN();

}


/*
*******************************************************************************
*
* FUNCTION:         access_rom
*
* DESCRIPTION:      This is just an access-bus with the address multiplied by 4
*
* INPUT PARAMETERS: int - rw, or access mode
*                   DWORD - address
*                   DWORD - data
*                   int rp - whether to read or ignore the parallel port
*
* RETURNS:          DWORD - returned data
*
*******************************************************************************
*/
DWORD access_rom(int rw, DWORD address, DWORD data, int rp)
{
	DWORD returnvalue;
    DWORD HalfData = data & FIRST_HALF_WORD_MASK;	// Get the rightmost half of the word only

    // Shift Flash address making A2 the LSB
    
	if(Debug_Mode)
	{
	   	if(PlatformIs16bit)
		 printf("ACCESS_ROM: inp addr = %X, inp HalfData = %X\n", address, HalfData);
		else
		 printf("ACCESS_ROM: inp addr = %X, inp data = %X\n", address, data);
    }

	if(PlatformIs16bit)
		returnvalue = (access_bus(rw, address << 1, HalfData, rp) & FIRST_HALF_WORD_MASK);
    else
		returnvalue = access_bus(rw, address << 2, data, rp);

    if(Debug_Mode)
    	printf("ACCESS_ROM Returns %X\n", returnvalue);

    return returnvalue;
}

/*
*******************************************************************************
*
* FUNCTION:         Write_Rom
*
* DESCRIPTION:      This routine manipulates the memory bus to do reads 
*                   and writes to any memory location.
*
* INPUT PARAMETERS: int address - address to which you need to write to rom
*					int data    - data you need to write to rom
*
* RETURNS:          none
*
*******************************************************************************
*/
void Write_Rom(DWORD address, DWORD data)
{
	if(Debug_Mode)
		printf("Writing to ROM ...\n");

	access_rom(SETUP, address, data, IGNORE_PORT);
	access_rom(WRITE, address, data, IGNORE_PORT);
	access_rom(HOLD, address, data, IGNORE_PORT);
}

/*
*******************************************************************************
*
* FUNCTION:         Read_Rom
*
* DESCRIPTION:      This routine uses access_rom to read from rom
*                   
*
* INPUT PARAMETERS: int address - address from which you need to read from rom
*
* RETURNS:          DWORD - data read
*
*******************************************************************************
*/

DWORD Read_Rom(DWORD address)
{
	if(Debug_Mode)
		printf("Reading from ROM ...\n");
		
		return access_rom(READ, address, 0, READ_PORT);
}


/*
*******************************************************************************
*
* FUNCTION:         access_bus
*
* DESCRIPTION:      This routine manipulates the memory bus to do reads 
*                   and writes to any memory location.
*
* INPUT PARAMETERS: int rw - mode of READ, WRITE, SETUP, HOLD, or RS
*                   DWORD - address of access
*                   DWORD - data to write
*                   int rp - read or ignore port data
*
* RETURNS:          DWORD - returned data
*
*******************************************************************************
*/


DWORD access_bus(int rw, DWORD address, DWORD data, int rp)
{
	DWORD i;
//	int j;
	int device;

	// Preset SA-1110 or Cotulla pins to default values (all others set in Cotullajtag.h)
    
    clear_chip_selects();
	mem_output_enable(ENABLE);
	mem_write_enable(DISABLE);
	mem_rw_mode(WRITE);
    mem_data_driver(HIZ);
    set_address(address);

    //----------------------------------------------
    if(rw == READ)
	{
		if(Debug_Mode)
        	printf("Read Mode\n");

		mem_rw_mode(READ);
        set_pin_chip_select(address);
	}

    //----------------------------------------------
	else if(rw == WRITE)
	{
		if(Debug_Mode)
        	printf("Write Mode\n");

        mem_write_enable(ENABLE);
		mem_output_enable(DISABLE);
        mem_data_driver(DRIVE);
        set_pin_chip_select(address);
        set_data(data);
	}
    
    //----------------------------------------------
	else if(rw == SETUP || rw == HOLD)	// just like a write except WE, WE needs setup time
	{
		if(Debug_Mode)
        	printf("Setup or Hold Mode\n");

		mem_output_enable(DISABLE);
        mem_data_driver(DRIVE);
		set_data(data);
	}
    //----------------------------------------------
	else if(rw == RS)	// setup prior to RD_nWR_OUT
	{
		if(Debug_Mode)
        	printf("RS Mode\n");

        mem_output_enable(DISABLE);
	}
	else if(rw == K3)
		clear_chip_selects();

    // Common finish

    putp(1,0,IP);	//Run-Test/Idle
	putp(1,0,IP);	//Run-Test/Idle
	putp(1,0,IP);	//Run-Test/Idle
	putp(1,0,IP);	//Run-Test/Idle
	putp(1,1,IP);	//select DR scan
	putp(1,0,IP);	//capture DR
	putp(1,0,IP);	//shift IR ---> (Rami: should be DR?)


	int out_dat[MAX_CHAIN_LENGTH];

	for(device = DEVICES_IN_CHAIN -1 ; device >= 0; device--)
	{
		if(device == DEVICE_CONTROLLER)
		{
			for(i = 1; i < ChainLength; i++)	// shift write data in to JTAG port and read data out
				out_dat[i] = putp(pin[i-1],0,rp);
//			for(i = 0; i < ChainLength; i++)	// shift write data in to JTAG port and read data out
//				out_dat[i] = putp(pin[i],0,rp);

		}
		else
		{
			putp(0,0,IP); // extra clicks for devices in the chain
		} 
	}

#ifdef serious_error
    if(Debug_Mode)
    {
		for(i = 1; i < ChainLength; i++)	
		{
    		if(rw == READ)
			{
				if(i%30 == 0) printf("\n");
				printf(" %d", out_dat[i]);
			}
		}
		printf("\n");
	}
#endif

	putp(0,1,IP);	//Exit1-DR
	putp(1,1,IP);	//Update-DR
	putp(1,0,IP);	//Run-Test/Idle
	putp(1,0,IP);	//Run-Test/Idle
	putp(1,0,IP);	//Run-Test/Idle

	DWORD busdat = 0;

	for(i = 0; i < 32; i++)	// convert serial data to single DWORD
		busdat = busdat | ((DWORD)(out_dat[input_dat_order[i]] << i));
    
    //extest();
	IR_Command(IR_Extest);

	if(Debug_Mode)
	{
    printf("just before return\n");
    dump_chain();
	}

    return(busdat);
}

/*
*******************************************************************************
*
* FUNCTION:         test_port
*
* DESCRIPTION:      Searches for a valid parallel port
*
* INPUT PARAMETERS: void
*
* RETURNS:          int - Address of the port or zero if none available
*
*******************************************************************************
*/

int test_port(void)
{
	// search for valid parallel port
		_outp(LPT1, 0x55);
		if((int)_inp(LPT1) == 0x55)
        {
            if(Debug_Mode)
            	printf("Parallel Com port found at I/O address: %X\n", LPT1);

            return LPT1;
        }

		_outp(LPT2, 0x55);
		if((int)_inp(LPT2) == 0x55)
        {
            if(Debug_Mode)
            	printf("Parallel Com port found at I/O address: %X\n", LPT2);
           
            return LPT2;
		}
 
        _outp(LPT3, 0x55);
		if((int)_inp(LPT3) == 0x55)
        {
            if(Debug_Mode)
            	printf("Parallel Com port found at I/O address: %X\n", LPT3);
            
            return LPT3;
        }
        
	return(0);	// return zero if none found
}
/*
*******************************************************************************
*
* FUNCTION:         check_id
*
* DESCRIPTION:      Compare an ID string returned from the device with the expected string.
*
* INPUT PARAMETERS: char * device_id - a pointer to the string returned from the device
*
* RETURNS:          int - 0 if ID matches expected, -1 if a match fails
*
*******************************************************************************
*/

int check_id(char *device_id)
{
	// compare passed device ID to the one returned from the ID command
	char in_id[40];
	BOOL error_flag = FALSE;

	if(DEVICES_IN_CHAIN > 1)
		putp(1,0,IGNORE_PORT); // this is a bug fudge factor - look into this
	
	
	for(int i = 34; i >= 0; i--)
	{
		// skip over the spaces in the ID string
        if(i == 4 || i == 21 || i == 33)
		{
			in_id[i] = ' ';
			i--;
		}
        
		if(putp(1,0,READ_PORT) == 0)
			in_id[i] = '0';
		else
			in_id[i] = '1';

		if((in_id[i] != *(device_id + i)) && (*(device_id + i) != '*'))
		{
			error_flag = TRUE;
			
		}
	}
	in_id[35] = 0;

	
	if(error_flag)
	{
		printf("error, failed to read device ID\n");
		printf("check cables and power\n");
		printf("ACT: %s\n",in_id);
		printf("EXP: %s\n\n",device_id);
		return -1;
	}

	int revision =	(int)(in_id[0] - '0') * 8 +
					(int)(in_id[1] - '0') * 4 +
					(int)(in_id[2] - '0') * 2 +
					(int)(in_id[3] - '0');

	switch(revision)	   
	{
		case 0: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID0][0]); 
			break;
		case 1: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID1][0]); 
			break;
		case 2: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID2][0]); 
			break;
		case 3: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID3][0]); 
			break;
		case 4: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID4][0]); 
			break;
		case 5: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID5][0]); 
			break;
		case 6: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID6][0]); 
			break;
		case 7: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID7][0]); 
			break;
		case 8: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID8][0]); 
			break;
		case 9: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID9][0]); 
			break;
		case 10: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID10][0]); 
			break;
		case 11: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID11][0]); 
			break;
		case 12: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID12][0]); 
			break;
		case 13: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID13][0]); 
			break;
		case 14: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID14][0]); 
			break;
		case 15: 
			printf("%s revision %s\n", &WORDARRAY[p_processor][0], &WORDARRAY[p_CID15][0]); 
			break;

		default: printf("Unknown revision number. Out of range!");	// should never get here
	}

	return 0;
}
/*
*******************************************************************************
*
* FUNCTION:         error_out
*
* DESCRIPTION:      generic error printout and program exit.
*
* INPUT PARAMETERS: char * error_string to print before exit
*
* RETURNS:          void
*
* GLOBAL EFFECTS:   Exits the program
*******************************************************************************
*/

void error_out(char *error_string)
{
	printf("%s\n",error_string);
	exit(0);
}

/*
*******************************************************************************
*
* FUNCTION:         program_flash
*
* DESCRIPTION:      program the flash using buffered writes
*
* INPUT PARAMETERS: DWORD max_write_buffer derived from the flash query
*                   DWORD base_address
*                   DWORD fsize (flash size)
*
* RETURNS:          void
*
*******************************************************************************
*/

void program_flash(DWORD max_write_buffer, DWORD base_address, DWORD fsize)
{
	time_t start = 0;
	time_t now = 0;
	WORD li_WORD;
	DWORD li_DWORD;
	DWORD write_word_count;
	int bus_width;
//	DWORD Status;
	printf("Starting programming\n");

	if(!strcmp("WORD", &WORDARRAY[P_progmode][0] ))
	{
		printf("Using WORD programming mode...\n");
		DWORD lj;
		for(lj = base_address; lj < fsize + base_address; lj = lj +1)
		{
			
			time(&now);
			if(difftime(now,start) > STATUS_UPDATE)	// Update status every 2 seconds
				{
			   	printf("Writing flash at hex address %8lx, %5.2f%% done    \r"
					,lj * ADDR_MULT ,(float)(lj - base_address)/(float)fsize*100.0);
				time(&start);
				}

			if(!PlatformIs16bit)
			{
				fread((DWORD *)&li_DWORD, sizeof(DWORD) , 1, in_file);
				access_rom(WRITE, lj, F_WORDBYTE_PROG, IGNORE_PORT); 
				access_rom(HOLD, lj, F_WORDBYTE_PROG, IGNORE_PORT);
				access_rom(WRITE, lj, li_DWORD, IGNORE_PORT); 
				access_rom(HOLD, lj, li_DWORD, IGNORE_PORT);
			}
			else
			{
				fread((WORD *)&li_WORD, sizeof(WORD) , 1, in_file);
				access_rom(WRITE, lj, F_WORDBYTE_PROG, IGNORE_PORT); 
				access_rom(HOLD, lj, F_WORDBYTE_PROG, IGNORE_PORT);
				access_rom(WRITE, lj, li_WORD, IGNORE_PORT); 
				access_rom(HOLD, lj, li_WORD, IGNORE_PORT);
			}
		}
			 	Write_Rom(lj, F_READ_ARRAY);
	}

	else if(!strcmp("BUFFER", &WORDARRAY[P_progmode][0] ))
	{
		printf("Using BUFFER programming mode...\n");

		// "Write Buffer" flow.
		// This uses almost half the cycles required by "word programming" flow
		// Status register is not read to save time.  There is also no checking to see
		// if maximum "Write Buffer Program Time" is violated.  However even with the
		// fastest parallel port bus speed this should not be a problem
		// (i.e. 16 words * 300 JTAG chain length * 4 parallel port cycles * 1uS fast
		// parallel port cycle = 19mS, typical write buffer program times are in the 200uS range).

	if(!PlatformIs16bit)
		write_word_count = (max_write_buffer - 1) + ((max_write_buffer - 1) << 16);
	else
		write_word_count = max_write_buffer - 1;


		time(&start);
		DWORD lj;
		for(lj = base_address; lj < fsize + base_address; lj = lj + max_write_buffer)
		{

			access_rom(WRITE, lj, F_WRITE_BUFFER, IGNORE_PORT); // write buffer command
			access_rom(HOLD, lj, F_WRITE_BUFFER, IGNORE_PORT);

			access_rom(WRITE, lj, write_word_count, IGNORE_PORT); // write word count (max write buffer size)
			access_rom(HOLD, lj, write_word_count, IGNORE_PORT);

			time(&now);
			if(difftime(now,start) > STATUS_UPDATE)	// Update status every 2 seconds
				{
			   	printf("Writing flash at hex address %8lx, %5.2f%% done    \r"
					,lj * ADDR_MULT ,(float)(lj - base_address)/(float)fsize*100.0);
				time(&start);
				}

			if(!PlatformIs16bit)
			{
				for(DWORD lk = 0; lk < max_write_buffer; lk++)
				{
					fread((DWORD *)&li_DWORD, sizeof(DWORD) , 1, in_file);
					access_rom(WRITE, lj+lk, li_DWORD, IGNORE_PORT);  // Write buffer data
					access_rom(HOLD, lj+lk, li_DWORD, IGNORE_PORT);  // New
				 //	printf("writing %x at address %x\n", li_DWORD, lj+lk);
				}
			}
			else
			{
				for(DWORD lk = 0; lk < max_write_buffer; lk++)
				{
					fread((WORD *)&li_WORD, sizeof(WORD) , 1, in_file);
					access_rom(WRITE, lj+lk, li_WORD, IGNORE_PORT);  // Write buffer data
					access_rom(HOLD, lj+lk, li_WORD, IGNORE_PORT);  // New
				}
			}

				// No need to diferentiate between 16 and 32 bit access_rom functions anymore!
				access_rom(WRITE, 0, F_BLOCK_ERASE_2ND, IGNORE_PORT); // Program Buffer to Flash Confirm
				access_rom(HOLD, 0, F_BLOCK_ERASE_2ND, IGNORE_PORT);  //New
		}
			 	Write_Rom(lj, F_READ_ARRAY);
	}
	else if(!strcmp("XSCALE", &WORDARRAY[P_progmode][0] ))
	{
		printf("Using XSCALE programming mode...\n");
		
		xscale_init_handler();
		if(!PlatformIs16bit) 
		{
			bus_width = 32;
		}
		else
		{
			bus_width = 16;
		}
		
		xscale_program_flash(in_file, base_address, fsize, bus_width);	

	}


	printf("\nProgramming done\n");

	rewind(in_file);
}
/*
*******************************************************************************
*
* FUNCTION:         verify_flash
*
* DESCRIPTION:      compares data programmed in flash with the original binary file.
*
* INPUT PARAMETERS: DWORD base_address
*                   DWORD flash_size
*
* RETURNS:          void
*
*******************************************************************************
*/

void verify_flash(DWORD base_address, DWORD fsize)
{
	time_t start, now;
	DWORD li_DWORD, li1_DWORD;
	WORD li_WORD, li1_WORD;
	int dumpcount = 0;
	bool verified = false;
	bool retry = false;

	printf("Starting Verify\n");
	

	
	time(&start);

	if(PlatformIs16bit)
	{
		for(DWORD lj = base_address + 1; lj <= fsize + base_address; lj++)
			{
			fread((WORD *)&li_WORD, sizeof(WORD) , 1, in_file);
			retry = false;
			verified = false;
			do
			{
			    // toggle the chip select for K3 flash
			    access_rom(RS, lj, 0x0L, READ_PORT);
				
				li1_WORD = (WORD) Read_Rom(lj);
				
				#ifdef K3_BUGFIX
			    Read_Rom(lj);  //hack to fix K3 flash bug?
				#endif //K3_BUGFIX

				time(&now);
				if(difftime(now,start) > STATUS_UPDATE)	// Update status every 2 seconds
					{
					printf("Verifying flash at hex address %8lx, %5.2f%% done    \r"
						,lj*ADDR_MULT ,(float)(lj - base_address)/(float)fsize*100.0);
					time(&start);
					}
				if(li_WORD != li1_WORD)
					{
						printf("verify error at address = %lx exp_dat = %lx act_dat = %lx\n",(lj - 1)*ADDR_MULT, li_WORD,li1_WORD);
						dumpcount++;
						if(dumpcount > 10) exit(1);
						verified = false;
						printf("Retrying....\n");
						
						retry = true;
					}
					else
					{
						verified = true;
						if (retry) dumpcount--;
					}

			
			    }while(!verified);
			}
	}
	else 
	{
		for(DWORD lj = base_address + 1; lj <= fsize + base_address; lj++)
		{
			fread((DWORD *)&li_DWORD, sizeof(DWORD) , 1, in_file);
			retry = false;
			verified = false;
		 do
		 {
		    // toggle the chip select for K3 flash
		    access_rom(RS, lj, 0x0L, READ_PORT);
			li1_DWORD = Read_Rom(lj);
		    //	li1_DWORD = Read_Rom(lj);
			
			
			time(&now);
			if(difftime(now,start) > STATUS_UPDATE)	// Update status every 2 seconds
				{
				printf("Verifying flash at hex address %8lx, %5.2f%% done    \r"
					,lj*ADDR_MULT ,(float)(lj - base_address)/(float)fsize*100.0);
				time(&start);
				}
			if(li_DWORD != li1_DWORD)
				{
					printf("verify error at address = %lx exp_dat = %lx act_dat = %lx\n",(lj - 1) *ADDR_MULT,li_DWORD,li1_DWORD);
					dumpcount++;
					if(dumpcount > 10) exit(1);
					verified = false;
					printf("Retrying....\n");
					
					retry = true;
				}
				else
				{
					verified = true;
					if(retry) dumpcount--;
				}
			}while(!verified);
		}
	}


	printf("\nVerification successful!                                                    \n");
}
/*
*******************************************************************************
*
* FUNCTION:         test_logic_reset
*
* DESCRIPTION:      initializes the JTAG state machine to a known state
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
 
void test_logic_reset(void)
{
    if(Debug_Mode)
    printf("begin test logic reset\n");
    

	// keep TMS set to 1 force a test logic reset
	// no matter where you are in the TAP controller
	for(int i=0; i < 6; ++i)
		putp(1,1,IGNORE_PORT);

    if(Debug_Mode)
    printf("finish test logic reset\n");
    
}

/*
*******************************************************************************
*
* FUNCTION:         set_lock_flash
*
* DESCRIPTION:      sets locks bits in specified block
*
* INPUT PARAMETERS: DWORD base_address of flash
*                   DWORD fsize - size of flash
*                   DWORD block_size - block size of flash
*                   DWORD max_erase_time - used for a timeout 
*                   int block_number - block number of interest
*
* RETURNS:          void
*
*******************************************************************************
*/


void set_lock_flash(DWORD base_address, DWORD fsize, DWORD block_size, DWORD max_erase_time, int block_number)
{
	time_t start, now;

	printf("Starting set block lock bit\n");

	for(DWORD lj = base_address; lj < fsize + base_address; lj = lj + block_size)  // locks only blocks to be programmed
		{

		// Rami: Should this be lj instead of 0 ???
		Write_Rom(0, F_SET_BLOCK_LOCK);			//  block lock bit command
		Write_Rom(lj, F_SET_BLOCK_LOCK_2ND);	// Confirm

		time(&start);
		printf("Erasing block %3d   \r",block_number++);
		while(access_rom(RS, 0, 0, READ_PORT) != F_STATUS_READY)	// Loop until successful status return
			{
			Read_Rom(0);
			time(&now);
			if(difftime(now,start) > max_erase_time + 1)	// Check for status timeout
				error_out("Error, Clear lock timed out");
			}
		}
	printf("Set lock bit done                                           \n");
}

/*
*******************************************************************************
*
* FUNCTION:         set_address
*
* DESCRIPTION:      Loads the address into the address bits
*
* INPUT PARAMETERS: address
*
* RETURNS:          void
*
* GLOBAL EFFECTS:   None
*
* ASSUMPTIONS:      None
*
* CALLS:            None
*
* CALLED BY:        Anyone
*
* PROTOTYPE:        void set_address(unsigned int address);
*
*******************************************************************************
*/
void set_address (DWORD address)
{
    DWORD i;
    
    for (i = 0; i < 26; i++)
    {
        pin[addr_order[i]] = ((address >> i) & 1);
    }
}

/*
*******************************************************************************
*
* FUNCTION:         set_data
*
* DESCRIPTION:      Fills the chain with the data bits
*
* INPUT PARAMETERS: DWORD data
*
* RETURNS:          void
*
*******************************************************************************
*/
void set_data(DWORD data)
{
    DWORD i;
    
    for(i = 0; i < 32; i++)
    {
        pin[dat_order[i]] = ((data >> i) & 1);	// set data pins
    }
}

/*
*******************************************************************************
*
* FUNCTION:         set_pin_chip_select
*
* DESCRIPTION:      Sets chip selects depending on the address and the platform
*
* INPUT PARAMETERS: DWORD address
*
* RETURNS:          void
*
*******************************************************************************
*/

void set_pin_chip_select(DWORD address)
{
	    
	    	 if((address >= CSR_LADDR[0]) && (address < CSR_HADDR[0]))  pin[CSR1] = 0;
		else if((address >= CSR_LADDR[1]) && (address < CSR_HADDR[1]))  pin[CSR2] = 0;
		else if((address >= CSR_LADDR[2]) && (address < CSR_HADDR[2]))  pin[CSR3] = 0;
		else if((address >= CSR_LADDR[3]) && (address < CSR_HADDR[3]))  pin[CSR4] = 0;
		else if((address >= CSR_LADDR[4]) && (address < CSR_HADDR[4]))  pin[CSR5] = 0;
		else if((address >= CSR_LADDR[5]) && (address < CSR_HADDR[5]))  pin[CSR6] = 0;

		pin[p_nsdcas] = 0;
		
}

/*
*******************************************************************************
*
* FUNCTION:         clear_chip_selects
*
* DESCRIPTION:      reset all chip selects
*
* INPUT PARAMETERS: None
*
* RETURNS:          none
*
*******************************************************************************
*/

void clear_chip_selects()
{
    // Preset to default values 
	
		pin[ChipSelect0] = 1;
		pin[ChipSelect1] = 1;
		pin[ChipSelect2] = 1;
		pin[ChipSelect3] = 1;
		pin[ChipSelect4] = 1;
		pin[ChipSelect5] = 1;
		pin[p_nsdcas] = 1;
}
/*
*******************************************************************************
*
* FUNCTION:         mem_output_enable
*
* DESCRIPTION:      enable or disable memory output. This pin is connected to 
*                   the output enables of the memory device.
*
* INPUT PARAMETERS: int - enable or disable
*
* RETURNS:          void
*
*******************************************************************************
*/
void mem_output_enable(int endis)
{
    if (endis == ENABLE)
		pin[OutputEnable] = 0;
    else
		pin[OutputEnable] = 1;
}

/*
*******************************************************************************
*
* FUNCTION:         mem_write_enable
*
* DESCRIPTION:      enable or disable memory writes. This pin is connected to 
*                   the write enables of the memory device.
*
* INPUT PARAMETERS: int - enable or disable
*
* RETURNS:          void
*
*******************************************************************************
*/
void mem_write_enable(int endis)
{
    if (endis == ENABLE)
			pin[WriteEnable] = 0;
    else
			pin[WriteEnable] = 1;
}

/*
*******************************************************************************
*
* FUNCTION:         mem_data_driver
*
* DESCRIPTION:      Sets memory data pins to DRIVE or HIZ. 
*
* INPUT PARAMETERS: int - drive or highz
*
* RETURNS:          void
*
*******************************************************************************
*/

void mem_data_driver(int df)
{
	if (df == DRIVE)
	{
		pin[MdUpperControl] = 1;  
		pin[MdLowerControl] = 1;	// Note for Assabet: MdLowerControl = MdUpperControl 
	}
	else
	{
		pin[MdUpperControl] = 0;
		pin[MdLowerControl] = 0;	// Note for Assabet: MdLowerControl = MdUpperControl
	}
}

/*
*******************************************************************************
*
* FUNCTION:         mem_rw_mode
*
* DESCRIPTION:      Sets memory mode to READ or WRITE. 
*
* INPUT PARAMETERS: int - READ or WRITE
*
* RETURNS:          void
*
*******************************************************************************
*/
void mem_rw_mode(int rw)
{
    if (rw == WRITE)
			pin[ReadWriteMode] = 0;
    else
		    pin[ReadWriteMode] = 1;
}


/*
*******************************************************************************
*
* FUNCTION:         gpio_unlock_flash
*
* DESCRIPTION:      Sets the GPIO bits on the Mainstone that are keeping the 
*                   K3 flash locked. 
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void gpio_unlock_flash()
{

	if (UnlockFlashCtrl1 != 9999) 
	pin[UnlockFlashCtrl1] = UnlockFlashCtrl1Lev;

	if (UnlockFlashCtrl2 != 9999) 
	pin[UnlockFlashCtrl2] = UnlockFlashCtrl2Lev;

	if (UnlockFlashCtrl3 != 9999) 
	pin[UnlockFlashCtrl3] = UnlockFlashCtrl3Lev;

	if (UnlockFlashCtrl4 != 9999) 
	pin[UnlockFlashCtrl4] = UnlockFlashCtrl4Lev;

}

/*
*******************************************************************************
*
* FUNCTION:         gpio_lock_flash
*
* DESCRIPTION:      Clears the GPIO bits on the Mainstone to re-lock the 
*                   K3 flash. 
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void gpio_lock_flash()
{
	if (UnlockFlashCtrl1 != 9999) 
	pin[UnlockFlashCtrl1] = LockFlashCtrl1Lev;

	if (UnlockFlashCtrl2 != 9999) 
	pin[UnlockFlashCtrl2] = LockFlashCtrl2Lev;

	if (UnlockFlashCtrl3 != 9999) 
	pin[UnlockFlashCtrl3] = LockFlashCtrl3Lev;

	if (UnlockFlashCtrl4 != 9999) 
	pin[UnlockFlashCtrl4] = LockFlashCtrl4Lev;

}

/*
*******************************************************************************
*
* FUNCTION:         pre_IRSCAN
*
* DESCRIPTION:      Sets up the state machine to accept an IR SCAN
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void pre_IRSCAN()
{
    if(Debug_Mode)
    printf("begin pre-IR scan code\n");
    

    putp(1,0,IGNORE_PORT);	//Run-Test/Idle
    putp(1,0,IGNORE_PORT);	//Run-Test/Idle
    putp(1,0,IGNORE_PORT);	//Run-Test/Idle
    putp(1,0,IGNORE_PORT);	//Run-Test/Idle
    putp(1,1,IGNORE_PORT);
    putp(1,1,IGNORE_PORT);	//select IR scan
    putp(1,0,IGNORE_PORT);	//capture IR
    putp(1,0,IGNORE_PORT);	//shift IR
}

/*
*******************************************************************************
*
* FUNCTION:         post_IRSCAN
*
* DESCRIPTION:      Get back to IDLE after scanning in the instruction
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void post_IRSCAN()
{
    if(Debug_Mode)
    printf("begin post-IR scan code\n");
    
   	//putp(1,1,IGNORE_PORT);	//Exit1-IR

	putp(1,1,IGNORE_PORT);	//Update-IR
	putp(1,0,IGNORE_PORT);	//Run-Test/Idle
	putp(1,0,IGNORE_PORT);	//Run-Test/Idle
	putp(1,0,IGNORE_PORT);	//Run-Test/Idle
}

/*
*******************************************************************************
*
* FUNCTION:         pre_DRSCAN
*
* DESCRIPTION:      Sets up the state machine to accept an DR SCAN
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void pre_DRSCAN()
{
    if(Debug_Mode)
    printf("begin pre-DR scan code\n");
    
    
    putp(1,0,IGNORE_PORT);	//Run-Test/Idle
    putp(1,0,IGNORE_PORT);	//Run-Test/Idle
    putp(1,0,IGNORE_PORT);	//Run-Test/Idle
    putp(1,0,IGNORE_PORT);	//Run-Test/Idle
    putp(1,1,IGNORE_PORT);  //select DR scan
    putp(1,0,IGNORE_PORT);	//capture DR
//	putp(1,0,IGNORE_PORT);	//shift DR
}

/*
*******************************************************************************
*
* FUNCTION:         post_DRSCAN
*
* DESCRIPTION:      Get back to IDLE after scanning in the data register
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void post_DRSCAN()
{
    if(Debug_Mode)
    	printf("begin post-DR scan code\n");
    
	
    putp(1,1,IGNORE_PORT);	//Exit1-DR
	putp(1,1,IGNORE_PORT);	//Update-DR
	putp(1,0,IGNORE_PORT);	//Run-Test/Idle
	putp(1,0,IGNORE_PORT);	//Run-Test/Idle
	putp(1,0,IGNORE_PORT);	//Run-Test/Idle
}

/*
*******************************************************************************
*
* FUNCTION:         controller_scan_code
*
* DESCRIPTION:      clocks in a specified cotulla IR scan code
*
* INPUT PARAMETERS: int instruction code
*                   int read or ignore port
*                   int continue or terminate instruction stream
*
* RETURNS:          void
*
*******************************************************************************
*/
// NOTE: I think there is a bug here somewhere.	This procedure seems to work,
// but I think the count is off. Future debugging work required. The problem is
// that a 0x1 should be returned from the instruction register after each 
// valid instruction. I'm not getting this value back, but the instructions 
// appear to be valid because the system works. If this bug can be found, then
// the JTAG_TEST procedure could be used again. 

int controller_scan_code(int code, int rp, int ct)
{
    int i;
    int outval = 0;
    int tms = 0;
 //   int codebit;
    if(Debug_Mode)
    	printf("begin controller scan code = %x\n", code);
    
    
    for (i = 0; i < IrLength; i++)
    {
        if (ct == TERMINATE)
        {
            if (i == IrLength -1)
            {
                tms = 1;
            }
        }
        outval |= putp(((code & (1 << i)) >> i), tms, rp) << (IrLength - i - 1);
	   //	codebit = code & 1<<(IrLength -1 -i);
	   //	outval |= putp(codebit, tms, rp) << (IrLength -1 -i);		

    }
    if(Debug_Mode)
    	printf("Controller IR value: %X\n", outval);
    
    return outval;
}

/*
*******************************************************************************
*
* FUNCTION:         PZ_scan_code
*
* DESCRIPTION:      clocks in a specified PZxxxx IR scan code
*
* INPUT PARAMETERS: int code
*
* RETURNS:          void
*
*******************************************************************************
*/
int PZ_scan_code(int code, int rp, int ct)
{
    int i;
    int outval = 0;
    int tms = 0;
    
    if(Debug_Mode)
    	printf("begin PZ scan code\n");
    
    
    for (i = 0; i < PZ_IRLENGTH; i++)
    {
        if (ct == TERMINATE) 
        {
            if (i == PZ_IRLENGTH -1)
            {
                tms = 1;
            }
        }
        
        outval |= putp(((code & (1 << i)) >> i), tms, rp) << (PZ_IRLENGTH - i - 1);
    }
    return outval;
}

/*
*******************************************************************************
*
* FUNCTION:         other_bypass
*
* DESCRIPTION:      clocks in a bypass scan code for an arbitrary device
*
* INPUT PARAMETERS: int code
*
* RETURNS:          void
*
*******************************************************************************
*/
int other_bypass(int rp, int ct ,int length)
{
    int i;
    int outval = 0;
    int tms = 0;
    int code = 0;

    if(Debug_Mode)
    	printf("Putting Other Device in Bypass\n");
    
    for(i = 0; i < length; i++)
	{
		code |= 1 << i; // construct a universal bypass instruction
	}

    for (i = 0; i < length; i++)
    {
        if (ct == TERMINATE) 
        {
            if (i == length -1)
            {
                tms = 1;
            }
        }
        
        outval |= putp(((code & (1 << i)) >> i), tms, rp) << (length - i - 1);
    }
    return outval;
}

/*
*******************************************************************************
*
* FUNCTION:         jtag_test
*
* DESCRIPTION:      tests the JTAG connection by reading the steady state 
*                   instruction register.
*
* INPUT PARAMETERS: void
*
* RETURNS:          int - 0 if passed
*
*******************************************************************************
*/
void jtag_test()
{
    // set all devices into bypass mode as a safe instruction

    pre_IRSCAN();

		if (controller_scan_code(IR_Bypass, READ_PORT, TERMINATE) != 0x1)
		{
			error_out("Jtag test failure. Check connections and power.\n"); 
		}


    post_IRSCAN();
    
    printf("JTAG Test Passed\n");

}
/*
*******************************************************************************
*
* FUNCTION:         dump_chain
*
* DESCRIPTION:      This is a debug routine that dumps the contents of the 
*                   current boundary chain to the standard I/O.
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void dump_chain()
{
    DWORD addrdat = 0;
    DWORD obusdat = 0;
    DWORD ibusdat = 0;

    int i;
 
    printf("------------------------------------------------------\n");

	for(i = 0; i < 32; i++)	// convert serial data to single DWORD
	{
		obusdat = obusdat | (DWORD)(pin[dat_order[i]] << i);
    }
    printf("Data Bus (Output) = %X\n", obusdat);
    
	for(i = 0; i < 32; i++)	// convert serial data to single DWORD
	{
		ibusdat = ibusdat | (DWORD)(pin[input_dat_order[i]] << i);
	}
    printf("Data Bus (Input) = %X\n", ibusdat);

    for(i = 0; i < 26; i++) // convert address data into single DWORD
    {
        addrdat = addrdat | (DWORD)(pin[addr_order[i]] << i);
    }
    
    
    printf("Address Bus = %X\n", addrdat);
    printf("Flash address is: %X\n",addrdat >> 2);
    
	printf("Chip Select 0 = %d\n", pin[ChipSelect0]);
	
	// Bulverde or Dimebox shortchain cannot read bus data
	if(!PlatformIsBulverdeDimeboxShortChain)
	{
		printf("Chip Select 1 = %d\n", pin[ChipSelect1]);
		printf("Chip Select 2 = %d\n", pin[ChipSelect2]);
		printf("Chip Select 3 = %d\n", pin[ChipSelect3]);
		printf("Chip Select 4 = %d\n", pin[ChipSelect4]);
		printf("Chip Select 5 = %d\n", pin[ChipSelect5]);
	}

	printf("Mem Out Enable      = %d\n", pin[OutputEnable]);    
	printf("Mem Write Enable    = %d\n", pin[WriteEnable]);    
	printf("Mem READ/WRITE Mode = %d\n", pin[ReadWriteMode]);    
	printf("------------------------------------------------------\n");

}   



void usage()
	{
		UsageShown = true;
		printf("Usage:\n\n");
		printf(">JFLASHMM [*PLAT] [*IMAGE] [P, V, E] [ADDR] [INS, PAR] [NOD, DEB]\n\n");
		printf("* = required parameter\n");
		printf("Optional parameters assume the first item in the list.\n\n");
		printf("Where:\n\n");
		printf("[PLAT]	    =The name of the platform data file without the .DAT.\n");
		printf("[IMAGE]	    =The name of the image to program in flash.\n");
		printf("[P, V, E]   =(P)rogram and verify, (V)erify only, (E)rase device\n");
		printf("[ADDR]      =Hex byte address to start. No leading 0X, assumes 0\n");
		printf("[INS, PAR, WIG]  =Insight IJC cable, passive parallel, or Wiggler type cable\n");
		printf("[NOD, DEB]  =NODebug (Normal) or DEBug mode\n\n"); 
		printf("Example 1: JFlashmm DBPXA250 MyImage.bin P 0 INS\n");
		printf("Example 2: JFlashmm DBPXA250 MyImage.bin\n");
	}

/*
*******************************************************************************
*
* FUNCTION:         ParseAndLoad
*
* DESCRIPTION:      This procedure parses the data file and loads a global array
*					of strings that wlll be used to construct the rest of the  
*                   variables with the data acquired. The input file is a global.
*					Please refer to the data file for a description of the syntax. 
*
* INPUT PARAMETERS: Void
*
* RETURNS:          void
*
*******************************************************************************
*/
void ParseAndLoad()
{
	char element[132]; /* no word above 132 characters */
	int count = 0;
	unsigned long i = 0;
	bool comment = false;
	char firstchar[1] = "";

	// initialize the data array strings
	for(i=0; i<=MAX_DATA; i++)
	{
		strcpy(&WORDARRAY[i][0],"");
	}	


	if((data_file_pointer = fopen(data_filename, "rb")) == NULL)
	{
		printf("Cannot open input file: %s\n", data_filename);
		printf("This program supports platforms defined by DAT files\n");
		printf("contained in the directory. Please specify the platform\n");
		printf("by typing the name of the DAT file. Do not type the DAT extension.\n");
		exit(0);
	}
	else
	{ 
		if(Debug_Mode)
			printf("Parsing Platform Data File: %s\n", data_filename);

		// Display the file information stuff
		while( fscanf( data_file_pointer, " %s", element)!=EOF)
		{
			if(!strcmp("/*", element)) // found a begin of comments
			{
				comment = true;
			}
			else if(!strcmp("*/", element)) // found an end of comments
			{
				comment = false;
			}
			else
			{
				if(!comment)
				{
					// load up the data array with the raw strings
				   	strcpy(&WORDARRAY[count][0], element);
					
					if (Debug_Mode)
						printf("WORDARRAY: %d\t%s\n",count,element);
					
					count++;
				}
	    	}// end of else 
		}/* end of while construction */ 
	}// end of else
	
	// Certain data is used for validation of the file
	if(strcmp(VERSION_LOCK, &WORDARRAY[p_verlock][0]))
	{
		printf("Invalid Version Lock string. %s\n", &WORDARRAY[p_verlock][0]);
		printf("Please update your data file for this platform.\n");
		printf("This version of software is not compatible with the data file.\n");
		exit(0);
	}

	else if(strcmp("1111", &WORDARRAY[p_cp1][0]))
	{
		printf("Invalid Checkpoint number 1.\n");
		printf("You have corrupted data for this platform.\n");
		exit(0);
	}

	else if(strcmp("2222", &WORDARRAY[p_cp2][0]))
	{
		printf("Invalid Checkpoint number 2.\n");
		printf("You have corrupted data for this platform.\n");
		exit(0);
	}
	else if(strcmp("3333", &WORDARRAY[p_cp3][0]))
	{
		printf("Invalid Checkpoint number 3.\n");
		printf("You have corrupted data for this platform.\n");
		exit(0);
	}

	fclose(data_file_pointer);
		 
}// ParseAndLoad 

/*
*******************************************************************************
*
* FUNCTION:         ParseAndLoadFlashData
*
* DESCRIPTION:      This procedure parses the flash data file and loads a global array
*					of strings that will be used to construct the rest of the  
*                   variables with the data acquired. The input file is a global.
*					Please refer to the data file for a description of the syntax. 
*
* INPUT PARAMETERS: Void
*
* RETURNS:          void
*
*******************************************************************************
*/
void ParseAndLoadFlashData()
{
	char element[132]; /* no word above 132 characters */
	int count = 0;
	unsigned long i = 0;
	bool comment = false;
	char firstchar[1] = "";

	// initialize the data array strings
	for(i=0; i<=MAX_FLASH_DATA; i++)
	{
		strcpy(&FLASHWORDARRAY[i][0],"");
	}	


	if((flash_file_pointer = fopen(flash_data_filename, "rb")) == NULL)
	{
		// should never get here because we would not have been called if
		// the file doesn't exist. 
		printf("Flash data file not found\n");
		exit(1);
	}
	else
	{ 
		if(Debug_Mode)
			printf("Parsing Flash Data File: %s\n", flash_data_filename);

		// Display the file information stuff
		while( fscanf( flash_file_pointer, " %s", element)!=EOF)
		{
			if(!strcmp("/*", element)) // found a begin of comments
			{
				comment = true;
			}
			else if(!strcmp("*/", element)) // found an end of comments
			{
				comment = false;
			}
			else
			{
				if(!comment)
				{
					// load up the data array with the raw strings
				   	strcpy(&FLASHWORDARRAY[count][0], element);
					
					if (Debug_Mode)
						printf("FLASHWORDARRAY: %d\t%s\n",count,element);
					
					count++;
				}
	    	}// end of else 
		}/* end of while construction */ 
	}// end of else
	
	// Certain data is used for validation of the file
	if(strcmp(FLASH_VERSION_LOCK, &FLASHWORDARRAY[pf_verlock][0]))
	{
		printf("Invalid Version Lock string. %s\n", &FLASHWORDARRAY[pf_verlock][0]);
		printf("Please update your flash data file for this platform.\n");
		printf("This version of software is not compatible with the data file.\n");
		exit(0);
	}

	else if(strcmp("1111", &FLASHWORDARRAY[pf_cp1][0]))
	{
		printf("Invalid Checkpoint number 1.\n");
		printf("You have corrupted data for this platform.\n");
		exit(0);
	}


	fclose(flash_file_pointer);
		 
}// ParseAndLoad 

/*
*******************************************************************************
*
* FUNCTION:         convert_to_dword
*
* DESCRIPTION:      This procedure is used to convert a string that may be keyed 
*                   to be decimal data, hex data, or octal data into a numeric 
*					value.  
*
* INPUT PARAMETERS: char *
*
* RETURNS:          DWORD
*
*******************************************************************************
*/
DWORD convert_to_dword(char *element)
{
	DWORD return_value = 0;
	DWORD i;
	unsigned long hexword = 0x0;
	unsigned long octword = 0x0;

	// if we are expecting numeric data, then decipher the format

	// if the first character is alpha, then upper case it.
	if (islower(element[0]) || isupper(element[0]))
				element[0] = toupper(element[0]);

			if (element[0] == 'X') // a hex value
			{
				for(i = 0; i< 9; i++) // cannot be larger than 8 hex characters + 1
				{
					//strip off the format character
					element[i] = element[i+1];
				}
				// convert the string to a hex numeric value
				sscanf(element,"%x", &hexword);
				return_value = hexword;
			}
			else if (element[0] == 'O') // an octal value
			{
				for(i = 0; i< 12; i++) // cannot be larger than 11 octal chars + 1
				{
					element[i] = element[i+1];
				}
				// convert the string to an octal value
				sscanf(element,"%o", &octword);
				return_value = octword;
			}
			else 
			{
				// it must be a decimal value
				return_value = atoi(element);
			}

	return return_value;
}

/*
*******************************************************************************
*
* FUNCTION:         AnalyzeChain
* DESCRIPTION:      This procedure constructs a description of the devices on  
*                   the chain. Results are stored in Global variables. 
*					 
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void AnalyzeChain ()
{
	bool found_controller = false;
	int i;

	// init the globals
	for (i = 0; i < 5; i++)
	{
		DEVICESTATUS[i] = false;
		DEVICETYPE[i] = false;
		DEVICEIRLENGTH[i] = 0;
		DEVICEISLAST[i] = false;
	}

if (!strcmp("Enabled", &WORDARRAY[p_dev1_stat][0]))	DEVICESTATUS[0] = true;
if (!strcmp("Enabled", &WORDARRAY[p_dev2_stat][0]))	DEVICESTATUS[1] = true;
if (!strcmp("Enabled", &WORDARRAY[p_dev3_stat][0]))	DEVICESTATUS[2] = true;
if (!strcmp("Enabled", &WORDARRAY[p_dev4_stat][0]))	DEVICESTATUS[3] = true;
if (!strcmp("Enabled", &WORDARRAY[p_dev5_stat][0]))	DEVICESTATUS[4] = true;

if (!strcmp("Controller", &WORDARRAY[p_dev1_type][0]))	DEVICETYPE[0] = true;
if (!strcmp("Controller", &WORDARRAY[p_dev2_type][0]))	DEVICETYPE[1] = true;
if (!strcmp("Controller", &WORDARRAY[p_dev3_type][0]))	DEVICETYPE[2] = true;
if (!strcmp("Controller", &WORDARRAY[p_dev4_type][0]))	DEVICETYPE[3] = true;
if (!strcmp("Controller", &WORDARRAY[p_dev5_type][0]))	DEVICETYPE[4] = true;

if (!strcmp("Last", &WORDARRAY[p_dev1_islast][0])) DEVICEISLAST[0] = true;
if (!strcmp("Last", &WORDARRAY[p_dev2_islast][0])) DEVICEISLAST[1] = true;
if (!strcmp("Last", &WORDARRAY[p_dev3_islast][0])) DEVICEISLAST[2] = true;
if (!strcmp("Last", &WORDARRAY[p_dev4_islast][0])) DEVICEISLAST[3] = true;
if (!strcmp("Last", &WORDARRAY[p_dev5_islast][0])) DEVICEISLAST[4] = true;

DEVICEIRLENGTH[0] = convert_to_dword(&WORDARRAY[p_dev1_bits][0]);
DEVICEIRLENGTH[1] = convert_to_dword(&WORDARRAY[p_dev2_bits][0]);
DEVICEIRLENGTH[2] = convert_to_dword(&WORDARRAY[p_dev3_bits][0]);
DEVICEIRLENGTH[3] = convert_to_dword(&WORDARRAY[p_dev4_bits][0]);
DEVICEIRLENGTH[4] = convert_to_dword(&WORDARRAY[p_dev5_bits][0]);

for(i=0; i<5; i++)
{
if(DEVICETYPE[i]) DEVICE_CONTROLLER = i;
}


for(i=0; i<5; i++)
{
	if (DEVICESTATUS[i])
	{
		DEVICES_IN_CHAIN++;
		if(DEVICETYPE[i]) 
		{
			found_controller = true;
		} 

		else if(found_controller)
		{
			DEVICES_AFTER++;	
		}
		else
		{
			DEVICES_BEFORE++;
		}
	}
}

if(Debug_Mode)
{
	printf("Devices_before = %d\n", DEVICES_BEFORE);
	printf("Devices_after  = %d\n", DEVICES_AFTER);
	printf("Device controller at position %d\n", DEVICE_CONTROLLER);

}

}

/*
*******************************************************************************
*
* FUNCTION:         InitPinArray
* DESCRIPTION:      This procedure creates the default pin array by setting  
*                   the initial state of all of the pins. 
*					 
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void InitPinArray()
{
	DWORD i;

	// initialize the pin array
	for(i=0; i<ChainLength; i++)
	{
		pin[i] = 0;
	}
	
	// stuff the pin array with the pins we want to be high all of the time

	for(i = p_nh1; i <= p_nh47; i++)
	{
		if(strcmp("9999", &WORDARRAY[i][0]))
		{
			pin[convert_to_dword(&WORDARRAY[i][0])] = 1;
		}		
	}

}
/*
*******************************************************************************
*
* FUNCTION:         InitLockUnlock
* DESCRIPTION:      This procedure sets up any external lock or unlock  
*                   controls for the board.  
*					 
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void InitLockUnlock()
{

	// first determine if we have any controls

	if(
		(strcmp("9999", &WORDARRAY[p_unlctl1][0])) ||
		(strcmp("9999", &WORDARRAY[p_unlctl2][0])) ||
		(strcmp("9999", &WORDARRAY[p_unlctl3][0])) ||
		(strcmp("9999", &WORDARRAY[p_unlctl4][0]))
	  )
	  	HASLOCKCONTROLS = true;

	if(HASLOCKCONTROLS)
	{
	    
		UnlockFlashCtrl1 = convert_to_dword(&WORDARRAY[p_unlctl1][0]);		// unlock flash control pin 1
		UnlockFlashCtrl2 = convert_to_dword(&WORDARRAY[p_unlctl2][0]);		// unlock flash control pin 2
		UnlockFlashCtrl3 = convert_to_dword(&WORDARRAY[p_unlctl3][0]);		// unlock flash control pin 3
		UnlockFlashCtrl4 = convert_to_dword(&WORDARRAY[p_unlctl4][0]);		// unlock flash control pin 4

		if(!strcmp("1", &WORDARRAY[p_unlctl1_lev][0]))
		{
		 	UnlockFlashCtrl1Lev = 1;
		 	LockFlashCtrl1Lev = 0;
		} 	
		else
		{
			UnlockFlashCtrl1Lev = 0;
		 	LockFlashCtrl1Lev = 1; 	
		}

		if(!strcmp("1", &WORDARRAY[p_unlctl2_lev][0]))
		{
		 	UnlockFlashCtrl2Lev = 1;
		 	LockFlashCtrl2Lev = 0;
		} 	
		else
		{
			UnlockFlashCtrl2Lev = 0;
		 	LockFlashCtrl2Lev = 1; 	
		}
		if(!strcmp("1", &WORDARRAY[p_unlctl3_lev][0]))
		{
		 	UnlockFlashCtrl3Lev = 1;
		 	LockFlashCtrl3Lev = 0;
		} 	
		else
		{
			UnlockFlashCtrl3Lev = 0;
		 	LockFlashCtrl3Lev = 1; 	
		}
		if(!strcmp("1", &WORDARRAY[p_unlctl4_lev][0]))
		{
		 	UnlockFlashCtrl4Lev = 1;
		 	LockFlashCtrl4Lev = 0;
		} 	
		else
		{
			UnlockFlashCtrl4Lev = 0;
		 	LockFlashCtrl4Lev = 1; 	
		}
	}
}
/*
*******************************************************************************
*
* FUNCTION:         InitAddressOrder
* DESCRIPTION:      This procedure fills the address bit array  
*                    
*					 
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/

void InitAddressOrder()
{
	addr_order[0] = convert_to_dword(&WORDARRAY[p_a0][0]);
	addr_order[1] = convert_to_dword(&WORDARRAY[p_a1][0]);
	addr_order[2] = convert_to_dword(&WORDARRAY[p_a2][0]);
	addr_order[3] = convert_to_dword(&WORDARRAY[p_a3][0]);
	addr_order[4] = convert_to_dword(&WORDARRAY[p_a4][0]);
	addr_order[5] = convert_to_dword(&WORDARRAY[p_a5][0]);
	addr_order[6] = convert_to_dword(&WORDARRAY[p_a6][0]);
	addr_order[7] = convert_to_dword(&WORDARRAY[p_a7][0]);
	addr_order[8] = convert_to_dword(&WORDARRAY[p_a8][0]);
	addr_order[9] = convert_to_dword(&WORDARRAY[p_a9][0]);
	addr_order[10] = convert_to_dword(&WORDARRAY[p_a10][0]);
	addr_order[11] = convert_to_dword(&WORDARRAY[p_a11][0]);
	addr_order[12] = convert_to_dword(&WORDARRAY[p_a12][0]);
	addr_order[13] = convert_to_dword(&WORDARRAY[p_a13][0]);
	addr_order[14] = convert_to_dword(&WORDARRAY[p_a14][0]);
	addr_order[15] = convert_to_dword(&WORDARRAY[p_a15][0]);
	addr_order[16] = convert_to_dword(&WORDARRAY[p_a16][0]);
	addr_order[17] = convert_to_dword(&WORDARRAY[p_a17][0]);
	addr_order[18] = convert_to_dword(&WORDARRAY[p_a18][0]);
	addr_order[19] = convert_to_dword(&WORDARRAY[p_a19][0]);
	addr_order[20] = convert_to_dword(&WORDARRAY[p_a20][0]);
	addr_order[21] = convert_to_dword(&WORDARRAY[p_a21][0]);
	addr_order[22] = convert_to_dword(&WORDARRAY[p_a22][0]);
	addr_order[23] = convert_to_dword(&WORDARRAY[p_a23][0]);
	addr_order[24] = convert_to_dword(&WORDARRAY[p_a24][0]);
	addr_order[25] = convert_to_dword(&WORDARRAY[p_a25][0]);


}

/*
*******************************************************************************
*
* FUNCTION:         InitInputDataOrder
* DESCRIPTION:      This procedure fills the input data bit array  
*                    
*					 
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void InitInputDataOrder()
{
   input_dat_order[0] = convert_to_dword(&WORDARRAY[p_d0in][0]);
   input_dat_order[1] = convert_to_dword(&WORDARRAY[p_d1in][0]);
   input_dat_order[2] = convert_to_dword(&WORDARRAY[p_d2in][0]);
   input_dat_order[3] = convert_to_dword(&WORDARRAY[p_d3in][0]);
   input_dat_order[4] = convert_to_dword(&WORDARRAY[p_d4in][0]);
   input_dat_order[5] = convert_to_dword(&WORDARRAY[p_d5in][0]);
   input_dat_order[6] = convert_to_dword(&WORDARRAY[p_d6in][0]);
   input_dat_order[7] = convert_to_dword(&WORDARRAY[p_d7in][0]);
   input_dat_order[8] = convert_to_dword(&WORDARRAY[p_d8in][0]);
   input_dat_order[9] = convert_to_dword(&WORDARRAY[p_d9in][0]);
   input_dat_order[10] = convert_to_dword(&WORDARRAY[p_d10in][0]);
   input_dat_order[11] = convert_to_dword(&WORDARRAY[p_d11in][0]);
   input_dat_order[12] = convert_to_dword(&WORDARRAY[p_d12in][0]);
   input_dat_order[13] = convert_to_dword(&WORDARRAY[p_d13in][0]);
   input_dat_order[14] = convert_to_dword(&WORDARRAY[p_d14in][0]);
   input_dat_order[15] = convert_to_dword(&WORDARRAY[p_d15in][0]);
   input_dat_order[16] = convert_to_dword(&WORDARRAY[p_d16in][0]);
   input_dat_order[17] = convert_to_dword(&WORDARRAY[p_d17in][0]);
   input_dat_order[18] = convert_to_dword(&WORDARRAY[p_d18in][0]);
   input_dat_order[19] = convert_to_dword(&WORDARRAY[p_d19in][0]);
   input_dat_order[20] = convert_to_dword(&WORDARRAY[p_d20in][0]);
   input_dat_order[21] = convert_to_dword(&WORDARRAY[p_d21in][0]);
   input_dat_order[22] = convert_to_dword(&WORDARRAY[p_d22in][0]);
   input_dat_order[23] = convert_to_dword(&WORDARRAY[p_d23in][0]);
   input_dat_order[24] = convert_to_dword(&WORDARRAY[p_d24in][0]);
   input_dat_order[25] = convert_to_dword(&WORDARRAY[p_d25in][0]);
   input_dat_order[26] = convert_to_dword(&WORDARRAY[p_d26in][0]);
   input_dat_order[27] = convert_to_dword(&WORDARRAY[p_d27in][0]);
   input_dat_order[28] = convert_to_dword(&WORDARRAY[p_d28in][0]);
   input_dat_order[29] = convert_to_dword(&WORDARRAY[p_d29in][0]);
   input_dat_order[30] = convert_to_dword(&WORDARRAY[p_d30in][0]);
   input_dat_order[31] = convert_to_dword(&WORDARRAY[p_d31in][0]);

}

/*
*******************************************************************************
*
* FUNCTION:         InitOutputDataOrder
* DESCRIPTION:      This procedure fills the output data bit array  
*                    
*					 
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void InitOutputDataOrder()
{
   dat_order[0] = convert_to_dword(&WORDARRAY[p_d0out][0]);
   dat_order[1] = convert_to_dword(&WORDARRAY[p_d1out][0]);
   dat_order[2] = convert_to_dword(&WORDARRAY[p_d2out][0]);
   dat_order[3] = convert_to_dword(&WORDARRAY[p_d3out][0]);
   dat_order[4] = convert_to_dword(&WORDARRAY[p_d4out][0]);
   dat_order[5] = convert_to_dword(&WORDARRAY[p_d5out][0]);
   dat_order[6] = convert_to_dword(&WORDARRAY[p_d6out][0]);
   dat_order[7] = convert_to_dword(&WORDARRAY[p_d7out][0]);
   dat_order[8] = convert_to_dword(&WORDARRAY[p_d8out][0]);
   dat_order[9] = convert_to_dword(&WORDARRAY[p_d9out][0]);
   dat_order[10] = convert_to_dword(&WORDARRAY[p_d10out][0]);
   dat_order[11] = convert_to_dword(&WORDARRAY[p_d11out][0]);
   dat_order[12] = convert_to_dword(&WORDARRAY[p_d12out][0]);
   dat_order[13] = convert_to_dword(&WORDARRAY[p_d13out][0]);
   dat_order[14] = convert_to_dword(&WORDARRAY[p_d14out][0]);
   dat_order[15] = convert_to_dword(&WORDARRAY[p_d15out][0]);
   dat_order[16] = convert_to_dword(&WORDARRAY[p_d16out][0]);
   dat_order[17] = convert_to_dword(&WORDARRAY[p_d17out][0]);
   dat_order[18] = convert_to_dword(&WORDARRAY[p_d18out][0]);
   dat_order[19] = convert_to_dword(&WORDARRAY[p_d19out][0]);
   dat_order[20] = convert_to_dword(&WORDARRAY[p_d20out][0]);
   dat_order[21] = convert_to_dword(&WORDARRAY[p_d21out][0]);
   dat_order[22] = convert_to_dword(&WORDARRAY[p_d22out][0]);
   dat_order[23] = convert_to_dword(&WORDARRAY[p_d23out][0]);
   dat_order[24] = convert_to_dword(&WORDARRAY[p_d24out][0]);
   dat_order[25] = convert_to_dword(&WORDARRAY[p_d25out][0]);
   dat_order[26] = convert_to_dword(&WORDARRAY[p_d26out][0]);
   dat_order[27] = convert_to_dword(&WORDARRAY[p_d27out][0]);
   dat_order[28] = convert_to_dword(&WORDARRAY[p_d28out][0]);
   dat_order[29] = convert_to_dword(&WORDARRAY[p_d29out][0]);
   dat_order[30] = convert_to_dword(&WORDARRAY[p_d30out][0]);
   dat_order[31] = convert_to_dword(&WORDARRAY[p_d31out][0]);

}
/*
*******************************************************************************
*
* FUNCTION:         InitChipSelectRegions
* DESCRIPTION:      This procedure sets the global chip select regions  
*                    
*					 
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/

void InitChipSelectRegions()
{

	// address ranges
	CSR_LADDR[0] = convert_to_dword(&WORDARRAY[p_m_reg1_low][0]);
	CSR_HADDR[0] = convert_to_dword(&WORDARRAY[p_m_reg1_high][0]);
	CSR_LADDR[1] = convert_to_dword(&WORDARRAY[p_m_reg2_low][0]);
	CSR_HADDR[1] = convert_to_dword(&WORDARRAY[p_m_reg2_high][0]);
	CSR_LADDR[2] = convert_to_dword(&WORDARRAY[p_m_reg3_low][0]);
	CSR_HADDR[2] = convert_to_dword(&WORDARRAY[p_m_reg3_high][0]);
	CSR_LADDR[3] = convert_to_dword(&WORDARRAY[p_m_reg4_low][0]);
	CSR_HADDR[3] = convert_to_dword(&WORDARRAY[p_m_reg4_high][0]);
	CSR_LADDR[4] = convert_to_dword(&WORDARRAY[p_m_reg5_low][0]);
	CSR_HADDR[4] = convert_to_dword(&WORDARRAY[p_m_reg5_high][0]);
	CSR_LADDR[5] = convert_to_dword(&WORDARRAY[p_m_reg6_low][0]);
	CSR_HADDR[5] = convert_to_dword(&WORDARRAY[p_m_reg6_high][0]);

	// the chip select for the range

	CSR1 = GetChipSelect(convert_to_dword(&WORDARRAY[p_m_reg1_cs][0]));
	CSR2 = GetChipSelect(convert_to_dword(&WORDARRAY[p_m_reg2_cs][0]));
	CSR3 = GetChipSelect(convert_to_dword(&WORDARRAY[p_m_reg3_cs][0]));
	CSR4 = GetChipSelect(convert_to_dword(&WORDARRAY[p_m_reg4_cs][0]));
	CSR5 = GetChipSelect(convert_to_dword(&WORDARRAY[p_m_reg5_cs][0]));
	CSR6 = GetChipSelect(convert_to_dword(&WORDARRAY[p_m_reg6_cs][0]));


}
/*
*******************************************************************************
*
* FUNCTION:         GetChipSelect
* DESCRIPTION:      This procedure translates a numeric string to the actual
*					offset for a chip select.  
*                    
*					 
*
* INPUT PARAMETERS: DWORD
*
* RETURNS:          DWORD
*
*******************************************************************************
*/
 

DWORD GetChipSelect(DWORD cs)
{
	
	switch(cs)
		{
			case 0:
				return convert_to_dword(&WORDARRAY[p_cs0][0]);
				break;
			case 1:
				return convert_to_dword(&WORDARRAY[p_cs1][0]);
				break;
			case 2:
				return convert_to_dword(&WORDARRAY[p_cs2][0]);
				break;
			case 3:
				return convert_to_dword(&WORDARRAY[p_cs3][0]);
				break;
			case 4:
				return convert_to_dword(&WORDARRAY[p_cs4][0]);
				break;
			case 5:
				return convert_to_dword(&WORDARRAY[p_cs5][0]);
				break;
			default:
				printf("Illegal chip select chosen!\n");
				printf("Define memory regions with chips selects\n");
				printf("from 0 to 5.\n");
				exit(0);

		}

}

/*
*******************************************************************************
*
* FUNCTION:         InitFlashGlobals
* DESCRIPTION:      This procedure sets the global flash data  
*                    
*					 
*
* INPUT PARAMETERS: void
*
* RETURNS:          void
*
*******************************************************************************
*/
void InitFlashGlobals()
{

	REGION_STATUS[0] = false;
	REGION_STATUS[1] = false;
	REGION_STATUS[2] = false;
	REGION_STATUS[3] = false;
	REGION_STATUS[4] = false;
	REGION_STATUS[5] = false;
	REGION_STATUS[6] = false;
	REGION_STATUS[7] = false;
	REGION_STATUS[8] = false;
	REGION_STATUS[9] = false;

	BlockEraseTime = convert_to_dword(&FLASHWORDARRAY[pf_ertime][0]);
	FlashBufferSize = convert_to_dword(&FLASHWORDARRAY[pf_bufsize][0]);
	
	if(!strcmp("enabled", &FLASHWORDARRAY[pf_reg0status][0]))	REGION_STATUS[0] = true;
	if(!strcmp("enabled", &FLASHWORDARRAY[pf_reg1status][0]))	REGION_STATUS[1] = true;
	if(!strcmp("enabled", &FLASHWORDARRAY[pf_reg2status][0]))	REGION_STATUS[2] = true;
	if(!strcmp("enabled", &FLASHWORDARRAY[pf_reg3status][0]))	REGION_STATUS[3] = true;
	if(!strcmp("enabled", &FLASHWORDARRAY[pf_reg4status][0]))	REGION_STATUS[4] = true;
	if(!strcmp("enabled", &FLASHWORDARRAY[pf_reg5status][0]))	REGION_STATUS[5] = true;
	if(!strcmp("enabled", &FLASHWORDARRAY[pf_reg6status][0]))	REGION_STATUS[6] = true;
	if(!strcmp("enabled", &FLASHWORDARRAY[pf_reg7status][0]))	REGION_STATUS[7] = true;
	if(!strcmp("enabled", &FLASHWORDARRAY[pf_reg8status][0]))	REGION_STATUS[8] = true;
	if(!strcmp("enabled", &FLASHWORDARRAY[pf_reg9status][0]))	REGION_STATUS[9] = true;

	REGION_NUM_BLOCKS[0] = convert_to_dword(&FLASHWORDARRAY[pf_reg0number][0]);
	REGION_BLOCKSIZE[0]  = convert_to_dword(&FLASHWORDARRAY[pf_reg0blsize][0]);
	REGION_START_ADDR[0] = convert_to_dword(&FLASHWORDARRAY[pf_reg0start][0]);
	REGION_END_ADDR[0]	 = convert_to_dword(&FLASHWORDARRAY[pf_reg0end][0]);
	REGION_NUM_BLOCKS[1] = convert_to_dword(&FLASHWORDARRAY[pf_reg1number][0]);
	REGION_BLOCKSIZE[1]  = convert_to_dword(&FLASHWORDARRAY[pf_reg1blsize][0]);
	REGION_START_ADDR[1] = convert_to_dword(&FLASHWORDARRAY[pf_reg1start][0]);
	REGION_END_ADDR[1]	 = convert_to_dword(&FLASHWORDARRAY[pf_reg1end][0]);
	REGION_NUM_BLOCKS[2] = convert_to_dword(&FLASHWORDARRAY[pf_reg2number][0]);
	REGION_BLOCKSIZE[2]  = convert_to_dword(&FLASHWORDARRAY[pf_reg2blsize][0]);
	REGION_START_ADDR[2] = convert_to_dword(&FLASHWORDARRAY[pf_reg2start][0]);
	REGION_END_ADDR[2]	 = convert_to_dword(&FLASHWORDARRAY[pf_reg2end][0]);
	REGION_NUM_BLOCKS[3] = convert_to_dword(&FLASHWORDARRAY[pf_reg3number][0]);
	REGION_BLOCKSIZE[3]  = convert_to_dword(&FLASHWORDARRAY[pf_reg3blsize][0]);
	REGION_START_ADDR[3] = convert_to_dword(&FLASHWORDARRAY[pf_reg3start][0]);
	REGION_END_ADDR[3]	 = convert_to_dword(&FLASHWORDARRAY[pf_reg3end][0]);
	REGION_NUM_BLOCKS[4] = convert_to_dword(&FLASHWORDARRAY[pf_reg4number][0]);
	REGION_BLOCKSIZE[4]  = convert_to_dword(&FLASHWORDARRAY[pf_reg4blsize][0]);
	REGION_START_ADDR[4] = convert_to_dword(&FLASHWORDARRAY[pf_reg4start][0]);
	REGION_END_ADDR[4]	 = convert_to_dword(&FLASHWORDARRAY[pf_reg4end][0]);
	REGION_NUM_BLOCKS[5] = convert_to_dword(&FLASHWORDARRAY[pf_reg5number][0]);
	REGION_BLOCKSIZE[5]  = convert_to_dword(&FLASHWORDARRAY[pf_reg5blsize][0]);
	REGION_START_ADDR[5] = convert_to_dword(&FLASHWORDARRAY[pf_reg5start][0]);
	REGION_END_ADDR[5]	 = convert_to_dword(&FLASHWORDARRAY[pf_reg5end][0]);
	REGION_NUM_BLOCKS[6] = convert_to_dword(&FLASHWORDARRAY[pf_reg6number][0]);
	REGION_BLOCKSIZE[6]  = convert_to_dword(&FLASHWORDARRAY[pf_reg6blsize][0]);
	REGION_START_ADDR[6] = convert_to_dword(&FLASHWORDARRAY[pf_reg6start][0]);
	REGION_END_ADDR[6]	 = convert_to_dword(&FLASHWORDARRAY[pf_reg6end][0]);
	REGION_NUM_BLOCKS[7] = convert_to_dword(&FLASHWORDARRAY[pf_reg7number][0]);
	REGION_BLOCKSIZE[7]  = convert_to_dword(&FLASHWORDARRAY[pf_reg7blsize][0]);
	REGION_START_ADDR[7] = convert_to_dword(&FLASHWORDARRAY[pf_reg7start][0]);
	REGION_END_ADDR[7]	 = convert_to_dword(&FLASHWORDARRAY[pf_reg7end][0]);
	REGION_NUM_BLOCKS[8] = convert_to_dword(&FLASHWORDARRAY[pf_reg8number][0]);
	REGION_BLOCKSIZE[8]  = convert_to_dword(&FLASHWORDARRAY[pf_reg8blsize][0]);
	REGION_START_ADDR[8] = convert_to_dword(&FLASHWORDARRAY[pf_reg8start][0]);
	REGION_END_ADDR[8]	 = convert_to_dword(&FLASHWORDARRAY[pf_reg8end][0]);
	REGION_NUM_BLOCKS[9] = convert_to_dword(&FLASHWORDARRAY[pf_reg9number][0]);
	REGION_BLOCKSIZE[9]  = convert_to_dword(&FLASHWORDARRAY[pf_reg9blsize][0]);
	REGION_START_ADDR[9] = convert_to_dword(&FLASHWORDARRAY[pf_reg9start][0]);
	REGION_END_ADDR[9]	 = convert_to_dword(&FLASHWORDARRAY[pf_reg9end][0]);

	// compute FlashDeviceSize. It is the address of the end of the last 
	// block +1.

	if (REGION_STATUS[0]) FlashDeviceSize = REGION_END_ADDR[0] + 1ul; 
	if (REGION_STATUS[1]) FlashDeviceSize = REGION_END_ADDR[1] + 1ul; 
	if (REGION_STATUS[2]) FlashDeviceSize = REGION_END_ADDR[2] + 1ul; 
	if (REGION_STATUS[3]) FlashDeviceSize = REGION_END_ADDR[3] + 1ul; 
	if (REGION_STATUS[4]) FlashDeviceSize = REGION_END_ADDR[4] + 1ul; 
	if (REGION_STATUS[5]) FlashDeviceSize = REGION_END_ADDR[5] + 1ul; 
	if (REGION_STATUS[6]) FlashDeviceSize = REGION_END_ADDR[6] + 1ul; 
	if (REGION_STATUS[7]) FlashDeviceSize = REGION_END_ADDR[7] + 1ul; 
	if (REGION_STATUS[8]) FlashDeviceSize = REGION_END_ADDR[8] + 1ul; 
	if (REGION_STATUS[9]) FlashDeviceSize = REGION_END_ADDR[9] + 1ul; 

	
}

/*
*******************************************************************************
*
* FUNCTION:         EraseBlocks
* DESCRIPTION:      This procedure computes which blocks need to be erased  
*                   by using the file size, the base address, and the memory
*					map of the flash memory. The blocks are then erased. Blocks
*                   are  unlocked  as needed with no warning.  
*					 
*
* INPUT PARAMETERS: base  address, filesize
*
* RETURNS:          void
*
*******************************************************************************
*/
void EraseBlocks(DWORD baseaddress, DWORD filesize)
{
	int region = 0;
	int i;
	DWORD blockaddress = 0;
	DWORD regionstart = 0;
	DWORD regionend = 0;
	DWORD endaddress = 0;
	bool erasedone = false;
	bool found_top = false;
	int total_blocks = 0;
	int block_count;
	bool erasing_on = false;
	int top_block = 0;
	int bottom_block = 0;

	endaddress = baseaddress + filesize;
	
	if(Debug_Mode)
		printf("endaddress: %x, baseaddress: %x, filesize: %x FlashDeviceSize: %x\n", endaddress *ADDR_MULT, baseaddress*ADDR_MULT, filesize * ADDR_MULT, FlashDeviceSize);

	if (baseaddress > FlashDeviceSize)
		error_out("Start address is outside of Flash memory");

	if (endaddress > FlashDeviceSize)
		error_out("End of file is outside of Flash memory");

	// generate a list of addresses of all of the blocks
	// limit is 512 blocks.

	// init the block address array
	for(i = 0; i < 512; i++)
	{ 
		BLOCK_ADDRESS[i] = 0;
	}

	// get the total number of blocks in this memory space
	
	for(i = 0; i < 10; i++)
	{
		if(REGION_STATUS[i])
		 total_blocks += REGION_NUM_BLOCKS[i];
	}

	// stuff the array with real addresses
	// element 0 must always be 0.
	
	block_count = 0;
	for(region = 0; region < 10; region++)
	{
		for(i=0; i < (int)REGION_NUM_BLOCKS[region]; i++)
		{
			BLOCK_ADDRESS[block_count] = 
				REGION_START_ADDR[region]/ADDR_MULT + (i * REGION_BLOCKSIZE[region]);
			
			block_count++;	
		}		
	}

	if(Debug_Mode)
	{
		for (i= 0; i< 512; i++)
		{
			if(BLOCK_ADDRESS[i] != 0)
			printf("Block number %d is at address %x\n",i, BLOCK_ADDRESS[i]);
		}
	}

	// Erase blocks at the addresses where the input binary will live

	// find the block at the top
	
	for (i = total_blocks -1 ; i >= 0 ; i--)
	{
	   if (BLOCK_ADDRESS[i] <= endaddress)
	   	{
	   		top_block = i;
	   		break;
	   	}	
	}	

	// find the bottom block
	for (i = 0; i <= top_block; i++)
	{
	   if ((BLOCK_ADDRESS[i] <= baseaddress) && (BLOCK_ADDRESS[i+1] > baseaddress))
	   	{
	   		bottom_block = i;
	   		break;
	   	}
		else // the start address is in the highest block
		{
			bottom_block = top_block;
		}
	}
	
	// erase all of the blocks in between
	for (i = bottom_block; i<= top_block; i++)
	{
		UnlockAndEraseBlock(BLOCK_ADDRESS[i]);
	}	

}
/*
*******************************************************************************
*
* FUNCTION:         UnlockAndEraseBlock
* DESCRIPTION:      This is a support procedure for EraseBlocks. This procedure
*					contains the actual unlock and erase procedure, and 
*					EraseBlocks computes where this procedure is applied.   
*					 
*
* INPUT PARAMETERS: address of block
*
* RETURNS:          void
*
*******************************************************************************
*/
void UnlockAndEraseBlock(DWORD blockaddress)
{

#define allowerase
#ifdef allowerase

	
	time_t start, now;
	DWORD lockstatus;

	// unlock the block
	Write_Rom(blockaddress, F_READ_ARRAY);	
	Write_Rom(blockaddress, F_READ_IDCODES);// Read Identifier Codes


	access_rom(READ, blockaddress + 2, 0, IGNORE_PORT); // read lock configuration (extra read to get JTAG pipeline going)
	lockstatus = Read_Rom(blockaddress + 2);
	if((lockstatus == 0x10001) || (lockstatus == 0x10000) || (lockstatus == 0x00001))
	{
		Write_Rom(blockaddress, F_CLEAR_BLOCK_LOCK); // Clear block lock bit command
		Write_Rom(blockaddress, F_CLEAR_BLOCK_LOCK_2ND);// Confirm

		time(&start);
		printf("Unlocking block at address %x\n", blockaddress * ADDR_MULT);
		while(access_rom(RS, 0, 0, READ_PORT) != F_STATUS_READY)	// Loop until successful status return 0x0080
			{
				Read_Rom(blockaddress);
				time(&now);
				if(difftime(now,start) > BlockEraseTime + 1)	// Check for status timeout
					error_out("\nError, Clear lock timed out");
			}

	}

	// erase the block
	Write_Rom(blockaddress, F_BLOCK_ERASE);		// Erase block command
	Write_Rom(blockaddress, F_BLOCK_ERASE_2ND);	// Erase confirm at the block address

	time(&start);
	printf("Erasing block at address %x   \n",blockaddress * ADDR_MULT);
	while(access_rom(RS, 0, 0, READ_PORT) != F_STATUS_READY)	// Loop until successful status return
		{
			Read_Rom(blockaddress);
			time(&now);
			if(difftime(now,start) > BlockEraseTime + 1)	// Check for erase timeout
				error_out("Error, Block erase timed out");
		}
#endif // allowerase
}

/*
*******************************************************************************
*
* FUNCTION:         xscale_init_handler
* DESCRIPTION:      This procedure sets up for high speed download using 
*					Xscale JTAG machinery  
*					 
*
* INPUT PARAMETERS: void
*
* RETURNS:          0 = success, 1=failure
*
*******************************************************************************
*/

int xscale_init_handler() {
//	unsigned long idcode;
	unsigned long dummy;
	int i;
//	char dbuf[80];

	xilinx_mode(1);		// Xilinx mode with processor reset
	test_logic_reset();
	test_logic_reset();
	//ms_delay(600);
	Sleep(600);	 // Windows call - needs porting to other OS
	jtag_rti();

	xscale_dcsr(0x40010000,0,1);	// hold reset
	jtag_rti();

	xilinx_mode(0);		//	RESET_INACTIVE -  processor in hold_reset
	//ms_delay(600);
	Sleep(600);		// Windows call - needs porting to other OS
	for (i=0; i<2048; i++)
		jtag_rti();

	xscale_dcsr(0x40010000,0,1);	// hold reset
	jtag_rti();

	for (i=0; i<10000; i++)
		jtag_rti();

	dh_pos = 0;

	while(dh_pos < dh_size) {
		if(dh_pos ==0) {
			dbg_handler[0] = 0xeac00006;
			xscale_load_line(dh_pos, &dbg_handler[(dh_pos>>2)]);
		}
		else
		 xscale_load_line(0xff000000|dh_pos, &dbg_handler[(dh_pos>>2)]);
		dh_pos += 32;
	}

	for (i=0; i<32; i++)
		jtag_rti();

	xscale_dcsr(0x40010000,0,0);	// hold reset now Inactive!
//	xscale_dcsr(0x40010000,0,0);	// hold reset now Inactive!
	jtag_rti();
/* Target is now running */

	if(xscale_tx_rd(&r14))
		return 3;					// error no data returned

	printf("In reset handler, r14=%#010x\n",r14);

	xscale_rx_wr(0xf1a54003);	// flash read
	xscale_rx_wr(4);		// start address
	xscale_rx_wr(7);		// 7 unsigned longs

	for(i=1; i<8; i++) {
		xscale_tx_rd(&dbg_handler[i]);
		printf("dbg_handler[%d]=%x\n",i,dbg_handler[i]);
	}
	if(xscale_tx_rd(&dummy))
		return 3;						// error: no data returned

	xscale_load_line(0, dbg_handler);	// merge user's line 0

	for (i=0; i<32; i++)
		jtag_rti();

	return 0;
}

/******************************************************************************
	Notes on controlling the cable:

	Bit7 Bit6 Bit5 Bit4 Bit3 Bit2 Bit1 Bit0
	0     { MODE}  X    RST {  MUX       }

	Bits 6&5 are the mode

	00 = Xilinx Mode
	01 = HighSpeed Mode
	10 = Altera Mode
	11 = ISP programming mode (Access the Blackstone CPLD)

	Bit 3 is the Reset bit (inverted nSreset)

	Bits 2,1,0 is the MUX field for HighSpeed mode.

	To write the value:  An ECP command write of the new value is all you need.

	To fake the ECP command write:

	nSelectin signal must be high, nInit must be high, nAF must be low
	THEN place the magic byte on the data port.
	THEN assert strobe, then de-assert strobe
	THEN finally bring nSelectin low, and nAF high

	You can follow the code below:

	nSelectin low, nInit high, nAF high, nStrobe high:   _outp(CONTROL, 0x0c); // normal mode
	nSelectin high,nInit high, nAF low,  nStrobe high:   _outp(CONTROL, 0x06); // ready to write ITP mode
	nSelectin high,nInit high, nAF low,  nStrobe high:   _outp(DATA, reset<<3);  // Xilinx mode
	nSelectin high,nInit high, nAF low,  nStrobe low:    _outp(CONTROL, 0x07); // strobe command into CPLD
	nSelectin high,nInit high, nAF low,  nStrobe high:   _outp(CONTROL, 0x06); // end strobe
	nSelectin low, nInit high, nAF high, nStrobe high:   _outp(CONTROL, 0x0c); // normal mode again

*/


/*
*******************************************************************************
*
* FUNCTION:         
* DESCRIPTION:       
*					 
*					 
*
* INPUT PARAMETERS: 
*
* RETURNS:          
*
*******************************************************************************
*/

void xilinx_mode(int reset) 
{
	_outp(lpt_ECR,0);			  	// Disable ECP
	_outp(lpt_CTL, 0x0c);			// normal mode
	_outp(lpt_CTL, 0x06);			// ready to write ITP mode
	_outp(lpt_address, reset<<3);	// Xilinx mode
	_outp(lpt_CTL, 0x07);			// strobe command into CPLD
	_outp(lpt_CTL, 0x06);			// end strobe
	_outp(lpt_CTL, 0x0c);			// normal mode again
}
/*
*******************************************************************************
*
* FUNCTION:         
* DESCRIPTION:       
*					 
*					 
*
* INPUT PARAMETERS: 
*
* RETURNS:          
*
*******************************************************************************
*/
void itp_mode() 
{
	_outp(lpt_ECR,0x20);			// byte mode
	_outp(lpt_CTL,0x4);		       	// forward request
	_outp(lpt_ECR,0x60);			// Enable ECP
	_outp(lpt_address, 0x68);	   	// ITP Mode with reset
	_outp(lpt_ECR,0x20);		   	// byte mode
	_outp(lpt_CTL,0xc);			   	// forward request
	_outp(lpt_ECR,0);			   	// Disable ECP

}

/*
*******************************************************************************
*
* FUNCTION:		get_time_scale         
* DESCRIPTION:  OS independent time delay computation. Count the loops for 3
*				seconds, then divide by 3000 to get an approximate 1 ms count.     
*					 
*
* INPUT PARAMETERS: void
*
* RETURNS:	none          
*
*******************************************************************************
*/
void get_time_scale() 
{
	time_t start, now;
//	double i;
	DWORD count = 0; 
	bool done = false;

	printf("Please wait...\r");

	time(&start); // get a start time
	// take a 3 second sample
	do
	{
		time(&now);	
		count++;
		if (difftime(now,start) >= 3) done = true;

	}while(!done);
	
	MILLISECOND_COUNT = count/3000;	 // set the global count
	
	if(Debug_Mode)
		printf("Speed factor for this computer is: %d\n", MILLISECOND_COUNT);

}
/*
*******************************************************************************
*
* FUNCTION:		ms_delay         
* DESCRIPTION:  use the speed factor from  get_time_scale to make an approximate
*				millisecond time delay.     
*					 
*
* INPUT PARAMETERS: milliseconds
*
* RETURNS:	none          
*
*******************************************************************************
*/

void ms_delay(DWORD milliseconds)
{
	time_t now;
	bool done = false;
	DWORD count = 0;

	do
	{
		time(&now);	// dummy timecheck 
		difftime(now, now); // dummy difftime
		count++;
		if(count >= milliseconds * MILLISECOND_COUNT) done = true;	

	}while(!done);

}

unsigned long xscale_dcsr(unsigned long v, int xbreak, int hold_rst) 
{
	unsigned long dcsr[2];
	int i;

//	printf("Starting xscale_dcsr\n");
//	IR_Command(IR_DCSR);
	IssueProcInst(IR_DCSR);
	for(i=0; i<100; i++)
		jtag_rti();
//	scan(6,0xd,0x3f);			// lhg: test
	dcsr[0] = (v<<3) | (xbreak<<2) | (hold_rst<<1);
	dcsr[1] = v>>29;
	jtag_dr_wr(dcsr, dcsr, 36);

//	printf("PXA250 DCSR=%#010x:%08x\n", dcsr[0], dcsr[1]);
	return (dcsr[1]<<29) | (dcsr[0]>>3);
}

unsigned long scan(int bits, unsigned long tms, unsigned long tdi) 
{
	unsigned long tdo = 0;
	unsigned int tms_tdi;
	int i;
#if 0
	for(i=0; i<bits; i++)
	{
		tdo |= putp(tdi, tms, 1) << i;
	}
//	printf("tdo = %x\n", tdo);
	return tdo;
#else 
	for(i=0; i<bits; i++) {
		tms_tdi = (tms&1)<<2|(tdi&1);
		_outp(lpt_address, tms_tdi);			// clock low
		tdo = tdo | ((_inp(lpt_STAT) >> 4) & 1) << i;
		_outp(lpt_address, tms_tdi|(1<<1));	// clock high
		tms>>=1;
		tdi>>=1;
	//	printf("SCAN: i=%d tms_tdi=%d\n",i, tms_tdi);
	}
	_outp(lpt_address, tms_tdi);	// clock low
   //	printf("tdo = %x\n", tdo);
	return tdo;
#endif // never
}

/******************************************
 *	jtag_rti
 *
 *  Sequences the JTAG state machine from
 *  'update' or 'TLR' into 'RTI'.
 *		
 ******************************************/
void jtag_rti() 
{	// scan tms=0 to get to rti from either TLR or Update
	scan(1,0,0);
}

/******************************************
 *	jtag_dr_wr
 *
 *  Reads/Writes bitcount bits from src to
 *  dst.  Normal JTAG order (lsb first)
 *		
 ******************************************/
void jtag_dr_wr(unsigned long *dst, unsigned long *src, int bitcount) 
{

//	printf("Starting jtag_dr_wr\n");
	scan(3,1,0);
							
	scan(DEVICES_AFTER,0,1);			// scan post processor bypass bits
	while(bitcount > 32) {
		*dst++ = scan(32,0,*src++);
		bitcount-=32;
	}
	if(DEVICES_BEFORE) {
		*dst=scan(bitcount,0,*src);
		scan(DEVICES_BEFORE,1<<(DEVICES_BEFORE-1),1);
	}
	else
		*dst=scan(bitcount,1<<(bitcount-1),*src);
	scan(1,1,0);						// update DR
	return;
}

/******************************************
 *	xscale_load_line
 *
 *  Loads 1 line of the ICache
 *		
 ******************************************/
void xscale_load_line(unsigned long addr, unsigned long *l) {
	unsigned long ldic[2] = {3,0};		// load mini IC
	int i;
//	printf("Starting xscale_load_line\n");

//	IR_Command(IR_LDIC);
	IssueProcInst(IR_LDIC);

// invalidate line
	ldic[0] = addr << 1;		// invalidate IC line
	ldic[1] = addr >> 31;
	jtag_dr_wr(ldic, ldic, 33);

	ldic[0] = (addr << 1) | 3;	// load mini icache
	ldic[1] = addr >> 31;
	jtag_dr_wr(ldic, ldic, 33);

	for (i=0; i<8; i++) {
//		printf("loading word %d:", i+(dh_pos>>2));
		ldic[0] = l[i];
		ldic[1] = calc_parity(ldic[0]);
//		printf("ldic[0]=%08x, ldic[1]=%08x\n", ldic[0], ldic[1]);
		jtag_dr_wr(ldic,ldic,33);
	}
}

int calc_parity(unsigned int v) {
//	printf("Starting calc_parity\n");
	
	
	int parity=0;

	while (v) {
		parity ^= v&1;
		v>>=1;
	}
	return parity;
}

/******************************************
 *	xscale_tx_rd
 *
 *  Reads the XScale DBGTX register
 *		
 ******************************************/
int xscale_tx_rd(unsigned long *dst) {

	unsigned long dbgtx[2] = {0,0};
	unsigned long dbgtxo[2];
	unsigned long fail_count = 0;

//	printf("Starting xscale_tx_rd\n");

//	IR_Command(IR_DBGtx);
	IssueProcInst(IR_DBGtx);

	do {
		jtag_dr_wr(dbgtxo, dbgtx, 36);
		if(++fail_count > 50000) {			// about 10 seconds
			return 1;	// Error
		}
//		printf("PXA250 DBGTX=%#010x:%08x", dbgtxo[0], dbgtxo[1]);
//		printf("=%#010x\n", (dbgtxo[1]<<29) | (dbgtxo[0]>>3));
	} while ((dbgtxo[0] & 1) == 0 );
	*dst = (dbgtxo[1]<<29) | (dbgtxo[0]>>3);
	return 0;	// Success
}

/******************************************
 *	xscale_rx_wr
 *
 *  Writes the XScale DBGRX register
 *		
 ******************************************/
int xscale_rx_wr(unsigned long d) {
	unsigned int rrstatus;
	unsigned long fail_count = 0;
	
	//printf("Starting xscale_rx_wr\n");

	//IR_Command(IR_DBGrx);
	IssueProcInst(IR_DBGrx);
	do {
		scan(3,1,0);	// update/rti to shiftDR
		scan(DEVICES_AFTER,0,1);			// scan post processor bypass bits
		rrstatus = (STATUS_READ >> 4) & 1;
		scan(3,0,0);	// shift in 3 bits of zeros into dbg_sr
		scan(32,0,d);		// shift in the DBGRX contents
// shift in the valid bit,exit1
// the valid bit must be 0 if RR is set! Or else overflow
		if(DEVICES_BEFORE) {
			scan(1,0,(rrstatus ? 0 : 1));
			scan(DEVICES_BEFORE,1<<(DEVICES_BEFORE-1),1);
		}
		else
			scan(1,1,(rrstatus ? 0 : 1));
		scan(1,1,1);		// exit1 to update DR
		if(rrstatus)
			if(++fail_count > 50000)
				return 1;		// error writing to RX
	} while (rrstatus);
	return 0;
}

bool xscale_program_flash(FILE *in_file, DWORD start_addr, DWORD rom_size, int bus_width) {

	int num_blocks;
	unsigned long romdata;
	int i;
	unsigned long dummy;

// Program blocks
	
	SetGPIOState(12, 1);
	SetGPIOState(22, 1);

	rom_size = rom_size * ADDR_MULT;

	num_blocks = (rom_size+0x1f) >> 5;	// round up!
	printf("Programming %d blocks\n", num_blocks);

	if (bus_width == 32) {
		if(xscale_rx_wr(0xf1a54009))	// program flash
			return true;
		xscale_rx_wr(start_addr);	// start address
		xscale_rx_wr(num_blocks);
		xscale_rx_wr(0x10001);		// multiplier
		xscale_rx_wr(0x70007);		// WTB count
	}
	else if (bus_width == 16) {
		if(xscale_rx_wr(0xf1a54008))	// program flash
			return true;
		xscale_rx_wr(start_addr);	// start address
		xscale_rx_wr(num_blocks);
		xscale_rx_wr(0x1);			// multiplier
		xscale_rx_wr(0xf);			// WTB count
	}

// uses XILINX mode
#if 1
	/* test code */
	for(i=0; i<num_blocks*8; i++) {
		fread(&romdata,1,4,in_file);
	 //	xscale_rx_wr_nir(romdata);
		xscale_rx_wr(romdata);
		printf("%x  ", romdata);
	}
#else // uses High speed mode		
	IssueProcInstExit1("DBGRX");

	lice_mode(0,g_nDevsAfterProc);			// go high speed
	_outp(AFIFO,0xa5);		// exit1 to shift DR

	for(i=0; i<num_blocks*8; i++) {
//		if((i&0xf) == 0) {
//			printf("programming word %08x\r",i);
//		}
		fread(&romdata,1,4,in_file);
		if (hs_xscale_rx_wr_nir(romdata))
			return 1;					// error
	}
	xilinx_mode(0);

	scan(1,1,0);						// Exit1 to update
#endif
	if(xscale_tx_rd(&dummy))
		return 1;						// error reading status
	return 0;
}

/******************************************
 *	xscale_rx_wr_nir
 *
 *  Writes the XScale DBGRX register,
 *  without scaning DBGRX into IR
 *		
 ******************************************/
int xscale_rx_wr_nir(unsigned long d) {
	unsigned int rrstatus;
	unsigned long fail_count = 0;

//	printf("Starting xscale_rx_wr_nir\n");


	do {
	   	scan(3,1,0);	// update/rti to shiftDR

		scan(DEVICES_AFTER,0,1);			// scan post processor bypass bits
		rrstatus = (STATUS_READ >> 4) & 1;
		scan(3,0,0);	// shift in 3 bits of zeros into dbg_sr
		scan(32,0,d);		// shift in the DBGRX contents
// shift in the valid bit,exit1
// the valid bit must be 0 if RR is set! Or else overflow
		if(DEVICES_BEFORE) {
			scan(1,0,(rrstatus ? 0 : 1));
			scan(DEVICES_BEFORE,1<<(DEVICES_BEFORE-1),1);
		}
		else
			scan(1,1,(rrstatus ? 0 : 1));
		scan(1,1,1);		// exit1 to update DR
		if(rrstatus)
			if(++fail_count > 50000)
				return 1;		// error writing to RX
	} while (rrstatus);
	return 0;
}

bool SetGPIOState(int nGPIO, int nState)
{
	// Find the pin that is associated with the GPIO.
	int regidx;
	int bitpos;
	unsigned long placed_bit;
	unsigned long tmp;
	

	regidx = nGPIO / 32;		// 0 - 3
	bitpos = nGPIO & 0x1f;		// 0 - 31
	placed_bit = 1 << bitpos;


	xscale_mem_rd(gpdr[regidx],&tmp);
	tmp |= placed_bit;
	xscale_mem_wr(gpdr[regidx],tmp);		// direction to output
	if(nState)
		xscale_mem_wr(gpsr[regidx],placed_bit);
	else
		xscale_mem_wr(gpcr[regidx],placed_bit);	
		

	return TRUE;
}

int xscale_mem_wr(unsigned long addr, unsigned long data) {
	unsigned long dummy;

	xscale_rx_wr(0xf1a54006);
	xscale_rx_wr(addr);
	xscale_rx_wr(1);
	xscale_rx_wr(data);
	return xscale_tx_rd(&dummy);	// status read
}

int xscale_mem_rd(unsigned long addr, unsigned long *dst) {
	unsigned long tmp;
	unsigned long dummy;

	xscale_rx_wr(0xf1a54003);
	xscale_rx_wr(addr);
	xscale_rx_wr(1);
	xscale_tx_rd(dst);
	tmp = xscale_tx_rd(&dummy);
	return tmp;
}

void IssueProcInst( int command  )
{
	int device;
//	char *pInst;
	// This routine will place the ring in the initial state
	// which is all devices in bypass except for the programming
	// device.

	// Issue a Run/Test/Idle a couple of times
	putp(1,0,IP);	//Run-Test/Idle
	putp(1,0,IP);	//Run-Test/Idle
	putp(1,0,IP);	//Run-Test/Idle
	putp(1,0,IP);	//Run-Test/Idle
	putp(1,1,IP);
	putp(1,1,IP);	//select IR scan
	putp(1,0,IP);	//capture IR
	putp(1,0,IP);	//shift IR

	for(device = DEVICES_IN_CHAIN -1 ; device >= 0; device--)
	{
		if(device == DEVICE_CONTROLLER)
		{
			if(DEVICEISLAST[device])
			{
				controller_scan_code(command, IGNORE_PORT, TERMINATE);
			}
			else // controller is not the last in the chain
			{
				controller_scan_code(command, IGNORE_PORT, CONTINUE);
			}
		}
		else
		{
			if(DEVICEISLAST[device])
			{
				    other_bypass(IGNORE_PORT, TERMINATE, (int)DEVICEIRLENGTH[device]);
			}
			else 
			{
				    other_bypass(IGNORE_PORT, CONTINUE, (int)DEVICEIRLENGTH[device]);
			}
		} 
	}

#ifdef never

	// Now, the IR is loaded for all the devices.  
	for( int nDev = (g_pDlg->GetNumDevices()-1); nDev >= 0; nDev-- ) {
		// The BYPASS instruction is loaded into all devices except
		// the processor.
		if( (g_pDlg->GetJtagChain())[nDev]->m_bProgrammable ) {
			pInst = pProcInst;
		} else {
			pInst = "BYPASS";
		}

		bool bExitIR = (nDev ? false : true);
		IssueInstruction( (g_pDlg->GetJtagChain())[nDev], pInst, bExitIR );
	}
#endif
//	putp(1,1,IP);	//EXIT-IR
	putp(1,1,IP);	//Update-IR
	putp(1,0,IP);	//Run-Test/Idle
	putp(1,0,IP);	//Run-Test/Idle
	putp(1,0,IP);	//Run-Test/Idle
}

