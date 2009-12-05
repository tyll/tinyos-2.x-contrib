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
 * This class simulates the Display Panel of a Oscilloscope,
 * and respond to user's clicks on the display screen.
 *
 * Original version by:
 *    @author Jason Hill and Eric Heien
 * Modified by:
 *    @author Fenghua Yuan <yuan@vancouver.wsu.edu>
 */


package oscope;

import java.util.*;
import java.awt.*;
import java.applet.Applet;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;
import java.awt.geom.*;
import java.io.PrintWriter;
import java.io.FileOutputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import monitor.MainFrame;


public class GraphPanel extends JPanel implements MouseListener, 
			 MouseMotionListener, MouseWheelListener  
{	

	// If true, log data to a file called LOG_FILENAME
	//private static final boolean LOG = false;
	//private static final String LOG_FILENAME = "log";

	private static final double _DEFAULT_BOTTOM = 1024.0;
	private static final double _DEFAULT_TOP = 4096.0-1024.0;
	private static final int _DEFAULT_START = -100;
	private static final int _DEFAULT_END = 1000;
	private static final double X_AXIS_POSITION = 0.1;
	private static final double Y_AXIS_POSITION = 0.1;

	public static final int REPAINT = 100;
	public static final int POINTSONSCREEN = 100;
	public static final int INTERVAL = 10;

	private double DEFAULT_BOTTOM;
	private double DEFAULT_TOP;
	private int DEFAULT_START;
	private int DEFAULT_END;
	boolean sliding = true;
	boolean legendEnabled = true;
	boolean connectPoints = true;
	boolean valueTest = false;
	int valueX, valueY;
	Channel testChannel = null;
	boolean hexAxis = false;
	boolean yaxishex = false;

	public boolean isConnectPoints() {
		return connectPoints;
	} 

	public void setConnectPoints(boolean b) { 
		connectPoints = b;
		repaint(REPAINT); 
	}


	/**
	 * Get the type of ticks on the Y axis (hexadecimal or decimal).
	 * @return the HexAxis value.
	 */
	public boolean isHexAxis() {
		return hexAxis;
	}

	/**
	 * Set the display of the Y axis (hexadecimal or decimal)
	 * @param newHexAxis The new HexAxis value.
	 */
	public void setHexAxis(boolean newHexAxis) {
		this.hexAxis = newHexAxis;
		repaint(REPAINT);
	}

	public boolean isSliding() { 
		return sliding;
	} 

	public void setSliding(boolean _sliding) { 
		sliding = _sliding;
		repaint(REPAINT);
	}
	/**
	 * Get the LegendEnabled value.
	 * @return the LegendEnabled value.
	 */
	public boolean isLegendEnabled() {
		return legendEnabled;
	}

	/**
	 * Set the LegendEnabled value.
	 * @param newLegendEnabled The new LegendEnabled value.
	 */
	public void setLegendEnabled(boolean newLegendEnabled) {
		this.legendEnabled = newLegendEnabled;
		repaint(REPAINT);
	}

	String xLabel;

	/**
	 * Get the XLabel value.
	 * @return the XLabel value.
	 */
	public String getXLabel() {
		return xLabel;
	}

	/**
	 * Set the XLabel value.
	 * @param newXLabel The new XLabel value.
	 */
	public void setXLabel(String newXLabel) {
		this.xLabel = newXLabel;
	}

	String yLabel;

	/**
	 * Get the YLabel value.
	 * @return the YLabel value.
	 */
	public String getYLabel() {
		return yLabel;
	}

	/**
	 * Set the YLabel value.
	 * @param newYLabel The new YLabel value.
	 */
	public void setYLabel(String newYLabel) {
		this.yLabel = newYLabel;
	}




	//output stream for logging the data to.
	//PrintWriter log_os;

	double bottom, top;
	int start, end;
	//int maximum_x = 0, minimum_x = Integer.MAX_VALUE;
	int maximum_x = 0, minimum_x = 65535;
	Vector cutoff; 
	Point highlight_start, highlight_end;

	Vector channels;

	public GraphPanel() {
		this(_DEFAULT_START, _DEFAULT_BOTTOM, _DEFAULT_END, _DEFAULT_TOP);
	}

	public GraphPanel(int _start, double _bottom, int _end, double _top) { 
		super();
		setBackground(Color.white);
		addMouseListener(this);
		addMouseMotionListener(this);
		addMouseWheelListener(this);
		cutoff = new Vector();
		//create an array to hold the data sets.
		channels = new Vector();

		//try{
		//create a file for logging data to.
		// FileOutputStream f = new FileOutputStream(LOG_FILENAME);
		// log_os = new PrintWriter(f);
		//} catch (Exception e) {
		//  e.printStackTrace();
		//}

		DEFAULT_BOTTOM = _bottom;
		bottom = _bottom;
		DEFAULT_TOP = _top;
		top = _top;
		DEFAULT_START = _start;
		start = _start; 
		DEFAULT_END = _end;
		end = _end;
	}

	public int getEnd() { 
		return end;
	}

	public int getStart() {
		return start;
	}

	public void setXBounds(int _start, int _end) {

		if(_start >= _end || _start < 0 || _end > 3600000 )
			return;
		start = _start;
		end = _end;
	}

	public void setYBounds(double _bottom, double _top) {
		if(_bottom >= _top || _bottom < -1500000 || _top > 1500000 )
			return;
		bottom = _bottom;
		top = _top;
	}


	public void addChannel(Channel c) { 
		channels.add(c);
	}

	public void removeChannel(Channel c) {
		channels.remove(c);
	}

	public Vector getChannels() {
		return (Vector)channels.clone();// return a copy rather than the object
	}

	public int getNumChannels() { 
		return channels.size();
	}

	public Channel getChannel(int numChannel) { 
		return (Channel)channels.elementAt(numChannel); 
	}
	public void mouseEntered(MouseEvent e) {
	}

	public void mouseExited(MouseEvent e) {
	}

	/* Select a view rectangle. */
	public void mouseDragged(MouseEvent e) {
		Dimension d = getSize();

		if (valueTest) {
			/* Andy remove doubles
				 Point2D virt_drag = screenToVirtual(new Point2D.Double(e.getX(), e.getY()));
				 */
			Point2D virt_drag = screenToVirtual(new Point2D(e.getX(), e.getY()));
			Point2D dp = findNearestX(testChannel, virt_drag);
			if (dp != null) {
				valueX = (int)Math.round(dp.getX());
				valueY = (int)Math.round(dp.getY());
			}

		} else if (highlight_start != null) {
			highlight_end.x = e.getX();
			highlight_end.y = e.getY();
		}
		repaint(REPAINT);
		e.consume();
	}

	public void mouseMoved(MouseEvent e) {
	}

	public void mouseClicked(MouseEvent e) {
	}

	/* Set zoom to selected rectangle. */
	public void mouseReleased(MouseEvent e) {
		removeMouseMotionListener(this);
		if( highlight_start != null )
			set_zoom();
		valueTest = false;
		testChannel = null;
		highlight_start = null;
		highlight_end = null;
		e.consume();
		repaint(REPAINT);
	}

	public void mousePressed(MouseEvent e) {
		addMouseMotionListener(this);

		// Check to see if mouse clicked near plot
		Dimension d = getSize();
		double  xVal,yVal;
		/* Andy remove double
			 Point2D virt_click = screenToVirtual(new Point2D.Double(e.getX(), e.getY()));
			 */
		Point2D virt_click = screenToVirtual(new Point2D(e.getX(), e.getY()));
		for(Enumeration i = channels.elements(); i.hasMoreElements();) {
			Channel data = (Channel) i.nextElement();
			Point2D dp = findNearestX(data, virt_click);
			if (dp != null) {

				if (Math.abs(dp.getY() - virt_click.getY()) <= (top-bottom)/10) {
					valueTest = true;
					testChannel = data;
					valueX = (int)dp.getX();
					valueY = (int)dp.getY();
				}
			}
		}

		if (!valueTest) {
			highlight_start = new Point();
			highlight_end = new Point();
			highlight_start.x = e.getX();
			highlight_start.y = e.getY();
			highlight_end.x = e.getX();
			highlight_end.y = e.getY();
		}
		repaint(REPAINT);
		e.consume();
	}

	/* Andy : Mouse Scrolling Event */
	public void mouseWheelMoved(MouseWheelEvent e) {
		int notches = e.getWheelRotation();  
		if (e.getScrollType() == MouseWheelEvent.WHEEL_UNIT_SCROLL) {
			if (notches > 0) {
				zoom_in_x();
				zoom_in_y();
			} else {
				zoom_out_x();
				zoom_out_y();
			}
		} 
	}


	public void start() {
	}

	public void stop() {
	}

	//double buffer the graphics.
	Image offscreen;
	Dimension offscreensize;
	Graphics offgraphics;


	public synchronized void paintComponent(Graphics g) {

		//get the size of the window.
		Dimension d = getSize();
		//System.out.println(monitor.MainFrame.getSize());
		//get the end value of the window.
		int end = this.end;

		//graph.time_location.setValue((int)(end / ((maximum_x - minimum_x)*1.0)));
		//create the offscreen image if necessary (only done once)
		if ((offscreen == null) || (d.width != offscreensize.width) || (d.height != offscreensize.height)) {
			offscreen = createImage(d.width, d.height);
			offscreensize = d;
			if (offgraphics != null) {
				offgraphics.dispose();
			}
			offgraphics = offscreen.getGraphics();
			offgraphics.setFont(getFont());
		}
		//blank the screen.
		offgraphics.setColor(Color.black);
		offgraphics.fillRect(0, 0, d.width, d.height);

		// Draw axes
		Point2D origin = new Point2D(0,0);
		//System.out.println("start: "+ start + " end: "+ end + " bottom: "+bottom+" top: "+top );
		double xTicSpacing = (end - start)/25.03;
		double yTicSpacing = (top - bottom)/13.7; 

		origin.x = start + ((end - start) * X_AXIS_POSITION);
		origin.y = bottom + ((top - bottom) * Y_AXIS_POSITION);

		//System.out.println("origin: "+origin.toString());
		if (yaxishex) {
			// Round origin to integer
			if ((origin.x % 1.0) != 0) origin.x -= (origin.x % 1.0);
			if ((origin.y % 1.0) != 0) origin.y -= (origin.y % 1.0);
		} else {
			// Round origin to integer
			if ((origin.x % 1.0) != 0) origin.x -= (origin.x % 1.0);
			if ((origin.y % 1.0) != 0) origin.y -= (origin.y % 1.0);
		}

		// Prevent tics from being too small
		if (yTicSpacing < 1.0) yTicSpacing = 1.0;
		if ((yTicSpacing % 1.0) != 0) yTicSpacing += (1.0 - (yTicSpacing % 1.0));
		if (xTicSpacing < 1.0) xTicSpacing = 1.0;
		if ((xTicSpacing % 1.0) != 0) xTicSpacing += (1.0 - (xTicSpacing % 1.0));

		Color xColor,yColor;
		xColor = Color.white;
		yColor = Color.white;

		drawGridLines(offgraphics, origin, xTicSpacing, yTicSpacing);
		drawAxisAndTics(offgraphics, origin, start, end, top, bottom, xTicSpacing, yTicSpacing, xColor, yColor);

		//draw the highlight box if there is one.
		draw_highlight(offgraphics);

		//draw the input channels.

		for (Enumeration i = channels.elements(); i.hasMoreElements(); ) {
			Channel c = (Channel) i.nextElement();

			Enumeration k = Channel.availableType.keys();
			while (k.hasMoreElements()) {
				Integer type = (Integer) k.nextElement();
				if( c.isTypeActive(type.intValue())  ) {

					offgraphics.setColor(c.getPlotColor(type.intValue()));

					draw_data(offgraphics, c.getData(type.intValue()), start, end);
				}	
			}
		}


		// Draw the value tester line if needed

		if (valueTest) {
			offgraphics.setFont(new Font("Default", Font.PLAIN, 12));
			offgraphics.setColor(new Color((float)0.9, (float)0.9, (float)1.0));
			Point2D vt = virtualToScreen(new Point2D(valueX, valueY));
			offgraphics.drawLine((int)vt.x, 0, (int)vt.x, d.height);
			offgraphics.drawRect((int)vt.x - 3, (int)vt.y - 3, 6, 6);
			if (yaxishex) {
				offgraphics.drawString("["+valueX+",0x"+Integer.toHexString(valueY)+"]", (int)vt.x+15, (int)vt.y-15);
			} else {
				offgraphics.drawString("["+valueX+","+valueY+"]", (int)vt.x+15, (int)vt.y-15);
			}
		}


		drawLegend(offgraphics);

		//transfer the constructed image to the screen.
		g.drawImage(offscreen, 0, 0, null); 

		/*
		//get the size of the window.
		super.paintComponent(g);
		Graphics2D g2d = (Graphics2D) g;
		g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
		RenderingHints.VALUE_ANTIALIAS_ON);	
		Dimension d = getSize();
		//get the end value of the window.
		int end = this.end;

		//blank the screen.
		g2d.setColor(Color.black);
		g2d.fillRect(0, 0, d.width, d.height);

		// Draw axes
		Point2D origin;

		// Prevent tics from being too small
		double xTicSpacing = Math.ceil((end - start)/25.03);
		double yTicSpacing = Math.ceil((top - bottom)/13.7); 
		//Andy
		//origin = new Point2D.Double(Math.floor(start + ((end - start) * X_AXIS_POSITION)), 
		//			    Math.floor(bottom + ((top - bottom) * Y_AXIS_POSITION)));

		origin = new Point2D(Math.floor(start + ((end - start) * X_AXIS_POSITION)), 
		Math.floor(bottom + ((top - bottom) * Y_AXIS_POSITION)));

		Color xColor,yColor;
		xColor = Color.white;
		yColor = Color.white;

		drawGridLines(g2d, origin, xTicSpacing, yTicSpacing);
		drawAxisAndTics(g2d, origin, start, end, top, bottom, xTicSpacing, yTicSpacing, xColor, yColor);
		//System.out.println("start="+start+"; end="+end+"; top="+top+"; bottom="+bottom);

		//draw the highlight box if there is one.
		draw_highlight(g2d);

		//draw the input channels.
		for (Enumeration i = channels.elements(); i.hasMoreElements(); ) {
		Channel c = (Channel) i.nextElement();
		if (c.isActive()) {
		//		System.out.println("Plotting data for channel "+c.getDataLegend());

		g2d.setColor(c.getPlotColor());
		draw_data(g2d, c, start, end);
		}
		}
		// Draw the value tester line if needed
		if (valueTest) {
		g2d.setFont(new Font("Default", Font.PLAIN, 12));
		g2d.setColor(new Color((float)0.9, (float)0.9, (float)1.0));
		//Andy
		//Point2D vt = virtualToScreen(new Point2D.Double((double)valueX, (double)valueY));
		//
		Point2D vt = virtualToScreen(new Point2D((double)valueX, (double)valueY));
		g2d.drawLine((int)vt.getX(), 0, (int)vt.getY(), d.height);
		g2d.drawRect((int)vt.getX() - 3, (int)vt.getY() - 3, 6, 6);
		if (isHexAxis()) {
		g2d.drawString("["+valueX+",0x"+Integer.toHexString(valueY)+"]", (int)vt.getX()+15, (int)vt.getY()-15);
		} else {
		g2d.drawString("["+valueX+","+valueY+"]", (int)vt.getX()+15, (int)vt.getY()-15);
		}
		}

		drawLegend(g2d);

		//transfer the constructed image to the screen.
		g.drawImage(offscreen, 0, 0, null); 
		*/
	}

	// Draw the grid lines
	void drawGridLines(Graphics offgraphics, Point2D origin, 
			double xTicSpacing, double yTicSpacing ) {

		offgraphics.setColor(new Color((float)0.2, (float)0.6, (float)0.2));

		int i = 0;

		/*Andy remove Double
			Point2D.Double virt, screen;
			*/

		Point2D virt, screen;

		/*Andy remove Double
			virt = (Point2D.Double) origin.clone();//new Point2D(origin.x, origin.y);
			*/
		//System.out.println(1);
		virt = new Point2D(origin.x, origin.y);
		screen = virtualToScreen(virt);

		while (screen.x < getSize().width) {
			if (screen.x<1.0e-8 || getSize().height<1.0e-8) 
				break;
			//System.out.println("DrawLine: screen.x="+(int)screen.x+", height="+ (int)screen.x);
			offgraphics.drawLine((int)screen.x, 0, (int)screen.x, getSize().height);
			/* Andy 
				 virt.setLocation(virt.getX()+xTicSpacing,virt.getY());
				 */
			virt.x += xTicSpacing;
			screen = virtualToScreen(virt);
		}
		/* Andy remove Double
			 virt =  (Point2D.Double) origin.clone();
			 */
		//System.out.println(2);
		virt = new Point2D(origin.x, origin.y);

		screen = virtualToScreen(virt);
		while (screen.x >= 0) {
			offgraphics.drawLine((int)screen.x, 0, (int)screen.x, getSize().height);

			virt.x -= xTicSpacing;
			/* Andy remove Double
				 virt.setLocation(virt.getX() - xTicSpacing, virt.getY());
				 screen = (Point2D.Double)virtualToScreen(virt);
				 */
			screen = (Point2D)virtualToScreen(virt);
		}
		/* Andy remove Double
			 virt =  (Point2D.Double) origin.clone();
			 screen = (Point2D.Double)virtualToScreen(virt);
			 */
		//System.out.println(3);
		virt = new Point2D(origin.x, origin.y);
		screen = (Point2D)virtualToScreen(virt);

		while (screen.y < getSize().height) {
			//if (screen.y<0 || getSize().width<0) 

			//	break;
			//while(screen.y >= 0){
			if (screen.y<1.0e-8 || getSize().width<1.0e-8) 
				break;
			//System.out.println("screen.y: "+ screen.toString() +" virt: "+virt.toString());
			offgraphics.drawLine(0, (int)screen.y, getSize().width, (int)screen.y);
			virt.y -= yTicSpacing;
			/* Andy remove Double
				 virt.setLocation(virt.getX(), virt.getY() - yTicSpacing);
				 screen = (Point2D.Double)virtualToScreen(virt);
				 */
			screen = (Point2D)virtualToScreen(virt);
			}
		/* Andy remove Double
			 virt =  (Point2D.Double) origin.clone();
			 screen =   (Point2D.Double)virtualToScreen(virt);
			 */
		//System.out.println(4);
		virt = new Point2D(origin.x, origin.y);
		screen =   (Point2D)virtualToScreen(virt);
		while (screen.y >=0) {
			//while (screen.y < getSize().height) {
			//System.out.println("screen.y: "+ screen.toString() +" virt: "+virt.toString());
			offgraphics.drawLine(0, (int)screen.y, getSize().width, (int)screen.y);
			virt.y += yTicSpacing;
			/* Andy remove Double
				 virt.setLocation(virt.getX(), virt.getY() + yTicSpacing);
				 screen = (Point2D.Double)virtualToScreen(virt);
				 */
			screen =   (Point2D)virtualToScreen(virt);
			}
		}


		void drawAxisAndTics(Graphics offgraphics, Point2D origin, 
				int start, int end, double top, double bottom, 
				double xTicSpacing, double yTicSpacing, 
				Color xColor, Color yColor) {

			int i;

			// Draw axis lines
			Point2D origin_screen = virtualToScreen(origin);
			offgraphics.setColor(xColor);
			offgraphics.drawLine(0, (int)origin_screen.getY(), getSize().width, (int)origin_screen.getY());
			offgraphics.setColor(yColor);
			offgraphics.drawLine((int)origin_screen.getX(), 0, (int)origin_screen.getX(), getSize().height);


			// Draw the tic marks and numbers
			offgraphics.setFont(new Font("Default", Font.PLAIN, 10));
			offgraphics.setColor(yColor);

			Point2D virt, screen;
			boolean label;

			// Y axis
			label = true;
			virt = new Point2D(origin.x, origin.y);
			/*Andy
				virt = (Point2D) origin.clone();//new Point2D(origin.getX(), origin.y);
				*/
			screen = virtualToScreen(virt);
			while (screen.getY() < getSize().height) {
				if (screen.getY()<0 || (screen.getX() - 5)<0 || getSize().height<0) 
					break;

				offgraphics.drawLine((int)screen.getX() - 5, (int)screen.getY(), (int)screen.getX() + 5, (int)screen.getY());
				if (label) {
					String tickstr;
					int xsub;
					if (isHexAxis()) {
						int tmp = (int)(virt.getY());
						tickstr = "0x"+Integer.toHexString(tmp);
						xsub = 40;
					} else {
						tickstr = new Double(virt.getY()).toString();
						xsub = 25;
					}
					offgraphics.drawString(tickstr, (int)screen.getX()-xsub, (int)screen.getY()-2);
					label = false;
				} else {
					label = true;
				}
				/*Andy
					virt.setLocation(virt.getX(), virt.getY() - yTicSpacing);
					*/
				virt.y -= yTicSpacing;
				screen = virtualToScreen(virt);
			}

			label = false;
			/*Andy
				virt = new Point2D.Double(origin.getX(), origin.getY() + yTicSpacing);
				*/
			virt = new Point2D(origin.getX(), origin.getY() + yTicSpacing);
			screen = virtualToScreen(virt);
			while (screen.getY() >= 0) {
				if (screen.getY()<0 || (screen.getX() - 5)<0) 
					break;

				offgraphics.drawLine((int)screen.getX() - 5, (int)screen.getY(), (int)screen.getX() + 5, (int)screen.getY());
				if (label) {
					String tickstr;
					int xsub;
					if (isHexAxis()) {
						int tmp = (int)(virt.getY());
						tickstr = "0x"+Integer.toHexString(tmp);
						xsub = 40;
					} else {
						tickstr = new Double(virt.getY()).toString();
						xsub = 25;
					}
					offgraphics.drawString(tickstr, (int)screen.getX()-xsub, (int)screen.getY()-2);
					label = false;
				} else {
					label = true;
				}
				virt.y += yTicSpacing;
				/*Andy
					virt.setLocation(virt.getX(), virt.getY() + yTicSpacing);
					*/
				screen = virtualToScreen(virt);
			}

			// X axis
			label = true;
			/*Andy
				virt = (Point2D)origin.clone();//new Point2D(origin.getX(), origin.getY());
				*/
			virt = new Point2D(origin.x, origin.y);
			screen = virtualToScreen(virt);
			while (screen.getX() < getSize().width) {
				if ((screen.getY()-5)<0 || screen.getX()<0 || getSize().width<0) 
					break;

				offgraphics.drawLine((int)screen.getX(), (int)screen.getY() - 5, (int)screen.getX(), (int)screen.getY() + 5);
				if (label) {
					String tickstr = new Double(virt.getX()).toString();
					offgraphics.drawString(tickstr, (int)screen.getX()-15, (int)screen.getY()+15);
					label = false;
				} else {
					label = true;
				}
				/*Andy
					virt.setLocation(virt.getX()+ xTicSpacing, virt.getY());
					*/
				virt.x += xTicSpacing;
				screen = virtualToScreen(virt);
			}

			label = false;
			/*Andy
				virt = new Point2D.Double(origin.getX() - xTicSpacing, origin.getY());
				*/
			virt = new Point2D(origin.getX() - xTicSpacing, origin.getY());
			screen = virtualToScreen(virt);
			while (screen.getX() >= 0) {
				if ((screen.getY()-5)<0 || screen.getX()<0) 
					break;

				offgraphics.drawLine((int)screen.getX(), (int)screen.getY() - 5, (int)screen.getX(), (int)screen.getY() + 5);
				if (label) {
					String tickstr = new Double(virt.getX()).toString();
					offgraphics.drawString(tickstr, (int)screen.getX()-15, (int)screen.getY()+15);
					label = false;
				} else {
					label = true;
				}
				/*Andy
					virt.setLocation(virt.getX() - xTicSpacing, virt.getY());
					*/
				virt.x -= xTicSpacing;
				screen = virtualToScreen(virt);
			}

			Graphics2D g2d = (Graphics2D) offgraphics;
			AffineTransform at = g2d.getTransform();
			Font f = g2d.getFont();
			offgraphics.setFont(new Font("Default", Font.BOLD, 12));
			FontMetrics fm = g2d.getFontMetrics();
			screen = virtualToScreen((Point2D) origin); 


			if (getYLabel() != null) { 
				int lWidth = fm.stringWidth(getYLabel());
				int ypos = (int) ((int)screen.getY() + lWidth)/2 ;
				int xpos = (int) ((int)screen.getX() - 30 - (int)(fm.getHeight()/2));
				AffineTransform at1 = new AffineTransform();
				at1.setToRotation(-Math.PI/2.0, xpos, ypos);
				g2d.setTransform(at1);
				g2d.drawString(getYLabel(), xpos, ypos);
				//System.out.println("YLable: xpos="+xpos+"; ypos="+ypos);

			}
			g2d.setTransform(at);

			if (getXLabel() != null) { 
				int lWidth = fm.stringWidth(getXLabel());
				int xpos = (int) (screen.getX() + getWidth() -lWidth)/2;
				int ypos = (int) (screen.getY() + fm.getHeight()/2 + 30);
				g2d.drawString(getXLabel(), xpos, ypos);
				//System.out.println("XLable: xpos="+xpos+"; ypos="+ypos+"\n");
			}
			g2d.setFont(f);
		}


		void drawLegend( Graphics offgraphics ) {
			Channel c;
			Graphics2D g2d = (Graphics2D) offgraphics;
			// Draw the legend
			if( isLegendEnabled() ) {
				FontMetrics fm = g2d.getFontMetrics();
				int width = 10; 
				int _width;
				int activeChannels=0,curChan=0;
				for (Enumeration i = channels.elements(); i.hasMoreElements(); ) {
					c = (Channel)i.nextElement();

					Enumeration k = Channel.availableType.keys();
					while (k.hasMoreElements()) {
						Integer type = (Integer) k.nextElement();
						if( c.isTypeActive(type.intValue()) ) {
							activeChannels++;
							_width = fm.stringWidth(c.getDataLegend());
							if (_width > width) 
								width = _width;
						}	
					}
				}

				if( activeChannels == 0 )
					return;

				int h = fm.getHeight();
				activeChannels++; //add a font height to the legend box.

				offgraphics.setColor(Color.black);
				offgraphics.fillRect( getSize().width-20-80-width, getSize().height-20-h*activeChannels, width+95, h*activeChannels );
				offgraphics.setColor(Color.white);
				offgraphics.drawRect( getSize().width-20-80-width, getSize().height-20-h*activeChannels, width+95, h*activeChannels );
				Line2D l = new Line2D.Double();
				for (Enumeration i = channels.elements(); i.hasMoreElements(); ) {
					c = (Channel) i.nextElement();
					Enumeration k = Channel.availableType.keys();
					while (k.hasMoreElements()) {
						Integer type = (Integer) k.nextElement();
						if( c.isTypeActive(type.intValue()) ) {
							offgraphics.setColor(Color.white);
							offgraphics.drawString( c.getDataLegend() + " Type " + type.intValue() , getSize().width-20-50-width, getSize().height-20 - h/2-h*curChan );
							offgraphics.setColor(c.getPlotColor(type.intValue()));
							g2d.setStroke(c.getPlotStroke(type.intValue()));
							l.setLine(getSize().width-20-75-width, getSize().height-20-h*(curChan+1)+h/4, getSize().width-20-55-width, getSize().height-20-h*(curChan+1)+h/4);
							g2d.draw( l  );
							curChan++;
						}	
					}
				}
			}
		}

		//return the difference between the two input vectors.

		Vector diff(Iterator a, Iterator b){
			Vector vals = new Vector();
			while(a.hasNext() && b.hasNext()){
				vals.add(new Double((((Double)b.next()).doubleValue() - ((Double)a.next()).doubleValue())));
			}
			return vals;
		}

		//draw the highlight box.
		void draw_highlight(Graphics g){
			if(highlight_start == null) return;
			int x, y, h, l;
			x = Math.min(highlight_start.x, highlight_end.x);
			y = Math.min(highlight_start.y, highlight_end.y);
			l = Math.abs(highlight_start.x - highlight_end.x);
			h = Math.abs(highlight_start.y - highlight_end.y);
			g.setColor(Color.white);
			g.fillRect(x,y,l,h);
		}


		void draw_data(Graphics g, Vector data, int start, int end){

			draw_data(g,data, start, end, 1);

		}

		//scale multiplies a signal by a constant factor.
		//scale multiplies a signal by a constant factor.
		void draw_data(Graphics g, Vector data, int start, int end, int scale){
			
			Point2D screen = null, screen2 = null;
			boolean noplot=true;  // Used for line plotting
			int previousXCoordination = 0;
			int previousYCoordination = 0;

			for(int i = 0; i < data.size(); i ++){
				Point2D virt;
				//map each point to a x,y position on the screen.
				/*Andy
					if((virt = (Point2D)data.get(i)) != null) {
					*/
				if((data.get(i)) != null) {
					virt = new Point2D(((java.awt.geom.Point2D)data.get(i)).getX(), ((java.awt.geom.Point2D)data.get(i)).getY());
		    //	System.out.print(((java.awt.geom.Point2D)data.get(i)).getX()+" "+((java.awt.geom.Point2D)data.get(i)).getY()+" ");
					screen = virtualToScreen(virt);
					if (screen.getX() >= 0 && screen.getX() < getSize().width) {
                                                //System.out.print((int)(screen.getY())+" ");
						//8/13/2008 Andy Don't draw the point onto screen if they are too close to each other to improve the speed
						if (previousXCoordination == 0 && previousYCoordination == 0){
							previousXCoordination = (int)screen.getX();
							previousYCoordination = (int)screen.getY();
						}
						else {
							if (Math.abs(previousXCoordination - (int)screen.getX()) < 3){
								continue;
							}
							else {
								previousXCoordination = (int)screen.getX();
								previousYCoordination = (int)screen.getY();
							}
						}
						//8/13/2008 Andy End

					
						if(connectPoints && !noplot){

							Graphics2D g2d=(Graphics2D)g;
							Stroke prestroke=g2d.getStroke() ;
							Stroke stroke=new BasicStroke(3.0f);
							g2d.setStroke(stroke); 
							g2d.drawLine((int)screen2.getX(), (int)screen2.getY(), (int)screen.getX(), (int)screen.getY());
							g2d.setStroke(prestroke); 

						}
						else if( !connectPoints )
							g.drawRect((int)screen.getX(), (int)screen.getY(), 1, 1);
						if (noplot) noplot = false;
					} else {
						noplot = true;
					}
				}
				screen2 = screen;
					}
			//System.out.println();
			}

			//functions for controlling zooming.
			void move_up(){/*
												System.out.println("top " + top);
												System.out.println("bottom" + bottom);
												System.out.println("start " + start);
												System.out.println("end " + end);
												*/

				double tmpBottom = bottom, tmpTop = top;
				double height = tmpTop - tmpBottom;
				tmpBottom += height/4;
				tmpTop += height/4;
				setYBounds(tmpBottom,tmpTop);
			}

			void move_down(){
				double tmpBottom = bottom, tmpTop = top;
				double height = tmpTop - tmpBottom;
				tmpBottom -= height/4;
				tmpTop -= height/4;
				setYBounds(tmpBottom,tmpTop);

			}

			void move_right(){
				int tmpStart = start, tmpEnd = end;
				int width = tmpEnd - tmpStart;
				tmpStart += width/4;
				tmpEnd += width/4;
				setXBounds(tmpStart,tmpEnd);
			}

			void move_left(){
				int tmpStart = start, tmpEnd = end;
				int width = tmpEnd - tmpStart;
				tmpStart -= width/4;
				tmpEnd -= width/4;
				setXBounds(tmpStart,tmpEnd);
			}

			void zoom_out_x(){
				int tmpStart = start, tmpEnd = end;
				int width = tmpEnd - tmpStart;
				tmpStart -= width/2;
				tmpEnd += width/2;
				//System.out.println(tmpStart+" "+tmpEnd);
				setXBounds(tmpStart,tmpEnd);
			}

			void zoom_out_y(){
				double tmpBottom = bottom, tmpTop = top;
				double height = tmpTop - tmpBottom;
				tmpBottom -= height/2;
				tmpTop += height/2;
				setYBounds(tmpBottom,tmpTop);
			}

			void zoom_in_x(){
				int tmpStart = start, tmpEnd = end;
				int width = tmpEnd - tmpStart;
				tmpStart += width/4;
				tmpEnd -= width/4;
				setXBounds(tmpStart,tmpEnd);
			}

			void zoom_in_y(){
				double tmpBottom = bottom, tmpTop = top;
				double height = tmpTop - tmpBottom;
				tmpBottom += height/4;
				tmpTop -= height/4;
				setYBounds(tmpBottom,tmpTop);
			}

			//Andy: Lookup Wave	
			void reset(double xLookupTail, double xLookupHead, double yLookupMin, double yLookupMax){
				//System.out.println(xLookupTail+" "+xLookupHead+" "+yLookupMin+" "+yLookupMax);

				/*if(yLookupMin == 1.0e8 || yLookupMax == -1.0e8)
					return;*/


				if (xLookupHead != xLookupTail){
					start = (int)xLookupTail ;
					end = (int)xLookupHead ;
					double width = start - end;
					end -= width/10;
					start += width/10;
					while(end - start < POINTSONSCREEN*INTERVAL){
						width = end - start;
						start -= width/5;
						end += width/5;
					}
				}	
				else { 
					end = (int)xLookupHead ;
					start = end -POINTSONSCREEN*INTERVAL;
				}

				if (yLookupMax == yLookupMin ){
					int yValue = (int)(bottom - top);
					top = (int)yLookupMax;
					bottom= top + yValue;
					double height = top - bottom;
					bottom -= height;
					top += height;
					return;
				}	

				if(yLookupMin == 1.0e8 || yLookupMax == -1.0e8)
					return;

				top = (int)yLookupMax;
				bottom = (int)yLookupMin;
				double height = top - bottom;
				bottom -= height/4;
				top += height/4;
			}

			/*
			//Andy: Lookup Wave
			void lookup_wave(double xLookup, double yLookupMin, double yLookupMax){

			int xValue = end - start;
			int yValue = (int)(bottom - top);
			start = (int)xLookup ;
			end = start + xValue ;
			top = (int)yLookupMax;
			bottom = (int)yLookupMin;
			//bottom= top + yValue;

			double height = top - bottom;
			bottom -= height/4;
			top += height/4;

			int width = end - start;
			start -= width;
			end += width;

			}
			*/

			void customize_Y(double fst_data)
			{
				if (bottom==DEFAULT_BOTTOM && top==DEFAULT_TOP 
						&& start==DEFAULT_START && end==DEFAULT_END)
				{
					double height = top - bottom;
					top = fst_data + height/2;
					bottom = fst_data - height/2;
					//	System.out.println("customize Y");
				}
			}


			void set_zoom(){
				int base = getSize().height;
				int x_start = Math.min(highlight_start.x, highlight_end.x);
				int x_end = Math.max(highlight_start.x, highlight_end.x);
				int y_start = Math.min(highlight_start.y, highlight_end.y);
				int y_end = Math.max(highlight_start.y, highlight_end.y);

				if(Math.abs(x_start - x_end) < 10) return;
				if(Math.abs(y_start - y_end) < 10) return;
				/*Andy
					Point2D topleft = screenToVirtual(new Point2D.Double((double)x_start, (double)y_start));
					Point2D botright = screenToVirtual(new Point2D.Double((double)x_end, (double)y_end));
					*/
				Point2D topleft = screenToVirtual(new Point2D((double)x_start, (double)y_start));
				Point2D botright = screenToVirtual(new Point2D((double)x_end, (double)y_end));

				start = (int)topleft.getX();
				end = (int)botright.getX();
				top = topleft.getY();
				bottom = botright.getY();
			}

			/** Convert from virtual coordinates to screen coordinates. */

			/*Point2D.Double virtualToScreen(Point2D virt) {
				Andy remove Double*/
			Point2D virtualToScreen(Point2D virt) {
				//System.out.print("virt: "+virt.toString());
				double xoff = virt.getX() - start;
				double xpos = xoff / (end*1.0 - start*1.0);
				double screen_xpos = xpos * getSize().width;
				//System.out.print(" start: "+ start + " end "+ end +" "+(end-start));
                                //System.out.println(" top: "+ top + " bottom "+ bottom );	
				double yoff = virt.getY() - bottom;
				double ypos = yoff / (top*1.0 - bottom*1.0);
				//double ypos = yoff/10;
				double screen_ypos = getSize().height - (ypos * getSize().height);
				/*Andy
					return new Point2D.Double(screen_xpos, screen_ypos);
					*/
				//System.out.println(" screen: "+ screen_xpos + " "+ screen_ypos);
				return new Point2D(screen_xpos, screen_ypos);
			}

			/** Convert from screen coordinates to virtual coordinates. */
			Point2D screenToVirtual(Point2D screen) {
				double xoff = screen.getX();
				double xpos = xoff / (getSize().width * 1.0);
				double virt_xpos = start + (xpos * (end*1.0 - start*1.0));

				double yoff = screen.getY();
				double ypos = yoff / (getSize().height * 1.0);
				double virt_ypos = top - (ypos * (top*1.0 - bottom*1.0));
				/*Andy
					return new Point2D.Double(virt_xpos, virt_ypos);
					*/
				return new Point2D(virt_xpos, virt_ypos);
			}

			/** Find nearest point in 'data' to x-coordinate of given point. */
			Point2D findNearestX(Channel _data, Point2D test) {

				Enumeration k = Channel.availableType.keys();
				while (k.hasMoreElements()) {
					Integer type = (Integer) k.nextElement();
					if( _data.isTypeActive(type.intValue()) ) {
						Vector data = _data.getData(type.intValue());
						String cutoffLengthOfX = Math.round(test.getX())+"";
						int cutoffValue = cutoffLengthOfX.length() - 5;
						try {
							double xval = Math.round(test.getX());
							for (int i = 0; i < data.size(); i++) {
								/* Andy: Enable to see the data when do mouse pressed*/
								Point2D pt = new Point2D(((java.awt.geom.Point2D)data.get(i)).getX(), ((java.awt.geom.Point2D)data.get(i)).getY());
								//Point2D pt = (Point2D)data.get(i);
								if (pt == null) continue;
								if (cutoffValue > 0) 
									if (Math.round(pt.getX()/(cutoffValue*10)) == Math.round(xval/(cutoffValue*10))) { return pt;}
									else			        
										if (Math.round(pt.getX()) == Math.round(xval)) { return pt;}
							}
							return null;
						} catch (Exception e) {
							return null;
						}
						//return data.findNearestX(test);
					}	
				}
				return null;
			}

			public void clear_data() {
				int i;
				for (Enumeration e = channels.elements(); e.hasMoreElements(); ) { 
					Channel c = (Channel) e.nextElement();
					Enumeration k = Channel.availableType.keys();
					while (k.hasMoreElements()) {
						Integer type = (Integer) k.nextElement();
						if( c.isTypeActive(type.intValue()) ) {
							c.clear(type.intValue());
						}	
					}

				}
			}

			void save_data() {
				/*JFileChooser	file_chooser = new JFileChooser();
					File		savedFile;
					FileWriter	dataOut;
					int		retval,i,n;

					retval = file_chooser.showSaveDialog(null);
					if( retval == JFileChooser.APPROVE_OPTION ) {
					try {
					savedFile = file_chooser.getSelectedFile();
					System.out.println( "Saved file: "+savedFile.getName() );
					dataOut = new FileWriter( savedFile );
					dataOut.write( "# Test Data File\n" );
					dataOut.write( "# "+(new Date())+"\n" );
					for (Enumeration e = channels.elements(); e.hasMoreElements(); ) {
					Channel c =(Channel) e.nextElement();
					c.saveData(dataOut);
					}
					dataOut.close();
					} catch( IOException e ) {
					System.out.println( e );
					}
					}*/
			}

			/** A simple inner class representing a 2D point. */
			public class Point2D {
				double x, y;

				Point2D(double newX, double newY) {
					x = newX;
					y = newY;
				}

				double getX() {
					return x;
				}

				double getY() {
					return y;
				}

				public String toString() {
					return x+","+y;
				}
			}


			}
