/* Procfs interface for the PCI series device driver.

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

  v 0.0.2  11 Sep 2002 by Reed Lai
    ixpci_cardname() ==> _pci_cardname()

  v 0.0.1  28 Dec 2001 by Reed Lai
    Fixed a bug that forgot to increase the present counter when
    a card had been found at kernel 2.4.

  v 0.0.0  2 Nov 2001 by Reed Lai
    Support Kernel 2.4.
    Separated from _pci.c.
    Create. */

#include <linux/proc_fs.h>
#include <linux/init.h>

#include "ixpci_kernel.h"

extern unsigned int ixpci_major;
extern ixpci_kernel_t *ixpci_dev;

static int ixpci_get_info(char *buf, char **start, off_t offset, int buf_size)
{
  /* read file /proc/ixpci
   *
   * Arguments: as /proc filesystem, read <linux/proc_fs.h>
   *
   * Returned:  number of written bytes */
  
  char *p, *q, *l;
  unsigned int i, n, a, b, c, d;
  ixpci_kernel_t *r;
  char my_buf[128];
  
  if (offset > 0)
    return 0;
  /* here, we assume the buf is always large
     enough to hold all of our info data at
     one fell swoop */
  
  p = buf;
  n = buf_size;
  
  /* export major number */
  sprintf(my_buf, "maj: %d\n", ixpci_major);
  q = my_buf;
  for (; n > 0 && *q != '\0'; --n) {	/* export characters */
    *p++ = *q++;
  }
  
  /* export module names */
  i = 0;
  l = "mod:";
  for (; n > 0 && *l != '\0'; --n) {
    *p++ = *l++;
  }
  while (ixpci_card[i].id) {	/* scan card list */
    if (ixpci_card[i].present) {	/* find present card */
      if (n > 0) {
	*p++ = ' ';
	--n;
      }
      q = ixpci_card[i].module;
      for (; n > 0 && *q != '\0'; --n) {	/* export card's module name */
	*p++ = *q++;
      }
    }
    ++i;
  }
  if (n > 0) {				/* separator */
    *p++ = '\n';
    --n;
  }
  
  /* export device characters */
  r = ixpci_dev;
  while (r) {
    l = "dev: ";
    for (; n > 0 && *l != '\0'; --n) {	/* export card's module name */
      *p++ = *l++;
    }
    a = (r->id >> 48) & 0xffff;
    b = (r->id >> 32) & 0xffff;
    c = (r->id >> 16) & 0xffff;
    d = r->id & 0xffff;
    sprintf(my_buf,
	    "ixpci%d %d 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%lx 0x%04x%04x%04x%04x %s\n",
	    r->no, r->sdev->irq, pci_resource_start(r->sdev, 0), 
	    pci_resource_start(r->sdev, 1), pci_resource_start(r->sdev, 2),
	    pci_resource_start(r->sdev, 3), pci_resource_start(r->sdev, 4),
	    pci_resource_start(r->sdev, 5), a, b, c, d,
	    (char *) ixpci_pci_cardname(r->id));
    q = my_buf;
    for (; n > 0 && *q != '\0'; --n) {	/* export characters */
      *p++ = *q++;
    }
    r = r->next;
  }
  
  return (p - buf - offset);	/* bye bye */
}

static struct proc_dir_entry *ixpci_proc_dir;

void ixpci_proc_exit(void)
{
  remove_proc_entry(DEVICE_NAME, ixpci_proc_dir);
}

int ixpci_proc_init(void)
{
  ixpci_proc_dir = proc_mkdir(FAMILY, 0);
  create_proc_info_entry(DEVICE_NAME, 0, ixpci_proc_dir, ixpci_get_info);
  return 0;
}
