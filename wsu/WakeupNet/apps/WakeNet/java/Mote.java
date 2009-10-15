// $Id$

/*									tab:4
 * Copyright (c) 2007 University College Dublin.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice and the following
 * two paragraphs appear in all copies of this software.
 *
 * IN NO EVENT SHALL UNIVERSITY COLLEGE DUBLIN BE LIABLE TO ANY
 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF 
 * UNIVERSITY COLLEGE DUBLIN HAS BEEN ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * UNIVERSITY COLLEGE DUBLIN SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND UNIVERSITY COLLEGE DUBLIN HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS.
 *
 * Authors:	Raja Jurdak, Antonio Ruzzelli, and Samuel Boivineau
 * Date created: 2007/09/07
 *
 */

/**
 * @author Raja Jurdak, Antonio Ruzzelli, and Samuel Boivineau
 */


import java.util.Date;
import java.io.*;


/*
	This class is a representation of a mote, based
	on the packets received from this mote.
	
	TODO :
			battery support
	BUG :
*/

public class Mote {
	private int moteId;
	private int x, y;
	private int count,  hops;

	//xg 20090413 reading->array
	//private int reading;
	private int[] reading;
	private int[] lastReadLight;
	private int[] lastReadTemperature;
	private int[] lastReadAcc;
	private int[] lastReadHumidity;
	private int[] lastReadDemo;
	private int[] lastReadAdc;
	private int[] lastReadBattery;

	double[] a;
	double[] b;
	double energyRes=0;
	double totalEnergy=0;
	double batteryRead=0;
	double energyTime=0;
	int lastEnergy = 0;
	int currentEnergy = 0;
	double accX=0,accY=0,accZ=0;
	double adc=0;
	double distance = 0;


	private int parentId;
	private int quality; 		// quality of the route to its parent
	private long lastTimeSeen; 	// last time a message was emitted by the mote
	private int battery;
	private boolean sleeping;
	private boolean modeAuto;
	
	//xg 20090413 active status
	private boolean active;
	
	private int samplingPeriod, threshold, sleepDutyCycle, awakeDutyCycle;
	
	/*
		The constructor lets the user create a new mote by using the fields
		of an automatic message.
	*/
	
	public Mote(int moteId, int count, int[] reading, int reply,
				int parentId, int quality, long lastTimeSeen) {
		this.moteId = moteId;
		this.hops = hops;
		this.x = (int)(Math.random() * Util.X_MAX);
		this.y = (int)(Math.random() * Util.Y_MAX);
		this.count = count;

		a = new double[30];
		b = new double[30];
		try{
			FileReader fr = new FileReader("iCount.txt");
			BufferedReader br = new BufferedReader(fr);
			String para;
			try{
				for(int i=0;i<20;i++)
				{
					br.readLine();
					para = br.readLine();
					a[i] = Double.valueOf(para);
					para = br.readLine();
					b[i] = Double.valueOf(para);
					br.readLine();
				}
				fr.close();
				br.close();
			}catch(IOException e) {System.out.println("Read Lines \n");} 
		}catch(FileNotFoundException e) { System.out.println("iCount.txt read\n");}
		//Xg 20090412 set different type data
		//this.reading = reading;
		set_reading(reading);

		if(reply == Constants.READING_TEMPERATURE)set_readTemperature(reading);
		if(reply == Constants.READING_HUMIDITY)set_readHumidity(reading);
		if(reply == Constants.READING_ACC)set_readAcc(reading);
		if(reply == Constants.READING_LIGHT)set_readLight(reading);
		if(reply == Constants.READING_ENERGY)set_readDemo(reading);
		if(reply == Constants.READING_ADC)set_readAdc(reading);
		if(reply == Constants.READING_BATTERY)set_readBattery(reading);

		this.parentId = parentId;
		this.quality = quality;
		this.lastTimeSeen = lastTimeSeen;
		this.battery = Util.UNKNOWN;
		setAwake();
		if(Constants.DEFAULT_MODE == Constants.MODE_AUTO)
			setModeAuto();
		else
			setModeQuery();
		this.samplingPeriod = Constants.DEFAULT_SAMPLING_PERIOD;
		this.threshold = Constants.DEFAULT_THRESHOLD;
		this.sleepDutyCycle = Constants.DEFAULT_SLEEP_DUTY_CYCLE;
		this.awakeDutyCycle = Constants.DEFAULT_AWAKE_DUTY_CYCLE;
	}

	public boolean isGateway() {
		if(moteId == 0)
			return true;
		else
			return false;
	}
	public int getMoteId() { return moteId;}


	public int getX() { return x;}
	public int getY() { return y;}
	public void setX(int x) { this.x = x;}
	public void setY(int y) { this.y = y;}

	public void setCount(int count) { this.count = count;}
	public int getCount() { return count;}
	//public void setReading(int reading) { this.reading = reading;}
	//public int getReading() { return reading;}
	/**
	 * Return the entire array 'reading' as a int[]
	 */
	public int[] get_reading() { return reading;}

	/**
	 * Set the contents of the array 'reading' from the given int[]
	 */
	public void set_reading(int[] value) {
		if(reading == null || reading.length < value.length)
			reading = new int[value.length];
		for (int index0 = 0; index0 < value.length; index0++)
			reading[index0]=value[index0];
	}

	/**
	 * Return the entire array 'reading' as a int[]
	 */
	public int[] get_reading(short channel)  { 

		if(channel == Constants.READING_TEMPERATURE)return get_readTemperature();
		if(channel == Constants.READING_HUMIDITY)return get_readHumidity();
		if(channel == Constants.READING_ACC)return get_readAcc();
		if(channel == Constants.READING_LIGHT)return get_readLight();
		if(channel == Constants.READING_ENERGY)return get_readDemo();
		if(channel == Constants.READING_ADC)return get_readAdc();
		if(channel == Constants.READING_BATTERY)return get_readBattery();
		return null;
	}

	/**
	 * Set the contents of the array 'reading' from the given int[]
	 */
	public void set_reading(short channel,int[] value) {
		if(channel == Constants.READING_TEMPERATURE)set_readTemperature(value);
		if(channel == Constants.READING_HUMIDITY)set_readHumidity(value);
		if(channel == Constants.READING_ACC)set_readAcc(value);
		if(channel == Constants.READING_LIGHT)set_readLight(value);
		if(channel == Constants.READING_ENERGY)set_readDemo(value);
		if(channel == Constants.READING_ADC)set_readAdc(value);
		if(channel == Constants.READING_BATTERY)set_readBattery(value);
	}


	/**
	* Return the entire array 'reading' as a int[]
	*/
	public int[] get_readLight() { return lastReadLight;}

	/**
	* Set the contents of the array 'reading' from the given int[]
	*/
	public void set_readLight(int[] value) {
		if(lastReadLight == null || lastReadLight.length < value.length)
			lastReadLight = new int[value.length];
		for (int index0 = 0; index0 < value.length; index0++)
		    lastReadLight[index0]=value[index0];
	}
	
	public int[] get_readTemperature() { return lastReadTemperature;}

	/**
	* Set the contents of the array 'reading' from the given int[]
	*/
	public void set_readTemperature(int[] value) {
		if(lastReadTemperature == null || reading.length < value.length)
			lastReadTemperature = new int[value.length];
		for (int index0 = 0; index0 < value.length; index0++)
			lastReadTemperature[index0]=value[index0];

	}
	public int[] get_readAcc() { return lastReadAcc;}

	/**
	* Set the contents of the array 'reading' from the given int[]
	*/
	public void set_readAcc(int[] value) {
		if(lastReadAcc == null || reading.length < value.length)
			lastReadAcc = new int[value.length];
		for (int index0 = 0; index0 < value.length; index0++)
		    lastReadAcc[index0]=value[index0];

		accX = get_readAcc()[0] & 0x3FF;
		accY = get_readAcc()[1] & 0x3FF;
		accZ = get_readAcc()[2] & 0x3FF;
		accX = accX * 0.001953125;
		accY = accY * 0.001953125;
		accZ = accZ * 0.001953125;
	}
	public int[] get_readHumidity() { return lastReadHumidity;}

	/**
	* Set the contents of the array 'reading' from the given int[]
	*/
	public void set_readHumidity(int[] value) {
		if(lastReadHumidity == null || reading.length < value.length)
			lastReadHumidity = new int[value.length];
		for (int index0 = 0; index0 < value.length; index0++)
		    lastReadHumidity[index0]=value[index0];
	}
	public int[] get_readDemo() { return lastReadDemo;}


	/**
	* Set the contents of the array 'reading' from the given int[]
	*/
	public void set_readDemo(int[] value) {
		if(lastReadDemo == null || reading.length < value.length)
			lastReadDemo = new int[value.length];
		for (int index0 = 0; index0 < value.length; index0++)
		    lastReadDemo[index0]=value[index0];


		double icountFre=0;
		energyTime = get_readDemo()[2]/100.0;
		if(energyTime < 1)
			return;

		currentEnergy = get_readDemo()[0]+(get_readDemo()[1]<<16) ;
		/*
		if(lastEnergy == 0){
			lastEnergy = get_readDemo()[0]+(get_readDemo()[1]<<16);
			currentEnergy = lastEnergy;
		}
		else{	
			currentEnergy = get_readDemo()[0]+(get_readDemo()[1]<<16) - lastEnergy;
			lastEnergy = get_readDemo()[0]+(get_readDemo()[1]<<16);
		}
		
		if(currentEnergy < 0)
			currentEnergy += Math.pow(2,31);
		*/
		icountFre = (currentEnergy)/energyTime;
		if(get_readDemo()!=null){
			if(batteryRead < 0.3)
				batteryRead = 3.0;
			for(int i=0;i<20;i++)
			{
				if(batteryRead < 3.0 - i*0.1 + 0.05 && batteryRead > 3.0 - i*0.1 - 0.05){
					energyRes= Math.pow(10,(Math.log10(icountFre)-b[i])/a[i]);
					energyRes = energyRes;//* batteryRead;
					totalEnergy += energyRes;// * energyTime; 
					energyRes = energyRes ;// energyTime;
					if(getMoteId() == 1)
					System.out.println(currentEnergy + " " + energyTime + " " + energyRes + " " + get_readDemo()[0]+(get_readDemo()[1]<<16));
					break;
				}
			}
		}
		//		totalEnergy += energyRes;
	}
	public int[] get_readAdc() { return lastReadAdc;}

	/**
	 * Set the contents of the array 'reading' from the given int[]
	 */
	public void set_readAdc(int[] value) {
		if(lastReadAdc == null || reading.length < value.length)
			lastReadAdc = new int[value.length];
		for (int index0 = 0; index0 < value.length; index0++)
			lastReadAdc[index0]=value[index0];

		adc = get_readAdc()[0] / 4096.0;
		adc = adc * get_readAdc()[1] / 10;

		distance = adc / 0.0064;
	}

	public int[] get_readBattery() { return lastReadBattery;}
	/**
	 * Set the contents of the array 'reading' from the given int[]
	 */
	public void set_readBattery(int[] value) {
		if(lastReadBattery== null || reading.length < value.length)
			lastReadBattery= new int[value.length];
		for (int index0 = 0; index0 < value.length; index0++)
			lastReadBattery[index0]=value[index0];

		batteryRead = (get_readBattery()[0] + 25)/ 4096.0;
		batteryRead = batteryRead* get_readBattery()[1] / 10;
	}
	public boolean setActive(boolean _active){
		active = _active;
		return active;
	}
	public boolean isActive(){
		return active;
	}







	public void setHops(int hops) { this.hops = hops;}
		public int getHops() { return hops;}
		public void setParentId(int parentId) { this.parentId = parentId;}
		public int getParentId() { return parentId;}
		public void setQuality(int quality) { this.quality = quality;}
		public int getQuality() { return quality;}
		public void setLastTimeSeen(long lastTimeSeen) { this.lastTimeSeen = lastTimeSeen;}
		public long getLastTimeSeen() { return lastTimeSeen;}
		public long getTimeSinceLastTimeSeen() { 
			Date d = new Date();
				return d.getTime() - lastTimeSeen;
		}
	
		public void setBattery(int battery) { this.battery = battery;}
		public int getBattery() { return battery;}
		public void setSamplingPeriod(int samplingPeriod) { this.samplingPeriod = samplingPeriod;}
		public int getSamplingPeriod() { return samplingPeriod;}
		public void setThreshold(int threshold) { this.threshold = threshold;}
		public int getThreshold() { return threshold;}
		public void setSleepDutyCycle(int sleepDutyCycle) { this.sleepDutyCycle = sleepDutyCycle;}
		public int getSleepDutyCycle() { return sleepDutyCycle;}
		public void setAwakeDutyCycle(int awakeDutyCycle) { this.awakeDutyCycle = awakeDutyCycle;}
		public int getAwakeDutyCycle() { return awakeDutyCycle;}
		public boolean isSleeping() { return sleeping;}
		public void setSleeping() { this.sleeping = true;}
		public void setAwake() { this.sleeping = false;}
		public boolean isInModeAuto() { return modeAuto;}
		public void setModeAuto() { this.modeAuto = true;}
		public void setModeQuery() { this.modeAuto = false;}
}
