def map_cc2420 (power):
    """
    Map power levels for the cc2420 radio onto a gain.
    """
    raise NotImplementedError


def map_normalized_direct (power):
    """
    Map power levels such that a value of X is (X - 127) dBm.

    Thus, the maximum level is 0 dBm (when power is 127) and the
    minimum level is -127 dBm (when power is 0).
    """
    return power - 127


def bootstrapTxPower (tx_power, dyn_topo, power_map=map_normalized_direct):
    """
    Create linkings between a TxPower object and a DynTopo object.
    """

    def power_change (mote_id, power):
        try:
            gain = power_map(power)
#            print "Mote %d changed power to %d (%d)" % (mote_id, power, gain)
            n = dyn_topo.getNode(mote_id)
            n.set_txgain(gain)
        except:
            print "Error changing power"
        finally:
            return power

    def power_inspect (mote_id):
        try:
#            print "Mote %d inspected power" % mote_id
            n = dyn_topo.getNode(mote_id)
        except:
            print "Error inspecting power"
        finally:
            return n.ro_txgain            

    tx_power.setChangeFunction(power_change)
    tx_power.setInspectFunction(power_inspect)
