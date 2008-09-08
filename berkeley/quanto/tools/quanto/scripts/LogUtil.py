
import traceback
import sys

from tinyos.message.SerialPacket import SerialPacket
from QuantoLogEntry import QuantoLogEntry

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

