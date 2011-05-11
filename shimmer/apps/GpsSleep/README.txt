sleep application for shimmers that have a gps/pressure sensor board
installed.  this board has a few anomalies that cause it burn lots of
power if both chipsets aren't placated.  the gps by itself will remain
quiescent with its enable pin high (default), but the bmp085 pressure
sensor requires i2c bus initialization to stay quiet.  here it is.
