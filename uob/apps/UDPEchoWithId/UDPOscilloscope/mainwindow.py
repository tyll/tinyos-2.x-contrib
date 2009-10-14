import sys

from PyQt4.QtGui import *
from Ui_osci_widget import *

from models import *

class MainWindow(QMainWindow, Ui_MainWindow):
    def __init__(self, parent = None):
        QMainWindow.__init__(self, parent)
        self.setupUi(self)

        self.packetIndicator = QRadioButton()
        self.packetIndicator.setEnabled(False)
        self.statusBar().addWidget(self.packetIndicator)
        self.statusLabel = QLabel("Ready.")
        self.statusBar().addWidget(self.statusLabel)

        # create models
        self.oscm = OscilloscopeModel(self.plot_temp,
                                      self.plot_hum,
                                      self.plot_tsr,
                                      self.plot_par,
                                      self.plot_volt)

        QtCore.QObject.connect(self.actionUpdate,
                               QtCore.SIGNAL("activated()"),
                               self.update)
        QtCore.QObject.connect(self.actionQuit,
                               QtCore.SIGNAL("activated()"),
                               self.quit)
        QtCore.QObject.connect(self.actionSave,
                               QtCore.SIGNAL("activated()"),
                               self.save)

    def update(self):
        #print "Update"
        self.oscm.update_display()

    def quit(self):
        sys.exit(0)

    def save(self):
        self.oscm.save_figure()
        pass
