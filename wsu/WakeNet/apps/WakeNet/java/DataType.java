public class DataType{

	int[] reading;
	public DataType(int[] value){
		if(reading == null || reading.length < value.length)
			reading = new int[value.length];
		for (int index0 = 0; index0 < value.length; index0++)
		    reading[index0]=value[index0];
	}
	public DataType(DataType value){
		if(reading == null || reading.length < value.get_reading().length)
			reading = new int[value.get_reading().length];
		for (int index0 = 0; index0 < value.get_reading().length; index0++)
		    reading[index0]=value.get_reading()[index0];
	}
	public int[] get_reading() { return reading;}
	public void set_reading(int[] value) {
	 if(reading == null || reading.length < value.length)
			reading = new int[value.length];
		for (int index0 = 0; index0 < value.length; index0++)
		    reading[index0]=value[index0];
	}
	public int get_value(){
		if(reading!=null)
			return reading[0];
		return 0;
	}


}
/*
class ChannelType {
	public int moteId; 
	public short channel;
	public ChannelType(int moteId, short Channel) {
		this.moteId = moteId;
		this.channel = channel;
	}
	
	
	
}
*/
