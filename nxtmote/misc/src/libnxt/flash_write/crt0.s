/**
 * NXT bootstrap interface; NXT onboard flashing driver bootstrap.
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

.text
.align 4
.globl _start

_start:
	/* Initialize the stack */
	mov sp, #0x210000

	/* Preserve old link register */
	stmfd sp!, {lr}

	/* Call main */
	bl nxt_main

	/* Return */
	ldmfd sp!, {pc}
