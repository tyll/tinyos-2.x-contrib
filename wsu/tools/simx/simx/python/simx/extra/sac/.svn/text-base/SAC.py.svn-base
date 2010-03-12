def inWords(n):
    return 4 * n

def openSAC(file):
    pass

# floats (word 0-69)
HdrFloats = ["DELTA", "DEPMIN", "DEPMAX", "SCALE", "ODELTA",
             "B", "E", "O", "A", "_INTERNAL",
             "T0", "T1", "T2", "T3", "T4",
             "T5", "T6", "T7", "T8", "T9",
             "F", "RESP0", "RESP1", "RESP2", "RESP3",
             "RESP4", "RESP5", "RESP6", "RESP7", "RESP8",
             "RESP9", "STLA", "STLO", "STEL", "STDP",
             "EVLA", "EVLO", "EVEL", "EVDP", "MAG",
             "USER0", "USER1", "USER2", "USER3", "USER4",
             "USER5", "USER6", "USER7", "USER8", "USER9",
             "DIST", "AZ", "BAZ", "GCARC", "_INTERNAL",
             "_INTERNAL", "DEPMEN", "CMPAZ", "CMPINC", "XMINIMUM",
             "XMAXIMUM", "YMINIMUM", "YMAXIMUM", "_UNUSED", "_UNUSED",
             "_UNUSED", "_UNUSED", "_UNUSED", "_UNUSED", "_UNUSED"]
assert len(HdrFloats) == 70

# integers and enumerated (words 70-104)
HdrInts = ["NZYEAR", "NZJDAY", "NZHOUR", "NZMIN", "NZSEC",
           "NZMSEC", "NVHDR", "NORID", "NEVID", "NPTS",
           "_INTERNAL", "NWFID", "NXSIZE", "NYSIZE", "_UNUSED",
           "IFTYPE", "IDEP", "IZTYPE", "_UNUSED", "IINST",
           "ISTREG", "IEVREG", "IEVTYP", "IQUAL", "ISYNTH",
           "IMAGTYP", "IMAGSRC", "_UNUSED", "_UNUSED", "_UNUSED",
           "_UNUSED", "_UNUSED", "_UNUSED", "_UNUSED", "_UNUSED"]
assert len(HdrInts) == 35

# logical (boolean) (words 105-109)
HdrLogicals = ["LEVEN", "LPSPOL", "LOVROK", "LCALDA", "_UNUSED"]
assert len(HdrLogicals) == 5

# alphanumeric (each is 2 words [8 ASCII characters] big)
# (KEVNM takes two slots as KEVNM_1, KEVNM_2)
HdrTexts = ["KSTNM", "KEVNM_1", "KEVNM_2",
            "KHOLE", "KO", "KA",
            "KT0", "KT1", "KT2",
            "KT3", "KT4", "KT5",
            "KT6", "KT7", "KT8",
            "KT9", "KF", "KUSER0",
            "KUSER1", "KUSER2", "KCMPNM",
            "KNETWK", "KDATRD", "KINST"]
assert len(HdrTexts) == 24

import struct

HEADER_SIZE = inWords(158)

def headerVersion(raw_header):
    """Returns a tuple of the (version, big-endian) or (None, None)
    
    nvhdr should be loaded from a SAC file at NVHDR_LOCATION.
    """
    _valid_version = range(1, 20)
    def valid_version(x):
        return x in _valid_version

    nvhdr_string = raw_header[inWords(76):inWords(77)]
    if len(nvhdr_string) != 4:
        raise ValueError, "nvhdr_string must be 4 bytes long"
    le_ver = struct.unpack("<i", nvhdr_string)[0]
    be_ver = struct.unpack(">i", nvhdr_string)[0]

    if valid_version(le_ver) and valid_version(be_ver):
        # can't decide (I don't even know if this can happen)
        return (None, None)
    if valid_version(le_ver):
        return (le_ver, False)
    if valid_version(be_ver):
        return (be_ver, True)
    else:
        return (None, None)

class Header():
    def __init__(self, raw_header):
        data = {}
        self.data = data

        def header_range(start, end):
            return raw_header[inWords(start):inWords(end+1)]

        required_size = inWords(158)
        if len(raw_header) != required_size:
            raise ValueError, "header size error (size=%d)" % len(raw_header)

        (version, big_endian) = headerVersion(raw_header)
        if not version:
            raise ValueError, "invalid header format"
        if big_endian:
            endian = ">"
        else:
            endian = "<"
        self.version = version
        self.big_endian = big_endian

        floats = struct.unpack(endian + "70f", header_range(0, 69))
        for (name, val) in zip(HdrFloats, floats):
            data[name] = val

        # integers, enumerated, and logicals
        ints = struct.unpack(endian + "40i", header_range(70, 109))
        for (name, val) in zip(HdrInts + HdrLogicals, ints):
            data[name] = val
            
        text_data = header_range(110, 157)
        for (name, index) in zip(HdrTexts, range(0, 4 * 24, 4)):
            data[name] = text_data[index:index+4]
        data["KEVNM"] = data["KEVNM_1"] + data["KEVNM_2"]

class Reader():
    def __init__(self, file):
        header_data = file.read(inWords(158))
        self.header = Header(header_data)
        npts = self.header.data["NPTS"]
        self.data1 = file.read(inWords(npts))
