#!/usr/bin/python
"""
/**
* File: install.py
* Version: 1.0
* Description: mulle software installiation script
* 
* Author: Laurynas Riliskis
* E-mail: Laurynas.Riliskis@ltu.se
* Date:   March 6, 2009
*
* Copyright notice
*
* Copyright (c) Communication Networks, Lulea University of Technology.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* 1. Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
* 2. Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
* 3. All advertising materials mentioning features or use of this software
*    must display the following acknowledgement:
*	This product includes software developed by the Communication Networks
*   Group at Lulea University of Technology.
* 4. Neither the name of the University nor of the group may be used
*    to endorse or promote products derived from this software without
*    specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
* OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
*/
"""
import sys
import os

if sys.version < '2.4':
	print "Too old python version."
	print "Please install python 2.4"
	raise SystemExit

print "********************************"
print "Welcome to Mulle platfor set up!"
print "Copyright (c) Communication Networks, Lulea University of Technology."
print "All rights reserved. See README file"
print ""
path = {'TOSROOT':'','TOSDIR':''}
curent_dir=os.getcwd()
error_msg="Exiting due an error enviroment."
succ_msg="Installiation was complete successfully! Happy coding!"
exit_msg=""
links=['mulle','m16c62p','mulle.target']
platforms=['mulle']
chips=['m16c62p']
make=['m16c62p/','mulle.target']
chip_path='/chips/'
make_path='/support/make/'
plat_path='/platforms/'
try:
	for key in path.keys():
		print "Checking existance of",key
    		path[key] = os.environ[key]
		print "OK!"
	try:
		for p in platforms:
			src=curent_dir+'/tos'+plat_path+p+'/'
			dest=path['TOSDIR']+plat_path+p
			print "Creating symlink" ,src, dest
			os.symlink(src,dest)
			print "OK!"
		
		for c in chips:
			src=curent_dir+'/tos'+chip_path+c+'/'
			dest=path['TOSDIR']+chip_path+c
			print "Creating symlink" ,src, dest
			os.symlink(src,dest)
			print "OK!"

		for m in make:
			src=curent_dir+make_path+m
			dest=path['TOSROOT']+make_path+m.replace("/", "")
			print "Creating symlink" ,src, dest
			os.symlink(src,dest)
			print "OK!"

	except OSError,e:
		print "System error", e.errno, e.strerror
		raise SystemExit


	exit_msg=succ_msg
except KeyError:
	print "Can't find variable ", key
	exit_msg = error_msg
	raise SystemExit

finally:
	print exit_msg
	



	


