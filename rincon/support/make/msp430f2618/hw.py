#!/bin/sh
########################################################################
### hw.py
###

'''eval' exec python $0 ${1+"$@"}
' '''

__doc__ = """
usage: hw.py [[-Dsym[=val]] [-Usym] ...] filename
"""

import re, sys

def barf(msg):
    raise SystemExit, "ERROR: " + msg.strip()

def msp430(pins, boot, mult, nc):
    import re
    ### validate and canonify pin names
    PIN_RX = re.compile(r'P[1-6][._]?[0-7]$')
    for name in pins.keys():
        PIN_RX.match(name) or barf("Bad pin " + name)
        k = name.replace(".", "").replace("_", "")
        if k != name:
            pins[k] = pins[name]
            del pins[name]
    for name in pins.keys():
        p = (int(name[1]), 1 << int(name[2]))
        pins[p] = pins[name]
        del pins[name]
    ### process boot specs
    for name in boot.keys():
        PIN_RX.match(name) or barf("Bad boot pin " + name)
        v = boot[name].strip()
        s = v.split("]")
        (len(s) == 2) and (not s[1]) or barf("Bad boot spec " + v)
        v = s[0].strip()
        k = name.replace(".", "").replace("_", "")
        p = (int(k[1]), 1 << int(k[2]))
        pins[p].append("mcu " + v)
    ### canonify mult
    for sig, items in mult.items():
        xitems = [ ]
        for name in items:
            k = name.replace(".", "").replace("_", "")
            k = (int(k[1]), 1 << int(k[2]))
            xitems.append(k)
        mult[sig] = xitems
    ### apply default to unused pins
    ###   the default is a string
    ###   connected pins are lists of strings
    nc = nc.strip()
    for P in range(1, 7):
        for p in range(8):
            n = (P, 1 << p)
            pins.setdefault(n, ["mcu " + nc])
    ### make everything be MCU-centric
    for port, specs in pins.items():
        mspecs = [ ]
        for spec in specs:
            tmp = spec.split()
            try:
                tmp.remove("boot")
            except:
                pass
            if tmp[0] == "mcu":
                mine = True
                if len(tmp) < 2: barf("Bad MCU spec " + repr(spec) + \
                                      " on port " + str(port))
                del tmp[0]
            else:
                mine = False
            if tmp[0] == "inout":
                mine = True
                if len(tmp) < 2: barf("Bad inout spec " + repr(spec) + \
                                      " on port " + str(port))
                del tmp[0]
            if tmp[0] == "output":
                try:
                    if mine:
                        assert len(tmp) == 2
                        tmp = tmp[1]
                        assert tmp in ("low", "high")
                        mspecs.append(tmp)
                    else:
                        assert len(tmp) == 1
                        mspecs.append("input")
                except:
                    barf("Bad output spec " + repr(spec) + " on " + \
                         "port " + str(port))
                continue
            if tmp[0] == "input":
                try:
                    if mine:
                        assert len(tmp) == 1
                        mspecs.append(tmp[0])
                    else:
                        assert len(tmp) == 2
                        tmp = tmp[1]
                        assert tmp in ("low", "high")
                        mspecs.append(tmp)
                except:
                    barf("Bad input spec " + repr(spec) + " on " + \
                         "port " + str(port))
                continue
            barf("Bad spec " + str(tmp))
        pins[port] = mspecs
    ### calc dir and out
    dir = { }
    out = { }
    chk  = { }
    for P in range(1, 7):
        dir[P] = out[P] = 0x00
    for (P, p), state in pins.iteritems():
        if not P:
            raise SystemExit, (P, p, state)
        uniq = { }
        for s in state:
            uniq.setdefault(s)
        state = uniq.keys()
        state.sort()
        state = tuple(state)
        if (len(state) > 2) or \
           (state == ("low", "high")):
            barf("Illegal state " + str(state))
        elif len(state) != 1:
            c = [x for x in state if x != "input"]
            assert len(c) == 1
            c = c[0]
            assert c in ("low", "high")
            chk[(P, p)] = c
            state = ["input"]
        for s in state:
            if s == "input":
                dir[P] &= ~p
            else:
                dir[P] |= p
                if s == "low":
                    out[P] &= ~p
                elif s == "high":
                    out[P] |= p
                else:
                    raise RuntimeError, "logs in the bedpan: " + \
                          repr(state) + " at " + str((P, p))
    ### check out any input+low and input+high combos
    if chk:
        for Pp, state in chk.items():
            ok = None
            for items in mult.values():
                if Pp not in items:
                    continue
                xi = items[:]
                xi.remove(Pp)
                for item in xi:
                    if item in chk:
                        continue
                    ii = pins[item]
                    if len(ii) != 1:
                        continue
                    ii = ii[0]
                    if ii == "input":
                        continue
                    if (ii == state) and (ok is None):
                        ok = True
                    elif ii != state:
                        ok = False
            if not ok:
                barf("Inconsistent pin assignment for " + str(Pp))
    ### generate C code...
    print """
#warning "Including machine-generated hardware init code"
    // disable interrupts
    P1IE  = 0x00;
    P1IES = 0x00;
    P1IFG = 0x00;
    P2IE  = 0x00;
    P2IES = 0x00;
    P2IFG = 0x00;

    // select io function for all
    P1SEL = 0x00;
    P2SEL = 0x00;
    P3SEL = 0x00;
    P4SEL = 0x00;
    P5SEL = 0x00;
    P6SEL = 0x00;

    // configure ports
    """.rstrip()
    for P in range(1, 7):
        print "    P%dOUT = 0x%02x;\n    P%dDIR = 0x%02x;\n" % \
              (P, out[P], P, dir[P])

CPUs = {
    "MSP430F1611": msp430,
    "MSP430F2618": msp430,
}

def resolve(mcu, pins, boot, mult, nc):
    CPUs[mcu](pins, boot, mult, nc)

def process(p):
    ### validate the Drawing section
    S = "Drawing"
    if not p.has_section(S): barf("No " + S + " section")
    for O in ("Title", "DocumentNumber", "Rev", "Date", "Pages"):
        if not (p.has_option(S, O) and \
                p.get(S, O).strip()): barf("Bad or missing " + O + " in " + S)
    try:
        pgs = p.getint(S, "Pages")
    except:
        pgs = 0
    pgs > 0 or barf("Illegal page count in " + S)
    ### print info
    Ol = ("Title", "DocumentNumber", "Rev", "Date")
    n  = max(map(len, Ol))
    f  = "%%-%ds: %%s" % n
    for O in Ol:
        print >>sys.stderr, f % (O, p.get(S, O).strip())
    print >>sys.stderr
    ### validate all __page__ keys
    for s in p.sections():
        if s != S:
            if not p.has_option(s, "__page__"): barf("No __page__ in " + s)
            try:
                pg = p.getint(s, "__page__")
            except:
                pg = 0
            (pg > 0) and (pg <= pgs) or barf("Bad __page__ in " + s)
    ### make sure there's a basic MCU section
    S = "MCU"
    if not p.has_section(S): barf("No " + S + " section")
    if not p.has_option(S, "__mcu__"): barf("No __mcu__ in " + S)
    mcu = p.get(S, "__mcu__").strip()
    mcu in CPUs or barf("Unknown MCU " + mcu)
    nc = None
    if p.has_option(S, "__nc__"):
        nc = p.get(S, "__nc__").strip()
    nc = nc or "output low"
    ### collect names
    names = { }
    locns = { }
    sects = p.sections()
    sects.sort()
    for S in sects:
        if S in ("Drawing", "MCU"):
            continue
        if not S.startswith("Subsys:"): barf("Unknown section " + S)
        for (k, v) in p.items(S):
            v = v.strip()
            v or barf("Empty value for " + k + " in " + S)
            if k in ("__page__",):
                continue
            if k == "__warn__":
                print >>sys.stderr, "Warning: %s: %s" % (S, v)
                continue
            k = k.upper()
            k not in names or barf("Duplicate name " + k + \
                                   " previously defined in section " + \
                                   locns[k])
            names[k] = v.strip()
            locns[k] = S
    ### collect pin assignments
    pins = { }
    seen = { }
    boot = { }
    mult = { }
    S    = "MCU"
    for (k, v) in p.items(S):
        v = v.strip()
        v or barf("Empty value for " + k + " in " + S)
        if k in ("__page__", "__mcu__", "__nc__"):
            continue
        k = k.upper()
        k not in names or barf("Duplicate pin " + k + " in " + S)
        if "," in v:
            v = v.replace(",", " ").split()
        else:
            v = [v]
        for name in v:
            tmp = name.split("[")
            n   = tmp[0]
            len(tmp) == 2 and boot.setdefault(k, tmp[1])
            n in names or barf("Pin " + k + \
                               " bound to unknown name " + repr(name))
            mult.setdefault(n, [ ]).append(k)
            seen.setdefault(n)
        v = [names[name.split("[")[0]] for name in v]
        pins[k] = v
    ### make sure we hit everything
    for name in seen:
        del names[name]
    if names:
        l = [ ]
        for k in names:
            l.append(locns[k] + "." + k)
        l.sort()
        barf("Unconnected pins: " + ", ".join(l))
    ### filter on mult
    for k, v in mult.items():
        if len(v) == 1:
            del mult[k]
    ### resolve everything
    resolve(mcu, pins, boot, mult, nc)

def usage():
    raise SystemExit, __doc__

def main(args):
    dfl = { }
    while args and args[0].startswith("-"):
        arg = args[0]
        if arg.startswith("-D"):
            tmp = arg[2:].split("=")
            len(tmp) == 2 or tmp.append(1)
            tmp[0] and (len(tmp[0].split()) == 1) or usage()
            dfl[tmp[0]] = tmp[1]
            continue
        if arg.startswith("-U"):
            tmp and (len(tmp.split()) == 1) and ("=" not in tmp) or usage()
            if tmp in dfl:
                del dfl[tmp]
            continue
        usage()
    len(args) == 1 or usage()
    from ConfigParser import ConfigParser
    p = ConfigParser(dfl)
    p.read(args) == args or usage()
    process(p)

if __name__ == "__main__":
    import sys
    main(sys.argv[1:])

### EOF hw.py

