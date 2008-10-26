/* Declarations for PCI DAQ series.

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

/* File level history (record changes for this file here.)

   v 0.10.0 25 Jun 2003 by Reed Lai
     Defines IXPCI_PROC_FILE.

   v 0.9.0 11 Mar 2003 by Reed Lai
     Gives support to PCI-TMC12.
	 Gives sub-vendor and sub-device IDs.

   v 0.8.0  9 Jan 2003 by Reed Lai
     PCI-1002.

   v 0.7.0  9 Jan 2003 by Reed Lai
     Gives support to PCI-P8R8.

   v 0.6.0  7 Jan 2003 by Reed Lai
     Gives support to PCI-1002.
     Adds base address ranges for ixpci_devinfo.

   v 0.5.0 11 Nov 2002 by Reed Lai
     ICPDAS_LICENSE
     Removes some unused symbols.

   v 0.4.2 11 Sep 2002 by Reed Lai
     Adds symbol void *(_cardname) (int,int)

   v 0.4.1 26 Jul 2002 by Reed Lai
     Just refines some codes.

   v 0.4.0 16 May 2002 by Reed Lai
     Gives support to PCI-P16R16/P16C16/P16POR16

   v 0.3.0  1 Nov 2001 by Reed Lai
     Macros for Kernel 2.2 compatibility
	 cleanup_module()
	 init_module()

   v 0.2.0 31 Oct 2001 by Reed Lai
     Macros for Kernel 2.2 compatibility
         module_register_chrdev()
	 module_unregister_chrdev()

   v 0.1.0 25 Oct 2001 by Reed Lai
     Re-filenames to ixpci.h (from pdaq.h.)
     Changes all "pdaq" to "ixpci."

   v 0.0.0 10 Apr 2001 by Reed Lai
     Create.  */

#ifndef _IXPCI_KERNEL_H
#define _IXPCI_KERNEL_H

#include "ixpci.h"

#include <linux/types.h>
#include <linux/pci.h>
#include <linux/version.h>

#define ICPDAS_LICENSE "GPL"

/* General Definition */
#define ORGANIZATION "icpdas"
#define FAMILY "ixpci"			/* name of family */
#define DEVICE_NAME "ixpci"		/* device name used in /dev and /proc */
#define DEVICE_NAME_LEN 5
#define DEVICE_MAJOR 0			/* dynamic allocation of major number */

#define PBAN  PCI_BASE_ADDRESSES_NUMBER
#define CNL  CARD_NAME_LENGTH

#define KMSG(fmt, args...) printk(KERN_INFO FAMILY ": " fmt, ## args)

/* PCI Card's ID (vendor id).(device id) */
/*
          0x 1234 5678 1234 5678
             ---- ---- ---- ----
              |    |     |    |
      vendor id    |     |    sub-device id
	       device id     sub-vendor id
*/
#define PCI_1800      0x1234567800000000ULL	/* conflict */
#define PCI_1802      0x1234567800000000ULL	/* conflict */
#define PCI_1602      0x1234567800000000ULL	/* conflict */
#define PCI_1602_A    0x1234567600000000ULL	
#define PCI_1202      0x1234567200000000ULL
#define PCI_1002      0x12341002c1a20823ULL
#define PCI_P16C16    0x12341616c1a20823ULL	/* conflict */
#define PCI_P16R16    0x12341616c1a20823ULL	/* conflict */
#define PCI_P16POR16  0x12341616c1a20823ULL	/* conflict */
#define PCI_P8R8      0x12340808c1a20823ULL
#define PCI_TMC12     0x10b5905021299912ULL
#define PCI_M512      0x10b5905021290512ULL
#define PCI_M256      0x10b5905021290256ULL
#define PCI_M128      0x10b5905021290128ULL
#define PCI_9050EVM   0x10b5905010b59050ULL

#define IXPCI_VENDOR(a)		((a) >> 48)
#define IXPCI_DEVICE(a)		(((a) >> 32) & 0x0ffff)
#define IXPCI_SUBVENDOR(a)	(((a) >> 16) & 0x0ffff)
#define IXPCI_SUBDEVICE(a)	((a) & 0x0ffff)

/* IXPCI cards' definition */
struct ixpci_carddef {
  __u64 id;			/* composed sub-ids */
  unsigned int present;		/* card's present counter */
  char *module;			/* module name, if card is present then
				   load module in this name */
  char *name;			/* card's name */
};

extern struct ixpci_carddef ixpci_card[];

/* IXPCI device information for found cards' list */
typedef struct ixpci_kernel {
  struct ixpci_kernel *next;	/* next device (ixpci card) */
  struct ixpci_kernel *prev;	/* previous device */
  struct ixpci_kernel *next_f;	/* next device in same family */
  struct ixpci_kernel *prev_f;	/* previous device in same family */
  unsigned int no;			/* device number (minor number) */
  __u64 id;		/* card's id */
  unsigned int open;			/* open counter */
  struct file_operations *fops;	/* file operations for this device */
  char name[CNL];				/* card name information */
  struct pci_dev *sdev;         /* The PCI device (we need to release
				   it on driver unload */
} ixpci_kernel_t;

/* from pci.c */
void *ixpci_pci_cardname(__u64);
void ixpci_copy_devinfo(ixpci_devinfo_t * dst, ixpci_kernel_t * src);
extern unsigned int ixpci_major;
extern ixpci_kernel_t *ixpci_dev;

/* from proc.c */
int ixpci_proc_init(void);
void ixpci_proc_exit(void);




#endif
