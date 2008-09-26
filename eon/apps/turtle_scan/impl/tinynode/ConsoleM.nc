/*
 * file:        ConsoleM.nc
 * description: implementation of simple serial console
 *
 * author:      Peter Desnoyers, UMass Computer Science Dept.
 * $Id$
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

module ConsoleM {
    provides interface Console;
    uses interface HPLUART;
}

#define CONBUF_SIZ 128

implementation {
    char buf[CONBUF_SIZ];
    uint8_t head, tail;
    bool busy;
    
    command result_t Console.init() {
	call HPLUART.init();
	return SUCCESS;
    }

    int buffer(char c) {
	uint8_t nxt, done;
	for (done = 0; !done;) atomic {
	    nxt = (head+1) % CONBUF_SIZ;
	    if (nxt != tail)
		buf[head] = c;
	    head = nxt;
	    done = 1;
	}
	return 0;
    }

    void kick() {
	char c = 0;
	atomic {
	    if (!busy) {
		c = buf[tail];
		tail = (tail+1) % CONBUF_SIZ;
		busy = 1;
	    }
	}
	if (c != 0) 
	    call HPLUART.put(c);
    }

    async event result_t HPLUART.putDone() {
	char c = 0;
	atomic {
	    if (head != tail) {
		c = buf[tail];
		tail = (tail+1) % CONBUF_SIZ;
	    }
	    else
		busy = 0;
	}
	if (c != 0)
	    call HPLUART.put(c);
	return SUCCESS;
    }

    static inline char hex(unsigned a) {
	if (a < 10) return '0' + a;
	return 'A' + a - 10;
    }

    static inline void decimal(int32_t n) {
	if (n == 0)
	    buffer('0');
	else {
	    uint8_t b[8], i = 0;
	    while (n != 0) {
		b[i++] = '0' + (n%10);
		n = n/10;
	    }
	    do 
		buffer(b[--i]);
	    while (i != 0);
	}
    }

    static inline void hexn(char len, int n) {
	if (len > '3')
	    buffer(hex((n>>12)&15));
	if (len > '2')
	    buffer(hex((n>>8)&15));
	if (len > '1')
	    buffer(hex((n>>4)&15));
	buffer(hex(n&15));
    }

    /* process up through the first %-escape, and then return the rest
     * of the format string.
     */
    static inline char *printf_x(char *fmt, int val) {
	while (*fmt) {
	    if (*fmt == '\n')
		buffer('\r');
	    if (*fmt != '%') {
		buffer(*fmt++);
		continue;
	    }
	    if (fmt[1] == 'x') {
		hexn(fmt[2], val);
		fmt += 3;
	    } else if (fmt[1] == 'd') {
		decimal(val);
		fmt += 2;
	    } else 
		fmt += 2;
	    break;
	}
	kick();
	return fmt;
    }

    command void Console.printf0(char *fmt) {
	printf_x(fmt, 0);
    }
    

    command void Console.printf1(char *fmt, int16_t val) {
	fmt = printf_x(fmt, val);
	if (*fmt)
	    printf_x(fmt, 0);
    }

    command void Console.printf2(char *fmt, int16_t val1, int16_t val2) {
	fmt = printf_x(fmt, val1);
	if (*fmt)
	    fmt = printf_x(fmt, val2);
	if (*fmt)
	    fmt = printf_x(fmt, 0);
    }

    command void Console.newline() {
	buffer('\r');
	buffer('\n');
	kick();
    }

    uint8_t cmd[10], *ptr = cmd;

    task void do_cmd() {
	signal Console.input(cmd);
	atomic {
	    ptr = cmd;
	    *ptr = 0;
	}
    }

    default event void Console.input(char* s) {
    }

    async event result_t HPLUART.get(uint8_t t) {
	if (t == '\r' || t == '\n') 
	    post do_cmd();
	else if (ptr < &cmd[9]) {
	    *ptr++ = t;
	    *ptr = 0;
	}
	return SUCCESS;
    }
}
