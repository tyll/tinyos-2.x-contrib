/* PCI-1202 Service Module

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

   v 0.3.2  8 Jul 2003 by Reed Lai
     Fixed a bug about _align_minor().

   v 0.3.1 16 Jan 2003 by Reed Lai
     Fixed the request io region bug that hanged the system.

   v 0.3.0  8 Jan 2003 by Reed Lai
     Uses the dp->range[] instead of IO_RANGE.

   v 0.2.0 11 Nov 2002 by Reed Lai
     Checks IO region before request.
     Uses slab.h in place of malloc.h.
     Complies to the kernel module license check.

   v 0.1.1 16 May 2002 by Reed Lai
     Remove unused items: msg_ptr and msg[]

   v 0.1.0 25 Oct 2001 by Reed Lai
     Re-filename to _pci1202.c (from pdaq1202.c.)
     Change all "pdaq" to "ixpci."

   v 0.0.0 3 May 2001 by Reed Lai
     create, blah blah... */

/* Mandatory */
#include <linux/kernel.h>		/* ta, kernel work */
#include <linux/module.h>		/* is a module */

/* Deal with CONFIG_MODVERSIONS that is defined in
   /usr/include/linux/config.h (config.h is included by module.h) */
#ifdef CONFIG_MODVERSIONS
#define MODVERSIONS
#include <linux/modversions.h>
#endif

/* Additional */
#include <linux/fs.h>

/* use I/O ports */
#include <asm/io.h>
#include <linux/ioport.h>

/* Usermode access */
#include <asm/uaccess.h>

/* Local matter */
#include "ixpci_kernel.h"

#define MODULE_NAME "ixpci1202"

/* Register offsets */
/* Region 0 (NA) */

/* Region 1 */
#define _8254_TIMER_1           0x00
#define _8254_TIMER_2           0x04
#define _8254_TIMER_3           0x08
#define _8254_CONTROL_REGISTER  0x0c
/* Shorthands */
#define _8254C0  _8254_TIMER_1	/* take care the digit!! */
#define _8254C1  _8254_TIMER_2
#define _8254C2  _8254_TIMER_3
#define _8254CR  _8254_CONTROL_REGISTER

/* Region 2 */
#define CONTROL_REGISTER        0x00
#define STATUS_REGISTER         0x00
#define AD_SOFTWARE_TRIGGER     0x04
/* Shorthands */
#define _CR       CONTROL_REGISTER
#define _SR       STATUS_REGISTER
#define _ADST     AD_SOFTWARE_TRIGGER

/* Region 3 */
#define DI_PORT                 0x00
#define DO_PORT                 0x00
/* Shorthands */
#define _DI       DI_PORT
#define _DO       DO_PORT

/* Region 4 */
#define AD_DATA_PORT            0x00
#define DA_CHANNEL_1            0x00
#define DA_CHANNEL_2            0x04
/* Shorthands */
#define _AD       AD_DATA_PORT
#define _DA1      DA_CHANNEL_1
#define _DA2      DA_CHANNEL_2

/* mask of registers (16-bit operation) */
#define _CR_MASK      0xbfdf
#define _SR_MASK      0x00ff
#define _AD_MASK      0x0fff
#define _DA1_MASK     0x0fff
#define _DA2_MASK     0x0fff

ixpci_kernel_t *dev;

#ifdef MODULE_LICENSE
MODULE_AUTHOR("Reed Lai <reed@icpdas.com>");
MODULE_DESCRIPTION("ICPDAS PCI-series driver, PCI-1202 service module");
MODULE_LICENSE(ICPDAS_LICENSE);
#endif

static ixpci_kernel_t *find_board(int minor)
{
  /* Locate a specific board by minor number */
  ixpci_kernel_t *dp;
  for (dp = dev; dp && dp->no != minor; dp = dp->next_f);
  return dp;
}

static int write_register(ixpci_reg_t * reg, struct pci_dev *sdev)
{
  /* Write to register
   *
   * Arguments:
   *   reg      pointer to a structure ixpci_reg for register
   *   sdev     pointer to a pci_dev structure.
   *
   * Returned:  SUCCESS or FAILURE */
  
  unsigned long timer = pci_resource_start(sdev, 1);
  unsigned long control = pci_resource_start(sdev, 2);
  unsigned long digital_io = pci_resource_start(sdev, 3);
  unsigned long da = pci_resource_start(sdev, 4);

  switch (reg->id) {
  case IXPCI_8254C0:
    outw((reg->value), timer + _8254C0);
    break;
  case IXPCI_8254C1:
    outw((reg->value), timer + _8254C1);
    break;
  case IXPCI_8254C2:
    outw((reg->value), timer + _8254C2);
    break;
  case IXPCI_8254CR:
    outw((reg->value), timer + _8254CR);
    break;
  case IXPCI_CR:
    outw((reg->value) & _CR_MASK, control + _CR);
    break;
  case IXPCI_ADST:
    outw((reg->value), control + _ADST);
    break;
  case IXPCI_DO:
    outw((reg->value), digital_io + _DO);
    break;
  case IXPCI_DA1:
    outw((reg->value) & _DA1_MASK, da + _DA1);
    break;
  case IXPCI_DA2:
    outw((reg->value) & _DA2_MASK, da + _DA2);
    break;
  default:
    return -EINVAL;
  }
  return 0;
}

static int read_register(ixpci_reg_t * reg, struct pci_dev *sdev)
{
  /* Read from register
   *
   * Arguments:
   *   reg      pointer to structure ixpci_reg for register
   *   sdev     pointer to a pci_dev structure.
   *
   * Returned:  SUCCESS or FAILURE */
  unsigned long timer = pci_resource_start(sdev, 1);
  unsigned long control = pci_resource_start(sdev, 2);
  unsigned long digital_io = pci_resource_start(sdev, 3);
  unsigned long da = pci_resource_start(sdev, 4);

  switch (reg->id) {
  case IXPCI_8254C0:
    reg->value = inw(timer + _8254C0);
    break;
  case IXPCI_8254C1:
    reg->value = inw(timer + _8254C1);
    break;
  case IXPCI_8254C2:
    reg->value = inw(timer + _8254C2);
    break;
  case IXPCI_SR:
    reg->value = inw(control + _SR) & _SR_MASK;
    break;
  case IXPCI_DI:
    reg->value = inw(digital_io + _DI);
    break;
  case IXPCI_AD:
    reg->value = inw(da + _AD) & _AD_MASK;
    break;
  default:
    return -EINVAL;
  }
  return 0;
}

static int time_span(int span, struct pci_dev *sdev)
{
  /* Use the 8254 counter-2 to be the machine independent timer
   * at the 8 MHz clock.
   *
   * Arguments:
   *   span     micro-second (us) to be spanned
   *   sdev     pointer to a pci_dev structure.
   *
   * Returned:  SUCCESS or FAILURE */
  unsigned long timer = pci_resource_start(sdev, 1);
  unsigned long control = pci_resource_start(sdev, 2);

  unsigned long sr;
  unsigned counter;
  unsigned char lbyte, hbyte;
  int i;
  
  if ((span > 8190) || (span == 0))
    return -EOVERFLOW;
  
  i = 0;
  sr = control + _SR;
  
  counter = span * 8;
  lbyte = counter & 0xff;
  hbyte = (counter >> 8) & 0xff;
  
  outb(0xb0, timer + _8254CR);
  outb(lbyte, timer + _8254C2);
  outb(hbyte, timer + _8254C2);
  
  while (inb(sr) & 0x01) {
    if (i > 100000000)
      return -ETIMEDOUT;
    /* XXX - fix me for timeout */
    ++i;
  }
  return 0;
}

static int reset_dev(ixpci_kernel_t * dp)
{
  unsigned long timer = pci_resource_start(dp->sdev, 1);
  unsigned long control = pci_resource_start(dp->sdev, 2);
  unsigned long digital_io = pci_resource_start(dp->sdev, 3);
  unsigned long da = pci_resource_start(dp->sdev, 4);

  /* stop timer 0 */
  outb(0x34, timer + _8254CR);
  outb(0x01, timer + _8254C0);
  outb(0x00, timer + _8254C0);
  
  /* stop timer 1 */
  outb(0x74, timer + _8254CR);
  outb(0x01, timer + _8254C1);
  outb(0x00, timer + _8254C1);
  
  /* stop timer 2 */
  outb(0xb0, timer + _8254CR);
  outb(0x01, timer + _8254C2);
  outb(0x00, timer + _8254C2);
  
  /* reset control register to
     A/D channel 0
     Gain control PGA = 1
     Input range control = PGA (+/- 5V)
     Reset the MagicScan controller
     Assert the MagicScan handshake control bit (bit 13)
     Clear FIFO */
  outw(0x2000, control + _CR);
  
  /* clear DO */
  outw(0, digital_io + _DO);
  
  /* clear DA */
  outw(0, da + _DA1);
  outw(0, da + _DA2);
  
  /* did I leak anything? */
  
  return 0;
}

static int pic_control(int command, struct pci_dev *sdev)
{
  int value;
  int cnt;
  unsigned long control = pci_resource_start(sdev, 2);


  value = inw(control + _SR) & _SR_MASK;
  if ((value & 0x04) == 0)
    /* Reset PIC */
    outw(0xFFFF & _CR_MASK, control + _CR);

  /* Wait for handshake */
  cnt = 0;
  value = inw(control + _SR) & _SR_MASK;
  while ((value & 0x04) == 0) {
    value = inw(control + _SR) & _SR_MASK;
    if (++cnt > 65530)
      return -ETIMEDOUT;
  }

  /* Send the command */
  command &= 0xDFFF;
  outw(command & _CR_MASK, control + _CR);

  /* Wait for handshake */
  cnt = 0;
  value = inw(control + _SR) & _SR_MASK;
  while (value & 0x04) {
    value = inw(control + _SR) & _SR_MASK;
    if (++cnt > 65530)
      return -ETIMEDOUT;
  }

  command |= 0x2000;
  outw(command & _CR_MASK, control + _CR);
  
  /* Wait for handshake */
  cnt = 0;
  value = inw(control + _SR) & _SR_MASK;
  while ((value & 0x04) == 0) {
    value = inw(control + _SR) & _SR_MASK;
    if (++cnt > 65530)
      return -ETIMEDOUT;
  }

  return 0;
}

static int ixpci1202_ioctl(struct inode *inode,
			   struct file *file,
			   unsigned int ioctl_num, unsigned long ioctl_param)
{
  /* (export)
   *
   * This function is called by ixpci.o whenever a process tries
   * to do and IO control on IXPCI device file
   *
   * Arguments: read <linux/fs.h> for (*ioctl) of struct file_operations
   *
   * Returned:  SUCCESS or FAILED */
  
  ixpci_kernel_t *dp;
  int res;
  
  dp = find_board(iminor(inode));
  
  if (!dp || !dp->open) return -ENODEV;
  
  switch (ioctl_num) {
  case IXPCI_GET_INFO: 
    {
      ixpci_devinfo_t info;
      
      ixpci_copy_devinfo(&info, dp);
      
      if (copy_to_user((void __user *) ioctl_param, &info, sizeof(info)))
	return -EFAULT;

      break;
    }
  case IXPCI_READ_REG:
    {
      ixpci_reg_t reg;
      int res;
      
      if (copy_from_user(&reg, (void __user *) ioctl_param, sizeof(reg)))
	return -EFAULT;

      res = read_register(&reg, dp->sdev);
      if (res)
	return res;

      if (copy_to_user((void __user *) ioctl_param, &reg, sizeof(reg)))
	return -EFAULT;
      break;
    }
  case IXPCI_WRITE_REG:
    {
      ixpci_reg_t reg;
      
      if (copy_from_user(&reg, (void __user *) ioctl_param, sizeof(reg)))
	return -EFAULT;

      return write_register(&reg, dp->sdev);
    }
  case IXPCI_TIME_SPAN:
    return time_span((int) ioctl_param, dp->sdev);
  case IXPCI_RESET:
    return reset_dev(dp);
  case IXPCI_PIC_CONTROL:
    res = pic_control((int) ioctl_param, dp->sdev);
    if (res) {
      KMSG("%s: pic_control failed!!!!\n", MODULE_NAME);
      return res;
    }
    break;
  default:
    return -EINVAL;
  }
  return 0;
}

static int ixpci1202_release(struct inode *inode, struct file *file)
{
  /* (export)
   *
   * This function is called by ixpci.o whenever a process attempts to
   * closes the device file. It doesn't have a return value in kernel
   * version 2.0.x because it can't fail (you must always be able to
   * close a device).  In version 2.2.x it is allowed to fail.
   *
   * Arguments: read <linux/fs.h> for (*release) of struct file_operations
   *
   * Returned:  none */
  
  int minor;
  ixpci_kernel_t *dp;
  
  minor = iminor(inode);
  dp = find_board(minor);
  
  if (!dp)
    return -ENODEV;

  dp->open = 0;
  module_put(THIS_MODULE);
  return 0;
}

static int ixpci1202_open(struct inode *inode, struct file *file)
{
  /* (export)
   *
   * This function is called by ixpci.o whenever a process attempts to
   * open the device file of PCI-1202
   *
   * Arguments: read <linux/fs.h> for (*open) of struct file_operations
   *
   * Returned:  none */
  
  int minor;
  ixpci_kernel_t *dp;
  
  minor = iminor(inode);
  dp = find_board(minor);
  
  if (!dp) return -ENODEV;
  
  if (!try_module_get(THIS_MODULE)) {
    KMSG("Could not get THIS_MODULE\n");
    return -EINVAL;
  }
  
  ++(dp->open);
  if (dp->open > 1) {
    --(dp->open);
    module_put(THIS_MODULE);
    return -EBUSY;
    /* if still opened by someone, get out */
  }
  
  return 0;
}

static struct file_operations fops = {
  open: ixpci1202_open,
  release: ixpci1202_release,
  ioctl: ixpci1202_ioctl,
};

void cleanup_module()
{
  /* cleanup this module */
  int i;
  ixpci_kernel_t *dp;
  
  for (dp = dev; dp; dp = dp->next_f) {
    KMSG("%s: Removing pci1202 card. Device %d:%d: ", MODULE_NAME,
	 ixpci_major, dp->no);
    reset_dev(dp);
    dp->fops = 0;

    for (i = 0; i < PBAN; i++) {
      if (!pci_resource_start(dp->sdev, i) 
	  || !pci_resource_len(dp->sdev, i))
	continue;

      release_region(pci_resource_start(dp->sdev, i), 
		     pci_resource_len(dp->sdev, i));
    }
		
    /* remove file operations */
    printk("done\n");
  }
  KMSG("%s has been removed.\n", MODULE_NAME);
}

int init_module()
{
  /* initialize this module
   *
   * Arguments: none
   *
   * Returned:
   * integer 0 for ok, otherwise failed (module can't be load) */
  
  ixpci_kernel_t *dp;
  int i;
  struct resource *res;
  
  /* align to first PCI-1202 in ixpci list */
  for (dev = ixpci_dev; dev && dev->id != PCI_1202; dev = dev->next);
  
  if (!dev) {
    KMSG("%s: fail!\n", MODULE_NAME);
    return -ENODEV;
  }

  /* initiate for each device (card) in family */
  for (dp = dev; dp; dp = dp->next_f) {
    KMSG("%s: Found pci1202 card. Device %d:%d: ", MODULE_NAME, 
	 ixpci_major, dp->no);

    /* request io region */
    for (i = 0; i < PBAN; i++) {
      if (!pci_resource_start(dp->sdev, i) 
	  || !pci_resource_len(dp->sdev, i))
	continue;
      
      res = request_region(pci_resource_start(dp->sdev, i), 
			   pci_resource_len(dp->sdev, i), MODULE_NAME);
      if (!res) {
	/* Release all regions */
	int j;
	for (j = 0; j < i; j++)
	  release_region(pci_resource_start(dp->sdev, i),
			 pci_resource_len(dp->sdev, i));

	KMSG("%s: Request region failed for 0x%08lx (size: 0x%08lx)\n", 
	     MODULE_NAME, pci_resource_start(dp->sdev, i), 
	     pci_resource_len(dp->sdev, i));

	return -ENXIO;	  
      }
    }

    dp->fops = &fops;
    reset_dev(dp);
    printk("done\n");
  }

  KMSG("%s ready.\n", MODULE_NAME);
  return 0;
}

