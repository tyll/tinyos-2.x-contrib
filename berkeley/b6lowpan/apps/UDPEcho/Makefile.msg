
msg:	
	mig -DMIG -I$(LOWPAN_ROOT)/tos/lib/net/b6lowpan -I$(LOWPAN_ROOT)/support/sdk/c/lib6lowpan  python -python-classname=UdpReport UDPReport.h udp_report -o UdpReport.py
