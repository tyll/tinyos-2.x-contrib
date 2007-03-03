/**************************************************************************
    RSSI Sampling Program created by HyungJune Lee (abbado@stanford.edu)
 **************************************************************************/

Development Environment: TinyOS 2.x T2 release, TelosB


How to Use


1) Setting Sampling Frequency

This program uses asynchronous timer, Alarm32Khz.
If you want to sample every 1ms, set ALARM_PERIOD in NoiseSample.h to 32.
Or for 5ms, ALARM_PERIOD should be 160(=32*5).
Do not use multiplication or division operator inside enum.
The minimum sampling frequency to be supported is 1.33KHz (ALARM_PERIOD 24).


2) Setting the total number of samples you would like to take

In NoiseSample.h, set TOTAL_SIZE to the trace length you want to take,
but make sure that TOTAL_SIZE should be a multiple of 512, i.e. 512, 1024,
1536, or 512*n upto 1024*1024.
In addition, the same number should be set in volumes-stm25p.xml.
TelosB uses STM25p flash memory chip which has the maximum 1MB capacity.
Therefore, the maximum size is 1048576 bytes (1024*1024 bytes).
Of course, regarding this, do not use multiplication or division operator 
inside enum.
Just designate a specific number you want.


3) Running the java program to collect the sampled data in 'Noise.txt' file

java TestSerial -comm serial@COMx:telosb
(x is the port number you are using.)


4) Setting 802.15.4 channel to use

The default channel in T2 release is 26. If you want to change the operating
channel to 11 for node 1, you can set it in compile time as follows.

make telosb CFLAGS=-DCC2420_DEF_CHANNEL=11 install,1


Do not distribute these codes without permission.

/**************************************************************************/

