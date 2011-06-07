package gui;


public class ArrayDelayAndFrameLoss {
	
	private long array[] = null;
	
	public ArrayDelayAndFrameLoss(){
		
		array = new long[30];
				
	}

	synchronized public long getArray(int pos) {
		if(pos==30) pos=0;
		return this.array[pos];
	}

	synchronized public void setArray(long rxTime, int pos) {
		if(pos==30) pos=0;
		this.array[pos] = rxTime;
	}
	
}
