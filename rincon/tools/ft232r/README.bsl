###########################################################################
/opt/svn/atlanta/tinyos-2.x-atlanta/tools/platforms/msp430/pybsl/README.bsl
###########################################################################

This directory contains the RRC version of tos-bsl. This
version supports:

  * The MSP430F2618 MCU

  * RRC's UMPH programmer (version 0.1)

Before using this BSL, you'll need to do the following:

1. Uninstall ALL existing FTDI drivers. Note that
   ALL of your FTDI devices will need to be redetected
   by the new drivers once you perform this step; i.e.,
   performing this step might degrade your productivity
   for a little while -- once started, it cannot be
   undone :-)

   Uninstallation can usually be achieved via the XP
   Add/Remove Programs dingus in the XP control panel.

2. Unpack the new FTDI driver zip from

     prereqs/FTDI-CDM 2.02.04 WHQL Certified.zip

   into C:\.

   This distro contains a combined VCP/D2XX driver.

3. Follow the installation instructions found in
   prereqs/FTDI_Windows_XP_Installation_Guide.pdf.

   Note that you'll want an FT232R-equipped device
   of some sort (dev kit or UMPH). You don't need
   to use it for anything -- you just need to plug
   it in so the drivers will get installed.

   An FT232BM device (tmote et al) won't work:
   after uninstalling, the device driver still exists
   in Windoze (sort of -- just enough to screw things
   up, as far as I can tell).

   Once you've installed an FT232R device, your
   FT232BM devices should install correctly (YMMV).

4. Start (re)plugging in all your devices, possibly changing
   COM port assignments to the values you desire (any
   values you had set under the old VCP or D2XX driver are,
   of course, [long] forgotten).

5. If you want to build for MSP430F2618 hardware, you'll
   need to install prereqs/mspgcc-20070216.exe into
   C:\mspgcc. After doing this, do a

	cd /cygdrive/c/mspgcc
	tar xfz /path/to/root/prereqs/mspgcc-f2618.tar.gz

   where /path/to/root/ is the location of this README.bsl
   file. This tarball adds stuff so you can compile for
   the 'F2618 (by telling gcc it's an 'FG4618, but that's
   a story for another day).

The tos-bsl binaries (in winexe/bin) have been checked
into our SVN repository. If you need to (re)build tos-bsl
from source, the instructions follow; otherwise, the TOS
build stuff for the msp430f2618 is already set up to use
the existing binaries.

If you upgrade from the FTDI 2.02.04 drivers, you might
need to rebuild tos-bsl, for example (see below). Keep in
mind that all team members might need to update drivers
simultaneously! In other words, updating tos-bsl isn't a
big deal; updating FTDI drivers is a much bigger deal.

########################################################################
### BUILDING TOS-BSL
###

1. Install the FTDI drivers as described above.

2. Run python-2.5.msi found in prereqs/. Make sure
   you install it to the default location C:\Python25\

   Unless you later change Python versions, you only
   need to do this once.

3. Run pywin32-210.win32-py2.5.exe found in prereqs/

   Unless you later change Python or win32all versions,
   you only need to do this once.

4. Run py2exe-0.6.6.win32-py2.5.exe found in prereqs/

   Unless you later change Python or py2exe versions,
   you only need to do this once.

5. If you've switched to newer FTDI drivers than the
   2.02.04 ones mentioned above, cd into ./d2xx/ and:

   a. Copy in ftd2xx.h from wherever you unpacked the
      new FTDI driver.
   b. Copy in ftd2xx.lib from i386/ under wherever you
      unpacked the new FTDI driver.
   c. Be sure and commit these changes to svn.
   d. Replace the FTDI driver distro in prereqs/ with
      the updated one you installed.
   e. Have everyone else update (uninstall+reinstall)
      their FTDI drivers and do an "svn update" once
      you're done testing your new tos-bsl.

   If you're using the drivers recommended above, and
   are fiddling with tos-bsl in some other way, just
   go straight to step 6.

6. Build the new tos-bsl:
     cd winexe
     make
     cd ..
   That's it -- it takes a minute or two to build.

   "Normal" errors you can safely ignore:
     ...
     The following modules appear to be missing
       ['FCNTL', 'TERMIOS']
     ...
     warning: sdist: missing required meta-data: url
     warning: sdist: missing meta-data: either (author and author_email) or
              (maintainer and maintainer_email) must be supplied
     error: file 'setup.py' does not exist

7. The new binaries will be under ./bin. Note that the
   TOS install makefiles use the tos-bsl in winexe/bin,
   so you'll need to move ./bin/* to winexe/bin to use
   your new bsl in TOS. Note that there's stuff in a
   bin/lib/ directory you'll need to move as well!

   You'll want to test your new tos-bsl first, of course :-)

   After moving them to winexe/bin, be sure and commit
   the changes to svn so folks get the new binaries (after
   installing new FTDI drivers, if appropriate).

### EOF README.bsl

