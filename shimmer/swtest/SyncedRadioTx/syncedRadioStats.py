/*
 * Copyright (c) 2012, Shimmer Research, Ltd.
 * All rights reserved
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:

 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of Shimmer Research, Ltd. nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author Mike Healy
 * @date   February, 2011
 */
#!/usr/bin/python
import sys, struct, array, time
try:
   import tos
except ImportError:
   import posix
   sys.path = [os.path.join(posix.environ['TOSROOT'], 'support', 'sdk', 'python')] + sys.path
   import tos


if len(sys.argv) < 2:
   print "no device specified"
   print "example:"
   print "   syncedRadioStats.py /dev/ttyUSB5"
else:
   try:
#      ser = tos.Serial(sys.argv[1], 115200, flush=True, debug=False)
      ser = tos.Serial(sys.argv[1], 115200)
      am = tos.AM(ser)
   except:
      print "ERROR: Unable to initialize serial port connection to", sys.argv[1]
      sys.exit(-1)

   AM_HOST_CONTROLLED_TIMING_MSG = 0x7F
   wpacket = tos.Packet([('msg', 'int', 1)]) #1 byte integer (i.e. uint8_t)   
   wpacket.msg = ord('s')
   am.write(wpacket, AM_HOST_CONTROLLED_TIMING_MSG)

   num_received = []
   senders_seen = []
   num_missed = []
   last_count = []
   packet_size = []
   sending_rate = []
   last_time_stamp = []
   num_lines = 0

   print "Node ID | Sending Rate | Packet size | Num received | Num missed | % missed | Current count"
   try:
      while True:
         packet = am.read(timeout=5)
         if packet:
            time_stamp = time.time()
            count = int(packet.data[1]) + (int(packet.data[0]<<8))
            if senders_seen.count(packet.source) == 0:
               senders_seen.append(packet.source)
               num_received.append(1)
               num_missed.append(0);
               last_count.append(count)
               packet_size.append(packet.data[2])
               sending_rate.append(0)
               last_time_stamp.append(time.time())
            else:
               # assuming 65535 messages haven't been missed
               temp_index = senders_seen.index(packet.source)
               if count < last_count[temp_index]:
                  if (count + 0xFFFF - last_count[temp_index]) != 1: #count starts at 1, not 0
                     num_missed[temp_index] += count+0xFFFE-last_count[temp_index]
               elif (count - last_count[temp_index]) != 1:
                  num_missed[temp_index] += count-last_count[temp_index]-1
               last_count[temp_index] = count;
               num_received[temp_index]+=1
               # cumulative average for receive frequency
               sending_rate[temp_index] = (((1/(time_stamp-last_time_stamp[temp_index]))+(num_received[temp_index]-1)*sending_rate[temp_index]))/num_received[temp_index]
               last_time_stamp[temp_index] = time_stamp
            print '\033[' + str(num_lines) + 'A'
            for i in range(len(senders_seen)):
               print "%7d |" % senders_seen[i],
               print "%10.3fHz |" % sending_rate[i],
               print "%5d bytes |" % packet_size[i],
               print "%12d |" % num_received[i],
               print "%10d |" % num_missed[i],
               print "%8.3f |" % ((float(num_missed[i])/(num_received[i]+num_missed[i]))*100),
               print "%13d" % last_count[i]
            num_lines = len(senders_seen) + 1
            sys.stdout.flush()

   except KeyboardInterrupt:
      wpacket.msg = ord('t')
      am.write(wpacket, AM_HOST_CONTROLLED_TIMING_MSG, timeout=5, blocking=False)
#     try a couple of times as sending might (quietly) fail 
      for i in range(4):   # arbitrary num times
         time.sleep(0.08) # arbitrary value
         am.write(wpacket, AM_HOST_CONTROLLED_TIMING_MSG, timeout=5, blocking=False)
      print
      print "All done"
