/* PCI series device driver.

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

  v 0.8.1  8 Jul 2003 by Reed Lai
    Fixed a bug about _find_minor().

  v 0.8.0 11 Mar 2003 by Reed Lai
    Gives support to PCI-TMC12.
	Gives sub-verdor sub-device IDs.

  v 0.7.0  7 Jan 2003 by Reed Lai
    Adds the io range information for devinfo.

  v 0.6.0 11 Nov 2002 by Reed Lai
    Uses slab.h in place of malloc.h.
    Complies to the kernel module license check.

  v 0.5.3 25 Jul 2002 by Reed Lai
    _pio_cardname() ==> _pci_cardname()

  v 0.5.2 25 Jul 2002 by Reed Lai
    Just refines some codes and messages.

  v 0.5.1 16 May 2002 by Reed Lai
    Corrects the PCI-P16R16(series) service module name with "ixpcip16x16"

  v 0.5.0  28 Dec 2001 by Reed Lai
    Gives support to Kernel 2.4.

  v 0.4.0  1 Nov 2001 by Reed Lai
    Uses module_init() and module_exit() in place of init_module() and
	cleanup_module() for Kernel 2.4

  v 0.3.0 31 Oct 2001 by Reeed Lai
    Renames module_register_chrdev module_unregister_chrdev to
    devfs_register_chrdev and devfs_unregister_chrdev for Kernel 2.4.

  v 0.2.0 29 Oct 2001 by Reeed Lai
    Updates modules _find_dev() and _add_dev() for Kernel 2.4 compatibility.

  v 0.1.0 25 Oct 2001 by Reed Lai
    Re-filenames to _pci.c (from pdaq.c.)
    Changes all of "pdaq" to "ixpci."

  v 0.0.0 10 Apr 2001 by Reed Lai
    Create. */

/* *INDENT-OFF* */
#define IXPCI_RESERVED 0		/* 1 do compilation with reserved codes */

/* Mandatory */
#include <linux/kernel.h>		/* ta, kernel work */
#include <linux/module.h>		/* is a module */
#include <linux/version.h>

#include <linux/devfs_fs_kernel.h>
#include <linux/init.h>

/* Deal with CONFIG_MODVERSIONS that is defined in
   /usr/include/linux/config.h (config.h is included by module.h) */
#ifdef CONFIG_MODVERSIONS
# define MODVERSIONS
# include <linux/modversions.h>
#endif

/* using I/O ports */
#include <asm/io.h>
#include <linux/ioport.h>

/* need kmalloc */
#include <linux/slab.h>

#include <linux/proc_fs.h>

/* Local matter */
#include "ixpci_kernel.h"

#define MODULE_NAME "ixpci"

#ifdef MODULE_LICENSE
MODULE_AUTHOR("Reed Lai <reed@icpdas.com>");
MODULE_DESCRIPTION("ICPDAS PCI-series driver, common Interface");
MODULE_LICENSE(ICPDAS_LICENSE);
#endif

unsigned int ixpci_major;
	/* IXPCI global major number, auto-asign */

ixpci_kernel_t *ixpci_dev;
	/* pointer to the found PCI cards' list */

EXPORT_SYMBOL(ixpci_dev);
EXPORT_SYMBOL(ixpci_major);
EXPORT_SYMBOL(ixpci_copy_devinfo);

struct ixpci_carddef ixpci_card[] = {
  /* composed_id present module name */
  {PCI_1800, 0, "ixpci1800", "PCI-1800/1802/1602"},
  {PCI_1602_A, 0, "ixpci1602", "PCI-1602 (new id)"},
  {PCI_1202, 0, "ixpci1202", "PCI-1202"},
  {PCI_1002, 0, "ixpci1002", "PCI-1002"},
  {PCI_P16R16, 0, "ixpcip16x16", "PCI-P16C16/P16R16/P16POR16"},
  {PCI_P8R8, 0, "ixpcip8r8", "PCI-P8R8"},
  {PCI_TMC12, 0, "ixpcitmc12", "PCI-TMC12"},
  {0, 0, "", "UNKNOW"},
};

static void *ixpci_cardname(__u64 id, int add_present)
{
  /* Get card name by id
   * 
   * Arguments:
   *     id     card id (see ixpci.h)
   *     new    flag for a new card just be found
   * Returned:
   *     Pointer to the name string that coresponds the given id.
   *     If there is no card name has been found, return 0. */
  
  int i = 0;
  
  while (ixpci_card[i].id) {
    if (ixpci_card[i].id == id) {
      if (add_present)
	++(ixpci_card[i].present);
      /* yeh, present, check in */
      return ixpci_card[i].name;
    }
    ++i;
  }
  return 0;
}

void *ixpci_pci_cardname(__u64 id)
{
  return ixpci_cardname(id, 0);
}

static void ixpci_del_dev(void)
{
  /* Release memory from card list
   *
   * Arguments: none
   *
   * Returned:  void */
  
  ixpci_kernel_t *dev, *prev;
  
  dev = ixpci_dev;
  while (dev) {
    pci_dev_put(dev->sdev);
    prev = dev;
    dev = dev->next;
    kfree(prev);
  }
}

static ixpci_kernel_t *ixpci_add_dev(unsigned int no, __u64 id, char *name,
				     struct pci_dev *sdev)
{
  /* Add the found card to list
   *
   * Arguments:
   *     no      device number in list
   *     id      card id (see ixpci.h)
   *     name    card name
   *     sdev    pointer to the device information from system
   *
   * Returned:   The added device */
  ixpci_kernel_t *dev, *prev, *prev_f;
  
  if (ixpci_dev) {			/* ixpci device list is already followed */
    if (ixpci_dev->id == id)
      prev_f = ixpci_dev;
    else
      prev_f = 0;
    prev = ixpci_dev;
    dev = prev->next;
    while (dev) {			/* seek the tail of list */
      if (dev->id == id) {	/* last device in family */
	prev_f = dev;
      }
      prev = dev;
      dev = dev->next;
    }
    dev = prev->next = kmalloc(sizeof(*dev), GFP_KERNEL);
    memset(dev, 0, sizeof(*dev));
    dev->prev = prev;		/* member the previous address */
    if (prev_f) {
      dev->prev_f = prev_f;	/* member the previous family
				   device */
      prev_f->next_f = dev;	/* member the next family device */
    }
  } else {					/* ixpci device list is empty, initiate */
    ixpci_dev = kmalloc(sizeof(*ixpci_dev), GFP_KERNEL);
    memset(ixpci_dev, 0, sizeof(*ixpci_dev));
    dev = ixpci_dev;
  }
  dev->no = no;
  dev->id = id;
  strncpy(dev->name, name, CNL);
  dev->sdev = sdev;
  return dev;
}

static int ixpci_find_dev(void)
{
  /* Find all devices (cards) in this system.
   *
   * Arguments: none
   *
   * Returned: The number of found devices */
  unsigned int i = 0;
  unsigned int dev_no = 0;
  unsigned int j;
  __u64 id;
  unsigned int vid, did, svid, sdid;
  char *name;
  struct pci_dev *sdev;
  ixpci_kernel_t *dev;
  
  dev = NULL;
  sdev = NULL;
  
  for (; (id = ixpci_card[i].id) != 0; ++i) {
    vid = IXPCI_VENDOR(id);
    did = IXPCI_DEVICE(id);
    svid = IXPCI_SUBVENDOR(id);
    sdid = IXPCI_SUBDEVICE(id);
    while ((sdev =
	    pci_get_subsys(vid, did, PCI_ANY_ID, PCI_ANY_ID, sdev))) {
      /* Remember to return the device, when we discover that we cannot use it */
      if (svid && svid != sdev->subsystem_vendor) {
	pci_dev_put(sdev);
	continue;
      }
      if (sdid && sdid != sdev->subsystem_device) {
	pci_dev_put(sdev);
	continue;
      }
      ++(ixpci_card[i].present);
      name = ixpci_card[i].name;
      dev = ixpci_add_dev(dev_no++, id, name, sdev);
      if (dev_no == 1)
	KMSG("NO  PCI_ID____________  IRQ  BASE______  NAME...\n");
      /* "  01  0x1234567812345678  10   0x0000a400  PCI-1800\n" */
      KMSG("%2d  0x%04x%04x%04x%04x  %3d  0x%08lx  %s\n", dev_no, vid, did, svid, sdid, sdev->irq,
	   pci_resource_start(dev->sdev, 0), name);
      for (j = 1; (j < PBAN) && (pci_resource_start(dev->sdev, j) != 0); ++j)
	KMSG("                             0x%08lx\n", pci_resource_start(dev->sdev, j));
    }
  }

  return dev_no;
}

void ixpci_copy_devinfo(ixpci_devinfo_t * dst, ixpci_kernel_t * src)
{
  int i;

  dst->no = src->no;
  dst->id = src->id;
  for (i = 0; i < PBAN; i++) {
    dst->base[i] = pci_resource_start(src->sdev, i);
    dst->range[i] = pci_resource_len(src->sdev, i);
  }
  strncpy(dst->name, src->name, CNL);
}

static ixpci_kernel_t *ixpci_find_minor(int minor)
{
  ixpci_kernel_t *dp;
  for (dp = ixpci_dev; dp && dp->no != minor; dp = dp->next);
  return dp;
}

static int ixpci_ioctl(struct inode *inode,
		       struct file *file,
		       unsigned int ioctl_num, unsigned long ioctl_param)
{
  /* This function is called whenever a process tries to do and IO
   * control on IXPCI device file
   *
   * Arguments: read <linux/fs.h> for (*ioctl) of struct file_operations
   *
   * Returned:  error code */
  
  ixpci_kernel_t *dp;
  
  dp = ixpci_find_minor(iminor(inode));
  
  if (!dp || !dp->fops || !dp->fops->ioctl) return -EINVAL;
  
  return (dp->fops->ioctl) (inode, file, ioctl_num, ioctl_param);
}

static int ixpci_release(struct inode *inode, struct file *file)
{
  /* This function is called whenever a process attempts to closes the
   * device file. It doesn't have a return value in kernel version 2.0.x
   * because it can't fail (you must always be able to close a device).
   * In version 2.2.x it is allowed to fail.
   *
   * Arguments: read <linux/fs.h> for (*release) of struct file_operations
   *
   * Returned:  version dependence */
  
  ixpci_kernel_t *dp;
  
  dp = ixpci_find_minor(iminor(inode));
  
  if (!dp || !dp->fops || !dp->fops->release) {
    return -EINVAL;
  } else {
    return (dp->fops->release) (inode, file);
  }
}

static int ixpci_open(struct inode *inode, struct file *file)
{
  /* This function is called whenever a process attempts to open the
   * device file
   *
   * Arguments: read <linux/fs.h> for (*open) of struct file_operations
   *
   * Returned:  error code */
  
  ixpci_kernel_t *dp;
  
  dp = ixpci_find_minor(iminor(inode));
  
  if (!dp || !dp->fops || !dp->fops->open) return -EINVAL;
  
  return (dp->fops->open) (inode, file);
}

/* device file operaitons information */
static struct file_operations fops = {
  open: ixpci_open,
  release: ixpci_release,
  ioctl: ixpci_ioctl,
};

void ixpci_cleanup(void)
{
  /* cleanup this module */
  
  int unr;
  
  /* remove /proc/ixpci */
  ixpci_proc_exit();
  
  /* remove device file operations */
  unr = unregister_chrdev(ixpci_major, DEVICE_NAME);
  if (unr < 0)
    KMSG("%s devfs(module)_unregister_chrdev() error: %d\n",
	 MODULE_NAME, unr);
  
  ixpci_del_dev();					/* release allocated memory */
  
  KMSG("%s has been removed\n", MODULE_NAME);
}

int ixpci_init(void)
{
  /* initialize this module
   *
   * Arguments:
   *
   * Returned:  error code, 0 ok */
  
  unsigned found;
  char *comp;
  int err;
  
  found = ixpci_find_dev();
  if (found < 0) {
    KMSG("_find_dev() failed!\n");
    return found;
  }
  if (found == 0) {
    KMSG("No device (card) found.\n");
    return -ENODEV;
  }
  if (found == 1)
    comp = "";
  else
    comp = "s";
  KMSG("Total %d device%s (card%s) found.\n", found, comp, comp);
  
  /* register device file operations  */
  ixpci_major = register_chrdev(DEVICE_MAJOR, DEVICE_NAME, &fops);
  if (ixpci_major < 0) {
    KMSG("Registration of character device failed: %d\n", ixpci_major);
    ixpci_del_dev();				/* release allocated memory */
    return err;
  }
  KMSG("Using major number %d.\n", ixpci_major);
  
  
  /* setup proc entry */
  if ((err = ixpci_proc_init())) {
    KMSG("%s/%s/%s %d failed!\n", proc_root.name, ORGANIZATION,
	 DEVICE_NAME, err);
    ixpci_del_dev();
    return err;
  }
  
  return 0;
}

module_init(ixpci_init);
module_exit(ixpci_cleanup);
