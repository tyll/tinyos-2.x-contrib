This is a general purpose configurable application to be used with shimmer and any add-on daughter-cards supplied by shimmer-research.


By default this application samples the 3-axis accelerometer at 50Hz and sends the data over the Bluetooth radio, using a data buffer size of 1.

   Data Packet Format:
          Packet Type | TimeStamp | chan1 | chan2 | ... |  chanX 
   Byte:       0      |    1-2    |  3-4  |  5-6  | ... | (x-1)-x


When the application receives an Inquiry command it respons with the following packet. The value in the channel fields indicate exactly what data from which sensor is contained in this field of the data packet:

Inquiry Response Packet Format:
          Packet Type | ADC Sampling rate | Accel Sensitivity | Config Byte 0 |Num Chans | Buf size | Chan1 | Chan2 | ... | ChanX
   Byte:       0      |         1         |          2        |       3       |    4     |     5    |   6   |   7   | ... |   x 


Currently the following parameters can be configured. This configuration is stored in the Infomem so survives a reset/power off (but does not survive reprogramming):
   - Sampling rate
   - Which sensors are sampled
   - Accelerometer sensitivity
   - The state of the 5V regulator on the AnEx board
   - The power mux


The following commands are available:
   - INQUIRY_COMMAND
   - GET_SAMPLING_RATE_COMMAND
   - SET_SAMPLING_RATE_COMMAND
   - TOGGLE_LED_COMMAND
   - START_STREAMING_COMMAND
   - SET_SENSORS_COMMAND
   - SET_ACCEL_SENSITIVITY_COMMAND
   - GET_ACCEL_SENSITIVITY_COMMAND
   - SET_5V_REGULATOR_COMMAND
   - SET_PMUX_COMMAND
   - SET_CONFIG_SETUP_BYTE0_COMMAND
   - GET_CONFIG_SETUP_BYTE0_COMMAND
   - SET_ACCEL_CALIBRATION_COMMAND
   - GET_ACCEL_CALIBRATION_COMMAND
   - SET_GYRO_CALIBRATION_COMMAND
   - GET_GYRO_CALIBRATION_COMMAND
   - SET_MAG_CALIBRATION_COMMAND
   - GET_MAG_CALIBRATION_COMMAND
   - STOP_STREAMING_COMMAND


Config Setup Byte 0:
   - Bit 7: 5V regulator
   - Bit 6: PMUX
   - Bit 5: Not yet assigned
   - Bit 4: Not yet assigned
   - Bit 3: Not yet assigned
   - Bit 2: Not yet assigned
   - Bit 1: Not yet assigned
   - Bit 0: Not yet assigned
Config Setup Byte 1-4:
   - Not yet assigned


The format of the configuration data stored in Infomem is as follows:
   - 13 bytes starting from address 0
      Byte 0: Sampling rate
      Byte 1: Buffer Size
      Byte 2 - 11: Selected Sensors (Allows for up to 80 different sensors)
      Byte 12: Accel Sensitivity
      Byte 13 - 17: Config Bytes (Allows for 40 individual boolean settings)
      Byte 18 - 38: Accelerometers calibration values
      Byte 39 - 59: Gyroscopes calibration values
      Byte 60 - 80: Magnetometer calibration values


The assignment of the selected sensors field is a follows:
   - 1 bit per sensor. When there is a conflict priority is most significant bit -> least significant bit
      Byte2:
         Bit 7: Accel
         Bit 6: Gyro
         Bit 5: Magnetometer
         Bit 4: ECG
         Bit 3: EMG
         Bit 2: GSR
         Bit 1: AnEx ADC Channel 7
         Bit 0: AnEx ADC Channel 0
      Byte3
         Bit 7: Strain Gauge
         Bit 6: Heart Rate
         Bit 5: Not yet assigned
         Bit 4: Not yet assigned
         Bit 3: Not yet assigned
         Bit 2: Not yet assigned
         Bit 1: Not yet assigned
         Bit 0: Not yet assigned
      Byte4 - Byte11
         Not yet assigned


TODO:
   - Support for dynamically changing GSR resistor values
   - Support for variable data buffer size
   - Real world time stamps
      - and command to initialise


Changelog:
- 10 Jan 2011
   - initial release
   - support for Accelerometer, Gyroscope, Magnetometer, ECG, EMG, AnEx sensors
   - Sampling rate, Accel sensitivity, 5V regulater and PMUX (volatage monitoring) configurable
   - save configuration to InfoMem
- 29 Mar 2011
   - support for Strain Gauge and Heart Rate sensors
   - fixed EMG problem
      - a second EMG channel was being added erroneously
   - support for transmitting 8-bit data channels instead of just 16-bit 
- 21 Apr 2011
   - Fixed bug in heart rate support
   - Fixed bug in timestamping
   - changed SampleTimer to an Alarm
- 4 May 2011
   - removed a lot of unnecessary atomic commands
   - added support for writing and reading accel, gyro and mag calibration data
