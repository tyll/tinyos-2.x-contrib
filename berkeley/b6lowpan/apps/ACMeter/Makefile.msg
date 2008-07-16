
msg:	
	mig -DMIG -I$(LOWPAN_ROOT)/tos/lib/net/b6lowpan -I$(LOWPAN_ROOT)/support/sdk/c/lib6lowpan  python -python-classname=AcReport ACReport.h ac_report -o ACReport.py
