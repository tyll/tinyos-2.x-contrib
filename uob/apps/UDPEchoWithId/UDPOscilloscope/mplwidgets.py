from PyQt4.QtGui import *

from matplotlib.patches import FancyArrow
from matplotlib.patches import Rectangle
from matplotlib.backends.backend_qt4agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure, SubplotParams
from matplotlib.font_manager import FontProperties
from matplotlib.lines import Line2D
from matplotlib import rc

import texttime
import datetime

class SFBT4Canvas(FigureCanvas):
    def __init__(self, parent=None, \
                 width=1, height=1, \
                 dpi=300):

        rc('lines', linewidth=.2)
        rc('font', size=4)

        fig_param = SubplotParams(left=0.08, bottom=0.1, right=0.99, top=0.95, wspace=None, hspace=None)
        self.fig = Figure(figsize=(width, height), dpi=dpi, facecolor='#ffffff', subplotpars=fig_param, linewidth=0.2)
        self.axes = self.fig.gca()

        # We want the axes cleared every time plot() is called
        self.axes.hold(False)

        FigureCanvas.__init__(self, self.fig)
        self.setParent(parent)

        FigureCanvas.setSizePolicy(self,
                                   QSizePolicy.Expanding,
                                   QSizePolicy.Expanding)
        FigureCanvas.updateGeometry(self)

    def compute_initial_figure_scatter(self):
        self.axes.scatter(self.n2xyzm.getX(), \
                          self.n2xyzm.getY(),  \
                          edgecolor='#ffffff')
        self.axes.add_line(Line2D([0, 0], [0, 2.3]))
        self.axes.add_line(Line2D([0, 12], [2.3, 2.3]))
        self.axes.add_line(Line2D([12, 12], [2.3, 0]))
        self.axes.add_line(Line2D([12, 0], [0, 0]))

    def compute_initial_figure(self):
        self.axes.set_xlabel('x [m]')
        self.axes.set_ylabel('y [m]')
        self.axes.set_aspect('equal', 'box')
        self.axes.set_xlim((-1, 15))
        self.axes.set_ylim((-1, 5))

class NeighborhoodWidget(SFBT4Canvas):
    def __init__(self, parent):
        self.parent = parent
        SFBT4Canvas.__init__(self, self.parent)

    def prepare(self, n2xyzm):
        self.n2xyzm = n2xyzm
        self.compute_initial_figure()

    def compute_initial_figure(self):
        SFBT4Canvas.compute_initial_figure_scatter(self)
        for i in range(0, self.n2xyzm.getNumberOfNodes()):

            twod_x = (self.n2xyzm.getXY_2D(i))[0]
            twod_y = (self.n2xyzm.getXY_2D(i))[1]

            self.axes.text(twod_x, \
                           twod_y-.3, \
                           i, \
                           color='b')

            base_x = self.n2xyzm.getXYZ(i)[0]
            base_y = self.n2xyzm.getXYZ(i)[1]

            self.axes.add_line(Line2D([base_x, twod_x], [base_y, twod_y], linestyle=':'))

        SFBT4Canvas.compute_initial_figure(self)

        self.axes.set_title('Neighborhood')

    def reset(self):
        self.axes.cla()
        self.compute_initial_figure()

    def addArrow(self, x, y, dx, dy, nh_value):
        arr = FancyArrow(x=x, y=y, dx=dx, dy=dy,
                         edgecolor='y',
                         facecolor='y',
                         length_includes_head=True,
                         linewidth=0.2,
                         head_width=0.05,
                         head_length=0.05)
        self.axes.add_patch(arr)
        #self.axes.text(x+dx/2, y+dy/2, \
        #               nh_value, color='r')

    def redraw(self):
        self.draw()

class TracerouteWidget(SFBT4Canvas):
    def __init__(self, parent):
        SFBT4Canvas.__init__(self, parent)

    def prepare(self, n2xyzm):
        self.n2xyzm = n2xyzm
        self.compute_initial_figure()

    def compute_initial_figure(self):
        SFBT4Canvas.compute_initial_figure_scatter(self)
        for i in range(0, self.n2xyzm.getNumberOfNodes()):
            twod_x = (self.n2xyzm.getXY_2D(i))[0]
            twod_y = (self.n2xyzm.getXY_2D(i))[1]

            self.axes.text(twod_x, \
                           twod_y-.3, \
                           i,  \
                           color='b')

            base_x = self.n2xyzm.getXYZ(i)[0]
            base_y = self.n2xyzm.getXYZ(i)[1]

            self.axes.add_line(Line2D([base_x, twod_x], [base_y, twod_y], linestyle=':'))

        SFBT4Canvas.compute_initial_figure(self)
        self.axes.set_title('Traceroute')

    def reset(self):
        self.axes.cla()
        self.compute_initial_figure()

    def addArrow(self, x, y, dx, dy, tr_value):
        arr = FancyArrow(x=x, y=y, dx=dx, dy=dy,
                         edgecolor='y',
                         facecolor='y',
                         length_includes_head=True,
                         linewidth=0.2,
                         head_width=0.05,
                         head_length=0.05)
        self.axes.add_patch(arr)
        self.axes.text(x+dx/2, y+dy/2, \
                       tr_value, color='r')

    def redraw(self):
        self.draw()

class HopCountWidget(SFBT4Canvas):
    def __init__(self, parent):
        SFBT4Canvas.__init__(self, parent)

    def prepare(self, n2xyzm):
        self.n2xyzm = n2xyzm
        self.compute_initial_figure()

    def compute_initial_figure(self):
        SFBT4Canvas.compute_initial_figure_scatter(self)
        for i in range(0, self.n2xyzm.getNumberOfNodes()):
            twod_x = (self.n2xyzm.getXY_2D(i))[0]
            twod_y = (self.n2xyzm.getXY_2D(i))[1]

            #self.axes.text(twod_x, \
            #               twod_y-.3, \
            #               i, color='b')

            base_x = self.n2xyzm.getXYZ(i)[0]
            base_y = self.n2xyzm.getXYZ(i)[1]

            self.axes.add_line(Line2D([base_x, twod_x], [base_y, twod_y], linestyle=':'))

        SFBT4Canvas.compute_initial_figure(self)
        self.axes.set_title('Hop Count')

    def reset(self):
        self.axes.cla()
        self.compute_initial_figure()

    def addText(self, x, y, hc_value):
        self.axes.text(x, y-.3, \
                       hc_value, color='r')

    def redraw(self):
        self.draw()

class SensorWidget(SFBT4Canvas):
    def __init__(self, parent):
        SFBT4Canvas.__init__(self, parent)

    def prepare(self, n2xyzm):
        self.n2xyzm = n2xyzm
        self.compute_initial_figure()

    def compute_initial_figure(self):
        SFBT4Canvas.compute_initial_figure_scatter(self)
        for i in range(0, self.n2xyzm.getNumberOfNodes()):

            twod_x = (self.n2xyzm.getXY_2D(i))[0]
            twod_y = (self.n2xyzm.getXY_2D(i))[1]

            #self.axes.text(twod_x, \
            #               twod_y-.3, \
            #               i, color='b')

            base_x = self.n2xyzm.getXYZ(i)[0]
            base_y = self.n2xyzm.getXYZ(i)[1]

            self.axes.add_line(Line2D([base_x, twod_x], [base_y, twod_y], linestyle=':'))

        SFBT4Canvas.compute_initial_figure(self)

        self.axes.set_title('Sensor Values')

    def reset(self):
        self.axes.cla()
        self.compute_initial_figure()

    def addText(self, x, y, text):
        self.axes.text(x, y-0.4, \
                       text, \
                       color='r')

    def redraw(self):
        self.draw()

class EnergyWidget(SFBT4Canvas):
    def __init__(self, parent):
        SFBT4Canvas.__init__(self, parent)

    def prepare(self, n2xyzm):
        self.n2xyzm = n2xyzm
        self.compute_initial_figure()

    def compute_initial_figure(self):
        SFBT4Canvas.compute_initial_figure_scatter(self)
        for i in range(0, self.n2xyzm.getNumberOfNodes()):

            twod_x = (self.n2xyzm.getXY_2D(i))[0]
            twod_y = (self.n2xyzm.getXY_2D(i))[1]

            #self.axes.text(twod_x, \
            #               twod_y-.3, \
            #               i, color='b')

            base_x = self.n2xyzm.getXYZ(i)[0]
            base_y = self.n2xyzm.getXYZ(i)[1]

            self.axes.add_line(Line2D([base_x, twod_x], [base_y, twod_y], linestyle=':'))

#        for i in self.n2xyzm.node2xyz:
#            self.axes.text((self.n2xyzm.node2xyz[i])[0], \
#                           (self.n2xyzm.node2xyz[i])[1], \
#                           i)

        SFBT4Canvas.compute_initial_figure(self)

        self.axes.set_title('Battery Voltage')

    def reset(self):
        self.axes.cla()
        self.compute_initial_figure()

    def addText(self, x, y, text):
        self.axes.text(x, y-0.4, \
                       text, \
                       color='r')

    def redraw(self):
        self.draw()

class DoorRebootWidget(SFBT4Canvas):
    def __init__(self, parent):
        SFBT4Canvas.__init__(self, parent)

    def prepare(self, n2xyzm):
        self.n2xyzm = n2xyzm
        self.compute_initial_figure()

    def compute_initial_figure(self):
        SFBT4Canvas.compute_initial_figure_scatter(self)
        for i in range(0, self.n2xyzm.getNumberOfNodes()):

            twod_x = (self.n2xyzm.getXY_2D(i))[0]
            twod_y = (self.n2xyzm.getXY_2D(i))[1]

            #self.axes.text(twod_x, \
            #               twod_y-.3, \
            #               i, color='b')

            base_x = self.n2xyzm.getXYZ(i)[0]
            base_y = self.n2xyzm.getXYZ(i)[1]

            self.axes.add_line(Line2D([base_x, twod_x], [base_y, twod_y], linestyle=':'))

#        for i in self.n2xyzm.node2xyz:
#            self.axes.text((self.n2xyzm.node2xyz[i])[0], \
#                           (self.n2xyzm.node2xyz[i])[1], \
#                           i)

        SFBT4Canvas.compute_initial_figure(self)

        self.axes.set_title('Door/Reboot')

    def reset(self):
        self.axes.cla()
        self.compute_initial_figure()

    def addText(self, x, y, text):
        if text == "0":
            self.axes.text(x, y-0.4, \
                           text, \
                           color='r')
        else:
            self.axes.text(x, y-0.4, \
                           text, \
                           color='b')

    def redraw(self):
        self.draw()

class StatWidget(QLabel):
    def __init__(self, parent, *args):
        QLabel.__init__(self, parent, *args)
        self.setFont(QFont("Sans Serif", 8))

    def prepare(self, n2xyzm):
        pass

def onpick(event):
    if isinstance(event.artist, RectangleWithInformation):
        msgBox = QMessageBox()
        msgBox.setModal(False) #FIXME: this is not working
        msgBox.setText(str(event.artist))
        msgBox.exec_()

class RectangleWithInformation(Rectangle):
        def __init__(self, tgi, node, time, type, msg, fullmsg, fulltime):
            Rectangle.__init__(self,
                    xy= (time + tgi.type_to_offset[type][0], \
                          node + tgi.type_to_offset[type][1]) , \
                          width=.5, height=.1, \
                          fc=tgi.type_to_color[type][0], \
                          ec=tgi.type_to_color[type][0], \
                          linewidth=0.0)
            self.fulltime = fulltime
            self.msg = msg
            self.fullmsg  = fullmsg

        def __str__(self):
            return str(self.fulltime) + "\n" \
                   + str(self.fullmsg) \
                   + str(self.msg)

class TypeGraphInformation:
    def __init__(self):
        self.type_to_color = {}
        self.type_to_color[128] = ((1., .0, .0), "Sensing" )  # sensing
        self.type_to_color[130] = ((.0, .2, .0), "Network" )  # network
        self.type_to_color[131] = ((.0, .5, .0), "Neighb" )   # neighborhood
        self.type_to_color[136] = ((.0, .0, 1.), "UART" )     # uart_sync
        self.type_to_color[138] = ((.0, 1., .0), "RSSI LQI" ) # rssi_lqi_report
        self.type_to_color[133] = ((1., .5, .0), "Beacon" )   # beacon
        self.type_to_color[132] = ((.5, .5, .5), "Ack" )      # ack
        self.type_to_color[134] = ((.5, .0, .5), "Sync Rep" ) # sync_reply
        self.type_to_color[135] = ((.5, .5, .0), "Sync Req" ) # sync_request
        self.type_to_color[139] = ((.0, .3, .3), "Boot" )     # boot

        self.type_to_offset = {}
        self.type_to_offset[128] = (0, .9) # sensing
        self.type_to_offset[130] = (0, .8) # network
        self.type_to_offset[131] = (0, .7) # neighborhood
        self.type_to_offset[136] = (0, .2) # uart_sync
        self.type_to_offset[138] = (0, .1) # rssi_lqi_report
        self.type_to_offset[133] = (0, .5) # beacon
        self.type_to_offset[132] = (0, .6) # ack
        self.type_to_offset[134] = (0, .4) # sync_reply
        self.type_to_offset[135] = (0, .3) # sync_request
        self.type_to_offset[139] = (0, .2) # boot

class PacketWidget(SFBT4Canvas):
    def __init__(self, parent):
        SFBT4Canvas.__init__(self, parent)

        self.SECONDS_TO_SHOW = 500

        self.tgi = TypeGraphInformation()

        self.xmin = 0
        self.xmax = self.SECONDS_TO_SHOW

        self.ymin = -2
        self.ymax = 1

        self.start_packet_time = datetime.datetime.now()

        self.compute_initial_figure()
        self.fig.canvas.mpl_connect('pick_event', onpick)

    def prepare(self):
        pass

    def compute_initial_figure(self):
        self.axes.set_title('Packet Scatter')

        r_l = [Rectangle(xy=(0, 0), width=.1, height=.1, \
                         fc=self.tgi.type_to_color[i][0], ec=self.tgi.type_to_color[i][0]) \
                   for i in self.tgi.type_to_color]
        label = [self.tgi.type_to_color[i][1] for i in self.tgi.type_to_color]
        self.axes.legend(r_l, label, loc='upper left')

        self.axes.set_xlabel('Time [s] (since start of program)')
        self.axes.set_ylabel('Node ID')

        self.draw()

    def add_rectangle(self, node, time, type, msg, fullmsg, fulltime):
        #print "add",(time, node), type, msg

        r = RectangleWithInformation(self.tgi, node, time, type, msg, fullmsg, fulltime)
        r.set_picker(100.0)
        #print "r", r
        self.axes.add_artist(r)

    def reset(self):
        self.axes.cla()
        self.compute_initial_figure()

    def redraw(self):
        self.draw()

    def set_lims(self, maxtime, maxnode):
        self.maxtime = maxtime
        self.maxnode = maxnode

        self.xmax = texttime.sec_between(maxtime, self.start_packet_time)+10
        self.xmin = max(0, self.xmax - self.SECONDS_TO_SHOW)

        self.ymax = maxnode+2

        self.axes.set_xlim(self.xmin, self.xmax)
        self.axes.set_ylim(self.ymin, self.ymax)

        self.axes.set_yticks(range(0, self.ymax))
        self.axes.yaxis.grid(True, linewidth=.2)

    def draw_packets(self, packets):
        #cur_packet_no = 0

        if packets == None:
            packets = self.cached_packets
        else:
            self.cached_packets = packets

        for p in packets:
            #if self.xmin < texttime.sec_between(self.maxtime, p[1]) < self.xmax:
            if self.xmin < texttime.sec_between(p[1], self.start_packet_time) < self.xmax:
                #print "Recent packet", p[1], texttime.sec_between(self.maxtime, p[1])
                self.add_rectangle(p[0], texttime.sec_between(p[1], self.start_packet_time), p[2], p[3], p[4], p[1])
            #else:
                #print "Old packet", p[1]
            #print "tt", texttime.sec_between(p[1], self.start_packet_time), self.xmin, self.xmax
            #cur_packet_no += 1

    def left(self):
        print "left"
        self.xmax = max(0, self.xmax - self.SECONDS_TO_SHOW)
        self.xmin = max(0, self.xmax - self.SECONDS_TO_SHOW) # actually this is ORIG xmax-2*SEC...

        self.axes.set_xlim(self.xmin, self.xmax)
        self.axes.set_ylim(self.ymin, self.ymax)

        self.draw_packets(None)
        self.redraw()

    def right(self):
        print "right"
        self.xmax += self.SECONDS_TO_SHOW
        self.xmin = max(0, self.xmax - self.SECONDS_TO_SHOW)

        self.axes.set_xlim(self.xmin, self.xmax)
        self.axes.set_ylim(self.ymin, self.ymax)

        self.draw_packets(None)
        self.redraw()
