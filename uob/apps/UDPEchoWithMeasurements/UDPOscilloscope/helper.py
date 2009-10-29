
class TOSUnitConverter():
    def __init__(self):
        self.NaN = float('NaN')

    def convertTemp(self, value):
        if value == 0:
            return self.NaN
        return -39.60 + 0.01*value #CHECK

    def convertHumidity(self, value):
        if value == 0:
            return self.NaN
        return  -4 + 0.0405*value + \
               (-2.8 * 0.000001)*(value*value) #CHECK

    def convertVoltage(self, value):
        return value/4096. * 1.5 * 2 # CHECK

    def convertRSSI(self, value):
        return value - 256 - 45 # FIXME
