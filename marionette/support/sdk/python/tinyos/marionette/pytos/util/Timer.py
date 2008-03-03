#$Id$

# "Copyright (c) 2000-2003 The Regents of the University of California.  
# All rights reserved.
#
# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose, without fee, and without written agreement
# is hereby granted, provided that the above copyright notice, the following
# two paragraphs and the author appear in all copies of this software.
# 
# IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
# DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
# OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
# OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
# ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
# PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."

# @author Shawn Schaffert <sms@eecs.berkeley.edu>

import threading

class Timer( object ) :

  def __init__( self , callback=None , period=0 , numFiring=0 , waitTime=0 ) :
    self.period = period   #must be >= 0
    self.waitTime = waitTime  #must be >=0
    self.numFiring = numFiring  # 0 = forever, 1 = one-shot , 2+ = finite repeats
    self.callback = callback

  def __fireNext( self ) :
    if self.numFiring == 0 :
      self.timer = threading.Timer( self.period , self.__callback ).start()
    elif self.remainingFirings == 0 :
      self.timer = None
    else :
      self.timer = threading.Timer( self.period , self.__callback ).start()
      self.remainingFirings -= 1

  def __callback( self ) :
    if self.stopTimer :
      self.timer = None
    else :
      self.__fireNext()
      if self.callback:
        self.callback()

  def __waitOver( self ) :
    self.__fireNext()

  def start( self ) :
    self.timer = None
    self.remainingFirings = self.numFiring
    self.stopTimer = False
    if self.waitTime > 0 :
      self.timer = threading.Timer( self.waitTime , self.__waitOver ).start()
    else :
      self.__fireNext()

  def cancel( self ) :
    self.stopTimer = True
