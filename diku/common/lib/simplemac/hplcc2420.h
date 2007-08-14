#ifndef HPLCC2420_H
#define HPLCC2420_H

typedef enum
{
 CC_REG_SNOP             =0x00,
 CC_REG_SXOSCON          =0x01,
 CC_REG_STXCAL           =0x02,
 CC_REG_SRXON            =0x03,
 CC_REG_STXON            =0x04,
 CC_REG_STXONCCA         =0x05,
 CC_REG_SRFOFF           =0x06,
 CC_REG_SXOSCOFF         =0x07,
 CC_REG_SFLUSHRX         =0x08,
 CC_REG_SFLUSHTX         =0x09,
 CC_REG_SACK             =0x0A,
 CC_REG_SACKPEND         =0x0B,
 CC_REG_SRXDEC           =0x0C,
 CC_REG_STXENC           =0x0D,
 CC_REG_SAES             =0x0E,

 CC_REG_MAIN             =0x10,
 CC_REG_MDMCTRL0         =0x11,
 CC_REG_MDMCTRL1         =0x12,
 CC_REG_RSSI             =0x13,
 CC_REG_SYNCWORD         =0x14,
 CC_REG_TXCTRL           =0x15,
 CC_REG_RXCTRL0          =0x16,
 CC_REG_RXCTRL1          =0x17,
 CC_REG_FSCTRL           =0x18,
 CC_REG_SECCTRL0         =0x19,
 CC_REG_SECCTRL1         =0x1A,
 CC_REG_BATTMON          =0x1B,
 CC_REG_IOCFG0           =0x1C,
 CC_REG_IOCFG1           =0x1D,
 CC_REG_MANFIDL          =0x1E,
 CC_REG_MANFIDH          =0x1F,
 CC_REG_FSMTC            =0x20,
 CC_REG_MANAND           =0x21,
 CC_REG_MANOR            =0x22,
 CC_REG_AGCCTRL          =0x23,
 CC_REG_AGCTST0          =0x24,
 CC_REG_AGCTST1          =0x25,
 CC_REG_AGCTST2          =0x26,
 CC_REG_FSTST0           =0x27,
 CC_REG_FSTST1           =0x28,
 CC_REG_FSTST2           =0x29,
 CC_REG_FSTST3           =0x2A,
 CC_REG_RXBPFTST         =0x2B,
 CC_REG_FSMSTATE         =0x2C,
 CC_REG_ADCTST           =0x2D,
 CC_REG_DACTST           =0x2E,
 CC_REG_TOPTST           =0x2F,
 CC_REG_RESERVED         =0x30,

 CC_REG_TXFIFO           =0x3E,
 CC_REG_RXFIFO           =0x3F
}cc2420_reg_t;

typedef enum
{
 CC_ADDR_TXFIFO		=0x000,
 CC_ADDR_RXFIFO		=0x080,
 CC_ADDR_KEY0			=0x100,
 CC_ADDR_RXNONCE		=0x110,
 CC_ADDR_SABUF			=0x120,
 CC_ADDR_KEY1			=0x130,
 CC_ADDR_TXNONCE		=0x140,
 CC_ADDR_CBCSTATE		=0x150,
 CC_ADDR_IEEEADDR		=0x160,
 CC_ADDR_PANID			=0x168,
 CC_ADDR_SHORTADDR		=0x16A
}cc2420_addr_t;

/*#define CC2420_RSSI_VALID 0x80
#define CC2420_TX_ACTIVE 0x40*/

/*MDMCTRL0 bits*/
#define CC2420_MC0_RESERVED_FRAME_MODE  0x2000
#define CC2420_MC0_PAN_COORDINATOR  		0x1000
#define CC2420_MC0_ADDR_DECODE		  		0x0800
#define CC2420_MC0_CCA_HYST_MASK	  		0x0700
#define CC2420_MC0_CCA_MODE_MASK	  		0x00C0
#define CC2420_MC0_CCA_MODE_RSSI	  		0x0040
#define CC2420_MC0_CCA_MODE_802154  		0x0080
#define CC2420_MC0_CCA_MODE_BOTH	  		0x00C0
#define CC2420_MC0_AUTOCRC				  		0x0020
#define CC2420_MC0_AUTOACK				  		0x0010
#define CC2420_MC0_PREAMB_LEN_MASK  		0x000F

/*MDMCTRL1 bits*/
#define CC2420_MC1_CORR_THR_MASK	  		0x07C0
#define CC2420_MC1_DEMOD_AVG_MODE	  		0x0020
#define CC2420_MC1_MODULATION_MODE  		0x0010
#define CC2420_MC1_TX_MODE_MASK 	  		0x000C
#define CC2420_MC1_TX_MODE_BUFFERED  		0x0000
#define CC2420_MC1_TX_MODE_SERIAL	  		0x0001
#define CC2420_MC1_TX_MODE_LOOP 	  		0x0002
#define CC2420_MC1_RX_MODE_MASK 	  		0x0003
#define CC2420_MC1_RX_MODE_BUFFERED  		0x0000
#define CC2420_MC1_RX_MODE_SERIAL	  		0x0001
#define CC2420_MC1_RX_MODE_LOOP 	  		0x0002

#define TXCTRL_INIT				0xA0FF

/* Status byte */
#define CC2420_XOSC16M_STABLE				0x40
#define CC2420_TX_UNDERFLOW					0x20
#define CC2420_ENC_BUSY						0x10
#define CC2420_TX_ACTIVE					0x08
#define CC2420_LOCK							0x04
#define CC2420_RSSI_VALID		  			0x02


typedef enum
{
	CCA_HYST_0DB	= 0x00,
	CCA_HYST_1DB	= 0x01,
	CCA_HYST_2DB	= 0x02,
	CCA_HYST_3DB	= 0x03,
	CCA_HYST_4DB	= 0x04,
	CCA_HYST_5DB	= 0x05,
	CCA_HYST_6DB	= 0x06,
	CCA_HYST_7DB	= 0x07,
} cca_hyst_db_t;

typedef enum
{
	LEADING_ZERO_BYTES_1	= 0x00,
	LEADING_ZERO_BYTES_2	= 0x01,
	LEADING_ZERO_BYTES_3	= 0x02,
	LEADING_ZERO_BYTES_4	= 0x03,
	LEADING_ZERO_BYTES_5	= 0x04,
	LEADING_ZERO_BYTES_6	= 0x05,
	LEADING_ZERO_BYTES_7	= 0x06,
	LEADING_ZERO_BYTES_8	= 0x07,
	LEADING_ZERO_BYTES_9	= 0x08,
	LEADING_ZERO_BYTES_10	= 0x09,
	LEADING_ZERO_BYTES_11	= 0x0A,
	LEADING_ZERO_BYTES_12	= 0x0B,
	LEADING_ZERO_BYTES_13	= 0x0C,
	LEADING_ZERO_BYTES_14	= 0x0D,
	LEADING_ZERO_BYTES_15	= 0x0E,
	LEADING_ZERO_BYTES_16	= 0x0F,
} preamble_length_t;

typedef struct
{
	preamble_length_t preamble_length : 4;
	bool autoack : 1;
	bool autocrc : 1;
	uint8_t cca_mode : 2;
	cca_hyst_db_t cca_hyst : 3;
	bool adr_decode : 1;
	bool pan_coordinator : 1;
	bool reserved_frame_mode : 1;
	uint8_t reserved : 2;
} MDMCTRL0_t;


#endif //HPLCC2420_H
