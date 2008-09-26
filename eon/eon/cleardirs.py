#!/usr/bin/python


import os;
import sys;


data = sys.stdin.readlines();

for l in data:
    reall = l[:len(l)-1];
    if os.path.isdir(reall) and reall.endswith('.svn'):
        dpath = "rm -rf "+reall;
        os.system(dpath);
        print dpath;

