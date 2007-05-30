The java application Sniffer802154 opens a connection to a SerialForwarder and shows the received raw packets on standard output. Furthermore it tries to read commands from the named pipe "sniffControlPipeIn" in the same directory and sends the proper command messages to the mote. Currently only channel switching is supported (via "setChannel X" where X is the channel number). The transmission attempt and response from the mote of a command frame is written to standard output.

-= Quick-Intro =-

Start your favorite SerialForwarder connected to a node running Sniff802154 (see ../t2SnifferApp/)

Just start the java app with
	./startsniff.sh > dump.txt &
	
Start wireshark 
	sudo wireshark
(sniff for the traffic between SerialForwarder and java application)

You can directly set the channel the mote is listening on via the preference pane for the cc2420 in wireshark (of course you should have build and installed the plugins in ../wiresharkPlugins/* before).

If you want to change the channel the node is listening on manually just type:
	echo "setChannel X" > sniffControlPipeIn
where X is the channel you want to listen on.
	
