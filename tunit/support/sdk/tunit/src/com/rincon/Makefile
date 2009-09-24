# Top-level Makefile for tools/java 

# We do all subdirectories (to allow for optional package installation)
SUBDIRS = $(shell find . -maxdepth 1 -type d | tail -n +2 | grep -v /CVS)

ROOT = ../..
include $(ROOT)/Makefile.include
