XMonitor
@author Xiaogang Yang
@date June 10th, 2009
XMonitor is the advanced version of oasis monitor. It is independent from tinyos and operating system. Which currently support TCP connection to serial forwarder for receiving any data based on the configure xml file 
    *  run make
    * put your xml file under this directory, we hava offered four example xml file: dxmstream_data.xml, octopus.xml, mviz.xml,mviz-raw.xml
          o dxmstream_data.xml : oasisapp
          o octopus.xml: Octopus
          o mviz.xml: MViz
          o mviz-raw.xml: another version of mviz.xml, but remove any information of message struct, to show how it work if there is no message structure has been defined. 

* run command: . monitor-sf [HOST] [PORT] [XML_FILE_PATH] [big/smalle]
(makesure you have run the serialforwarder :

command java net.tinyos.sf.SerialForwarder -comm serial@[PORT]:[MOTETYPE]
		java net.tinyos.sf.SerialForwarder -comm sf@[IP]:[PORT]	
)

    *
          o big: BIG ENDIAN(dxmstream_data.xml)
          o small: small ENDIAN(octopus.xml,mviz.xml, mviz-raw.xml)
          o example: monitor-sf localhost 9003 mviz.xml small 
