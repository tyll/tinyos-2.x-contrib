/**
 * NXT bootstrap interface; NXT flash chip code.
 *
 * Copyright 2006 David Anderson <david.anderson@calixo.net>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 * USA
 */

#include <stdio.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>

#include "error.h"
#include "lowlevel.h"
#include "samba.h"
#include "flash.h"

enum nxt_flash_commands
{
  FLASH_CMD_LOCK = 0x2,
  FLASH_CMD_UNLOCK = 0x4,
};

nxt_error_t
nxt_flash_wait_ready(nxt_t *nxt)
{
  nxt_word_t flash_status;

  do
    {
      NXT_ERR(nxt_read_word(nxt, 0xFFFFFF68, &flash_status));

      /* Bit 0 is the FRDY field. Set to 1 if the flash controller is
       * ready to run a new command.
       */
    } while (!(flash_status & 0x1));

  return NXT_OK;
}

static nxt_error_t
nxt_flash_alter_lock(nxt_t *nxt, int region_num,
                     enum nxt_flash_commands cmd)
{
  nxt_word_t w = 0x5A000000 | ((64 * region_num) << 8);
  w += cmd;

  NXT_ERR(nxt_flash_wait_ready(nxt));

  /* Flash mode register: FCMN 0x5, FWS 0x1
   * Flash command register: KEY 0x5A, FCMD = clear-lock-bit (0x4)
   * Flash mode register: FCMN 0x34, FWS 0x1
   */
  NXT_ERR(nxt_write_word(nxt, 0xFFFFFF60, 0x00050100));
  NXT_ERR(nxt_write_word(nxt, 0xFFFFFF64, w));
  NXT_ERR(nxt_write_word(nxt, 0xFFFFFF60, 0x00340100));

  return NXT_OK;
}


nxt_error_t
nxt_flash_lock_region(nxt_t *nxt, int region_num)
{
  return nxt_flash_alter_lock(nxt, region_num, FLASH_CMD_LOCK);
}


nxt_error_t
nxt_flash_unlock_region(nxt_t *nxt, int region_num)
{
  return nxt_flash_alter_lock(nxt, region_num, FLASH_CMD_UNLOCK);
}


nxt_error_t
nxt_flash_lock_all_regions(nxt_t *nxt)
{
  int i;

  for (i = 0; i < 16; i++)
    NXT_ERR(nxt_flash_lock_region(nxt, i));

  return NXT_OK;
}


nxt_error_t
nxt_flash_unlock_all_regions(nxt_t *nxt)
{
  int i;

  for (i = 0; i < 16; i++)
    NXT_ERR(nxt_flash_unlock_region(nxt, i));

  return NXT_OK;
}
