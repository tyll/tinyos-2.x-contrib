from gnuradio import gr, eng_notation
from gnuradio import usrp
from gnuradio import ucla
from gnuradio.ucla_blks import ieee802_15_4_pkt

# def pick_subdevice(u):
#     """
#     The user didn't specify a subdevice on the command line.
#     If there's a daughterboard on A, select A.
#     If there's a daughterboard on B, select B.
#     Otherwise, select A.
#     """
#     if u.db[0][0].dbid() >= 0:
#         # dbid is < 0 if there's no d'board or a problem
#         return (0, 0)
#     if u.db[1][0].dbid() >= 0:
#         return (1, 0)
#     return (0, 0)

def pick_subdevice(u):
    """
    """
#     return usrp.pick_subdev(u, (usrp_dbid.TV_RX_REV_2,
#                                 usrp_dbid.DBS_RX,
#                                 usrp_dbid.DBS_RX_REV_2_1,
#                                 usrp_dbid.BASIC_RX))
    return (0, 0)

class dummy_rx_block(gr.top_block):
    def __init__(self, rx_callback):
        pass

    def start(self):
        pass

    def wait(self):
        pass

    def set_auto_tr(self, enable):
        pass

    def carrier_sensed(self):
        return False

class dummy_tx_block(gr.top_block):
    def __init__(self):
        pass

    def start(self):
        pass

    def wait(self):
        pass

    def set_gain(self, gain):
        pass

    def set_auto_tr(self, enable):
        pass

    def send_pkt(self, payload='', eof=False):
        pass

    def send_tinyos_pkt(self, payload='', eof=False):
        pass

class rx_block(gr.top_block):
    def __init__(self, rx_callback):
        gr.top_block.__init__(self)

        self.data_rate =  2000000
        self.samples_per_symbol = 2
        self.usrp_decim = int (64e6 / self.samples_per_symbol / self.data_rate)
        self.fs = self.data_rate * self.samples_per_symbol
        payload_size = 128             # bytes

        print "data_rate = ", eng_notation.num_to_str(self.data_rate)
        print "samples_per_symbol = ", self.samples_per_symbol
        print "usrp_decim = ", self.usrp_decim
        print "fs = ", eng_notation.num_to_str(self.fs)

        self.u = usrp.source_c (0, self.usrp_decim)
        self.picksubdev = pick_subdevice(self.u)
        self.u.set_mux(usrp.determine_rx_mux_value(self.u, self.picksubdev))

        self.subdev = usrp.selected_subdev(self.u, pick_subdevice(self.u))
        print "Using RX d'board %s" % (self.subdev.side_and_name(),)

        #self.u.tune(0, self.subdev, 2475000000)
        #self.u.tune(0, self.subdev, 2480000000)
        self.u.tune(0, self.subdev, 2425000000)
        self.u.set_pga(0, 0)
        self.u.set_pga(1, 0)

        # receiver
        self.packet_receiver = ieee802_15_4_pkt.ieee802_15_4_demod_pkts(self,
                                                                        callback=rx_callback,
                                                                        sps=self.samples_per_symbol,
                                                                        symbol_rate=self.data_rate,
                                                                        threshold=-1)

        self.squelch = gr.pwr_squelch_cc(50, 1, 0, True)
        self.connect(self.u, self.squelch, self.packet_receiver)

        # enable Auto Transmit/Receive switching
        self.set_auto_tr(True)

    def set_auto_tr(self, enable):
        return self.subdev.set_auto_tr(enable)

    def carrier_sensed(self):
        return self.packet_receiver.carrier_sensed()

class tx_block(gr.top_block):
    def __init__(self):
        gr.top_block.__init__(self)
        self.normal_gain = 8000

        self.u = usrp.sink_c()
        dac_rate = self.u.dac_rate()
        self._data_rate = 2000000
        self._spb = 2
        self._interp = int(128e6 / self._spb / self._data_rate)
        self.fs = 128e6 / self._interp

        self.u.set_interp_rate(self._interp)

        self.picksubdev = pick_subdevice(self.u)
        #self.u.set_mux(usrp.determine_rx_mux_value(self.u, self.picksubdev))
        self.subdev = usrp.selected_subdev(self.u, pick_subdevice(self.u))
        print "Using TX d'board %s" % (self.subdev.side_and_name())

        #self.u.tune(0, self.subdev, 2475000000)
        #self.u.tune(0, self.subdev, 2480000000)
        self.u.tune(0, self.subdev, 2425000000)
        self.u.set_pga(0, 0)
        self.u.set_pga(1, 0)

        # transmitter
        self.packet_transmitter = ieee802_15_4_pkt.ieee802_15_4_mod_pkts(self, spb=self._spb, msgq_limit=2)

        self.gain = gr.multiply_const_cc (self.normal_gain)

        self.connect(self.packet_transmitter, self.gain, self.u)

        self.set_gain(self.subdev.gain_range()[1])  # set max Tx gain
        self.set_auto_tr(True)                      # enable Auto Transmit/Receive switching

    def set_gain(self, gain):
        self.gain = gain
        self.subdev.set_gain(gain)

    def set_auto_tr(self, enable):
        return self.subdev.set_auto_tr(enable)

    def send_pkt(self, payload='', eof=False):
        """
        Send a packet with a predetermined sequence number and from/to address.
        """
        #return self.packet_transmitter.send_pkt(0xe5, struct.pack("HHHH", 0xFFFF, 0xFFFF, 0x10, 0x10), payload, eof)
        return self.packet_transmitter.send_raw_pkt(payload, eof)

    #def send_pkt(self, seqno, address, payload='', eof=False):
    #    return self.packet_transmitter.send_pkt(seqno, address, payload, eof)

    def send_tinyos_pkt(self, payload='', eof=False):
        """
        Send a TinyOS packet.
        """
        return self.packet_transmitter.send_tinyos_pkt_add_crc(payload, eof)
