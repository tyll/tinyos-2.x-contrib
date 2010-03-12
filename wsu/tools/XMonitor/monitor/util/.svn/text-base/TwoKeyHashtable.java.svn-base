// $Id$

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */


/**
 * @author Wei Hong
 * @author Kamin Whitehouse <kamin@cs.berkeley.edu>
 */

//***********************************************************************
//***********************************************************************
//This hashtable is a normal java.util.hashtable
//but the overloaded functions take two keys instead of one.
//Basically, this class takes the two keys and wraps them in a Tuple object
//and uses that tuple as a key to a normal hashtable
//***********************************************************************
//***********************************************************************

package monitor.util;

import monitor.util.*;
import java.util.*;


public class TwoKeyHashtable extends Hashtable 
{
//	public static final int MAX_SIZE = 100;
	
    //returns the object indexed by the key pair
    public Object get(Object keyA, Object keyB) {
        return super.get(new Tuple(keyA, keyB));
    }


    // returns the previous value held by this object key pair (or null if none)
    public Object put(Object keyA, Object keyB, Object value) {
        return super.put(new Tuple(keyA, keyB), value);
    }

    // returns the previous value held by this object key pair (or null if none)
    public Object remove(Object keyA, Object keyB) {
        return super.remove(new Tuple(keyA, keyB));
    }

    // returns the previous value held by this object key pair (or null if none)
    public boolean containsKey(Object keyA, Object keyB) {
        return super.containsKey(new Tuple(keyA, keyB));
    }
	/*public void testThis()
	{
		Integer i1 = new Integer(1);
		Integer key1a = new Integer(3);
		Integer key1b = new Integer(5);
		Integer testKey1a = new Integer(3);
		Integer testKey1b = new Integer(5);
		Integer i2 = new Integer(2);
		Integer key2a = new Integer(4);
		Integer key2b = new Integer(6);
		Integer retrieved;
		
		Tuple key1 = new Tuple(key1a, key1b);	
		Tuple key2 = new Tuple(key2a, key2b);	
		Tuple testKey1 = new Tuple(key1a, key1b);	
		Tuple testKey2 = new Tuple(key1b, key1a);	
		Tuple testKey3 = new Tuple(testKey1a, testKey1b);	
		Tuple testKey4 = new Tuple(testKey1b, testKey1a);	

		this.put(key1, i1);
		this.put(key2, i2);
		
		int i;
		if(key1.equals(testKey1))
			i=1;
		if(key1.equals(testKey2))
			i=1;
		if(key1.equals(testKey3))
			i=1;
		if(key1.equals(testKey4))
			i=1;
		retrieved = (Integer)this.get(key1);
		retrieved = (Integer)this.get(key2);
		retrieved = (Integer)this.get(testKey1);
		retrieved = (Integer)this.get(testKey2);
		retrieved = (Integer)this.get(testKey3);
		retrieved = (Integer)this.get(testKey4);
	} */

    // a class that packages two elements as one
    public class Tuple {
        public Object keyA;
        public Object keyB;
        
        public Tuple(Object a, Object b) {
            keyA = a;
            keyB = b;
        }
        
        public boolean equals(Object obj) {
            //System.out.println("power of equaloity");
            if (!(obj instanceof Tuple)) return false;
            
            Tuple t = (Tuple)obj;
            if (((t.keyA.equals(keyA)) && (t.keyB.equals(keyB)))||
                ((t.keyA.equals(keyB)) && (t.keyB.equals(keyA)))) return true;

            return false;
        }
        
        public int hashCode()//this is essential so that Tuple(KeyA, KeyB)=Tuple(KeyB, KeyA)
        {
        	return keyA.hashCode() + keyB.hashCode();
        }
        
    }
}
