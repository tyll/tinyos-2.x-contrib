README for TestRssiApp

Install it to as many telosb as you need with different TOS_NODE_ID
make telosb install,X bsl,/dev/ttyUSBX

Press user button and the node will start sending packect at a sample time (default 50 ms)
Connect other nodes to printf to receive the RSSI values
java PrintfClient -comm serial@/dev/ttyUSBX:telosb
Press user button again and the node will stop sending packects

