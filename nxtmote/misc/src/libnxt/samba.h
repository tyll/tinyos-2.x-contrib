/**
 * NXT bootstrap interface; NXT bootstrap control functions.
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

#ifndef __SAMBA_H__
#define __SAMBA_H__

#include <stdint.h>
#include "error.h"
#include "lowlevel.h"

typedef uint32_t nxt_addr_t;
typedef uint32_t nxt_word_t;
typedef uint16_t nxt_hword_t;
typedef unsigned char nxt_byte_t;

nxt_error_t nxt_write_byte(nxt_t *nxt, nxt_addr_t addr, nxt_byte_t b);
nxt_error_t nxt_write_hword(nxt_t *nxt, nxt_addr_t addr, nxt_hword_t hw);
nxt_error_t nxt_write_word(nxt_t *nxt, nxt_addr_t addr, nxt_word_t w);

nxt_error_t nxt_read_byte(nxt_t *nxt, nxt_addr_t addr, nxt_byte_t *b);
nxt_error_t nxt_read_hword(nxt_t *nxt, nxt_addr_t addr, nxt_hword_t *hw);
nxt_error_t nxt_read_word(nxt_t *nxt, nxt_addr_t addr, nxt_word_t *w);

nxt_error_t nxt_send_file(nxt_t *nxt, nxt_addr_t addr,
                          char *file, unsigned short len);
nxt_error_t nxt_recv_file(nxt_t *nxt, nxt_addr_t addr,
                          char *file, unsigned short len);

nxt_error_t nxt_jump(nxt_t *nxt, nxt_addr_t addr);

nxt_error_t nxt_samba_version(nxt_t *nxt, char *version);

#endif /* __SAMBA_H__ */
