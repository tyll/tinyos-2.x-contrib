This directory contains patches for the configure/make system against wireshark-1.0.0.

Apply from within the vanilla wireshark source directory using:

find PATH_TO_THESE_PATCHES -maxdepth 1 -name "*.patch" | xargs -i patch -p1 -i{}

