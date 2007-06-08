/**
 * NXT bootstrap interface; NXT flash chip access code.
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

#ifndef __FLASH_H__
#define __FLASH_H__

#include "error.h"
#include "lowlevel.h"

nxt_error_t nxt_flash_wait_ready(nxt_t *nxt);
nxt_error_t nxt_flash_lock_region(nxt_t *nxt, int region_num);
nxt_error_t nxt_flash_unlock_region(nxt_t *nxt, int region_num);
nxt_error_t nxt_flash_lock_all_regions(nxt_t *nxt);
nxt_error_t nxt_flash_unlock_all_regions(nxt_t *nxt);

#endif /* __FLASH_H__ */
