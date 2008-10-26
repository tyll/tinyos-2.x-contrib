/* User space declarations for PCI DAQ series.

   Author: Reed Lai

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. */

#ifndef _IXPCI_H
#define _IXPCI_H

#define IXPCI_PROC_FILE "/proc/ixpci/ixpci"

#define PCI_BASE_ADDRESSES_NUMBER  6
#define CARD_NAME_LENGTH  32

/* The chaos of name convention from hardware manual... */
enum {
  IXPCI_8254_COUNTER_0,
  IXPCI_8254_COUNTER_1,
  IXPCI_8254_COUNTER_2,
  IXPCI_8254_CONTROL_REG,
  IXPCI_SELECT_THE_ACTIVE_8254_CHIP,
  IXPCI_GENERAL_CONTROL_REG,
  IXPCI_STATUS_REG,
  IXPCI_AD_SOFTWARE_TRIGGER_REG,
  IXPCI_DIGITAL_INPUT_PORT,
  IXPCI_DIGITAL_OUTPUT_PORT,
  IXPCI_ANALOG_INPUT_CHANNEL_CONTROL_REG,
  IXPCI_ANALOG_INPUT_GAIN_CONTROL_REG,
  IXPCI_ANALOG_INPUT_PORT,
  IXPCI_ANALOG_OUTPUT_CHANNEL_1,
  IXPCI_ANALOG_OUTPUT_CHANNEL_2,
  IXPCI_PCI_INTERRUPT_CONTROL_REG,
  IXPCI_CLEAR_INTERRUPT,
  IXPCI_LAST_REG
};

#define IXPCI_8254C0       IXPCI_8254_COUNTER_0
#define IXPCI_8254C1       IXPCI_8254_COUNTER_1
#define IXPCI_8254C2       IXPCI_8254_COUNTER_2
#define IXPCI_8254CR       IXPCI_8254_CONTROL_REG
#define IXPCI_8254_CHIP_SELECT IXPCI_SELECT_THE_ACTIVE_8254_CHIP
#define IXPCI_8254CS       IXPCI_8254_CHIP_SELECT
#define IXPCI_GCR          IXPCI_GENERAL_CONTROL_REG
#define IXPCI_CONTROL_REG  IXPCI_GENERAL_CONTROL_REG
#define IXPCI_CR           IXPCI_CONTROL_REG
#define IXPCI_SR           IXPCI_STATUS_REG
#define IXPCI_ADST         IXPCI_AD_SOFTWARE_TRIGGER_REG
#define IXPCI_DI           IXPCI_DIGITAL_INPUT_PORT
#define IXPCI_DO           IXPCI_DIGITAL_OUTPUT_PORT
#define IXPCI_AICR         IXPCI_ANALOG_INPUT_CHANNEL_CONTROL_REG
#define IXPCI_AIGR         IXPCI_ANALOG_INPUT_GAIN_CONTROL_REG
#define IXPCI_AI           IXPCI_ANALOG_INPUT_PORT
#define IXPCI_AD           IXPCI_AI
#define IXPCI_AO1          IXPCI_ANALOG_OUTPUT_CHANNEL_1
#define IXPCI_DA1          IXPCI_AO1
#define IXPCI_AO2          IXPCI_ANALOG_OUTPUT_CHANNEL_2
#define IXPCI_DA2          IXPCI_AO2
#define IXPCI_PICR         IXPCI_PCI_INTERRUPT_CONTROL_REG
#define IXPCI_CI           IXPCI_CLEAR_INTERRUPT

/* IXPCI structure for register */
typedef struct ixpci_reg {
  unsigned int id;			/* register's id */
  unsigned int value;			/* register's value for read/write */
} ixpci_reg_t;

/* register operation mode */
enum {
  IXPCI_RM_RAW,				/* read/write directly without data mask */
  IXPCI_RM_NORMAL,			/* read/write directly */
  IXPCI_RM_READY,			/* blocks before ready */
  IXPCI_RM_TRIGGER,			/* do software trigger before ready (blocked) */
  IXPCI_RM_LAST_MODE
};

/* IXPCI device information for found cards' list */
typedef struct ixpci_devinfo {
  unsigned int no;			/* device number (minor number) */
  long long id;		/* card's id */
  unsigned long base[PCI_BASE_ADDRESSES_NUMBER];	/* base I/O addresses */
  unsigned int range[PCI_BASE_ADDRESSES_NUMBER];	/* ranges for each I/O address */
  char name[CARD_NAME_LENGTH];				/* card name information */
} ixpci_devinfo_t;

/* IOCTL command IDs */
enum {
  IXPCI_IOCTL_ID_RESET,
  IXPCI_IOCTL_ID_GET_INFO,
  IXPCI_IOCTL_ID_SET_SIG,
  IXPCI_IOCTL_ID_READ_REG,
  IXPCI_IOCTL_ID_WRITE_REG,
  IXPCI_IOCTL_ID_TIME_SPAN,
  IXPCI_IOCTL_ID_DI,
  IXPCI_IOCTL_ID_DO,
  IXPCI_IOCTL_ID_IRQ_ENABLE,
  IXPCI_IOCTL_ID_IRQ_DISABLE,
  IXPCI_IOCTL_ID_PIC_CONTROL,
  IXPCI_IOCTL_ID_LAST_ITEM,
};

/* IXPCI IOCTL command */
#define IXPCI_MAGIC_NUM  0x26	/* why? ascii codes 'P' + 'D' + 'A' + 'Q' */
#define IXPCI_GET_INFO   _IOR(IXPCI_MAGIC_NUM, IXPCI_IOCTL_ID_GET_INFO, ixpci_devinfo_t *)

#define IXPCI_SET_SIG    _IOR(IXPCI_MAGIC_NUM, IXPCI_IOCTL_ID_SET_SIG, ixpci_signal_t *)

#define IXPCI_READ_REG   _IOR(IXPCI_MAGIC_NUM, IXPCI_IOCTL_ID_READ_REG, ixpci_reg_t *)
#define IXPCI_WRITE_REG  _IOR(IXPCI_MAGIC_NUM, IXPCI_IOCTL_ID_WRITE_REG, ixpci_reg_t *)
#define IXPCI_TIME_SPAN  _IOR(IXPCI_MAGIC_NUM, IXPCI_IOCTL_ID_TIME_SPAN, int)
#define IXPCI_WAIT       IXPCI_TIME_SPAN
#define IXPCI_DELAY      IXPCI_TIME_SPAN
#define IXPCI_BLOCK      IXPCI_TIME_SPAN
#define IXPCI_RESET      _IO(IXPCI_MAGIC_NUM, IXPCI_IOCTL_ID_RESET)
#define IXPCI_PIC_CONTROL _IOR(IXPCI_MAGIC_NUM, IXPCI_IOCTL_ID_PIC_CONTROL, int)

#define IXPCI_IOCTL_DI   _IOR(IXPCI_MAGIC_NUM, IXPCI_IOCTL_ID_DI, void *)
#define IXPCI_IOCTL_DO   _IOR(IXPCI_MAGIC_NUM, IXPCI_IOCTL_ID_DO, void *)

#define IXPCI_IRQ_ENABLE  _IO(IXPCI_MAGIC_NUM, IXPCI_IOCTL_ID_IRQ_ENABLE)
#define IXPCI_IRQ_DISABLE  _IO(IXPCI_MAGIC_NUM, IXPCI_IOCTL_ID_IRQ_DISABLE)

#endif							/* _IXPCI_H */
/* *INDENT-ON* */
