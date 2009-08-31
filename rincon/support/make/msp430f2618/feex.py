#!/bin/sh
########################################################################
### feex.py
###

'''exec' python $0 ${1+"$@"}
'''

__version__ = "0.4"

import re

UID = "_feex_"

class Symbol:
    globl   = False  # decl as .global
    local   = False  # decl as .local
    comm    = False  # decl as .comm
    intrnl  = False  # starts with .L
    label   = False  # appears as a label?
    type    = None   # @object, @function, or None for .Lxxx
    size    = None   # int>0 if obj, autogen for funcs, None for .Lxxx
    sect    = None   # .text, .data, .far, .bss, .jtab, .cstrs, .near, .stub
                     # .cstub, .swx, .extern, .nosect
    body    = None   # code for symbol
    #jumps  = None   # list jump table names for func
    align   = None   # alignment for symbols (funcs always aligned)
    oname   = None   # output name (without "$")
    obody   = None   # output body (without "$")
    done    = False  # have we generated output?

    def __init__(self, symtab, name):
        self.symtab = symtab  # Symtab to which we're bound
        self.name   = name    # our name

    def __call__(self, sect, writer):
        if self.sect != sect:
            return
        assert sect
        f = getattr(self, "gen__" + sect.replace(".", ""), None)
        if f is None:
            return
        assert callable(f)
        assert not self.done
        self.done = True
        assert self.oname
        if not self.obody:
            self.obody = (self.body or "").replace("$", UID)
        f(writer)

    def gen__nosect(self, writer):
        assert not (self.local or self.comm)

    def gen__bss(self, writer):
        if self.local:
            writer("\n\t.local " + self.oname)
        writer("\n\t.comm " + self.oname + "," + self.comm)

    def gen__data(self, writer):
        if self.globl:
            writer("\n\t.global " + self.oname)
        writer("\n\t.type " + self.oname + ",@object")
        writer("\n\t.size " + self.oname + "," + str(self.size))
        writer(self.align)
        writer("\n" + self.oname + ":")
        writer(self.obody)

    def gen__text(self, writer):
        if self.globl:
            writer("\n\t.global " + self.oname)
        writer(self.align)
        writer("\n" + self.oname + ":")
        writer(self.obody)

    def gen__jtab(self, writer):
        #writer("\n\t.p2align 1,0\n" + self.oname + ":")
        writer(self.obody + "\n\n")

    def gen__cstrs(self, writer):
        writer("\n" + self.oname + ":")
        writer(self.obody)

    def gen___func(self, writer):
        if self.globl:
            writer("\n\t.global " + self.oname)
        assert (self.type == "@function") and self.label
        writer("\n\t.type " + self.oname + ",@function")
        writer("\n\t.p2align 1,0")
        lbl = "\n" + self.oname + ":"
        b   = self.obody
        if lbl not in b:
            writer(lbl)
        if not b.startswith("\n"):
            writer("\n")
        writer(b)
        writer("\n\t.size " + self.oname + ", .-" + self.oname)
        writer("\n")

    gen__stub = gen___func
    gen__far  = gen___func
    gen__near = gen___func

    def gen__cstub(self, writer):
        #writer("\n\t.type " + self.oname + ",@function")
        writer("\n.p2align 1,0" + \
               "\n" + self.oname + ":" + \
               self.obody + \
               "\n")
        #writer("\n\t.size " + self.oname + ", .-" + self.oname + "\n")

    gen__swx   = gen__cstub

    def gen__extern(self, writer): pass

class Symtab:
    def __len__(self):
        return len(self.__dict__)

    def __contains__(self, name):
        return ("$" + name) in self.__dict__

    def __iter__(self):
        return iter([n[1:] for n in self.__dict__.keys()])

    def syms(self):
        return self.__dict__.values()

    def __delitem__(self, item):
        name = getattr(item, "name", item)
        del self.__dict__["$" + name]

    def add(self, name):
        if not isinstance(name, str):
            raise TypeError, "Non-string symbol name?!?"
        if not name:
            raise RuntimeError, "Empty symbol name encountered"
        if name in self:
            raise RuntimeError, "Dup label " + repr(name) + " encountered"
        ret = Symbol(self, name)
        setattr(self, "$" + name, ret)
        return ret

    def fetch(self, name):
        return getattr(self, "$" + name)

    def get(self, name):
        ret = getattr(self, "$" + name, None)
        if ret is None:
            ret = self.add(name)
        return ret

class Translator:
    kws = ("ARCH", "UNIX", "NEAR", "TRIV", "DBG", "NPAT", "SPILL",
           "SHIFT")

    ARCH  = "msp430xG4618"
    DBG   = False
    UNIX  = False
    NEAR  = False
    TRIV  = False
    NPAT  = None
    SPILL = False
    SHIFT = False
    VER   = __version__

    ### if self.dbg is true...
    DEBUG_FARJMP_NEAR = False  ### code FARJMP as "br #tgt", else bra
    DEBUG_FARTAB_NEAR = False  ### code FARTAB as "br tgt", else reta
    DEBUG_BR_IMM      = False  ### leave "br .Lxxx" alone, else FARJMP
    DEBUG_BR_TABLE    = False  ### leave "br tbl(rX)" alone, else FARTAB
    DEBUG_CALL        = False  ### leave "call #tgt" alone, else stubbify
    DEBUG_CALL_INLINE = False  ### inline phony call if !DEBUG_CALL
    DEBUG_CALL_POP    = False  ### call stub is called if !DEBUG_CALL

    def __init__(self, fname, **kw):
        import time
        self._start = time.time()
        self.start  = time.ctime()
        self.symtab = Symtab()
        self.fname  = fname
        self.nears  = [ ]
        self.cseq   = 0
        self.sseq   = 0

        for k in kw:
            ku = k.upper()
            if ku not in self.kws:
                raise ValueError, "Bad keyword " + repr(k)
            v = getattr(self, ku)
            if v is None:
                t = str
            else:
                t = type(v)
            setattr(self, ku, t(kw[k]))
        for k in self.kws:
            kl = k.lower()
            setattr(self, kl, getattr(self, k))
        self.ver  = self.VER

        import sys
        self.prog = sys.argv[0]

        if self.npat:
            try:
                self.npat_ = re.compile(self.npat)
            except:
                raise SystemExit, "Bad RX " + repr(self.npat)
        else:
            self.npat_ = re.compile("\x01")

        if self.dbg:
            self.near = True
            print >>sys.stderr, "\nDEBUG MODE SELECTED!\n"

        if self.triv:
            self.near = True
            print >>sys.stderr, "\nUSING TRIVIAL CONVERSION!\n"

        if self.near:
            print >>sys.stderr, "\nUSING NEAR-ONLY MODEL!\n"

        if self.spill:
            print >>sys.stderr, "\nRegister spill optimization enabled\n"

        if self.shift:
            print >>sys.stderr, "\nShift optimizations enabled\n"

    def loadfile(self, name):
        text = open(name, "r").read()
        text = text.replace("\r\n", "\n").replace("\r", "\n")
        text = "\n" + text.rstrip() + "\n"
        if ("\x01" in text) or ("\x02" in text):
            raise ValueError, "Illegal chars in asm text"
        return text

    MODAL_RX = re.compile(r"(/\*(.|\n)*?\*/)|" + \
                          r"(//[^\n]*(?=\n))|" + \
                          r"(;[^\n]*(?=\n))|" + \
                          r"(\"([^\\\n]|\\.)*?\")")

    def parse1(self, text):
        from urllib import quote
        from cStringIO import StringIO
        r = StringIO()
        w = r.write
        c = None
        m = self.MODAL_RX.search(text)
        while m:
            h = text[:m.start(0)]
            if h:
                c = h[-1]
                w(h)
            mtch = m.group(0)
            out  = quote(mtch) + "\x02"
            if (not mtch.startswith('"')) and (c != "\n"):
                out = "\n\x01-" + out
            else:
                out = "\x01" + out
            w(out)
            c    = mtch[-1]
            text = text[m.end(0):]
            m    = self.MODAL_RX.search(text)
        if text:
            w(text)
        text = r.getvalue()
        for ch in "\b\v\f\"'{}":
            if ch in text:
                raise ValueError, "Illegal chars in asm text"
        for st in ("\\\\", "/*", "*/", "//", ";", ".L$"):
            if st in text:
                raise ValueError, "Illegal chars in asm text"
        if UID in text:
            raise ValueError, "UID " + repr(UID) + " found in " + \
                  "text. Please change the source code."
        text = text.replace("\x01", "{").replace("\x02", "}")
        return text

    BRACE_RX = re.compile(r"\{[^}]+\}")

    def unparse1(self, text):
        from cStringIO import StringIO
        from urllib import unquote
        text = text.replace("\n{-", "{")
        r = StringIO()
        w = r.write
        m = self.BRACE_RX.search(text)
        while m:
            w(text[:m.start(0)])
            enc = m.group(0)[1:-1]
            w(unquote(enc))
            text = text[m.end(0):]
            m    = self.BRACE_RX.search(text)
        if text:
            w(text)
        return r.getvalue()

    def extract(self, text, rx):
        """
        Extract everything from text that contains rx
          - Return the nonmatching text and a list of matches
        """
        from cStringIO import StringIO
        m = rx.search(text)
        r = StringIO()
        w = r.write
        o = [ ]
        while m:
            w(text[:m.start(0)])
            o.append(m.group(0))
            text = text[m.end(0):]
            m    = rx.search(text)
        if text:
            w(text)
        return r.getvalue(), o

    GLOBAL_RX = re.compile(r"\n[ \t]*\.global\s+[_A-Za-z][_A-Za-z0-9$]*[ \t]*(?=\n)")

    def do_globl(self, text):
        text, l = self.extract(text, self.GLOBAL_RX)
        for decl in l:
            decl = decl.split()
            assert len(decl) == 2
            s = self.symtab.get(decl[1])
            s.globl = True
        ### make sure we got 'em all
        if ".global" in text:
            raise RuntimeError, ".global decl extraction failed"
        return text

    LOCAL_RX = re.compile(r"\n[ \t]*\.local\s+[_A-Za-z][_A-Za-z0-9$]*[ \t]*(?=\n)")

    def do_local(self, text):
        text, l = self.extract(text, self.LOCAL_RX)
        for decl in l:
            decl = decl.split()
            assert len(decl) == 2
            s = self.symtab.get(decl[1])
            if s.globl:
                raise RuntimeError, ".global symbol also declared .local"
            s.local = True
        ### make sure we got 'em all
        if ".local" in text:
            raise RuntimeError, ".local decl extraction failed"
        return text

    COMM_RX = re.compile(r"\n[ \t]*\.comm\s+[_A-Za-z][_A-Za-z0-9$]*\s*(,\s*\d+){1,2}[ \t]*(?=\n)")

    def do_comm(self, text):
        text, l = self.extract(text, self.COMM_RX)
        for decl in l:
            decl = decl.split()
            assert len(decl) == 2
            decl = decl[1].replace(",", " ")
            decl = decl.split()
            assert len(decl) in (2, 3)
            if len(decl) == 3:
                decl = [decl[0], decl[1] + "," + decl[2]]
            s = self.symtab.get(decl[0])
            s.comm = decl[1]
            s.sect = ".bss"
        ### make sure we got 'em all
        if ".comm" in text:
            raise RuntimeError, ".comm decl extraction failed"
        return text

    FUNCSZ_RX = re.compile(r"\n(\.Lfe\d+):\n\s*\.size\s+([_A-Za-z][_A-Za-z0-9$]*)\s*,\s*\1\s*-\s*\2(?=\n)")

    def kill_Lfe(self, text):
        from cStringIO import StringIO
        r = StringIO()
        w = r.write
        m = self.FUNCSZ_RX.search(text)
        while m:
            w(text[:m.start(0)])
            w("\n\t.size " + m.group(2))
            text = text[m.end(0):]
            m    = self.FUNCSZ_RX.search(text)
        if text:
            w(text)
        ret = r.getvalue()
        if ".Lfe" in text:
            raise RuntimeError, ".Lfennn label kill failed"
        return ret

    def hack1(self, text):
        return text.replace("\n\t.LcmpSIe", "\n.LcmpSIe")

    LABEL_RX  = re.compile(r"\n[_A-Za-z][_A-Za-z0-9$]*:(?=\n)")
    LLABEL_RX = re.compile(r"\n\.L[_A-Za-z0-9]*:(?=\n)")
    TLABEL_RX = re.compile(r"\n\t?[1-9]\d*:\s*(?=\n)")

    def scan_labels(self, text):
        dummy, l = self.extract(text, self.LABEL_RX)
        for lbl in l:
            lbl = lbl.strip()[:-1]
            s   = self.symtab.get(lbl)
            ### can't be .comm if it has a label
            if s.comm:
                raise RuntimeError, "Label " + repr(lbl) + \
                      " has .comm decl"
            s.label = True
        dummy, l = self.extract(dummy, self.LLABEL_RX)
        for lbl in l:
            lbl = lbl.strip()[:-1]
            assert lbl.startswith(".L")
            if lbl.startswith(".L__FrameSize_") or \
               lbl.startswith(".L__FrameOffset"):
                raise RuntimeError, ".L__Framexxx symbol is label?!?"
            ### we killed all the .Lfe labels
            assert not lbl.startswith(".Lfe")
            s = self.symtab.get(lbl)
            assert not (s.label or s.intrnl)
            s.label  = True
            s.intrnl = True
        ### skip temp labels
        dummy, l = self.extract(dummy, self.TLABEL_RX)
        ### colons should only appear in labels
        if ":" in dummy:
            p = dummy.find(":")
            s = dummy[p - 20:p + 20]
            raise RuntimeError, "Spurious ':' chars detected at " + repr(s)
        ### all symbols we've seen should appear as labels OR be .comm decls
        for sym in self.symtab:
            s = self.symtab.fetch(sym)
            assert not (s.comm and s.label)
            if not (s.comm or s.label):
                raise RuntimeError, "Symbol " + repr(sym) + \
                      " has neither label nor .comm decl"

    OTYPE_RX = re.compile(r"\n[ \t]*\.type\s+[_A-Za-z][_A-Za-z0-9$]*\s*,\s*@object(?=\n)")

    def do_otype(self, text):
        text, l = self.extract(text, self.OTYPE_RX)
        for item in l:
            sym    = item.split()[1].replace(",", " ").split()[0]
            s      = self.symtab.fetch(sym)
            s.type = "@object"
            if not s.label:
                raise RuntimeError, "Typed object " + repr(sym) + \
                      " has no label"
            if s.intrnl:
                raise RuntimeError, "Local label " + repr(sym) + \
                      " has type info"
        return text

    OSIZE_RX = re.compile(r"\n[ \t]*\.size\s+[_A-Za-z][_A-Za-z0-9$]*\s*,\s*\d+(?=\n)")

    def do_osize(self, text):
        text, l = self.extract(text, self.OSIZE_RX)
        for item in l:
            sym, sz = item.split(None, 1)[1].replace(",", " ").split()
            sz = int(sz)
            ### size must be positive
            if sz <= 0:
                raise RuntimeError, "Symbol " + repr(sym) + \
                      " has nonpositive .size"
            s      = self.symtab.fetch(sym)
            s.size = sz
            if s.intrnl:
                raise RuntimeError, "Local label " + repr(sym) + \
                      " has size info"
            if s.type != "@object":
                raise RuntimeError, "Sized object " + repr(sym) + \
                      " has incorrect type"
            if not s.label:
                raise RuntimeError, "Sized object " + repr(sym) + \
                      " has no label"
        return text

    FPROLOGUE_RX = re.compile(r"(.|\n)*?(?=\n\t\.(text|data)\n)")
    FEPILOGUE_RX = re.compile(r"\{/[^\}]+?prologues[^\}]+?epilogues[^\}]+?/\}\n+")

    ### prologue can only contain this AFAIK -- enforce it
    XPROLOGUE_RX = re.compile(r"\s*(\.file\s+\{[^\}]*\}\n)?" + \
                              r"\s*(\.arch\s+[_A-Za-z0-9]+\n)?" + \
                              r"$")

    def do_pro_epi(self, text):
        m = self.FPROLOGUE_RX.search(text)
        if m:
            pro  = m.group(0)
            if not self.XPROLOGUE_RX.match(pro):
                raise RuntimeError, "Gibberish encountered in file prologue"
            text = text[m.end(0):]
        else:
            pro = ""
        self.prologue = pro
        m = self.FEPILOGUE_RX.search(text)
        if m:
            epi  = m.group(0)
            text = text[:m.start(0)]
        else:
            epi = ""
        self.epilogue = epi
        return text

    FSPLIT1_RX = re.compile(r"\n(\t\.text\n)?(\t\.p2align\s+1,0\n)?\t\.type")
    FSPLIT2_RX = re.compile(r"\n\.L[^C][_A-Za-z0-9]+:\n")

    def do_fsplit1(self, text):
        m = self.FSPLIT1_RX.search(text)
        if not m:
            raise RuntimeError, "No code found!"
        data = text[:m.start(0)] + "\n"
        code = text[m.start(0):]
        ### code shouldn't contain any .data directives
        if ".data" in code:
            raise RuntimeError, ".data found in code segment"
        tmp = code.split("\n\t.text\n")
        if len(tmp) == 2:
            assert not tmp[0], tmp
            code = "\n" + tmp[1]
        else:
            p1 = data.rfind("\n\t.data\n")
            p2 = data.rfind("\n\t.text\n")
            ### all functions must be in text segment
            if (p2 < 0) or (p2 <= p1):
                raise RuntimeError, "Functions exist outside .text segment"
        ### all local labels should be in code
        m = self.FSPLIT2_RX.match(data)
        if m:
            raise RuntimeError, "Local labels exist in data segments: " + \
                  repr(m.group(0))
        return data, code

    CSTR_RX = re.compile(r"\n\.LC\d+:" + \
                         "(\n\t\." + \
                         r"(ascii|asciz|string)\s+" + \
                         r"\{[^\}]*\}(?=\n))+")

    def do_strings(self, text):
        text, cstrs = self.extract(text, self.CSTR_RX)
        if (".ascii"  in text) or \
           (".asciz"  in text) or \
           (".string" in text):
            raise RuntimeError, "C string extraction failed"
        for cs in cstrs:
            tmp = cs.replace(":", " ").split()
            assert len(tmp) & 1
            name = tmp[0]
            del tmp[0]
            assert len(tmp) and not (len(tmp) & 1)
            s = self.symtab.fetch(name)
            assert not (s.globl or s.local or s.comm or s.type or s.size)
            assert s.intrnl and s.label
            s.sect = ".cstrs"
            tmp2   = [""]
            while tmp:
                tmp2.append(" ".join(tmp[:2]))
                del tmp[:2]
            s.body = "\n\t".join(tmp2)
        return text

    FRAME_RX = re.compile(r"\n\.L__Frame(Size|Offset)_[_A-Za-z][_A-Za-z0-9$]*=0x[0-9A-Fa-f]+(?=\n)")

    def kill_LFrame(self, text):
        text, dummy = self.extract(text, self.FRAME_RX)
        if ".L__Frame" in (text + self.data):
            raise RuntimeError, ".L__Frame... in program text -- " + \
                  "please recompile with optimization turned on"
        return text

    FEND_RX = re.compile(r"\n\t\.size\s+([_A-Za-z][_A-Za-z0-9$]*)\n\{/(%2A)+%20End%20of%20+function%20(%2A)+/\}\n")
    FBGN_RX = re.compile(r"\n(\t\.p2align\s+1,0)?\n\t\.type\s+([_A-Za-z][_A-Za-z0-9$]*),@function\n")

    def do_fsplit2(self, text):
        text = text.rstrip() + "\n"
        ### split bodies on end-of-func marker
        bodies = [ ]
        m = self.FEND_RX.search(text)
        while m:
            if not m.start(0):
                raise RuntimeError, "Found end-of-func at start of funcs?!?"
            ### save name and head+body
            ### drop .size -- we'll autogen
            bodies.append( (m.group(1), text[:m.start(0)]) )
            text = text[m.end(0):]
            m    = self.FEND_RX.search(text)
        text and bodies.append(text)
        ret = [ ]
        for (sym, b) in bodies:
            ### find start-of-func markers
            m = self.FBGN_RX.match(b)
            if not m:
                raise RuntimeError, "Cannot find start of " + repr(sym)
            ### make sure name agrees
            if m.group(2) != sym:
                raise RuntimeError, "Cross linked functions " + repr(sym) + \
                      " and " + repr(m.group(2))
            ### drop .align and .type -- we'll autogen these
            b = b[m.end(0):]
            if not b:
                raise RuntimeError, "Empty function body for " + repr(sym)
            ### sanity checks
            if ".size" in b:
                raise RuntimeError, "Body of " + repr(sym) + \
                      " contains .size"
            if ".type" in b:
                raise RuntimeError, "Body of " + repr(sym) + \
                      " contains .type"
            s = self.symtab.fetch(sym)
            if s.local or s.comm or s.intrnl or s.size or s.type:
                raise RuntimeError, "Garbage decl of func " + repr(sym)
            if not s.label:
                raise RuntimeError, "Function " + repr(sym) + \
                      " has no label?!?!?"
            if ("\n" + s.name + ":\n") not in b:
                raise RuntimeError, "Cannot find label in func " + \
                      repr(s.name)
            s.type  = "@function"
            s.body  = b
            ret.append(s)
        return ret

    DSEG_RX = re.compile(r"\n\t\.(data|text)(?=\n)")

    def do_dsplit(self, text):
        from cStringIO import StringIO
        text = "\n\t" + text.strip() + "\n"
        if (not text.startswith("\n\t.data")) and \
           (not text.startswith("\n\t.text")):
            raise RuntimeError, "Data segment starts with garbage"
        d = {
            "data": StringIO(),
            "text": StringIO(),
        }
        m = self.DSEG_RX.search(text)
        D = None
        while m:
            t = text[:m.start(0)]
            if t:
                if D is None:
                    raise RuntimeError, "Found data decls with no segment"
                if (".data" in t) or (".text" in t):
                    raise RuntimeError, "Data segment split failed"
                d[D].write(t)
            else:
                if D is not None:
                    raise RuntimeError, "Consecutive segment decls found"
            D    = m.group(1)
            text = text[m.end(0):]
            m    = self.DSEG_RX.search(text)
        if text:
            if D is None:
                raise RuntimeError, "Found data decls with no segment"
            d[D].write(text)
        return d["data"].getvalue(), d["text"].getvalue()

    JUMPT_RX = re.compile(r"(\n\t\.p2align\s+1,0(?=\n))*\n(\.L\d+):(\n\t\.word\s+\.L\d+(?=\n))+")
    ALIGN_RX = re.compile(r"\n\t\.p2align\s+1,0(?=\n)")
    DIREC_RX = re.compile(r"\n\t?\.(?!L\d+:)")
    XCOMM_RX = re.compile(r"\{-?[^\}]*\}")

    def extract_jumps(self, funcs):
        from cStringIO import StringIO
        for f in funcs:
            b = f.body
            r = StringIO()
            w = r.write
            j = [ ]
            m = self.JUMPT_RX.search(b)
            while m:
                w(b[:m.start(0)])
                ### ditch the aligns -- we'll always align 'em
                L = self.extract(m.group(0), self.ALIGN_RX)[0]
                ### attach jump table to symbol
                s = self.symtab.fetch(m.group(2))
                assert s.label and s.intrnl
                s.body = "/* Jump table for " + f.name + " */\n" + \
                         "\t.p2align 1,0" + L
                s.sect = ".jtab"
                ### tag function with its jtab(s)
                l = getattr(f, "jumps", [ ])
                l.append(s.name)
                setattr(f, "jumps", l)
                ### save info for sanity check
                t = L.split(":")[1].strip().split("\n")
                t = [x.split()[1] for x in t]
                j.append( (s.name,  t) )
                ### keep going
                b = b[m.end(0):]
                m = self.JUMPT_RX.search(b)
            w(b)
            b = r.getvalue()
            ### check refs for each jtab
            if j:
                ### remove comments, strings
                t = self.extract(b, self.XCOMM_RX)[0]
                for (tsym, syms) in j:
                    ### must be exactly one ref to each jtab
                    if len(t.split(tsym)) != 2:
                        raise RuntimeError, "Multiple refs for jtab " + \
                              repr(tsym) + " in func " + repr(f.name)
                    ### everything in the table must live inside this func
                    for s in syms:
                        u = "\n" + s + ":\n"
                        if u not in t:
                            raise RuntimeError, "Nonlocal entry " + repr(u) + \
                                  " in jtab " + repr(tsym) + \
                                  " in func " + repr(f.name)
            ### no directives should remain in func
            if self.DIREC_RX.match(b):
                raise RuntimeError, "Unknown asm directives found in func " + \
                      repr(f.name) + b
            f.body = b

    DSYMHEAD_RX = re.compile(r"((\n\t\.p2align\s+1,0(?=\n))?)\n((?:\.L|[_A-Za-z])[_A-Za-z0-9$]*):(?=\n)")

    def extract_dseg(self, text, sname):
        sym = None
        while text:
            m = self.DSYMHEAD_RX.search(text)
            if m:
                ### found hdr -- attach leader to prev sym decl
                b, text = text[:m.start(0)], text[m.end(0):]
                if sym and not b:
                    raise RuntimeError, "Empty decl for sym " + repr(sym.name)
                if b and not sym:
                    raise RuntimeError, "Leading gibberish in dseg"
                if b:
                    sym.body = b + "\n"
            else:
                ### trailing text -- attach to final sym
                b, text = text, ""
                if not sym:
                    raise RuntimeError, "Dseg parse failed"
                sym.body = b.rstrip() + "\n"
            ### ensure no other labels
            if ":" in b:
                raise RuntimeError, "Label extract failed in dseg"
            if b:
                assert not (sym.comm or sym.local)
                if sym.intrnl:
                    ### for .LC\d+
                    assert sym.label
                    assert not (sym.type or sym.size)
                    assert sym.name.startswith(".LC")
                    try:
                        int(sym.name[3:])
                    except:
                        raise RuntimeError, "Illegal local label crept in?!?!?!"
                    sym.intrnl = False
                else:
                    assert sym.label
                    assert sym.type == "@object"
                    assert sym.size
            ### update w/ symbol we found and continue
            if not m:
                continue
            sym = self.symtab.fetch(m.group(3))
            sym.align = m.group(1)
            sym.sect  = sname

    DDECL_OK = {
        ".ascii" : True,
        ".asciz" : True,
        ".byte"  : False,
        ".long"  : False,
        ".short" : False,
        ".skip"  : False,
        ".string": True,
    }

    DSEG_IDENT_RX = re.compile(r"(?:\.L|[_A-Za-z])[_A-Za-z0-9$]*")

    def validate_dsyms(self, syms):
        for sym in syms:
            name, body = sym.name, sym.body
            lines = [s.strip() for s in body.strip().split("\n")]
            for line in lines:
                decl, val = line.split(None, 1)
                flag = self.DDECL_OK.get(decl)
                if flag is None:
                    raise RuntimeError, "Unknown decl " + repr(decl) + \
                          " in symbol " + repr(name)
                if flag:
                    continue
                rest, ids = self.extract(val, self.DSEG_IDENT_RX)
                if ("." in rest) or ("$" in rest):
                    raise RuntimeError, "Bad chars in decl of " + \
                          repr(name) + ": " + repr(rest)
                for id in ids:
                    try:
                        s = self.symtab.fetch(id)
                    except:
                        raise RuntimeError, "Unknown reference to " + \
                              repr(id) + " in decl of " + repr(name)
                    if s.sect not in (".text", ".data", ".bss"):
                        raise RuntimeError, "Symbol " + repr(name) + \
                              " references disallowed symbol " + repr(id)

    ISR_LBL_RX = re.compile(r"\nvector_[0-9a-f]{4}:(?=\n)")

    def swizzle_isr(self, func, ilbl):
        lbl  = "\n" + ilbl + ":"
        decl = "\n\t.global " + ilbl
        body = func.body
        tmp  = body.split(lbl)
        if len(tmp) != 2:
            raise RuntimeError, "Cannot patch decl for ISR " + repr(func.name)
        func.body = (decl + lbl).join(tmp)

    def FARJMP(self, arg):
        if self.near:
            if self.DEBUG_FARJMP_NEAR and self.dbg:
                return "\n\tbr\t#" + arg
            return "\n\t.word\t0x0080\t; mova ofs, r0" + \
                   "\n\t.word\t" + arg
        else:
            return "\n\t.word\t0x0180\t; mova #0x10000+ofs, r0" + \
                   "\n\t.word\t" + arg

    def generate_stub(self, func):
        near      = func
        nname     = near.name
        fname     = "$F$" + nname
        far       = self.symtab.add(fname)
        far.body  = near.body.replace("\n" + nname + ":", "")
        near.body = self.FARJMP(fname)
        far.label = True
        far.type  = "@function"
        far.sect  = ".far"
        near.sect = ".stub"
        ### near retains other original properties...

    def assign_cseg(self, funcs):
        for f in funcs:
            n = f.name
            b = f.body
            i = self.extract(b, self.ISR_LBL_RX)[1]
            if "\n\treti\n" in b:
                ### make sure it has ONE isr-like label
                if len(i) != 1:
                    raise RuntimeError, "Cannot grok ISR decl in " + repr(n)
                ### make sure it's a secondary name
                i = i[0].strip()[:-1]
                if i == n:
                    raise RuntimeError, "Bogus ISR decl in " + repr(n)
                ### mark secondary for deletion
                t = self.symtab.fetch(i)
                if not t.globl:
                    raise RuntimeError, "Non-global secondary label " + \
                          repr(i) + " for func " + repr(n)
                t.sect = ".nosect"
                ### mark it as near
                self.swizzle_isr(f, i)
                f.sect = ".near"
            else:
                ### make sure it has NO isr-like label
                if len(i):
                    raise RuntimeError, "Non-ISR has ISR label: " + repr(n)
                ### give it a section
                nf = self.npat_.search(n)
                if (n == "main") or \
                   n.startswith("__nesc_") or \
                   nf:
                    if nf:
                        self.nears.append(n)
                    f.sect = ".near"
                else:
                    ### generate near stub and far symbol
                    if not self.triv:
                        self.generate_stub(f)
                    else:
                        f.sect = ".near"

    def gen_onames(self, syms):
        seen = { }
        for s in syms:
            n = s.name
            f = n.replace("$", UID)
            if f in seen:
                raise RuntimeError, "Duplicate output symbol for " + repr(n)
            seen[f] = n
            assert not s.oname
            s.oname = f

    OPCODE_RX = re.compile(r"(mov|dadd|addc|add|subc|sub|cmp|bit|bic|bis|xor|and|rrc|rra|push|swpb|call|reti|sxt|jeq|jz|jne|jnz|jc|jnc|jn|jge|jl|jmp|adc|br|clrc|clrn|clrz|clr|dadc|decd|dec|dint|eint|incd|inc|inv|nop|pop|ret|rla|rlc|sbc|setc|setn|setz|tst|jhs|jlo)((\.[bw])?)$")
    OKBYTE_RX = re.compile(r"(mov|add|addc|sub|subc|cmp|dadd|bit|bic|bis|xor|and|rrc|rra|push|adc|clr|dadc|dec|decd|inc|incd|inv|pop|rla|rlc|sbc|tst)$")
    OKBARE_RX = re.compile(r"(reti|clrc|clrn|clrz|dint|eint|nop|ret|setc|setn|setz)$")
    OKDUAL_RX = re.compile(r"(mov|add|addc|sub|subc|cmp|dadd|bit|bic|bis|xor|and)$")

    OK_OPND1_RX = re.compile(r"((r(1[0-5]|[124-9]))|" + \
                             r"(@r(1[0-5]|[14-9])\+?)" + \
                             r")$")
    OK_OPND2_RX = re.compile(r"((\#[lh](lo|hi)\(-?\d+\))|" + \
                             r"(\#[lh](lo|hi)\(0x[0-9A-Fa-f]+\))|" + \
                             r"(\#\(__stack-\d+\))|" + \
                             r"(\#__nesc_atomic_(start|end))|" + \
                             r"(\#__stop_progExec__)" + \
                             r")$")
    OK_OPND3_RX = re.compile(r"((\&0x[0-9A-Fa-f]+)|" + \
                             r"(\&\d+)|" + \
                             r"(\#0x[0-9A-Fa-f]+)|" + \
                             r"(\#-?\d+)" + \
                             r")$")
    OK_OPND4_RX  = re.compile(r"(-?\d+([-+]\d+)*([-+]\d+)?\(r(1[0-5]|[14-9])\))$")
    ABS_OPND_RX  = re.compile(r"\&([_A-Za-z][_A-Za-z0-9$]*)([-+]\d+)*$")
    IMM_OPND1_RX = re.compile(r"\#([_A-Za-z][_A-Za-z0-9$]*)([-+]\d+)?$")
    IMM_OPND2_RX = re.compile(r"\#(\.LC\d+)$")
    JMP_RX       = re.compile(r"(jeq|jz|jne|jnz|jc|jnc|jn|jge|jl|jmp|jhs|jlo)$")
    JMP_OPND_RX  = re.compile(r"((\.L(cmpSIe|msn|send|sst|csn)?\d+)|" + \
                              r"(\.L__[_A-Za-z0-9$]+)|" + \
                              r"(\#\.L\d+)|" + \
                              r"([-+]\d+)" + \
                              r")$")
    JMP_TMP_RX   = re.compile(r"([1-9]\d*[bf])$")
    NDX_OPND1_RX = re.compile(r"([_A-Za-z][_A-Za-z0-9$]*)([-+]\d+)*\(r(1[0-5]|[4-9])\)$")
    NDX_OPND2_RX = re.compile(r"(\.L\d+)\(r(1[0-5]|[4-9])\)$")

    def check_opnd(self, op, opnd):
        if self.OK_OPND1_RX.match(opnd) or \
           self.OK_OPND2_RX.match(opnd) or \
           self.OK_OPND3_RX.match(opnd) or \
           self.OK_OPND4_RX.match(opnd):
            if opnd == "@r1+":
                raise RuntimeError, "Bad mode @r1+"
            return
        m = self.ABS_OPND_RX.match(opnd)
        if m:
            s = self.symtab.fetch(m.group(1))
            if s.sect not in (".bss", ".data", ".text"):
                raise RuntimeError, "Non-data symbol " + repr(m.group(1))
            return
        m = self.IMM_OPND1_RX.match(opnd)
        if m:
            s = self.symtab.get(m.group(1))
            if not (s.label or s.comm):
                ### call to something w/o a label
                if (op != "call") or ("$" in m.group(1)):
                    raise RuntimeError, "Unknown symbol " + repr(opnd)
                s.sect  = ".extern"
                s.oname = s.name
                return
            if (op in ("br", "call")):
                if (s.sect not in (".near", ".stub")):
                    raise RuntimeError, "Non-code ref " + repr(m.group(1))
            else:
                if s.sect == ".stub":
                    raise RuntimeError, "Illegal code ref " + repr(m.group(1))
            return
        m = self.IMM_OPND2_RX.match(opnd)
        if m:
            s = self.symtab.fetch(m.group(1))
            if (op in ("br", "call")) or (s.sect != ".cstrs"):
                raise RuntimeError, "Bad cstr ref " + repr(opnd)
            return
        m = self.JMP_OPND_RX.match(opnd)
        if m:
            try:
                int(opnd, 0)
            except:
                s = self.symtab.fetch(opnd.replace("#", ""))
                if self.JMP_RX.match(op):
                    if not (s.label and s.intrnl):
                            raise RuntimeError, "Invalid jump target " + \
                            repr(opnd)
                else:
                    if op != "br":
                        raise RuntimeError, "Bad jump target " + repr(opnd)
            return
        ### tmp jumps
        m = self.JMP_TMP_RX.match(opnd)
        if m:
            if not self.JMP_RX.match(op):
                raise RuntimeError, "Illegal use of tmp label " + \
                      repr(opnd) + " by " + repr(op)
            return
        m = self.NDX_OPND1_RX.match(opnd)
        if m:
            s = self.symtab.fetch(m.group(1))
            if s.sect in (".bss", ".data", ".text"):
                return
            raise RuntimeError, "Illegal indexed code ref"
        m = self.NDX_OPND2_RX.match(opnd)
        if m:
            s = self.symtab.fetch(m.group(1))
            if (op != "br") or (s.sect != ".jtab"):
                raise RuntimeError, "Invalid jtab ref " + repr(m.group(1))
            return
        raise RuntimeError, "Cannot parse operand " + repr(opnd)

    BR1_RX = re.compile(r"\tbr\s+#(\.L\d+)$")
    BR2_RX = re.compile(r"\tbr\s+(\.L\d+)\((r(1[0-5]|[4-9]))\)\s*$")

    def FARTAB(self, arg):
        if self.DEBUG_FARTAB_NEAR and self.dbg:
            return "\n\tbr\t" + arg
        hi = self.near and "0" or "1"
        return "\n\tpush\t#" + hi + \
               "\n\tpush\t" + arg + \
               "\n\t.word\t0x0110\t; mova @r1+, r0"

    def fix_br(self, line, name):
        m = self.BR1_RX.match(line)
        if m:
            s = self.symtab.fetch(m.group(1))
            assert (s.label and s.intrnl), s.__dict__
            assert (s.sect in ((self.triv and ".near" or ".far"),
                                ".nosect")), s.__dict__
            if self.DEBUG_BR_IMM and self.dbg:
                return ("\n\t" + line.lstrip()).replace("$", UID)
            return self.FARJMP(m.group(1))
        m = self.BR2_RX.match(line)
        if m:
            s = self.symtab.fetch(m.group(1))
            assert (s.label and s.intrnl), s.__dict__
            assert (s.sect == ".jtab"), s.__dict__
            if self.DEBUG_BR_TABLE and self.dbg:
                return ("\n\t" + line.lstrip()).replace("$", UID)
            arg = m.group(1) + "(" + m.group(2) + ")"
            seq = self.sseq
            self.sseq = seq + 1

            sname = (".L$S$" + str(seq)).replace("$", UID)
            stub  = self.symtab.add(sname)
            stub.intrnl = True
            stub.label  = True
            stub.sect   = ".swx"
            stub.oname  = sname
            stub.obody  = "\n\t; From " + name + \
                          "\n\t" + self.FARTAB(arg)

            return "\n\tbr\t#" + sname + "\t; table: " + arg
        raise RuntimeError, "Cannot fix BR instruction in " + repr(line)

    CALL_RX = re.compile(r"\tcall\s+#([_A-Za-z][_A-Za-z0-9$]*)$")

    def fix_call(self, line, name):
        m = self.CALL_RX.match(line)
        if not m:
            raise RuntimeError, "Cannot fix CALL instruction in " + repr(line)
        s = self.symtab.fetch(m.group(1))
        assert (s.label and \
                (s.type == "@function") and \
                (s.sect in (".near", ".stub"))) or \
                (s.sect == ".extern"), s.__dict__
        if self.DEBUG_CALL and self.dbg:
            return ("\n\t" + line.lstrip()).replace("$", UID)
        seq = self.cseq
        self.cseq = seq + 1
        cname = (".L$C$" + str(seq)).replace("$", UID)
        rname = (".L$R$" + str(seq)).replace("$", UID)
        tgt   = m.group(1).replace("$", UID)

        cstub = self.symtab.add(cname)
        cstub.intrnl = True
        cstub.label  = True
        cstub.sect   = ".cstub"
        cstub.oname  = cname
        cstub.obody  = "\n\t; From " + name + \
                       "\n\tcall\t#" + tgt + \
                       self.FARJMP(rname)

        if self.DEBUG_CALL_INLINE and self.dbg:
            cstub.obody = "\n\tpush\t#" + rname + \
                          "\n\tbr\t#" + tgt

        if self.DEBUG_CALL_POP and self.dbg:
            cstub.obody = "\n\tincd\tr1" + \
                          "\n\tcall\t#" + tgt + \
                          self.FARJMP(rname)
            return "\n\tcall\t#" + cname + "\t; call: " + tgt + \
                   "\n" + rname + ":"

        return "\n\tbr\t#" + cname + "\t; call: " + tgt + \
               "\n" + rname + ":"

    SRAWU_RX = re.compile(r"\n\tclrc" + \
                          r"\n\trrc\tr([4-9]|1[0-5])" + \
                          r"(\n\trra\tr\1){0,3}")

    def RRUM(self, nm1, reg):
        return "\n\t.word\t0x%04x\t; RRUM #%d, r%d" % \
               (0x0350 | (nm1 << 10) | reg, nm1 + 1, reg)

    def opt_srawu(self, text):
        """
        unsigned word right shifts -> rrum
        """
        from cStringIO import StringIO
        out = StringIO()
        w   = out.write
        while True:
            m = self.SRAWU_RX.search(text)
            if not m:
                break
            w(text[:m.start(0)])
            sra  = m.group(0)
            cnt  = len(sra.strip().split("\n")) - 1
            reg  = m.group(1)
            text = text[m.end(0):]
            w(self.RRUM(cnt - 1, int(reg)))
        if text:
            w(text)
        return out.getvalue()

    RRW_RX = re.compile(r"(\n\trr([ac])\tr([4-9]|1[0-5]))" + \
                        r"\1{1,3}")

    def RRACM(self, kind, nm1, reg):
        assert kind in "ac"
        base = (kind == "a") and 0x0140 or 0x0040
        return "\n\t.word\t0x%04x\t; RR%cM #%d, r%d" % \
               (base | (nm1 << 10) | reg, kind.upper(), nm1 + 1, reg)

    def opt_rrw(self, text):
        """
        arithmetic right shifts -> rram
        circular right shifts -> rrcm
        """
        from cStringIO import StringIO
        out = StringIO()
        w   = out.write
        while True:
            m = self.RRW_RX.search(text)
            if not m:
                break
            w(text[:m.start(0)])
            rr   = m.group(0)
            cnt  = len(rr.strip().split("\n"))
            kind = m.group(2)
            reg  = m.group(3)
            text = text[m.end(0):]
            w(self.RRACM(kind, cnt - 1, int(reg)))
        if text:
            w(text)
        return out.getvalue()

    def opt_shrw(self, text):
        """
        optimize *word* shifts. arbitrary byte shifts cannot
        safely be optimized; the cases that can be safely
        optimized are empirically few and far between.
        """
        text = self.opt_srawu(text)
        text = self.opt_rrw(text)
        return text

    SHLW1_RX = re.compile(r"(\n\trla\tr([4-9]|1[0-5]))" + \
                          r"\1{1,3}" + \
                          r"(?=(?:\n\tmov[^\n]+)?\n\t(?:add|rla|xor)\t)")

    SHLW2_RX = re.compile(r"(\n\trla\tr([4-9]|1[0-5]))" + \
                          r"\1{1,3}" + \
                          r"(?=\1\n)")

    def RLAM(self, nm1, reg):
        return "\n\t.word\t0x%04x\t; RLAM #%d, r%d" % \
               (0x0240 | (nm1 << 10) | reg, nm1 + 1, reg)

    def opt_shlw(self, text):
        """
        optimize left *word* shifts. since rla and rlaw set
        the V flag differently (but probably consistently,
        though rlaw officially -> "undefined"), we should
        leave the ultimate rla intact so that nothing changes.

        if the next non-mov instructions adjusts the V bit,
        we can safely condense all the rla-s. in practice,
        the next non-mov instruction seems to be {add,xor,rla}.
        """
        from cStringIO import StringIO
        out = StringIO()
        w   = out.write
        while True:
            m = self.SHLW1_RX.search(text)
            if not m:
                m = self.SHLW2_RX.search(text)
            if not m:
                break
            w(text[:m.start(0)])
            shl  = m.group(0)
            cnt  = len(shl.strip().split("\n"))
            reg  = m.group(2)
            text = text[m.end(0):]
            w("\n/*" + shl + "\n*/")
            w(self.RLAM(cnt - 1, int(reg)))
        if text:
            w(text)
        return out.getvalue()

    SPILL_RX = re.compile(r"(\n\tpush\s+r(?:1[0-5]|[4-9])){2,}")

    def O_SPILL(self, rdst, nm1):
        val = 0x1500 | (nm1 << 4) | rdst
        return "\n\t.word\t0x%04x\t; PUSHM #%d, r%d" % \
               (val, nm1 + 1, rdst)

    def O_LLIPS(self, rdst, nm1):
        val = 0x1700 | (nm1 << 4) | (rdst - nm1)
        return "\n\t.word\t0x%04x\t; POPM #%d, r%d" % \
               (val, nm1 + 1, rdst)

    def opt_spill(self, text):
        from cStringIO import StringIO
        out = StringIO()
        w   = out.write
        while True:
            m = self.SPILL_RX.search(text)
            if not m:
                break
            w(text[:m.start(0)])
            spill = m.group(0)
            text  = text[m.end(0):]
            chk   = map(int,
                        spill.replace("push", "").replace("r", "").split())
            assert len(chk) > 1
            if (max(chk) != chk[0]) or \
               (min(chk) != chk[-1]) or \
               (len(chk) != (chk[0] - chk[-1] + 1)):
                w(spill)
                continue
            bgn = chk[0]
            nm1 = bgn - chk[-1]
            chk.reverse()
            chk.insert(0, "")
            chk = "\n\tpop\\s+r".join(map(str, chk))
            chk = re.compile(chk)
            m   = chk.search(text)
            if not m:
                w(spill)
                continue
            w(self.O_SPILL(bgn, nm1))
            w(text[:m.start(0)])
            w(self.O_LLIPS(bgn, nm1))
            text = text[m.end(0):]
        if text:
            w(text)
        return out.getvalue()

    def do_func(self, func):
        from cStringIO import StringIO
        out = StringIO()
        w   = out.write
        far = func.sect == ".far"
        x   = lambda s: s.replace("$", UID)
        for line in func.body.strip().split("\n"):
            xline = "\n" + x(line)
            tmp = line.split(None, 1)
            ### handle empty lines
            if not tmp:
                w(xline)
                continue
            ### handle single "token" lines
            if len(tmp) == 1:
                op = tmp[0]
                if op.startswith(".") or \
                   (":" in op) or \
                   op.startswith("{") or \
                   self.OKBARE_RX.match(op):
                    w(xline)
                    continue
                raise RuntimeError, "Bogus bare word " + repr(op) + \
                      " in " + repr(line)
            ### multiple tokens -- grab first
            op, rest = tmp
            ### handle directives
            if op.startswith("."):
                if op not in (".global",):
                    raise RuntimeError, "Bogus directive " + repr(op) + \
                          " in " + repr(line)
                w(xline)
                continue
            ### check opcode format
            m = self.OPCODE_RX.match(op)
            if not m:
                raise RuntimeError, "Bogus opcode " + repr(op) + " in " + \
                      repr(line)
            if (m.group(3) == ".b") and (not self.OKBYTE_RX.match(m.group(1))):
                raise RuntimeError, "Bogus byte instruction " + repr(op) + \
                      " in " + repr(line)
            ### br/call fix markers
            if m.group(1) == "br":
                okbr = False
            else:
                okbr = True
            if m.group(1) == "call":
                okcall = False
            else:
                okcall = True
            ### keep going...
            tmp = line.split(op, 1)
            if len(tmp) == 1:
                tmp.insert(0, "")
            if len(tmp) != 2:
                raise RuntimeError, "Bogus line " + repr(line)
            head, tail = tmp
            ### head is start of output line
            head += op + "\t"
            assert rest.strip() == tail.strip(), (rest, tail)
            ### extract operands
            opnds = [s.strip() for s in rest.split(",")]
            if len(opnds) not in (1, 2):
                raise RuntimeError, "Cannot parse operands in " + repr(line)
            if (len(opnds) == 2) and (not self.OKDUAL_RX.match(m.group(1))):
                raise RuntimeError, "Bogus dual-operand op " + repr(op) + \
                      " in " + repr(line)
            ### check operands
            try:
                [ self.check_opnd(op, o) for o in opnds ]
                if far:
                    ### fix br and call if far
                    if op == "br":
                        xline = self.fix_br(line, func.name)
                        okbr  = True
                    elif op == "call":
                        xline  = self.fix_call(line, func.name)
                        okcall = True
                else:
                    okbr = okcall = True
            except (AttributeError, RuntimeError), msg:
                raise RuntimeError, str(msg) + " in " + repr(line) + \
                      " in func " + repr(func.name)
            w(xline)
            if not okbr:
                raise RuntimeError, "branch not fixed in " + repr(line) + \
                      " in func " + repr(func.name)
            if not okcall:
                raise RuntimeError, "call not fixed in " + repr(line) + \
                      " in func " + repr(func.name)
        body = out.getvalue()
        if self.shift:
            body = self.opt_shrw(body)
            body = self.opt_shlw(body)
        if self.spill:
            body = self.opt_spill(body)
        func.obody = body

    def execute(self):
        ### load the gas src
        self.tcanon = self.loadfile(self.fname)
        ### escape various constructs into {}
        self.text = self.parse1(self.tcanon)
        ### extract .global, .local, and .comm decls
        self.text = self.do_globl(self.text)
        self.text = self.do_local(self.text)
        self.text = self.do_comm(self.text)
        ### kill the .Lfennn labels
        self.text = self.kill_Lfe(self.text)
        ### hack for .LcmpSIe labels
        self.text = self.hack1(self.text)
        ### scan all labels into the symbol table
        self.scan_labels(self.text)
        ### get .type and .size for objects
        self.text = self.do_otype(self.text)
        self.text = self.do_osize(self.text)
        ### grab the file prologue and epilogue
        ###   into self.prologue and self.epilogue
        self.text = self.do_pro_epi(self.text)
        ### split data from function bodies
        self.data, self.code = self.do_fsplit1(self.text)
        ### grab constant strings into self.strs
        self.code = self.do_strings(self.code)
        ### kill .L__Framexxx decls
        self.code = self.kill_LFrame(self.code)
        ### split up function bodies
        self.code = self.do_fsplit2(self.code)
        ### extract jump tables
        self.extract_jumps(self.code)
        del self.code
        ### break up data into .data and .text
        self.data, self.text = self.do_dsplit(self.data)
        ### process .data and .text segments
        self.extract_dseg(self.data, ".data")
        self.extract_dseg(self.text, ".text")
        del self.data
        del self.text
        ### validate contents of .data and .text
        self.validate_dsyms([s for s in self.symtab.syms()
                             if s.sect in (".data", ".text")])
        ### assign segments to functions, generate near stubs
        code = [s for s in self.symtab.syms() if s.type == "@function"]
        self.assign_cseg(code)
        ### kill local label syms, except for jump tables
        self.count = len(self.symtab)
        todo = [s for s in self.symtab.syms() if s.intrnl]
        for s in todo:
            if s.sect in (".cstrs", ".jtab"):
                assert s.label and s.body
                continue
            assert s.label and (not s.body) and (not s.sect)
            s.sect = ".nosect"
        ### generate output symbol names
        self.gen_onames(self.symtab.syms())
        ### do funcs, generate call-return jump labels
        code = [s for s in self.symtab.syms() if \
                (s.type == "@function") and (s.sect != ".stub")]
        [ self.do_func(f) for f in code ]
        t = [0, 0]
        for f in code:
            if f.sect == ".far":
                t[1] += 1
            elif f.sect == ".near":
                t[0] += 1
        self.nnear, self.nfar = t
        ### whew!

    def emit(self):
        ### make sure we got everything
        [ s(".extern", None) for s in self.symtab.syms() ]
        [ s(".nosect", None) for s in self.symtab.syms() ]
        for s in self.symtab.syms():
            assert s.sect

        ### generate output file
        from cStringIO import StringIO
        out  = StringIO()
        syms = self.symtab.syms()
        self.nears = "\n;;;\t".join(self.nears)
        out.write("""\
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; !!!DO NOT EDIT THIS <<MACHINE GENERATED>> FILE!!!
;;;
;;; Generated from: %(fname)s
;;; Generated on:   %(start)s
;;; Generated by:   %(prog)s
;;; Generator ver:  %(ver)s
;;; Symbol count:   %(count)s
;;; Call/ret stubs: %(cseq)s
;;; Indexed jumps:  %(sseq)s
;;; Far funcs:      %(nfar)s
;;; Near funcs:     %(nnear)s
;;;
;;;\t%(nears)s
;;;
;;; Switches:
;;;   --triv  = %(triv)s
;;;   --dbg   = %(dbg)s
;;;   --near  = %(near)s
;;;   --npat  = %(npat)s
;;;   --unix  = %(unix)s
;;;   --spill = %(spill)s
;;;   --shift = %(shift)s
;;;
\t.file "%(fname)s"
\t.arch %(arch)s
""" % self.__dict__)
        out.write("""
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; original prologue (commented out) follows
;;;
""")
        out.write("/*\n" + self.prologue + "\n*/\n")
        out.write("""
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; .bss follows
;;;""")
        [ s(".bss", out.write) for s in syms ]
        out.write("""

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; .data follows
;;;
\t.data
\t.p2align 1,0
__feex_data:""")
        [ s(".data", out.write) for s in syms ]
        out.write("""
\t.size __feex_data, .-__feex_data

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; .text follows
;;;
\t.text
\t.p2align 1,0
__feex_text:""")
        [ s(".text", out.write) for s in syms ]
        out.write("""
\t.size __feex_text, .-__feex_text

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; c string constants follow
;;;

.section .cstrs, "ax"
__feex_cstrs:
""")
        [ s(".cstrs", out.write) for s in syms ]
        out.write("""

\t.size __feex_cstrs, .-__feex_cstrs

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; switch() jump tables follow
;;;

.section .jtab, "ax"
\t.p2align 1,0
__feex_jtab:
""")
        [ s(".jtab", out.write) for s in syms ]

        out.write("""
\t.size __feex_jtab, .-__feex_jtab

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; far call stubs follow
;;;

.section .cstub, "ax"
\t.p2align 1,0
__feex_cstub:
""")
        [ s(".cstub", out.write) for s in syms ]

        out.write("""
\t.size __feex_cstub, .-__feex_cstub

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; switch() jump stubs follow
;;;

.section .swx, "ax"
\t.p2align 1,0
__feex_swx:
""")
        [ s(".swx", out.write) for s in syms ]

        out.write("""
\t.size __feex_swx, .-__feex_swx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; stubs for far funcs follow
;;;

.section .stub, "ax"
\t.p2align 1,0
__feex_stub:
""")
        [ s(".stub", out.write) for s in syms ]

        out.write("""
\t.size __feex_stub, .-__feex_stub

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; near funcs follow
;;;

.section .near, "ax"
\t.p2align 1,0
__feex_near:
""")
        if self.near:
            for s in syms:
                if s.sect == ".far":
                    s.sect = ".near"

        [ s(".near", out.write) for s in syms ]

        out.write("""
\t.size __feex_near, .-__feex_near

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; far funcs follow
;;;

.section .far, "ax"
\t.p2align 1,0
__feex_far:
""")
        [ s(".far", out.write) for s in syms ]

        out.write("""
\t.size __feex_far, .-__feex_far

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; original epilogue follows
;;;

""")
        out.write(self.epilogue)
        import time
        t = time.time()
        self.stop = time.ctime(t)
        self.dur  = t - self._start
        out.write("""
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Started:  %(start)s
;;; Finished: %(stop)s
""" % self.__dict__)

        ### unescape {}s
        text = self.unparse1(out.getvalue()) + \
               ("""\
;;; Runtime:  %(dur).3f seconds
;;;
;;; EOF %(fname)s
""" % self.__dict__)

        text = text.replace("\r\n", "\n").replace("\r", "\n")
        if not self.unix:
            text = text.replace("\n", "\r\n")
        self.text = text

        ### make sure we got 'em all
        for s in syms:
            assert s.done, s.__dict__

__usage__ = """
usage: feex2.py [--npat=rx] [--dbg] [--triv] [--near]
                [--unix] [--spill] [--shift] infile > outfile

options:
  --npat  specify regex for near function names.
  --dbg   activate ad-hoc debug mode. fiddles with
          various unspecified things.
  --triv  do a trivial transformation; basically, just
          replace '$' with '_'. for debugging. implies
          --near.
  --near  by default, put functions in the .far section.
          this option puts everything in .text.
  --unix  by default, map LF to CRLF on output. --unix
          suppresses this transformation.
  --spill turn on register spill optimization using
          pushm/popm instructions.
  --shift turn on right-shift optimizations.
"""

def usage(msg):
    raise SystemExit, str(msg) + __usage__

def main(args):
    from getopt import getopt, GetoptError
    try:
        opts, args = getopt(args, "",
                            ["dbg", "triv", "near", "unix",
                             "npat=", "spill", "shift"])
    except GetoptError, msg:
        usage(str(msg))
    len(args) == 1 or usage("Too many args")
    d = { }
    for k, v in opts:
        K = k.replace("-", "")
        if K == "npat":
            d[K] = v
        else:
            d[K] = True
    xlat = Translator(args[0], **d)
    xlat.execute()
    xlat.emit()
    sys.stdout.write(xlat.text)

if __name__ == "__main__":
    import sys
    main(sys.argv[1:])

### EOF feex.py

