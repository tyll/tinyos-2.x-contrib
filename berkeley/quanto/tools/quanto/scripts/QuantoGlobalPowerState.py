#!/usr/bin/python

from QuantoActivity import activity
from QuantoCC2420Constants import QuantoCC2420Constants
from QuantoCoreConstants import QuantoCoreConstants
from QuantoLogConstants import QuantoLogConstants
from ResourceConstants import ResourceConstants

 
#extracts from the cc2420 power state raw value the bit 
#corresponding to the key
def _getCC2420PowerBitValues(radioPowerState,key):
    cc2420PowerKey = {
        '2420starting' :QuantoCC2420Constants.CC2420_PW_STARTING,
        '2420listen'   :QuantoCC2420Constants.CC2420_PW_LISTEN,
        '2420rx'       :QuantoCC2420Constants.CC2420_PW_RX,
        '2420stopping' :QuantoCC2420Constants.CC2420_PW_STOPPING,
        '2420rxfifo'   :QuantoCC2420Constants.CC2420_PW_RXFIFO,
        '2420txfifo'   :QuantoCC2420Constants.CC2420_PW_TXFIFO,
        '2420tx'       :QuantoCC2420Constants.CC2420_PW_TX
    }
    if (radioPowerState & cc2420PowerKey[key]):
        return 1
    else:
        return 0

class GlobalPowerState:
    compNames = ( 'cpu', 'led0', 'led1', 'led2',
        '2420starting', '2420listen', '2420rx', '2420stopping',
        '2420rxfifo', '2420txfifo',
        '2420tx3', '2420tx7', '2420tx11', '2420tx15',
        '2420tx19', '2420tx23', '2420tx27', '2420tx31'
    )
    compBit = {}
    for i in range(len(compNames)):
        compBit[compNames[i]] = i

    def __init__(self):
        self.clear()

    def clear(self):
        self._values = ['-' for i in range(len(GlobalPowerState.compNames))]
    
    def getBitByName(self, name):
        '''Gets the bit indicated by name.'''
        return self._values[GlobalPowerState.compBit[name]]

    def setBitByName(self, name, value):     
        '''Sets the bit indicated by name.
            
           Returns True if the state changed, False otherwise'''
        if (self._values[GlobalPowerState.compBit[name]] == value):
            return False
        self._values[GlobalPowerState.compBit[name]] = value
        return True

    def getBit(self, bit):
        '''Gets the bit indicated by the index 'bit'.'''
        return self._values[bit]

    def setBit(self, bit, value):
        '''Sets the bit indicated by the index 'bit'.

           Returns True if the state changed, False otherwise'''
        if (self._values[bit] == value):
            return False
        self._values[bit] = value
        return True

    def __str__(self):
        '''Returns the powerstate as a string with a space-separated
           list of bits, in the order of compNames.'''
        return ' '.join(map(str,self._values))

    def getKey(self):
        '''Returns a compact representation suitable to be a hash key'''
        return ''.join(map(str,self._values))

    def getHeader(self):
        '''Returns a string with the component names in order, separated by
           spaces.'''
        return ' '.join(map(str,GlobalPowerState.compNames))

    def updateFromEntry(self, entry):
        '''Update the values based on a log entry.
           This is the reason for this class, and has logic to change
           the global power state based on different resources individual
           power states.
 
           Some resources don't require explicit power state statements in
           the log, as their state can be inferred from lack of activity.
            
           Returns True if the state changed, False otherwise.
        '''
        type = (entry.get_type() >> 4 ) & 0x0F
        subtype = entry.get_type() & 0x0F
        old_values = list(self._values)
        
        # CPU State: idle or busy, inferred from activity
        if (type == QuantoLogConstants.MSG_TYPE_FLUSH_REPORT):
            self.clear()
        elif (type == QuantoLogConstants.MSG_TYPE_SINGLE_CHG):
            if (entry.get_res_id() == ResourceConstants.CPU_RESOURCE_ID):
               if (activity(entry.get_arg()).get_activity_type() == QuantoCoreConstants.ACT_TYPE_IDLE):
                    self.setBitByName('cpu',0)
               else:
                    self.setBitByName('cpu',1)
        elif (type == QuantoLogConstants.MSG_TYPE_POWER_CHG):

            #LED States: directly from the powerstate.
            #Can also be inferred by the activities alone.
            if (entry.get_res_id() == ResourceConstants.LED0_RESOURCE_ID):
                self.setBitByName('led0',entry.get_arg())
            elif (entry.get_res_id() == ResourceConstants.LED1_RESOURCE_ID):
                self.setBitByName('led1',entry.get_arg())
            elif (entry.get_res_id() == ResourceConstants.LED2_RESOURCE_ID):
                self.setBitByName('led2',entry.get_arg())

            #CC2420: has complicated power states, setting several bits.
            #        Each transmit power level is a different bit,
            #        but they are exclusive. See the constants for
            #        more info.
            elif (entry.get_res_id() == ResourceConstants.CC2420_RESOURCE_ID):
                ps = entry.get_arg()
                #other states
                map( lambda x: self.setBitByName( x, _getCC2420PowerBitValues(ps, x) ), 
                    ('2420starting','2420listen','2420rx','2420stopping','2420rxfifo','2420txfifo'))
                #if rx !listen
                if (_getCC2420PowerBitValues(ps, '2420rx')):
                    self.setBitByName('2420listen',0)
    
                #tx : must get power. 
                #First zero all power bits in the global power state to 0
                map( lambda x: self.setBitByName( x, 0),
                    ('2420tx3', '2420tx7', '2420tx11', '2420tx15',
                     '2420tx19', '2420tx23', '2420tx27', '2420tx31')
                )
                #Now find the correct one
                if (_getCC2420PowerBitValues(ps, '2420tx')):
                    self.setBitByName('2420listen',0)     #tx xor listen!
                    power = ps & QuantoCC2420Constants.CC2420_POWERLEVEL_MASK
                    if (power == 3):
                        self.setBitByName( '2420tx3', 1)
                    elif (power == 7):
                        self.setBitByName( '2420tx7', 1)
                    elif (power == 11):
                        self.setBitByName( '2420tx11', 1)
                    elif (power == 15):
                        self.setBitByName( '2420tx15', 1)
                    elif (power == 19):
                        self.setBitByName( '2420tx19', 1)
                    elif (power == 23):
                        self.setBitByName( '2420tx23', 1)
                    elif (power == 27):
                        self.setBitByName( '2420tx27', 1)
                    elif (power == 31):
                        self.setBitByName( '2420tx31', 1)
    
        return old_values != self._values


                   
if __name__ == "__main__":
   p = GlobalPowerState() 
   print "Header: " + p.getHeader()
   print "New state: " + str(p)
   print "Compact: " + p.getKey()
   assert(p.setBitByName('cpu',0))     #true b/c of change
   assert(not p.setBitByName('cpu',0)) #false b/c no change
   print "Setting cpu to 0: " + str(p)
   assert(p.setBitByName('cpu',1))
   print "Setting cpu to 1: " + str(p)
   
    
   
   

    
            
