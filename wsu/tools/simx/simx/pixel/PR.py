#! /usr/bin/python
#! /usr/bin/python

import sys,os
from PIL import Image
import ImageDraw

size = 512,512
mode = 'P'
out = Image.new(mode, size, 255)
ipixel = Image.new(mode, size, 255).load()

FILENUM = 16


row = 0
col = 0

for l in xrange(FILENUM):
	x=0
	y=0
	if(os.path.exists(str(l))):
		FILE = open(str(l),"r")
		for line in FILE.readlines():
			x=int(line)
			v=x/1000000		
			Y=(x-v*1000000)/1000
			X=x%1000
		
			#print X,Y,v
			ipixel[X,Y]=v
		FILE.close()



    
def new_point():
	opixel = out.load()
	for y in xrange(512):
		for x in xrange(512):
			opixel[x, y] = ipixel[x, y]
	return out


new_point()
out.show()
