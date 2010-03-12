//$Id$

/**
 * Copyright (C) 2006 WSU All Rights Reserved
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE WASHINGTON STATE UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE WASHINGTON 
 * STATE UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE WASHINGTON STATE UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE WASHINGTON STATE UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */


/**
 * Function Description:
 *
 * A class that implemements Oscilloscope channel.  
 *
 * Original version by:
 *    @author moteiv.com
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */

package oscope;

import java.util.*;
import java.awt.Color;
import java.awt.geom.Point2D;
import java.awt.Stroke;
import java.io.IOException;
import java.io.Writer;

public class Channel  {
    static final int MAX_NUM_POINTS = 5000;
    static Hashtable availableType = new Hashtable();
    private Hashtable dataChannel= new Hashtable();


    int lastPoint; 

    String dataLegend;

    boolean active;

    GraphPanel graphPanel;

    int maxLength;
    boolean master;


    public long getStartPCTime(int type){
		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			return newChannel.getStartPCTime();
		}
		return 0;
    }

    public void setStartPCTime(long time, int type){
		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			newChannel.setStartPCTime(time);
		}
    }

  public boolean getPCFirstMessage(int type){
		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			return newChannel.getPCFirstMessage();
		}
		return false;
    }

    public void setPCFirstMessage(boolean isFirstMsg, int type){
		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			newChannel.setPCFirstMessage(isFirstMsg);
		}
    }
	
    public double getXLookupValue(int type){
		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			return newChannel.getXLookupValue();
		}
		return 0;
    }

    public void setXLookupValue(double _xLookupValue, int type){
		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			newChannel.setXLookupValue(_xLookupValue);
		}
    }

    public long getstartTimeCalculation(int type){
		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			return newChannel.getstartTimeCalculation();
		}
		return 0;
    }

    public void setstartTimeCalculation(long _startTimeCalculation, int type){
		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			newChannel.setstartTimeCalculation(_startTimeCalculation);
		}
    }

     public void addNewDataChannel(int type){
	 	
		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel == null){
			Integer typeSelected = (Integer)ControlPanel.checkTypeTable.get(new Integer(type));
			newChannel = new DataChannel(this);
			newChannel.setType(type);
      if (typeSelected != null) {
        if (typeSelected.intValue() == ControlPanel.TYPE_CHECK)
          newChannel.setEnable(true);
        else 
          newChannel.setEnable(false);
        dataChannel.put(new Integer(type), newChannel);
      }
		}
    }

    public Hashtable getDataChannel(){
		return this.dataChannel;
    }

      public boolean isTypeActive(int type) {  
	    DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel == null){
			return false;
		}
		else {
			return newChannel.getEnable();
		}
    }

    public void setTypeActive(int type, boolean enable) {
    		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel == null){
			newChannel = new DataChannel(this);
			newChannel.setType(type);
			newChannel.setEnable(enable);
			dataChannel.put(new Integer(type), newChannel);
		}
		else {
			newChannel.setType(type);
			newChannel.setEnable(enable);
		}
    }
	

    /**
     * Get the PlotStroke value.
     * @return the PlotStroke value.
     */
    public Stroke getPlotStroke(int type) {
    		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			return newChannel.getPlotStroke();
		}
		return null;

    }

    /**
     * Set the PlotStroke value.
     * @param newPlotStroke The new PlotStroke value.
     */
    public void setPlotStroke(Stroke newPlotStroke, int type) {
		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			newChannel.setPlotStroke(newPlotStroke);
		}
    }

    
    /**
     * Get the Master value.
     * @return the Master value.
     */
    public boolean isMaster() {
	return master;
    }

    /**
     * Set the Master value.
     * @param newMaster The new Master value.
     */
    public void setMaster(boolean newMaster) {
	this.master = newMaster;
    }
    
    /**
     * Get the LastPoint value.
     * @return the LastPoint value.
     */
    public int getLastPoint() {
	return lastPoint;
    }

    /**
     * Set the LastPoint value.
     * @param newLastPoint The new LastPoint value.
     */
    public void setLastPoint(int newLastPoint) {
	this.lastPoint = newLastPoint;
    }

    /**
     * Get the DataLegend value.
     * @return the DataLegend value.
     */
    public String getDataLegend() {
	return dataLegend;
    }

    /**
     * Set the DataLegend value.
     * @param newDataLegend The new DataLegend value.
     */
    public void setDataLegend(String newDataLegend) {
	this.dataLegend = newDataLegend;
    }
    
    /**
     * Get the Active value.
     * @return the Active value.
     */
    public boolean isActive() {
	return active;
    }

    /**
     * Set the Active value.
     * @param newActive The new Active value.
     */
    public void setActive(boolean newActive) {
	this.active = newActive;
    }

    /**
     * Get the PlotColor value.
     * @return the PlotColor value.
     */
    public Color getPlotColor(int type) {
     		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			return newChannel.getPlotColor();
		}
		return null;
    }

    /**
     * Set the PlotColor value.
     * @param newPlotColor The new PlotColor value.
     */
    public void setPlotColor(Color newPlotColor, int type) {
		DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			newChannel.setPlotColor(newPlotColor);
		}
    }

    /**
     * Get the Data value.
     * @return the Data value.
     */
    public Vector getData(int type) {
    		 DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel == null){
			return null;
		}
		else {
			return newChannel.getData();
		}
    }

    /**
     * Get the GraphPanel value.
     * @return the GraphPanel value.
     */
    public GraphPanel getGraphPanel() {
	return graphPanel;
    }

    /**
     * Set the GraphPanel value.
     * @param newGraphPanel The new GraphPanel value.
     */
    public void setGraphPanel(GraphPanel newGraphPanel) {
	this.graphPanel = newGraphPanel;
    }
    
    /**
     * Get the MaxLength value.
     * @return the MaxLength value.
     */
    public int getMaxLength() {
	return maxLength;
    }

    /**
     * Set the MaxLength value.
     * @param newMaxLength The new MaxLength value.
     */
    public void setMaxLength(int newMaxLength) {
	this.maxLength = newMaxLength;
    }

    /**
     * Create a channel.  The channel starts out without a legend, and in an
     * inactive state.  Its last point is -1. 
     */ 

    public Channel() { 
	dataLegend = "";
	active = false; 
	lastPoint = -1;
	maxLength = MAX_NUM_POINTS;
	master = false;
    } 
    
    public synchronized void trim(int type) { 

		 DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			newChannel.trim();
		}
    }

    public Point2D findNearestX(Point2D test, int type) { 
		 DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			return newChannel.findNearestX(test);
		}
		return null;
    }

    public synchronized void clear(int type) {
	 DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			newChannel.clear();
		}
    }

    public synchronized void addPoint(Point2D val, int type) { 
	 DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
		if (newChannel != null){
			newChannel.addPoint(val, this.graphPanel,isMaster());
		}
    }


    public synchronized void saveData(Writer dataOut , int type) throws IOException {
		 DataChannel newChannel = (DataChannel)dataChannel.get(new Integer(type));
				if (newChannel != null){
					newChannel.saveData(dataOut);
				}
    }
	
}
