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


import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.geom.*;
import java.io.*;
import java.lang.Math;
import java.util.Iterator;
import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;
	
/*
	This class is used to display a map of the network for the user.
	The gateway appears in red, and the regular motes in blue.
	
	TODO : 
			add the gradient feature
*/

class MapPanel extends JPanel implements MouseListener, MouseMotionListener {
	private MoteDatabase moteDatabase;
	private RequestPanel requestPanel;
	private LegendPanel legendPanel;
	
	private static final int SIZE_COLOR_ARRAY = 10;
	private static Color colorQualityArray[];
	private String moteLegend, samplingPeriodLegend, parentIdLegend, moteIdLegend, 
		countLegend, readingLegend, qualityLegend, lastTimeSeenLegend, routeLegend;
	
	private boolean moteDragged = false;
	private Mote moteMoving;
	private int timeout = Util.TIMEOUT;
	
	public MapPanel(MoteDatabase moteDatabase, RequestPanel requestPanel) {
		this.moteDatabase = moteDatabase;
		this.requestPanel = requestPanel;
		// the quality array starts from good quality (green) to bad quality (red)
		colorQualityArray = new Color [SIZE_COLOR_ARRAY];
		for (int i=0; i<SIZE_COLOR_ARRAY; i++)
			colorQualityArray[i] = new Color(255*i/(SIZE_COLOR_ARRAY-1), 255-255*i/(SIZE_COLOR_ARRAY-1), 0);
		// The Strings are initialized at "none" for most of them
		moteLegend = "none" ; samplingPeriodLegend = "none"; parentIdLegend = "none"; moteIdLegend = "none"; 
		countLegend = "none"; readingLegend = "none"; qualityLegend = "none"; routeLegend = "line";
		addMouseListener(this);
		addMouseMotionListener(this);
	}
	
	public void paint(Graphics g) {
		Graphics2D g2 = (Graphics2D) g;
		// we draw first a white area with a border
		Dimension d = getSize();
		g2.setPaint(Color.black);
		g2.fill(new Rectangle2D.Double(0, 0, d.width, d.height));
		g2.setPaint(Color.white);
		g2.fill(new Rectangle2D.Double(Util.MOTE_RADIUS, Util.MOTE_RADIUS, d.width-2*Util.MOTE_RADIUS, d.height-2*Util.MOTE_RADIUS));
		// we run through the list of motes and display 
		// in first the routes and next each mote
		Mote localMote, parentMote;
		moteDatabase.getMutex();
		
		String msg;
		
		// we run through the available legends, to know which one is selected
		// and we launch the corresponding functions
		
		if ("line".equals(routeLegend) || "line + label".equals(routeLegend)) {
			for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
				localMote = (Mote)it.next();
				drawParentRoute(localMote, g2);
			}
		}
		
		if ("line + label".equals(routeLegend)) {
			for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
				localMote = (Mote)it.next();
				msg = "From Id=" + localMote.getMoteId() + " To Id=" + localMote.getParentId() + "\n";
				if ("text".equals(qualityLegend)) { msg = msg.concat("Quality = " + localMote.getQuality() + "\n");}
				if ("text".equals(lastTimeSeenLegend)) {msg = msg.concat("Last Time Seen = " + localMote.getTimeSinceLastTimeSeen() + "ms\n");}
				drawParentRouteLabel(localMote, msg, g2);
			}
		}
		
		if ("circle".equals(moteLegend)) {
			for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
				localMote = (Mote)it.next();
				drawCircleMote(localMote, g2);
			}
		}
		
		// If the mote is displayed and one of the text legend is choosen
		if ("circle".equals(moteLegend) 
			&& ("text".equals(samplingPeriodLegend) || "text".equals(parentIdLegend) ||
			"text".equals(moteIdLegend) || "text".equals(countLegend) || "text".equals(readingLegend) ||
			"text + gradient".equals(samplingPeriodLegend) || "text + gradient".equals(parentIdLegend) ||
			"text + gradient".equals(moteIdLegend) || "text + gradient".equals(countLegend) || "text + gradient".equals(readingLegend))) {
			// then we run through the database
			for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
				localMote = (Mote)it.next();
				msg = "";
				if ("text".equals(moteIdLegend)) { msg = msg.concat("Mote Id = " + localMote.getMoteId() + "\n");}
				if ("text + gradient".equals(moteIdLegend)) { msg = msg.concat("Mote Id = " + localMote.getMoteId() + "\n");}
				if ("text".equals(samplingPeriodLegend)) { msg = msg.concat("Sampling Period = " + localMote.getSamplingPeriod() + " ms\n");}
				if ("text + gradient".equals(samplingPeriodLegend)) { msg = msg.concat("Sampling Period = " + localMote.getSamplingPeriod() + " ms\n");}
				if ("text".equals(parentIdLegend)) { msg = msg.concat("Parent Id = " + localMote.getParentId() + "\n");}
				if ("text + gradient".equals(parentIdLegend)) { msg = msg.concat("Parent Id = " + localMote.getParentId() + "\n");}
				if ("text".equals(countLegend)) { msg = msg.concat("Count = " + localMote.getCount() + "\n");}
				if ("text + gradient".equals(countLegend)) { msg = msg.concat("Count = " + localMote.getCount() + "\n");}
				if ("text".equals(readingLegend)) { msg = msg.concat("Reading = " + localMote.getReading() + "\n");}
				if ("text + gradient".equals(readingLegend)) { msg = msg.concat("Reading = " + localMote.getReading() + "\n");}
				drawMoteText(localMote, msg, g2);
			}
		}
		moteDatabase.releaseMutex();
	}
	
	/*
		This functions are called by legendPanel and store the value
		selected by the user.
	*/
	
	public void setMoteLegend(String s) { moteLegend = s;}
	public void setMoteIdLegend(String s) { moteIdLegend = s;}
	public void setSamplingPeriodLegend(String s) { samplingPeriodLegend = s;}
	public void setParentIdLegend(String s) { parentIdLegend = s;}
	public void setCountLegend(String s) { countLegend = s;}
	public void setReadingLegend(String s) { readingLegend = s;}
	public void setQualityLegend(String s) { qualityLegend = s;}
	public void setLastTimeSeenLegend(String s) { lastTimeSeenLegend = s;}
	public void setRouteLegend(String s) { routeLegend = s;}
	public void setTimeout(int timeout) { this.timeout = timeout;}
	
	/*
		This function draws a mote by using a circle and adds a 
		black border if the mote is selected.
		Mote.getX() gives the center of the mote, so we have to get 
		the top left corner for the functions fill and draw.
	*/
	
	private void drawCircleMote(Mote mote, Graphics2D g2) {
		if(mote != null) {
			if(mote.isGateway())
				g2.setPaint(Color.red);		// gateway
			else
				g2.setPaint(Color.blue);	// mote
			g2.fill(new Ellipse2D.Double(toVirtualX(mote.getX())-Util.MOTE_RADIUS, toVirtualY(mote.getY())-Util.MOTE_RADIUS, 
				2*Util.MOTE_RADIUS, 2*Util.MOTE_RADIUS));
			BasicStroke stroke = new BasicStroke(1.0f);
			g2.setStroke(stroke);
			if(requestPanel.moteIsSelected(mote))
				g2.setPaint(Color.black);	// mote selected
			else
				g2.setPaint(Color.white);	// mote not selected
			g2.draw(new Ellipse2D.Double(toVirtualX(mote.getX())-Util.MOTE_RADIUS, toVirtualY(mote.getY())-Util.MOTE_RADIUS, 
				2*Util.MOTE_RADIUS, 2*Util.MOTE_RADIUS));
		}
	}
	
	/*
		This function draws some text near of a mote. It takes in
		parameter a string representing the text to print. The 
		character "\n" means a new line.
		Mote.getX() gives the center of the mote, so we have to get 
		the top left corner for the functions fill and draw
	*/
	
	private void drawMoteText(Mote mote, String text, Graphics2D g2) {
		if(mote != null && text.length() > 0) {
			g2.setPaint(Color.black);
			BasicStroke stroke = new BasicStroke(1.0f);
			g2.setStroke(stroke);
			g2.setFont(new Font("Serif",Font.PLAIN,12));
			int beginIndex=0, endIndex=0, i=0;
			String msg;
			boolean exit = false;
			do {
				endIndex = text.indexOf("\n", beginIndex);
				if (endIndex == -1)
					msg = text.substring(beginIndex);
				else 
					msg = text.substring(beginIndex, endIndex);
				if (text.indexOf("\n", beginIndex+1) == -1)
					exit = true;
				beginIndex = endIndex+1;
				g2.drawString(msg, toVirtualX(mote.getX())+2*Util.MOTE_RADIUS, toVirtualY(mote.getY())+Util.MOTE_RADIUS+(12*i++));
			}while(!exit);
		}
	}
	/*
		This function draws a route from the mote to its parent if
		it exists, and deals with the quality and lastTimeSeen variables.
	*/
	
	private void drawParentRoute(Mote mote, Graphics2D g2) {
		if(mote != null) {
			if(mote.getParentId() == mote.getMoteId())	// No route drawn for the gateway
				return;
			Mote parentMote = moteDatabase.getMote(mote.getParentId());
			if(parentMote == null) {
				System.out.println("Parent mote (id="+mote.getParentId()+") from mote (id="+mote.getMoteId()+") not found");
				return;
			}
			BasicStroke stroke = new BasicStroke(3.0f);
			g2.setStroke(stroke);
			float tmp = (float)mote.getQuality() / 65535 * (SIZE_COLOR_ARRAY-1);
			float alpha = 255.0f;
			if(mote.getTimeSinceLastTimeSeen()<timeout)
				alpha = (float)mote.getTimeSinceLastTimeSeen() / timeout * 255;
			g2.setPaint(new Color(colorQualityArray[(int)tmp].getRed(), 
						colorQualityArray[(int)tmp].getGreen(),
						colorQualityArray[(int)tmp].getBlue(),
						255 - (int)alpha));
			g2.draw(new Line2D.Double(	toVirtualX(mote.getX()), toVirtualY(mote.getY()), 
										toVirtualX(parentMote.getX()), toVirtualY(parentMote.getY())));
		}
	}
	
	/*
		This function draws a route from the mote to its parent if
		it exists, and deals with the quality and lastTimeSeen variables.
	*/
	
	private void drawParentRouteLabel(Mote mote, String text, Graphics2D g2) {
		if(mote != null) {
			if(mote.getParentId() == mote.getMoteId())	// No route drawn for the gateway
				return;
			Mote parentMote = moteDatabase.getMote(mote.getParentId());
			if(parentMote == null) {
				System.out.println("Parent mote (id="+mote.getParentId()+") from mote (id="+mote.getMoteId()+") not found");
				return;
			}
			g2.setPaint(Color.blue);
			BasicStroke stroke = new BasicStroke(1.0f);
			g2.setStroke(stroke);
			g2.setFont(new Font("Serif",Font.PLAIN,12));
			int beginIndex=0, endIndex=0, i=0;
			int x = (mote.getX() + parentMote.getX())/2;
			int y = (mote.getY() + parentMote.getY())/2;
			String msg;
			boolean exit = false;
			do {
				endIndex = text.indexOf("\n", beginIndex);
				if (endIndex == -1)
					msg = text.substring(beginIndex);
				else 
					msg = text.substring(beginIndex, endIndex);
				if (text.indexOf("\n", beginIndex+1) == -1)
					exit = true;
				beginIndex = endIndex+1;
				g2.drawString(msg, toVirtualX(x), toVirtualY(y)+(12*i++));
			}while(!exit);
		}
	}
	
	/*
		These both functions translate the x and y values of the mote
		to values for the screen.
	*/
	
	private int toVirtualX(int x) { 
		Dimension d = getSize();
		int tmp = d.width*x/Util.X_MAX;
		if (tmp<Util.MOTE_RADIUS)					// we prevent x to go past the panel
			return Util.MOTE_RADIUS;
		else if (tmp>d.width-Util.MOTE_RADIUS)
			return d.width-Util.MOTE_RADIUS;
		else
			return tmp;
	}
	
	private int toVirtualY(int y) { 
		Dimension d = getSize();
		int tmp = d.height*y/Util.Y_MAX;
		if (tmp<Util.MOTE_RADIUS)					// we prevent y to go past the panel
			return Util.MOTE_RADIUS;
		else if (tmp>d.height-Util.MOTE_RADIUS)
			return d.height-Util.MOTE_RADIUS;
		else
			return tmp;
	}
	
	/*
		These both functions translate the x and y values of the screen
		to real values for the mote.
	*/
	
	private int toRealX(int x) { 
		Dimension d = getSize();
		if (x<Util.MOTE_RADIUS)
			x = Util.MOTE_RADIUS;
		else if (x>d.width-Util.MOTE_RADIUS)
			x = d.width-Util.MOTE_RADIUS;
		return Util.X_MAX*x/d.width;
	}
	
	private int toRealY(int y) { 
		Dimension d = getSize();
		if (y<Util.MOTE_RADIUS)
			y = Util.MOTE_RADIUS;
		else if (y>d.height-Util.MOTE_RADIUS)
			y = d.height-Util.MOTE_RADIUS;
		return Util.Y_MAX*y/d.height;
	}
	
    public void mouseEntered(MouseEvent e) {}

    public void mouseExited(MouseEvent e) {}
	
	/*
		Function called when a user clicks in the JPanel, either
		he clicks one or more time.
		We check if a mote is in this area and if so, this mote
		becomes selected. Else all the motes of the database are
		unselected.
		The control key lets the user select many motes in the same time.
	*/
	
    public void mouseClicked(MouseEvent e) {
		Mote localMote=null;
		int x,y;
		boolean moteClicked = false;
		for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
			localMote = (Mote)it.next();
			x = toVirtualX(localMote.getX());
			y = toVirtualY(localMote.getY());
			if ((Math.abs(x-e.getX())<=Util.MOTE_RADIUS) && (Math.abs(y-e.getY())<=Util.MOTE_RADIUS)) {
				moteClicked = true;
				break;
			}
		}
		if(localMote != null) {
			if (moteClicked) {
				if(!e.isControlDown())
					requestPanel.unselectMotes();
				requestPanel.selectMote(localMote);
				//Util.debug("clik on mote id = "+localMote.getMoteId());
			} else
				requestPanel.unselectMotes();
		} else
			requestPanel.unselectMotes();
		repaint();
	}
	
	public void mouseMoved(MouseEvent e) {}

	/*
		These three functions are used to move a mote.
		moteMoving is a Mote Object, it's the mote that 
		is dragged by the user, through the mouse.
		moteDragged is a flag to know if the user is still
		moving the mote.
	*/
	
	public void mousePressed(MouseEvent e) {}

    public void mouseReleased(MouseEvent e) {
		moteDragged = false;
		moteMoving = null;
	}
	
	public void mouseDragged(MouseEvent e) {
		int x,y;
		if (!moteDragged) {
			for (Iterator it=moteDatabase.getIterator(); it.hasNext(); ) {
				moteMoving = (Mote)it.next();
				x = toVirtualX(moteMoving.getX());
				y = toVirtualY(moteMoving.getY());
				if ((Math.abs(x-e.getX())<=Util.MOTE_RADIUS) && (Math.abs(y-e.getY())<=Util.MOTE_RADIUS)) {
					moteDragged = true;
					break;
				}
			}
		}
		if (moteMoving != null) {
			if (moteDragged) {
				moteMoving.setX(toRealX(e.getX()));
				moteMoving.setY(toRealY(e.getY()));
			} else
				requestPanel.unselectMotes();
			repaint();
		}
	}
}
