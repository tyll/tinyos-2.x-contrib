package oscope;

import java.util.*;
import java.awt.Color;
import java.awt.geom.Point2D;
import java.awt.Stroke;
import java.awt.BasicStroke;
import java.io.IOException;
import java.io.Writer;

public class DataChannel {
		static Color plotColors[];
		static int plotColorsUsed[];
		static int colorIndex = 0; 
		protected Channel channel;
		protected int type;
		protected boolean enable=false;
		Vector data;
		int maxLength ;
		Color plotColor=null;
		int selfColorIndex=-1;
		Stroke plotStroke;
		private double xLookupValue = 0;
    		private long startTimeCalculation = 0;
		private long startPCTime = 0;
		private boolean pcFirstMessage = true;

		private int colorNum=16;
		    static { 
		    	
			plotColors    = new Color[16];
			plotColorsUsed    = new int[16];
			/*
			plotColors[0] = Color.yellow;
			plotColors[1] = Color.red;
			plotColors[2] = Color.blue;
			plotColors[3] = Color.magenta;
			plotColors[4] = Color.orange;
			plotColors[5] = Color.yellow;
			plotColors[6] = Color.cyan;
			plotColors[7] = Color.pink;
			plotColors[8] = Color.red;
			plotColors[9] = Color.white;
			*/
			/*
			plotColors[0] = Color.yellow;
			plotColors[1] = Color.red;
			plotColors[2] = Color.blue;
			plotColors[3] = new Color(0,128,64);
			plotColors[4] = Color.orange;

			plotColors[5] = Color.gray;
			plotColors[6] = Color.cyan;
			plotColors[7] = Color.pink;
			plotColors[8] = Color.green;
			plotColors[9] = Color.white;

			plotColors[10] = Color.darkGray;

			plotColors[11] = Color.lightGray;
			plotColors[12] = new Color(128,0,255);
			plotColors[13] = new Color(255,128,192);
			plotColors[14] = new Color(64,128,128);
			plotColors[15] = new Color(128,128,0);
			*/
			/*plotColors[0] =  new Color(255,255,255);
			plotColors[1] =  new Color(255,0,0);
			plotColors[2] =  new Color(255,255,0);
			plotColors[3] =  new Color(128,255,0);
			plotColors[4] =  new Color(255,0,255);
			plotColors[5] =  new Color(0,255,255);
			plotColors[6] =  new Color(255,128,64);
			plotColors[7] =  new Color(128,0,255);
			plotColors[8] =  new Color(128,64,0);
			plotColors[9] =  new Color(128,0,64);
			plotColors[10] =  new Color(128,128,0);
			plotColors[11] =  new Color(64,128,128);
			plotColors[12] =  new Color(255, 249, 204);
			plotColors[13] =  new Color(64,0,128);
			plotColors[14] =  new Color(94, 0, 255);
			plotColors[15] =  new Color(192,192,192);
			*/
			plotColors[0] =  new Color(255,255,255);
			plotColors[1] =  new Color(255,0,0);
			plotColors[2] =  new Color(255,255,0);
			plotColors[3] =  new Color(128,255,0);
			plotColors[4] =  new Color(255,0,255);
			plotColors[5] =  new Color(0,255,255);
			plotColors[6] =  new Color(0xf78704);
			plotColors[7] =  new Color(128,0,255);
			plotColors[8] =  new Color(128,64,0);
			plotColors[9] =  new Color(128,0,64);
			plotColors[10] =  new Color(128,128,0);
			plotColors[11] =  new Color(64,128,128);
			plotColors[12] =  new Color(255, 249, 204);
			plotColors[13] =  new Color(255,128,128);
			plotColors[14] =  new Color(94, 0, 255);
			plotColors[15] =  new Color(0x827f82);
			
			plotColorsUsed[0] =  0;
			plotColorsUsed[1] =  0;
			plotColorsUsed[2] =  0;
			plotColorsUsed[3] = 0;
			plotColorsUsed[4] =  0;

			plotColorsUsed[5] =  0;
			plotColorsUsed[6] =  0;
			plotColorsUsed[7] = 0;
			plotColorsUsed[8] =  0;
			plotColorsUsed[9] =  0;
			plotColorsUsed[10] =  0;
			plotColorsUsed[11] = 0;
			plotColorsUsed[12] =  0;

			plotColorsUsed[13] =  0;
			plotColorsUsed[14] =  0;
			plotColorsUsed[15] = 0;

		    }


	
		public DataChannel(Channel channel){
			this.channel = channel;
			
			data = new Vector(); 
			maxLength = Channel.MAX_NUM_POINTS;
			plotStroke = new BasicStroke(2.0f);
			
			
			/*synchronized(DataChannel.class) { 
			  
				for(int i =0;i<colorNum;i++){
					if(plotColorsUsed[i] <= 0){
						plotColor = plotColors[i];
						plotColorsUsed[i] ++;
						return;
					}
				}
				plotColor = plotColors[colorIndex];
				plotColorsUsed[colorIndex] ++;
				colorIndex = (colorIndex + 1) % colorNum; 
				return;
				
			}
			*/
		}

		public long getStartPCTime(){
			return this.startPCTime;
		}

    		public void setStartPCTime(long time){
			this.startPCTime = time;
	       }

		public boolean getPCFirstMessage(){
			return this.pcFirstMessage;
		}

    		public void setPCFirstMessage(boolean isFirstMsg){
			this.pcFirstMessage = isFirstMsg;
	       }


		public void setType(int type){
			this.type = type;
		}

		public void setEnable(boolean enable){
			this.enable = enable;
			synchronized(DataChannel.class) { 
			if(enable == true){
					if(selfColorIndex==-1){
					for(int i =0;i<colorNum;i++){
						
						if(plotColorsUsed[i] == 0){
						
							plotColor = plotColors[i];
							selfColorIndex=i;
							plotColorsUsed[i]++;
							//System.out.println("enable"+selfColorIndex+plotColorsUsed[i]+" "+this.enable);
							
							return;
						}
					}
					
					plotColor = plotColors[colorIndex];
					selfColorIndex=colorIndex;
					plotColorsUsed[colorIndex]++;
					colorIndex = (colorIndex + 1) % colorNum; 
					//Random r = new Rand
					
					//plotColor = new Color(new Random().nextInt()%255,new Random().nextInt()%255,new Random().nextInt()%255 );
					//selfColorIndex=-2;
					return;
				}
				
			}
			else{
				if(selfColorIndex!=-1){
					if(selfColorIndex!=-2){
					plotColorsUsed[selfColorIndex]--;
					//System.out.println("disable"+selfColorIndex+" "+plotColorsUsed[selfColorIndex]+" "+this.enable);
					}
					selfColorIndex=-1;
					
					return;
				
				}
			
			
			
			}
			
			
			}
			
			
		}

		public int getType(){
			return this.type;
		}

		public boolean getEnable(){
			return this.enable;
		}

		public Vector getData(){
			return data;
		}

		  public Color getPlotColor() {
		  	//System.out.println("get color");
			return plotColor;
		    }


		    public void setPlotColor(Color newPlotColor) {
			this.plotColor = newPlotColor;
		    }


		    public Stroke getPlotStroke() {
				return plotStroke;
			}


		public void setPlotStroke(Stroke newPlotStroke) {
			this.plotStroke = newPlotStroke;
		    }

		  public double getXLookupValue(){
				return xLookupValue;
		    }

		    public void setXLookupValue(double _xLookupValue){
				xLookupValue = _xLookupValue;
		    }

		    public long getstartTimeCalculation(){
				return startTimeCalculation;
		    }

		    public void setstartTimeCalculation(long _startTimeCalculation){
				startTimeCalculation = _startTimeCalculation;
		    }
	
		public synchronized void trim() { 
			
			if (data.size() > maxLength) {
				//System.out.println(maxLength + " " +data.size()  );
			    Vector tmp = new Vector(maxLength/10*6);
			    for (int i = data.size()-(maxLength/10*6); i < data.size(); i++) { 
				tmp.add(data.get(i));
			    }
			    data = tmp;
		}
	
  		}
		 
   		 public synchronized void clear() {
			data.clear();
  		  }

   		 public synchronized void addPoint(Point2D val, GraphPanel graphPanel, boolean ismaster) { 


				if (val == null) 
				    return;
				
				if (ismaster) {
				   int graphPanelSize = (graphPanel.getEnd()-graphPanel.getStart());
					/*if(graphPanel.isSliding() && 
					   ((val.getX() > (graphPanel.getEnd() -graphPanelSize/10)) || (val.getX() < graphPanel.getStart()))) {
						int diff = graphPanel.getEnd() - graphPanel.getStart();
						int end = (int)val.getX() + graphPanelSize/10;
						int start = end - diff;
						graphPanel.setXBounds(start, end);
					}*/
					if(graphPanel.isSliding()) { 
					   if((val.getX() > (graphPanel.getEnd() -graphPanelSize/10)) ) {
							int diff = graphPanel.getEnd() - graphPanel.getStart();
							int end = (int)val.getX() + graphPanelSize/10;
							int start = end - diff;
							graphPanel.setXBounds(start, end);
						}
						else if(val.getX() < graphPanel.getStart()){
							/*
							int diff = graphPanel.getEnd() - graphPanel.getStart();
							int start = (int)val.getX() ;
							graphPanel.setXBounds(start, end);
							*/
						}
					}

				}

				data.add(val);
				trim();
		}


			    public synchronized void saveData(Writer dataOut) throws IOException {
					/*
				if (data.size() > 0) {
				    dataOut.write("# BEGIN CHANNEL DATA: "+ data.size() +" SAMPLES\n");
				    dataOut.write("# "+getDataLegend()+"\n");
				    for(int n=0;n<data.size();n++ ) {
					Point2D sample;
					sample = (Point2D) data.get(n);
					if (sample != null) {
					    dataOut.write(""+sample.getX() +" " + sample.getY());
					    dataOut.write( "\n" );
					}
				    }
				}*/
			    }

			public Point2D findNearestX(Point2D test) { 
				try {
				    double xval = Math.round(test.getX());
				    for (int i = 0; i < data.size(); i++) {
					Point2D pt = (Point2D)data.get(i);
					if (pt == null) continue;
					if (Math.round(pt.getX()) == xval) { return pt; }
				    }
				    return null;
				} catch (Exception e) {
				    return null;
				}
			  }
			
	}
