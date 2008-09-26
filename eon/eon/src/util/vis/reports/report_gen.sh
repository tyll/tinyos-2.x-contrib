#!/usr/bin/bash

echo "changing to directory $(dirname $0)"

cd $(dirname $0)

R --vanilla <gpsattempts.R;
R --vanilla <incoming.R;
R --vanilla <pktdelay.R;
R --vanilla <solar.R;
R --vanilla <tortoisearrival.R;
R --vanilla <tortoisedelay.R;

./makejpg.py gen

./report_dep.sh