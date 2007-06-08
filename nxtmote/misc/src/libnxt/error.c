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

#include "error.h"

static const char const *err_str[] = {
  "Success",
  "NXT not found on USB bus",
  "Error trying to configure the NXT USB link",
  "NXT USB interface is already claimed by another program",
  "USB write error",
  "USB read error",
  "SAM-BA protocol error",
  "NXT handshake failed",
  "File open/handling error",
  "Invalid firmware image",
};

const char const *
nxt_str_error(nxt_error_t err)
{
  return err_str[err];
}
