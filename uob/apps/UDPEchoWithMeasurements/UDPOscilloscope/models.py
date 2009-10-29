import datetime, calendar

from PyQt4.QtGui import *
from PyQt4.QtCore import *
from PyKDE4.kdeui import *

from helper import *
#from multihop.multihop_protocol import *

class OscilloscopeModel():
    def __init__(self, plot_temp, plot_hum, plot_tsr, plot_par, plot_volt):
        self.plot_temp = plot_temp
        self.plot_hum  = plot_hum
        self.plot_tsr  = plot_tsr
        self.plot_par  = plot_par
        self.plot_volt = plot_volt

        self.plot_temp.axis(KPlotWidget.BottomAxis).setLabel("Unix Time")
        self.plot_hum.axis(KPlotWidget.BottomAxis).setLabel("Unix Time")
        self.plot_tsr.axis(KPlotWidget.BottomAxis).setLabel("Unix Time")
        self.plot_par.axis(KPlotWidget.BottomAxis).setLabel("Unix Time")
        self.plot_volt.axis(KPlotWidget.BottomAxis).setLabel("Unix Time")

        self.plot_temp.axis(KPlotWidget.LeftAxis).setLabel("Temperature [deg Celsius]")
        self.plot_hum.axis(KPlotWidget.LeftAxis).setLabel("Rel. Humidity [%]")
        self.plot_tsr.axis(KPlotWidget.LeftAxis).setLabel("Visible Light")
        self.plot_par.axis(KPlotWidget.LeftAxis).setLabel("Photo Active Radiation")
        self.plot_volt.axis(KPlotWidget.LeftAxis).setLabel("Voltage [V]")

        self.temp_po = {}
        self.hum_po  = {}
        self.tsr_po  = {}
        self.par_po  = {}
        self.volt_po = {}

        #self.min_x = 1000
        #self.max_x = 10
        self.min_x = calendar.timegm(datetime.datetime.now().timetuple())
        self.max_x = calendar.timegm(datetime.datetime.now().timetuple())

        self.min_temp = 20
        self.max_temp = 10

        self.min_hum  = 50
        self.max_hum  = 50

        self.min_tsr = 1
        self.max_tsr = 1

        self.min_par = 1
        self.max_par = 1

        self.min_volt = 2
        self.max_volt = 2

        self.tuc = TOSUnitConverter()
        self.cm  = ColorManager()

    def update_msg(self, msg, time):
        print msg

        if not self.temp_po.has_key(msg.get_sender()):
            print "New node"
            color = self.cm.getNextColor()

            self.temp_po[msg.get_sender()] = KPlotObject(color, KPlotObject.Lines)
            self.hum_po[msg.get_sender()]  = KPlotObject(color, KPlotObject.Lines)
            self.tsr_po[msg.get_sender()]  = KPlotObject(color, KPlotObject.Lines)
            self.par_po[msg.get_sender()]  = KPlotObject(color, KPlotObject.Lines)
            self.volt_po[msg.get_sender()] = KPlotObject(color, KPlotObject.Lines)

            self.plot_temp.addPlotObject(self.temp_po[msg.get_sender()])
            self.plot_hum.addPlotObject(self.hum_po[msg.get_sender()])
            self.plot_tsr.addPlotObject(self.tsr_po[msg.get_sender()])
            self.plot_par.addPlotObject(self.par_po[msg.get_sender()])
            self.plot_volt.addPlotObject(self.volt_po[msg.get_sender()])


        raw_temp = msg.get_temp()
        raw_hum  = msg.get_hum()
        raw_volt = msg.get_volt()
        raw_tsr  = msg.get_tsr()
        raw_par  = msg.get_par()

        # convert to real values
        temp = self.tuc.convertTemp(raw_temp)
        hum  = self.tuc.convertHumidity(raw_hum)

        tsr = raw_tsr # TODO
        par = raw_par # TODO

        volt = self.tuc.convertVoltage(raw_volt)

        #if msg.get_seqno() < self.min_x:
            #self.min_x = msg.get_seqno()
        #if msg.get_seqno() > self.max_x:
            #self.max_x = msg.get_seqno()
        #if time < self.min_x:
        #    self.min_x = time
        time = calendar.timegm(time.timetuple())
        if time > self.max_x:
            self.max_x = time

        #check validness of data
        #print msg.get_valid(), "Valid:",
        if msg.get_valid() & 0x1:  # PAR
            #print "PAR",
            if par < self.min_par:
                self.min_par = par
            if par > self.max_par:
                self.max_par = par

            self.par_po[msg.get_sender()].addPoint(
                #msg.get_seqno(),
                time,
                par)

            self.plot_par.setLimits(self.min_x, \
                                    self.max_x, \
                                    0, \
                                    self.max_par +10)
            self.plot_par.update()

        if msg.get_valid() & 0x2:  # TSR
            #print "TSR",
            if tsr < self.min_tsr:
                self.min_tsr = tsr
            if tsr > self.max_tsr:
                self.max_tsr = tsr

            self.tsr_po[msg.get_sender()].addPoint(
                #msg.get_seqno(),
                time,
                tsr)

            self.plot_tsr.setLimits(self.min_x, \
                                    self.max_x, \
                                    0, \
                                    self.max_tsr +10)
            self.plot_tsr.update()

        if msg.get_valid() & 0x4:  # VOLT
            #print "VOLT",
            if volt < self.min_volt:
                self.min_volt = volt
            if volt > self.max_volt:
                self.max_volt = volt

            self.volt_po[msg.get_sender()].addPoint(
                #msg.get_seqno(),
                time,
                volt)

            self.plot_volt.setLimits(self.min_x, \
                                     self.max_x, \
                                     0, \
                                     self.max_volt +1)
            self.plot_volt.update()

        if msg.get_valid() & 0x8:  # HUM
            #print "HUM",
            if hum < self.min_hum:
                self.min_hum = hum
            if hum > self.max_hum:
                self.max_hum = hum

            self.hum_po[msg.get_sender()].addPoint(
                #msg.get_seqno(),
                time,
                hum)

            self.plot_hum.setLimits(self.min_x, \
                                    self.max_x, \
                                    0, \
                                    self.max_hum +10)
            self.plot_hum.update()

        if msg.get_valid() & 0x10: # TEMP
            #print "TEMP",
            if temp < self.min_temp:
                self.min_temp = temp
            if temp > self.max_temp:
                self.max_temp = temp

            self.temp_po[msg.get_sender()].addPoint(
                #msg.get_seqno(),
                time,
                temp)

            self.plot_temp.setLimits(self.min_x, \
                                     self.max_x, \
                                     self.min_temp -10, \
                                     self.max_temp +10)
            self.plot_temp.update()

    def update_display(self):
        self.widget.reset()

        self.widget.redraw()

    def save_figure(self):
        self.widget.print_figure("output/oscilloscope.png", dpi=300)


class ColorManager():
    def __init__(self):

        self.colormap = [
            [  0,   0,   0],

            [  0,   0, 128],
            [  0, 128,   0],
            [128,   0,   0],

            [128, 128,   0],
            [128,   0, 128],
            [  0, 128, 128],

            [128, 128, 128],

            [  0,   0, 256],
            [  0, 256,   0],
            [256,   0,   0],

            [256, 256,   0],
            [256,   0, 256],
            [  0, 256, 256],

            [128, 128, 256],
            [128, 256, 128],
            [256, 128, 128],

            [256, 256, 128],
            [256, 128, 256],
            [128, 256, 256],
            ]
        self.index = 0

    def getNextColor(self):

        self.index = self.index +1
        self.index = self.index % len(self.colormap)

        return QColor(
            self.colormap[self.index][0],
            self.colormap[self.index][1],
            self.colormap[self.index][2],
            )
