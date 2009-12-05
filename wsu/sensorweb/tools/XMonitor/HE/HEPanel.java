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
 * It create the MessagePanel to display received messages 
 * and takes care of all user's interactive actions
 *
 * @author Xiaogang Yang <gavinxyang@gmail.com>
 */
package HE;

import Config.OasisConstants;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
 import java.util.Random;
import javax.swing.ImageIcon;

import javax.swing.border.TitledBorder;
import javax.swing.plaf.basic.*;

import javax.swing.table.*;

import javax.swing.event.*;
import java.beans.*;
import rpc.message.MoteIF;

import java.awt.Toolkit;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.image.MemoryImageSource;
public class HEPanel extends JPanel {

    public MoteIF mote;
	
 
    void init() {
	generator = new Random();
        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 400, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );
        
        
        w = 512;
        h = 512;
        myImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
        pixels = new int[w*h]; 
        for(int i=0;i<w;i++)
        	for(int j=0;j<h;j++)
        		//pixels[i*w+j]=generator.nextInt()%255;
        		//pixels[i*w+j]=200;
        		myImage.setRGB(i,j,255<<16|255<<8|255);
        //myImage=this.createImage(x,y);
       
       //  myImage = createImage(new MemoryImageSource(w,h,pixels,0,w));
        
        
        
	oriImage = Toolkit.getDefaultToolkit().getImage( OasisConstants.RES+"/ori.gif");
       System.out.println(oriImage+OasisConstants.RES+"/ori.gif");
        //Graphics g = myImage.getGraphics();
        //g.drawLine(0, 0, x, y);
        //g.drawLine(x, 0, 0, y);
        //for (int i = 0; i < x; i += 2) {
         //   setPixel(myImage, 50, i, new Color(0).blue);
          //  setPixel(myImage, i, 50, new Color(0).GREEN);

        //}

    }
	
    public HEPanel(MoteIF m) {
        mote = m;
	init();
    }
    BufferedImage myImage; 
    Image oriImage;
    Random generator;
    int[] pixels;
    int w,h;
    
    /*
    public void setPixel(Image image, int x, int y, Color color) {
        Graphics g = image.getGraphics();
        g.setColor(color);
        g.fillRect(x, y, 1, 1);
        g.dispose();
    }*/

    @Override
    public void paint(Graphics g) {
       // g.drawImage(myImage, 0, 0, this);
       //g.drawRect(20, 100,512,512);
         // g.drawRect(20, 100,512,512);
       //g.drawImage(oriImage, 20, 100, this);
       g.drawImage(myImage, 100,100, this);
       // g.finalize();
    }
   int k=0;
    public void update(int x, int y,int v){
    	//setPixel(myImage, x, y, v);
    	//pixels[x*w+y]=v;
    	/*for(int i=0;i<w;i++)
        	for(int j=0;j<h;j++)
        		pixels[i*w+j]=generator.nextInt()%255;*/
        		//int ww=generator.nextInt()%512,hh=generator.nextInt()%512;
        /*for(int i=0;i<ww;i++)
        	for(int j=0;j<hh;j++)
        		pixels[i*w+j]=generator.nextInt()%255;*/
    	//System.out.println(x+" "+y+" "+v);
    	//myImage = createImage(new MemoryImageSource(w,h,pixels,0,w));
	if(x>=0&&x<w&&y>=0&&y<h&&v>=0&&v<=255)
    	myImage.setRGB(x,y,v<<16|v<<8|v);
    	repaint();
    }
    
    
    
}

