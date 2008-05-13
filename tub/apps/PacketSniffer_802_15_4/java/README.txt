The java application Sniff802154Control opens a connection to a SerialForwarder and tries to read commands from the named pipe "sniffControlPipeIn" in the same directory and sends the proper command messages to the mote. Currently only channel switching is supported (via "setChannel X" where X is the channel number). The transmission attempt and response from the mote of a command frame is written to standard output.

-= Quick-Intro =-

-Start your favorite SerialForwarder connected to a node running Sniff802154.

-Just start the java app with:
	./control_sniff.sh &
	
-Start wireshark:
	sudo wireshark

-Sniff for the traffic between SerialForwarder and the java application
	try sniffing the local interface 127.0.0.1 using a capture filter "tcp port XXXX", where XXXX is the listening port of the SerialForwarder (default 9002).

-You can directly set the channel the mote is listening on via the preference pane for the cc2420 protocol in wireshark

If you want to change the channel the node is listening on manually just type:
	echo "setChannel X" > sniffControlPipeIn
where X is the channel you want to listen on.
	
