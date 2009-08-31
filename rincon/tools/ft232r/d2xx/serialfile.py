########################################################################
### serialfile.py
###

import sys

### not used herein
PARITY_EVEN = 0

class Serial:
    _FILE = None

    _LANG = None
    
    _XTAB = {
        None : "_translate_bin",
        "bin": "_translate_bin",
        "BIN": "_translate_bin",
        "h"  : "_translate_h",
        "H"  : "_translate_h",
        "c"  : "_translate_c",
        "C"  : "_translate_c",
        "raw": "_translate_raw",
        "RAW": "_translate_raw",
    }

    _CMD_SIZE   = 0x00
    _CMD_BEGIN  = 0x01
    _CMD_BSL    = 0x02
    _CMD_WBLK   = 0x03
    _CMD_B38400 = 0x04
    _CMD_AMADDR = 0x05
    _CMD_END    = 0x06
    _CMD_ILL    = 0xff

    _VERSTR = '\xf1l @\x00\x00\x00\x00\x00\x00\x01a\x01\x00\xd1Mo\xef'

    _BAUD_38400 = [128, 32, 4, 4, 224, 135, 2, 0, 153, 92]

    ### not used herein
    portstr = "serialfile"

    def __init__(self, dev, baud, **kw):
        self._rq = [ ]
        self._wq = [ ]
        self._cq = [ ]
        assert baud == 9600
        self._cq.append("BSL_CMD_BEGIN")  # Power up, start UART 9600 8E1

    def _translate_h(self, fp, cmds, mutex=True):
        if mutex:
            fp.write("#ifndef __bsl_cmd_h__\n"
                     "#define __bsl_cmd_h__\n"
                     "\n")
        fp.write("#define BSL_SYNC 0x80\n"
                 "#define BSL_ACK  0x90\n"
                 "\n")
        fp.write("#ifdef __AVR__\n"
                 "#include <avr/pgmspace.h>\n"
                 "#define BSL_TYPE prog_uchar\n"
                 "#define BSL_GET(a,x) pgm_read_byte(&(a)[x])\n"
                 "#endif\n"
                 "\n"
                 "#ifdef __MSP430__\n"
                 "#define BSL_TYPE const uint8_t\n"
                 "#define BSL_GET(a,x) ((a)[x])\n"
                 "#endif\n"
                 "\n"
                 "#ifndef BSL_TYPE\n"
                 "#error \"BSL_TYPE not defined!\"\n"
                 "#endif\n"
                 "\n")
        fp.write("#define BSL_SIZE(a) \\\n"
                 "  (((a)[0] == BSL_CMD_SIZE) ? \\\n"
                 "  ((((uint32_t) (a)[1])      ) | \\\n"
                 "   (((uint32_t) (a)[2]) <<  8) | \\\n"
                 "   (((uint32_t) (a)[3]) << 16) | \\\n"
                 "   (((uint32_t) (a)[4]) << 24)) : \\\n"
                 "  0)\n"
                 "\n")
        fp.write("typedef enum bsl_cmd {\n"
                 "  BSL_CMD_SIZE   = 0x%02x, /* decl cmd array size */\n"
                 "  BSL_CMD_BEGIN  = 0x%02x, /* start UART, MSP pwr off */\n"
                 "  BSL_CMD_BSL    = 0x%02x, /* invoke BSL on MSP */\n"
                 "  BSL_CMD_WBLK   = 0x%02x, /* write blk to BSL */\n"
                 "  BSL_CMD_B38400 = 0x%02x, /* UART 38400 8E1 */\n"
                 "  BSL_CMD_AMADDR = 0x%02x, /* AM addr offset */\n"
                 "  BSL_CMD_END    = 0x%02x  /* UART off */\n"
                 "} bsl_cmd_t;\n"
                 "\n" % \
                 (self._CMD_SIZE,
                  self._CMD_BEGIN,
                  self._CMD_BSL,
                  self._CMD_WBLK,
                  self._CMD_B38400,
                  self._CMD_AMADDR,
                  self._CMD_END))
        if mutex:
            fp.write("#endif\n"
                     "\n")

    def _translate_c(self, fp, cmds):
        self._translate_h(fp, None, False)
        fp.write("BSL_TYPE bsl_cmd_list[] = {\n")
        for cmd in cmds:
            cmd = cmd.split()
            if len(cmd) == 1:
                cmd = cmd[0]
                assert cmd not in ("BSL_CMD_SIZE", "BSL_CMD_WBLK", "BSL_CMD_AMADDR")
                if cmd == "BSL_CMD_ILL":
                    cmd = "0x%02x" % self._CMD_ILL
                fp.write("  " + cmd + ",\n")
                continue
            c = cmd[0]
            del cmd[0]
            assert c in ("BSL_CMD_SIZE", "BSL_CMD_WBLK", "BSL_CMD_AMADDR")
            fp.write("  " + c + ",\n")
            fp.write("    ")
            for c in cmd:
                fp.write(" 0x" + c + ",")
            fp.write("\n")
        fp.write("};\n"
                 "\n")

    def _translate_bin(self, fp, cmds):
        for cmd in cmds:
            cmd = cmd.split()
            if len(cmd) == 1:
                cmd = cmd[0]
                assert cmd not in ("BSL_CMD_SIZE", "BSL_CMD_WBLK", "BSL_CMD_AMADDR")
                cmd = cmd[3:]
                val = getattr(self, cmd)
                fp.write(chr(val))
                continue
            c = cmd[0]
            del cmd[0]
            assert c in ("BSL_CMD_SIZE", "BSL_CMD_WBLK", "BSL_CMD_AMADDR")
            c = getattr(self, c[3:])
            fp.write(chr(c))
            cmd = map(lambda s: int(s, 16), cmd)
            for c in cmd:
                fp.write(chr(c))

    def _translate_raw(self, fp, cmds):
        cmds.append("")
        fp.write("\n".join(cmds))

    def _fix(self, cmds):
        cmds.insert(0, "BSL_CMD_SIZE - - - -")
        sz = 0
        for i in xrange(len(cmds)):
            cmd = cmds[i].split()
            sz += len(cmd)
            if cmd[0] == "BSL_CMD_WBLK":
                ### insert #data bytes after BSL_CMD_WBLK
                cmd.insert(1, "%02x" % (len(cmd) - 1))
                ### replace array entry
                cmds[i] = " ".join(cmd)
                sz += 1
        ### burn in table size
        cmds[0] = "BSL_CMD_SIZE %02x %02x %02x %02x" % \
                  ((sz & 0xff),
                   ((sz >>  8) & 0xff),
                   ((sz >> 16) & 0xff),
                   ((sz >> 24) & 0xff))
        ### pad to multiple of 16 with illegal command
        ### NB all the embedded stuff deals in 16-blocks
        while sz & 0x0f:
            cmds.append("BSL_CMD_ILL")
            sz += 1

    def _translate(self, cmds):
        ### patch up table
        self._fix(cmds)
        ### open output file
        fp = self._FILE and open(self._FILE, "w") or sys.stdout
        ### generate data
        try:
            getattr(self, self._XTAB[self._LANG])(fp, cmds)
        finally:
            fp.close()

    def flushInput(self): pass
    def flushOutput(self): pass
    def resetMCU(self): pass
    def setDTR(self, *rest): pass
    def setRTS(self, *rest): pass
    def setBaudrate(self, x):
        assert x == 38400

    def close(self):
        self._cq.append("BSL_CMD_END")    # Stop UART, power off
        self._translate(self._cq)
        self.__dict__.clear()

    def enterBSL(self):
        self._cq.append("BSL_CMD_BSL")    # Execute sequence to enter BSL

    def read(self, n):
        if self._rq:
            assert not self._wq
            assert n <= len(self._rq), (n, len(self._rq), self._rq)
            r = self._rq[:n]
            del self._rq[:n]
            ### target won't do version query -- so don't record cmd
            ### print >>sys.stderr, "READ", n, map(hex, r)
            return "".join(map(chr, r))
        
        q, self._wq = self._wq, [ ]
        assert q and (q[0] == 0x80)
        br = False
        if (len(q) > 1):
            if (q[1] == 0x14):
                ### TX data block (version query)
                assert self._cq and (self._cq[-1] == "BSL_CMD_SYNC")
                self._cq.pop()
                assert len(q) == 10
                self._rq = [0x80, 0x00, q[6], q[6]] + \
                           [ord(x) for x in self._VERSTR]
                ### target won't do version query -- so don't record cmd
                return self.read(n)
            elif (q[1] == 0x20):
                ### set baud rate (to 38400)
                assert q == self._BAUD_38400
                br = True
            elif q[1] == 0x22:
                ### AM address hack
                assert self._cq and (self._cq[-1] == "BSL_CMD_SYNC")
                self._cq.pop()
                ### 80 22 04 04 AL AH 00 00
                assert q[:4] == [0x80, 0x22, 0x04, 0x04]
                assert (len(q) == 10) and (q[5:8] == [0x00, 0x00, 0x00]), q
                assert q[4] < 0xff
                self._cq.append("BSL_CMD_AMADDR %02x" % q[4])
                q = ( )
        assert n == 1
        if len(q) == 1:
            ### send SYNC, expect ACK
            self._cq.append("BSL_CMD_SYNC")  ### TX 0x80, RX 0x90
        elif len(q):
            ### send block, expect ACK
            assert self._cq and (self._cq[-1] == "BSL_CMD_SYNC")
            self._cq.pop()
            self.wblk(q)
        if br:
            self._cq.append("BSL_CMD_B38400")  ### UART 38400 8E1
        return "\x90"

    def wblk(self, data):
        d = " ".join(["%02x" % x for x in data])
        self._cq.append("BSL_CMD_WBLK " + d) ### SYNC+ACK, TX data, RX ACK

    def write(self, s):
        assert not self._rq
        assert len(s) == 1
        self._wq.append(ord(s))

    def _func(self, name, *rest):
        print >>sys.stderr, name, rest

    def __getattr__(self, attr):
        if attr[:2] == "__":
            raise AttributeError, attr
        def f(*rest, **kw):
            return self._func(attr, *rest)
        return f

### EOF serialfile.py

