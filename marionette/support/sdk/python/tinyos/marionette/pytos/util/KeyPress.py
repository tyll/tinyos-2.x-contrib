#!/usr/bin/env python

# $Id$

#                                                                      tab:2
#  "Copyright (c) 2000-2003 The Regents of the University  of California.  
#  All rights reserved.
#
#  Permission to use, copy, modify, and distribute this software and its
#  documentation for any purpose, without fee, and without written agreement is
#  hereby granted, provided that the above copyright notice, the following
#  two paragraphs and the author appear in all copies of this software.
#  
#  IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
#  DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
#  OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
#  CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#  
#  THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
#  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
#  AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
#  ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
#  PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
# 
#  Copyright (c) 2002-2003 Intel Corporation
#  All rights reserved.
# 
#  This file is distributed under the terms in the attached INTEL-LICENSE     
#  file. If you do not find these files, copies can be found by writing to
#  Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
#  94704.  Attention:  Intel License Inquiry.
#

# 
#  @author Shawn Schaffert
#


import os


if os.name == "posix" :

    import sys, select, termios

    class KeyPress:


        def __init__(self):
            self.f = sys.stdin
            self.oldAttr = termios.tcgetattr( self.f )

            # we need to adjust some parameters of the term
            # (1) do not echo
            # (2) turn off canonical mode input (ie, switch to non-canonical mode input)
            # so that input is not processed in line chunks
            # (3) set the VMIN (the min num of bytes needed before returning during a read) to 1
            # (4) set the VTIME (the inter-byte timer) to 0, so we do not delay
            newAttr = self.oldAttr[:]
            newAttr[3] = newAttr[3] & ~termios.ECHO & ~termios.ICANON
            newAttr[6][termios.VMIN] = 1
            newAttr[6][termios.VTIME] = 0
            termios.tcsetattr( self.f , termios.TCSANOW , newAttr )

        def destroy(self):
            termios.tcsetattr( self.f , termios.TCSANOW , self.oldAttr )

        def getChar( self , blocking = False ):
            if blocking :
                ready = select.select( [self.f] , [] , [] )
            else :
                ready = select.select( [self.f] , [] , [] , 0 )

            if ready[0] :
                ch = self.f.read(1)
            else:
                ch = ""
            return ch


        
elif os.name == "nt" :

    import msvcrt

    class KeyPress:

        def __init__( self ):
            pass

        def destroy( self ):
            pass

        def getChar( self , blocking = False ):
            if blocking :
                return msvcrt.getch()
            else :
                if msvcrt.kbhit() :
                    return msvcrt.getch()
                else:
                    return ""


else :
    raise OSError




if __name__=="__main__":
    import time

    kp = KeyPress()
    i = 0
    print "press \'q\' to quit"
    while kp.getChar() != "q" :
        i += 1
        print i
        time.sleep(.25)
    kp.destroy() 
