#! /usr/bin/python

import sys,os
from PIL import Image
import ImageDraw

im = Image.open("airforce.gif")
width,height = im.size
print im.format, im.size, im.mode, width, height

NUM =4 
wunit=(width/NUM)
hunit=(height/NUM)
#im.show()
box = (0,0,wunit,hunit)
im1 = im.crop(box)
	#im1.show();
if(1):
		for i in range(NUM):
			for j in range(NUM):
				box = (j*wunit,i*hunit,(j+1)*wunit,(i+1)*hunit)
				print box
				im1 = im.crop(box)
				pixel1 = im1.load()
				print pixel1[0,0]
	
				im1.thumbnail(im1.size,Image.ANTIALIAS)
				index = i*4 + j
		    		filename = str(index)
				FILE = open(filename,"w")
				out_str = ''
		  		for l in xrange(wunit):
			    		for k in xrange(hunit):
						X=l+j*wunit
						Y=k+i*hunit
						FILE.write(str(pixel1[l,k]*1000000+Y*1000+X)+'\n')#1000,000,000, x,y,value
						#FILE.write(str(pixel1[l,k])+" "+str(k*1000)+" "+str(l)+'\n')#1000,000,000, x,y,value
				FILE.write(str(-42)+'\n')
				FILE.close()
				im1.save(filename + ".gif", "gif")



