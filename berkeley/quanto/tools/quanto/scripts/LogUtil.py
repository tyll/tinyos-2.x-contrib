
import traceback
import sys
import re

from tinyos.message.SerialPacket import SerialPacket
from HexByteConversion import HexToByte,ByteToHex
from QuantoLogMsgV import QuantoLogMsgV
from QuantoLogEntry import DEFAULT_MESSAGE_SIZE as entry_len
from QuantoLogEntry import QuantoLogEntry

validLineRe = re.compile("^[0-9A-Fa-f\s]+$")

def entriesFromVFile(fin):
    """ Returns an iterator over the entries in the open file fin.
        Expects a file with each line corresponding to a QuantoLogMsgV,
        with NO AM HEADER.
        A QuantoLogMsgV is an array of Quanto messages, preceeded by a
        single-byte integer denoting how many log entries there are in
        the message.
        See QuantoLogStagedMyUART.h
    """
    for line in fin:
        line = line.rstrip()
        if not validLineRe.match(line) :
            continue
        try:
            bytes = HexToByte(line)
        except Exception, x:
            print >>sys.stderr, x
            continue
        try:
            msg = QuantoLogMsgV( data=bytes, data_length = len(bytes) );
        except Exception, x:
            print >>sys.stderr, x
            continue
        n = msg.get_n();
        for i in range(n):
            pos = 1 + i*entry_len
            try:
                entry = QuantoLogEntry( data=bytes[pos:pos+entry_len], data_length=entry_len)
            except Exception, x:
                print >>sys.stderr, x
                continue
            yield entry

def entriesFromLFile(fin):
    """ Returns an iterator over the entries in the open file fin.
        Expects a file with each line corresponding to a QuantoLogEntry
        with NO AM HEADER
    """
    for line in fin:
        line = line.rstrip()
        if not validLineRe.match(line) :
            continue
        try:
            bytes = HexToByte(line)
        except Exception, x:
            print >>sys.stderr, x
            continue
        try:
            entry = QuantoLogEntry( data=bytes, data_length = len(bytes))
        except Exception, x:
            print >>sys.stderr, x
            continue
        yield entry

        
def getUartLogPayload(packet):
    """
    Get a Quanto Log Entry from the UART packet.
    Returns None if the AM type of the packet is not 
     QUANTO_LOG_AM_TYPE (c.f. QuantoLog/RawUartMsg.h)
    """ 
    #From MoteIF.py
    try:
        # Message.py ignores base_offset, so we'll just chop off
        # the first byte (the SERIAL_AMTYPE) here.
        serial_pkt = SerialPacket(packet[1:],
                                  data_length=len(packet)-1)
    except:
        traceback.print_exc()


    try:
        data_start = serial_pkt.offset_data(0) + 1
        data_end = data_start + serial_pkt.get_header_length()
        data = packet[data_start:data_end]
        amType = serial_pkt.get_header_type()

    except Exception, x:
        print >>sys.stderr, x
        print >>sys.stderr, traceback.print_tb(sys.exc_info()[2])
    if (amType == QuantoLogEntry.get_amType()): 
        try:
            msg = QuantoLogEntry(data=data,
                             data_length = len(data),
                             addr=serial_pkt.get_header_src(),
                             gid=serial_pkt.get_header_group())
         
        except Exception, x:
            print >>sys.stderr, x
            print >>sys.stderr, traceback.print_tb(sys.exc_info()[2])
        return msg
    else:
        return None

def getUartMyLogPayload(packet):
    """
    Get a Quanto Log Entry from the UART packet.
    This version reads the packet that is just the log message
    outside of an active message.
    """ 
    try:
        data_start = 0
        data_end = 12
        data = packet[data_start:data_end]

    except Exception, x:
        print >>sys.stderr, x
        print >>sys.stderr, traceback.print_tb(sys.exc_info()[2])
    try:
        msg = QuantoLogEntry(data=data,
                         data_length = len(data))
     
    except Exception, x:
        print >>sys.stderr, x
        print >>sys.stderr, traceback.print_tb(sys.exc_info()[2])
        return None
    return msg

"""
HexByteConversion

Convert a hex string packet representation to the corresponding array of bytes.
"""

# Inspired by http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/510399
#

# raises ValueError (how to express this in contract?)
def HexStringToBytes ( hexStr ):
    """
    Convert a string of hex bytes to an array of bytes. The Hex String values
    may or may not be space separated
    """
    bytes = []
    
    # Remove spaces
    hexStr = ''.join( hexStr.rstrip().split(" ") )
    for i in range(0, len(hexStr), 2):
        bytes.append( int (hexStr[i:i+2], 16) )

    return bytes

# some test data

__hexStr1  = "FFFFFF5F8121070C0000FFFFFFFF5F8129010B"
__hexStr2  = "FF FF FF 5F 81 21 07 0C 00 00 FF FF FF FF 5F 81 29 01 0B"
__hexStr3  = "FF FF FF 5F 81 21 07 0C 00 00 FF FF FF FF 5F 81 29 01 0"
__hexStr4  = "This is not a hex string..."
__hexStr5  = "FF FF Neither is this!"
__byte1 = [0xFF, 0xFF, 0xFF, 0x5F, 0x81, 0x21, 0x07, 0x0C, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x5F, 0x81, 0x29, 0x01, 0x0B]
__byte2 = [0xFF, 0xFF, 0xFF, 0x5F, 0x81, 0x21, 0x07, 0x0C, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0x5F, 0x81, 0x29, 0x01, 0x00]

if __name__ == "__main__":
    print "\nHex String to Byte Conversion"

    if ( HexStringToBytes(__hexStr1) == __byte1):
        print "Test 1 passed"
    if ( HexStringToBytes(__hexStr2) == __byte1):
        print "Test 2 passed"
    if ( HexStringToBytes(__hexStr3) == __byte2):
        print "Test 3 passed"
    if ( len(HexStringToBytes(__hexStr4)) == 0):
        print "Test 4 passed: failed to convert '" + __hexStr4 + "'"
    if ( len(HexStringToBytes(__hexStr5)) == 0):
        print "Test 5 passed: failed to convert '" + __hexStr5 + "'"

