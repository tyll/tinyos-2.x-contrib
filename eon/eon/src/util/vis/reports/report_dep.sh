#!/usr/bin/bash


./makejpg.py gen

date > gen/lastgen.txt;
scp -r gen/* prisms.cs.umass.edu:./public_html/eon/reports/.
