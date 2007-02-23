#ifndef DSNTEST_H
#define DSNTEST_H

enum {
	BSL_RX_DATA = 0x12,
	BSL_ERASE_SEGMENT = 0x16,
	BSL_MASS_ERASE = 0x18,
	BSL_LOAD_PC = 0x1a,
	BSL_RX_PWD = 0x10,
	BSL_TX_BSLVERSION = 0x1e,
	BSL_TX_DATA = 0x14,
	BSL_ERASE_CHECK = 0x1c,
	BSL_CHANGE_BAUDRATE = 0x20,
	
	RESET_ADDR = 0xfffe,
	ID_ADDR = 0xfe00,
	
	BSL_VERSION_HI = 0x01,
	BSL_VERSION_LO = 0xa5,
	DSN_BOOT_START = 0xf200,
	DSN_BOOT_LAST_SEGMENT = 0xfdff,
	DSN_BOOT_PROGRAM_SEGMENT = 0x4000
};

typedef nx_struct myMsg {
	nx_uint16_t myId;
	nx_uint16_t seqNr;	
} myMsg;

#endif
