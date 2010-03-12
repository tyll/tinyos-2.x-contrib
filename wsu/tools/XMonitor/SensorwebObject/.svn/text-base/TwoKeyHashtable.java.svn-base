
package SensorwebObject;

import java.io.Serializable;
import java.util.*;


public class TwoKeyHashtable extends Hashtable implements Serializable
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
    public class Tuple implements Serializable{
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
            if (((t.keyA.equals(keyA)) && (t.keyB.equals(keyB))))
            	return true;

            return false;
        }
        
        public int hashCode()//this is essential so that Tuple(KeyA, KeyB)=Tuple(KeyB, KeyA)
        {
        	return keyA.hashCode() + keyB.hashCode();
        }
        
    }
}
