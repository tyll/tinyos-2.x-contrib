/**
 * NXT bootstrap interface; error handling code.
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

#ifndef __ERROR_H__
#define __ERROR_H__

typedef enum
{
  NXT_OK = 0,
  NXT_NOT_PRESENT = 1,
  NXT_CONFIGURATION_ERROR = 2,
  NXT_IN_USE = 3,
  NXT_USB_WRITE_ERROR = 4,
  NXT_USB_READ_ERROR = 5,
  NXT_SAMBA_PROTOCOL_ERROR = 6,
  NXT_HANDSHAKE_FAILED = 7,
  NXT_FILE_ERROR = 8,
  NXT_INVALID_FIRMWARE = 9,
} nxt_error_t;

const char const *nxt_str_error(nxt_error_t err);

#define NXT_ERR(expr)                   \
  do {                                  \
    nxt_error_t nxt__err_temp = (expr); \
    if (nxt__err_temp)                  \
      return nxt__err_temp;             \
  } while(0)

#endif /* __ERROR_H__ */
