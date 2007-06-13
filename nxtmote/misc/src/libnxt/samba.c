/**
 * NXT bootstrap interface; NXT Bootstrap control functions.
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
#include <string.h>
#include "error.h"
#include "lowlevel.h"
#include "samba.h"

static nxt_error_t
nxt_format_command2(char *buf, char cmd,
                    nxt_addr_t addr, nxt_word_t word)
{
  snprintf(buf, 20, "%c%08X,%08X#", cmd, addr, word);

  return NXT_OK;
}

static nxt_error_t
nxt_format_command(char *buf, char cmd, nxt_addr_t addr)
{
  snprintf(buf, 20, "%c%08X#", cmd, addr);

  return NXT_OK;
}


static nxt_error_t
nxt_write_common(nxt_t *nxt, char type, nxt_addr_t addr, nxt_word_t w)
{
  char buf[21] = {0};

  NXT_ERR(nxt_format_command2(buf, type, addr, w));
  NXT_ERR(nxt_send_str(nxt, buf));

  return NXT_OK;
}


nxt_error_t
nxt_write_byte(nxt_t *nxt, nxt_addr_t addr, nxt_byte_t b)
{
  return nxt_write_common(nxt, 'O', addr, b);
}


nxt_error_t
nxt_write_hword(nxt_t *nxt, nxt_addr_t addr, nxt_hword_t hw)
{
  return nxt_write_common(nxt, 'H', addr, hw);
}


nxt_error_t
nxt_write_word(nxt_t *nxt, nxt_addr_t addr, nxt_word_t w)
{
  return nxt_write_common(nxt, 'W', addr, w);
}


static nxt_error_t
nxt_read_common(nxt_t *nxt, char cmd, int len,
                nxt_addr_t addr, nxt_word_t *word)
{
  char buf[20] = {0};
  nxt_word_t w;

  NXT_ERR(nxt_format_command2(buf, cmd, addr, len));
  NXT_ERR(nxt_send_str(nxt, buf));
  NXT_ERR(nxt_recv_buf(nxt, buf, len));

  w = *((nxt_word_t*)buf);

#ifdef _NXT_BIG_ENDIAN
  /* The value returned is in little-endian byte ordering, so swap
     bytes on a big-endian architecture. */
  w = (((w & 0x000000FF) << 24) +
       ((w & 0x0000FF00) << 8)  +
       ((w & 0x00FF0000) >> 8)  +
       ((w & 0xFF000000) >> 24));
#endif /* _NXT_BIG_ENDIAN */

  *word = w;
  return NXT_OK;
}


nxt_error_t
nxt_read_byte(nxt_t *nxt, nxt_addr_t addr, nxt_byte_t *b)
{
  nxt_word_t w;
  NXT_ERR(nxt_read_common(nxt, 'o', 1, addr, &w));
  *b = (nxt_byte_t)w;

  return NXT_OK;
}


nxt_error_t
nxt_read_hword(nxt_t *nxt, nxt_addr_t addr, nxt_hword_t *hw)
{
  nxt_word_t w;

  NXT_ERR(nxt_read_common(nxt, 'h', 2, addr, &w));
  *hw = (nxt_hword_t)w;

  return NXT_OK;
}


nxt_error_t
nxt_read_word(nxt_t *nxt, nxt_addr_t addr, nxt_word_t *w)
{
  return nxt_read_common(nxt, 'w', 4, addr, w);
}


nxt_error_t
nxt_send_file(nxt_t *nxt, nxt_addr_t addr, char *file, unsigned short len)
{
  char buf[20];

  NXT_ERR(nxt_format_command2(buf, 'S', addr, len));
  NXT_ERR(nxt_send_str(nxt, buf));
  NXT_ERR(nxt_send_buf(nxt, file, len));

  return NXT_OK;
}


nxt_error_t
nxt_recv_file(nxt_t *nxt, nxt_addr_t addr, char *file, unsigned short len)
{
  char buf[20];

  NXT_ERR(nxt_format_command2(buf, 'R', addr, len));
  NXT_ERR(nxt_send_str(nxt, buf));
  NXT_ERR(nxt_recv_buf(nxt, file, len+1));
  return NXT_OK;
}


nxt_error_t
nxt_jump(nxt_t *nxt, nxt_addr_t addr)
{
  char buf[20];

  NXT_ERR(nxt_format_command(buf, 'G', addr));

  NXT_ERR(nxt_send_str(nxt, buf));
  return NXT_OK;
}


nxt_error_t
nxt_samba_version(nxt_t *nxt, char *version)
{
  char buf[3];
  strcpy(buf, "V#");
  NXT_ERR(nxt_send_str(nxt, buf));
  NXT_ERR(nxt_recv_buf(nxt, version, 4));
  version[4] = 0;
  return NXT_OK;
}
