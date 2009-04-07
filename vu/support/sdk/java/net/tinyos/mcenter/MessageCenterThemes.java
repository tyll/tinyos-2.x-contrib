/*
 * Copyright (c) 2003 Sun Microsystems, Inc. All  Rights Reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * -Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 * 
 * -Redistribution in binary form must reproduct the above copyright
 *  notice, this list of conditions and the following disclaimer in
 *  the documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of Sun Microsystems, Inc. or the names of contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 * 
 * This software is provided "AS IS," without a warranty of any kind. ALL
 * EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND WARRANTIES, INCLUDING
 * ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
 * OR NON-INFRINGEMENT, ARE HEREBY EXCLUDED. SUN AND ITS LICENSORS SHALL NOT
 * BE LIABLE FOR ANY DAMAGES OR LIABILITIES SUFFERED BY LICENSEE AS A RESULT
 * OF OR RELATING TO USE, MODIFICATION OR DISTRIBUTION OF THE SOFTWARE OR ITS
 * DERIVATIVES. IN NO EVENT WILL SUN OR ITS LICENSORS BE LIABLE FOR ANY LOST
 * REVENUE, PROFIT OR DATA, OR FOR DIRECT, INDIRECT, SPECIAL, CONSEQUENTIAL,
 * INCIDENTAL OR PUNITIVE DAMAGES, HOWEVER CAUSED AND REGARDLESS OF THE THEORY
 * OF LIABILITY, ARISING OUT OF THE USE OF OR INABILITY TO USE SOFTWARE, EVEN
 * IF SUN HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
 * 
 * You acknowledge that Software is not designed, licensed or intended for
 * use in the design, construction, operation or maintenance of any nuclear
 * facility.
 */

/*
 * @(#)GreenMetalTheme.java	1.8 03/01/23
 */ 
package net.tinyos.mcenter;

import javax.swing.plaf.*;
import javax.swing.plaf.metal.*;
import javax.swing.plaf.basic.*;
import javax.swing.*;
import javax.swing.border.*;
import java.awt.*;
 

/**
 *
 * TODO
 */
/**
 * This class describes a theme using "green" colors.
 *
 * @version 1.8 01/23/03
 * @author Steve Wilson
 */
public class MessageCenterThemes {
	
	public static MetalTheme[] generateThemeArray(){
		MetalTheme[] themes = { new DefaultMetalTheme(),
				new GreenMetalTheme(),
				new AquaMetalTheme(),
				new KhakiMetalTheme(),
				new DemoMetalTheme(),
				new ContrastMetalTheme(),
				new BigContrastMetalTheme(),
				new DarkGreenMetalTheme()}; 
		return themes;
	}
	
	/**
	 * This class describes a theme using "blue-green" colors.
	 *
	 * @version 1.8 01/23/03
	 * @author Steve Wilson
	 */
	public static class AquaMetalTheme extends DefaultMetalTheme {

	    public String getName() { return "Oxide"; }

	    private final ColorUIResource primary1 = new ColorUIResource(102, 153, 153);
	    private final ColorUIResource primary2 = new ColorUIResource(128, 192, 192);
	    private final ColorUIResource primary3 = new ColorUIResource(159, 235, 235);

	    protected ColorUIResource getPrimary1() { return primary1; }
	    protected ColorUIResource getPrimary2() { return primary2; }
	    protected ColorUIResource getPrimary3() { return primary3; }

	} 
	/**
	 * This class describes a theme using "green" colors.
	 *
	 * @version 1.13 01/23/03
	 * @author Steve Wilson
	 */
	public static class BigContrastMetalTheme extends ContrastMetalTheme {

	    public String getName() { return "Low Vision"; }

	    private final FontUIResource controlFont = new FontUIResource("Dialog", Font.BOLD, 24);
	    private final FontUIResource systemFont = new FontUIResource("Dialog", Font.PLAIN, 24);
	    private final FontUIResource windowTitleFont = new FontUIResource("Dialog", Font.BOLD, 24);
	    private final FontUIResource userFont = new FontUIResource("SansSerif", Font.PLAIN, 24);
	    private final FontUIResource smallFont = new FontUIResource("Dialog", Font.PLAIN, 20);


	    public FontUIResource getControlTextFont() { return controlFont;}
	    public FontUIResource getSystemTextFont() { return systemFont;}
	    public FontUIResource getUserTextFont() { return userFont;}
	    public FontUIResource getMenuTextFont() { return controlFont;}
	    public FontUIResource getWindowTitleFont() { return windowTitleFont;}
	    public FontUIResource getSubTextFont() { return smallFont;}

	    public void addCustomEntriesToTable(UIDefaults table) {
	         super.addCustomEntriesToTable(table);

	         final int internalFrameIconSize = 30;
	         table.put("InternalFrame.closeIcon", MetalIconFactory.getInternalFrameCloseIcon(internalFrameIconSize));
	         table.put("InternalFrame.maximizeIcon", MetalIconFactory.getInternalFrameMaximizeIcon(internalFrameIconSize));
	         table.put("InternalFrame.iconifyIcon", MetalIconFactory.getInternalFrameMinimizeIcon(internalFrameIconSize));
	         table.put("InternalFrame.minimizeIcon", MetalIconFactory.getInternalFrameAltMaximizeIcon(internalFrameIconSize));


		Border blackLineBorder = new BorderUIResource( new MatteBorder( 2,2,2,2, Color.black) );
		Border textBorder = blackLineBorder;

	        table.put( "ToolTip.border", blackLineBorder);
		table.put( "TitledBorder.border", blackLineBorder);


	        table.put( "TextField.border", textBorder);
	        table.put( "PasswordField.border", textBorder);
	        table.put( "TextArea.border", textBorder);
	        table.put( "TextPane.font", textBorder);

	        table.put( "ScrollPane.border", blackLineBorder);

	        table.put( "ScrollBar.width", new Integer(25) );



	    }
	} 
	/**
	 * This class describes a higher-contrast Metal Theme.
	 *
	 * @version 1.16 01/23/03
	 * @author Michael C. Albers
	 */

	public static class ContrastMetalTheme extends DefaultMetalTheme {

	    public String getName() { return "Contrast"; }

	    private final ColorUIResource primary1 = new ColorUIResource(0, 0, 0);
	    private final ColorUIResource primary2 = new ColorUIResource(204, 204, 204);
	    private final ColorUIResource primary3 = new ColorUIResource(255, 255, 255);
	    private final ColorUIResource primaryHighlight = new ColorUIResource(102,102,102);

	    private final ColorUIResource secondary2 = new ColorUIResource(204, 204, 204);
	    private final ColorUIResource secondary3 = new ColorUIResource(255, 255, 255);
	    private final ColorUIResource controlHighlight = new ColorUIResource(102,102,102);

	    protected ColorUIResource getPrimary1() { return primary1; } 
	    protected ColorUIResource getPrimary2() { return primary2; }
	    protected ColorUIResource getPrimary3() { return primary3; }
	    public ColorUIResource getPrimaryControlHighlight() { return primaryHighlight;}

	    protected ColorUIResource getSecondary2() { return secondary2; }
	    protected ColorUIResource getSecondary3() { return secondary3; }
	    public ColorUIResource getControlHighlight() { return super.getSecondary3(); }

	    public ColorUIResource getFocusColor() { return getBlack(); }

	    public ColorUIResource getTextHighlightColor() { return getBlack(); }
	    public ColorUIResource getHighlightedTextColor() { return getWhite(); }
	  
	    public ColorUIResource getMenuSelectedBackground() { return getBlack(); }
	    public ColorUIResource getMenuSelectedForeground() { return getWhite(); }
	    public ColorUIResource getAcceleratorForeground() { return getBlack(); }
	    public ColorUIResource getAcceleratorSelectedForeground() { return getWhite(); }


	    public void addCustomEntriesToTable(UIDefaults table) {

	        Border blackLineBorder = new BorderUIResource(new LineBorder( getBlack() ));
	        Border whiteLineBorder = new BorderUIResource(new LineBorder( getWhite() ));

		Object textBorder = new BorderUIResource( new CompoundBorder(
							       blackLineBorder,
						               new BasicBorders.MarginBorder()));

	        table.put( "ToolTip.border", blackLineBorder);
		table.put( "TitledBorder.border", blackLineBorder);
	        table.put( "Table.focusCellHighlightBorder", whiteLineBorder);
	        table.put( "Table.focusCellForeground", getWhite());

	        table.put( "TextField.border", textBorder);
	        table.put( "PasswordField.border", textBorder);
	        table.put( "TextArea.border", textBorder);
	        table.put( "TextPane.font", textBorder);


	    }

	} 
	
	/**
	 * This class describes a theme using large fonts.
	 * It's great for giving demos of your software to a group
	 * where people will have trouble seeing what you're doing.
	 *
	 * @version 1.10 01/23/03
	 * @author Steve Wilson
	 */
	public static class DemoMetalTheme extends DefaultMetalTheme {

	    public String getName() { return "Presentation"; }

	    private final FontUIResource controlFont = new FontUIResource("Dialog", Font.BOLD, 18);
	    private final FontUIResource systemFont = new FontUIResource("Dialog", Font.PLAIN, 18);
	    private final FontUIResource userFont = new FontUIResource("SansSerif", Font.PLAIN, 18);
	    private final FontUIResource smallFont = new FontUIResource("Dialog", Font.PLAIN, 14);

	    public FontUIResource getControlTextFont() { return controlFont;}
	    public FontUIResource getSystemTextFont() { return systemFont;}
	    public FontUIResource getUserTextFont() { return userFont;}
	    public FontUIResource getMenuTextFont() { return controlFont;}
	    public FontUIResource getWindowTitleFont() { return controlFont;}
	    public FontUIResource getSubTextFont() { return smallFont;}

	    public void addCustomEntriesToTable(UIDefaults table) {
	         super.addCustomEntriesToTable(table);

	         final int internalFrameIconSize = 22;
	         table.put("InternalFrame.closeIcon", MetalIconFactory.getInternalFrameCloseIcon(internalFrameIconSize));
	         table.put("InternalFrame.maximizeIcon", MetalIconFactory.getInternalFrameMaximizeIcon(internalFrameIconSize));
	         table.put("InternalFrame.iconifyIcon", MetalIconFactory.getInternalFrameMinimizeIcon(internalFrameIconSize));
	         table.put("InternalFrame.minimizeIcon", MetalIconFactory.getInternalFrameAltMaximizeIcon(internalFrameIconSize));


	         table.put( "ScrollBar.width", new Integer(21) );



	    }

	} 
	public static class DarkGreenMetalTheme extends DefaultMetalTheme {
		
		    public String getName() { return "Dark Green"; }
		
		  // greenish colors
		    private final ColorUIResource primary1 = new ColorUIResource(26, 51, 26);
		    private final ColorUIResource primary2 = new ColorUIResource(51, 102, 51);
		    private final ColorUIResource primary3 = new ColorUIResource(102, 153, 102); 
		    
		    private final ColorUIResource black = new ColorUIResource(0, 0, 0);
		
		    protected ColorUIResource getPrimary1() { return primary1; }  
		    protected ColorUIResource getPrimary2() { return primary2; } 
		    protected ColorUIResource getPrimary3() { return primary3; } 
		    public ColorUIResource getControl() { return black; } 

		} 
	
	
	public static class GreenMetalTheme extends DefaultMetalTheme {
	
	    public String getName() { return "Emerald"; }
	
	  // greenish colors
	    private final ColorUIResource primary1 = new ColorUIResource(51, 102, 51);
	    private final ColorUIResource primary2 = new ColorUIResource(102, 153, 102);
	    private final ColorUIResource primary3 = new ColorUIResource(153, 204, 153); 
	
	    protected ColorUIResource getPrimary1() { return primary1; }  
	    protected ColorUIResource getPrimary2() { return primary2; } 
	    protected ColorUIResource getPrimary3() { return primary3; } 

	} 
	
	/**
	 * This class describes a theme using "khaki" colors.
	 *
	 * @version 1.8 01/23/03
	 * @author Steve Wilson
	 */
	public static class KhakiMetalTheme extends DefaultMetalTheme {

	    public String getName() { return "Sandstone"; }

	    private final ColorUIResource primary1 = new ColorUIResource( 87,  87,  47);
	    private final ColorUIResource primary2 = new ColorUIResource(159, 151, 111);
	    private final ColorUIResource primary3 = new ColorUIResource(199, 183, 143);

	    private final ColorUIResource secondary1 = new ColorUIResource( 111,  111,  111);
	    private final ColorUIResource secondary2 = new ColorUIResource(159, 159, 159);
	    private final ColorUIResource secondary3 = new ColorUIResource(231, 215, 183);

	    protected ColorUIResource getPrimary1() { return primary1; }
	    protected ColorUIResource getPrimary2() { return primary2; }
	    protected ColorUIResource getPrimary3() { return primary3; }

	    protected ColorUIResource getSecondary1() { return secondary1; }
	    protected ColorUIResource getSecondary2() { return secondary2; }
	    protected ColorUIResource getSecondary3() { return secondary3; }

	} 
}