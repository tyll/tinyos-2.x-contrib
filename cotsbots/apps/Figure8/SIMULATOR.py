from playerc import *
import time
#0
#0
client0 = playerc_client(None, "localhost", 6665)
#0
if client0.connect() != 0: raise playerc_error_str()
#0
pos0 = playerc_position2d(client0,0)
#0
if pos0.subscribe(PLAYERC_OPEN_MODE) != 0: raise playerc_error_str()
#0
time.sleep(0* 3600 +0* 60 +1.000000000-0)
#0
pos0.set_cmd_vel(1.000, 0, 0.000, 1)
#0
time.sleep(0* 3600 +0* 60 +1.122070332-1.0)
#0
pos0.set_cmd_vel(1.000, 0, 0.000, 1)
#0
time.sleep(0* 3600 +0* 60 +1.366210957-1.122070332)
#0
pos0.set_cmd_vel(1.000, 0, 0.524, 1)
#0
time.sleep(0* 3600 +0* 60 +13.573242207-1.366210957)
#0
pos0.set_cmd_vel(1.000, 0, 0.000, 1)
#0
time.sleep(0* 3600 +0* 60 +14.305664082-13.573242207)
#0
pos0.set_cmd_vel(1.000, 0, -0.524, 1)
#0
time.sleep(0* 3600 +0* 60 +26.512695332-14.305664082)
#0
pos0.set_cmd_vel(1.000, 0, 0.000, 1)
#0
time.sleep(0* 3600 +0* 60 +27.000976582-26.512695332)
#0
pos0.set_cmd_vel(1.000, 0, 0.000, 1)
#0
time.sleep(0* 3600 +0* 60 +27.245117207-27.000976582)
#0
pos0.set_cmd_vel(1.000, 0, 0.524, 1)
#0
time.sleep(0* 3600 +0* 60 +39.452148457-27.245117207)
#0
pos0.set_cmd_vel(1.000, 0, 0.000, 1)
#0
time.sleep(0* 3600 +0* 60 +40.184570332-39.452148457)
#0
pos0.set_cmd_vel(1.000, 0, -0.524, 1)
#0
time.sleep(0* 3600 +0* 60 +52.391601582-40.184570332)
