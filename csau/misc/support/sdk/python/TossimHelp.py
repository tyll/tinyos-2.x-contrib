"""
/*
 * Copyright (c) 2008-2010 Aarhus University
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of Aarhus University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL AARHUS
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   October 12 2008
 */
"""

def loadLinkModel(t, file):
    #print "Loading link model from " + file + "... "
    r = t.radio()
    f = open(file, "r")
    nodes = []
    lines = f.readlines()
    for line in lines:
        s = line.split("\t")
        if (len(s) > 0):
            if s[0] =="gain":
                #print " ", s[1], " ", s[2], " ", s[3];
                r.add(int(s[1]), int(s[2]), float(s[3]))
            if s[0]=="noise":
                #print " ", s[1], " ", s[2], " ", s[3];
                r.setNoise(int(s[1]), float(s[2]), float(s[3]))
                nodes.append(int(s[1]))
            #if int(s[1])>nodecount:
                #nodecount = int(s[1])
    return nodes

def loadNoiseModel(t, file, nodes):
    #print "Loading noise model from " + file + "... "
    noise = open(file, "r")
    lines = noise.readlines()
    for line in lines:
        str = line.strip()
        if (str != ""):
            val = int(str)
            for i in nodes:
                t.getNode(i).addNoiseTraceReading(val)

    for i in nodes:
      #print "Creating noise model for ",i;
      t.getNode(i).createNoiseModel()

def initializeNodes(t, nodes):
    #print "Initializing nodes..."
    for i in nodes:
      #print "nr: ", i
      #t.getNode(i).bootAtTime((31 + t.ticksPerSecond() / 10) * i + 1);
      t.getNode(i).bootAtTime((31 + t.ticksPerSecond() / 10) + 1);
      
