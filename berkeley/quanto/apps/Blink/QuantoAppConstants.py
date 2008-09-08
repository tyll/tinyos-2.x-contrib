class QuantoAppConstants:
    ACT_BOUNCE = 0x10
    ACT_RED = 0x1
    ACT_GREEN = 0x2
    ACT_BLUE = 0x3

    ACT_MAIN = 21
    ACT_HUM = 22
    ACT_TEMP = 23
    ACT_TSR = 24
    ACT_PAR = 25
    ACT_PKT = 26

    names = {
        ACT_BOUNCE      : 'BounceApp',
        ACT_MAIN        : 'Main',
        ACT_HUM         : 'SenseHumidity',
        ACT_TEMP        : 'SenseTemp', 
        ACT_TSR         : 'SenseTSR',
        ACT_PAR         : 'SensePAR',
        ACT_PKT         : 'Send',
        ACT_RED         : 'Red',
        ACT_GREEN       : 'Green',
        ACT_BLUE        : 'Blue',
    }
