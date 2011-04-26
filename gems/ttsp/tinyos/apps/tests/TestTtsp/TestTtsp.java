import java.io.FileOutputStream;
import java.io.PrintStream;
import net.tinyos.message.*;
import net.tinyos.util.*;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.DateAxis;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYItemRenderer;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.time.*;
import org.jfree.ui.RectangleInsets;
import java.util.Map;
import java.util.HashMap;

public class TestTtsp implements MessageListener {
	private MoteIF mote;
	private Map<Integer, Long> globalTimes = new HashMap<Integer, Long>();
	private Map<Integer, TimeSeries> timeSeries = new HashMap<Integer, TimeSeries>();
	private Map<Integer, Long> lastReceivedBeacons = new HashMap<Integer, Long>();
	private Map<Long, Second> seconds = new HashMap<Long, Second>();
	private Map<Integer, TimeSeries> syncPeriodTimeSeries = new HashMap<Integer, TimeSeries>();

	private PrecisionErrorChart pec;
	private SyncPeriodChart spc;

	static private final int MAX_AGE = 10000;
	
	public PrecisionErrorChart getPrecisionErrorChart() {
		return pec;
	}

	public SyncPeriodChart getSyncPeriodChart() {
		return spc;
	}	
	
	public void setPrecisionErrorChart(PrecisionErrorChart pec) {
		this.pec = pec;
	}
	
	public void setSyncPeriodChart(SyncPeriodChart spc) {
		this.spc = spc;
	}	
	
	static class PrecisionErrorChart extends JPanel {
		private TimeSeriesCollection timeseriescollectionPrecisionError;
		
		public PrecisionErrorChart()
		{
			super(new BorderLayout());		
			timeseriescollectionPrecisionError = new TimeSeriesCollection();
			
			DateAxis dateaxis = new DateAxis("Time (hh:mm:ss)");
			dateaxis.setTickLabelFont(new Font("SansSerif", 0, 12));
			dateaxis.setLabelFont(new Font("SansSerif", 0, 14));
			dateaxis.setAutoRange(true);
			dateaxis.setUpperMargin(0.3D);
			dateaxis.setTickLabelsVisible(true);
			
			NumberAxis numberaxis = new NumberAxis("Precision error (ms)");
			numberaxis.setTickLabelFont(new Font("SansSerif", 0, 12));
			numberaxis.setLabelFont(new Font("SansSerif", 0, 14));
			numberaxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits());
			numberaxis.setRangeWithMargins(-100.0, 100.0);
			
			XYLineAndShapeRenderer xylineandshaperenderer = new XYLineAndShapeRenderer(true, false);
			xylineandshaperenderer.setSeriesPaint(0, Color.blue);
			xylineandshaperenderer.setSeriesPaint(1, Color.red);
			xylineandshaperenderer.setSeriesPaint(2, Color.green);
			xylineandshaperenderer.setSeriesPaint(3, Color.pink);
			xylineandshaperenderer.setSeriesPaint(4, Color.magenta);
			xylineandshaperenderer.setSeriesPaint(5, Color.cyan);			
			xylineandshaperenderer.setSeriesStroke(0, new BasicStroke(0.7F, 0, 2));
			xylineandshaperenderer.setSeriesStroke(1, new BasicStroke(0.7F, 0, 2));
			xylineandshaperenderer.setBaseShapesVisible(true);
			
			XYPlot xyplot = new XYPlot(timeseriescollectionPrecisionError, dateaxis, numberaxis, xylineandshaperenderer);
			xyplot.setBackgroundPaint(Color.lightGray);
			xyplot.setDomainGridlinePaint(Color.white);
			xyplot.setRangeGridlinePaint(Color.white);
			xyplot.setAxisOffset(new RectangleInsets(5D, 5D, 5D, 5D));
			xyplot.setDomainGridlinesVisible(true);
	
			JFreeChart jfreechart = new JFreeChart("Time Precision Error", new Font("SansSerif", 1, 24), xyplot, true);
			jfreechart.setBackgroundPaint(Color.white);
			ChartPanel chartpanel = new ChartPanel(jfreechart, true);
			add(chartpanel);
		}
		
		public TimeSeriesCollection getTimeSeriesCollection() {
			return timeseriescollectionPrecisionError;
		}		
	}
	
	static class SyncPeriodChart extends JPanel {
		private TimeSeriesCollection timeseriescollectionSyncPeriod;
		
		public SyncPeriodChart()
		{
		super(new BorderLayout());		
		
		timeseriescollectionSyncPeriod = new TimeSeriesCollection();
		
		DateAxis dateaxis = new DateAxis("Time (hh:mm:ss)");
		dateaxis.setTickLabelFont(new Font("SansSerif", 0, 12));
		dateaxis.setLabelFont(new Font("SansSerif", 0, 14));
		dateaxis.setAutoRange(true);
		dateaxis.setUpperMargin(0.3D);
		dateaxis.setTickLabelsVisible(true);
		
		NumberAxis numberaxis = new NumberAxis("Synchronization period (ms)");
		numberaxis.setTickLabelFont(new Font("SansSerif", 0, 12));
		numberaxis.setLabelFont(new Font("SansSerif", 0, 14));
		numberaxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits());
		//numberaxis.setRangeWithMargins(0.0, 100000.0);
		
		XYLineAndShapeRenderer xylineandshaperenderer = new XYLineAndShapeRenderer(true, false);
		xylineandshaperenderer.setSeriesPaint(0, Color.blue);
		xylineandshaperenderer.setSeriesPaint(1, Color.red);
		xylineandshaperenderer.setSeriesPaint(2, Color.green);
		xylineandshaperenderer.setSeriesPaint(3, Color.pink);
		xylineandshaperenderer.setSeriesPaint(4, Color.magenta);
		xylineandshaperenderer.setSeriesPaint(5, Color.cyan);			
		xylineandshaperenderer.setSeriesStroke(0, new BasicStroke(0.7F, 0, 2));
		xylineandshaperenderer.setSeriesStroke(1, new BasicStroke(0.7F, 0, 2));
		xylineandshaperenderer.setBaseShapesVisible(true);
		
		XYPlot xyplot = new XYPlot(timeseriescollectionSyncPeriod, dateaxis, numberaxis, xylineandshaperenderer);
		xyplot.setBackgroundPaint(Color.lightGray);
		xyplot.setDomainGridlinePaint(Color.white);
		xyplot.setRangeGridlinePaint(Color.white);
		xyplot.setAxisOffset(new RectangleInsets(5D, 5D, 5D, 5D));
		xyplot.setDomainGridlinesVisible(true);

		JFreeChart jfreechart = new JFreeChart("Synchronization Period", new Font("SansSerif", 1, 24), xyplot, true);
		jfreechart.setBackgroundPaint(Color.white);
		ChartPanel chartpanel = new ChartPanel(jfreechart, true);
		add(chartpanel);
		}
		
		public TimeSeriesCollection getTimeSeriesCollection() {
			return timeseriescollectionSyncPeriod;
		}
	}
	

	
	public TestTtsp() {	
		try {
			mote = new MoteIF(PrintStreamMessenger.err);
			mote.registerListener(new TestTtspMsg(), this);
			System.out.println("Connecting to basestation...OK");
		} catch(Exception e) {
			System.out.println("Connecting to basestation...FAILED");
			e.printStackTrace();
			System.exit(2);
		}
		
		System.out.println("[Reception Time (ms)] [Node] [Beacon] [GlobalTime (ms)] [LocalTime (ms)] [Offset (ms)] [Root] [Period]");
	}

	public void processTtspMsg(TestTtspMsg msg) {
		if(seconds.containsKey(msg.get_beaconId())) {
			
		} else {
			if(seconds.containsKey(msg.get_beaconId()-1)) {
				seconds.remove(msg.get_beaconId()-1);
			}
			
			seconds.put(msg.get_beaconId(), new Second());
			
			System.out.printf("\n");
		}
		
		globalTimes.put(msg.get_srcAddr(), msg.get_globalTime());
		lastReceivedBeacons.put(msg.get_srcAddr(), msg.get_beaconId());
		
		try {
			System.out.printf("%20d %6d %8d %17d %16d %13d", System.currentTimeMillis(), msg.get_srcAddr(), msg.get_beaconId(), msg.get_globalTime(), msg.get_localTime(), msg.get_offset());
		} catch (Exception e) {
			System.out.printf("%20d %6d %8d %17d %16d %13d", System.currentTimeMillis(), msg.get_srcAddr(), msg.get_beaconId(), msg.get_globalTime(), msg.get_localTime(), msg.get_offset());
		}
 		

		if(msg.get_rootId() == 65535) {
			System.out.printf("      -        -");
		} else {
			System.out.printf(" %6d %8d", msg.get_rootId(), msg.get_syncPeriod());
		}
		
		//System.out.printf(" %6d", msg.get_precisionError());
		
		System.out.printf("\n");
		
		if(!timeSeries.containsKey(msg.get_srcAddr())) {
			timeSeries.put(msg.get_srcAddr(), new TimeSeries("node " + msg.get_srcAddr(), org.jfree.data.time.Second.class));
			timeSeries.get(msg.get_srcAddr()).setMaximumItemAge(MAX_AGE);
			pec.getTimeSeriesCollection().addSeries(timeSeries.get(msg.get_srcAddr()));
		}
		
		if(msg.get_rootId() == msg.get_srcAddr() && !syncPeriodTimeSeries.containsKey(msg.get_srcAddr())) {
			syncPeriodTimeSeries.put(msg.get_srcAddr(), new TimeSeries("node " + msg.get_srcAddr(), org.jfree.data.time.Second.class));
			syncPeriodTimeSeries.get(msg.get_srcAddr()).setMaximumItemAge(MAX_AGE);
			spc.getTimeSeriesCollection().addSeries(syncPeriodTimeSeries.get(msg.get_srcAddr()));
		}
		
		if(msg.get_srcAddr() != msg.get_rootId() && globalTimes.containsKey(msg.get_rootId()) && lastReceivedBeacons.get(msg.get_rootId()) == msg.get_beaconId()) {			
				timeSeries.get(msg.get_srcAddr()).addOrUpdate(seconds.get(msg.get_beaconId()), globalTimes.get(msg.get_rootId()) - msg.get_globalTime());
		}
		
		if(msg.get_srcAddr() == msg.get_rootId()) {
			syncPeriodTimeSeries.get(msg.get_srcAddr()).addOrUpdate(seconds.get(msg.get_beaconId()), (int) msg.get_syncPeriod()/1.024);
		}
	}


	public void messageReceived(int dest_addr, Message msg) {
		if (msg instanceof TestTtspMsg)
			processTtspMsg((TestTtspMsg)msg);
	}

	public static void main(String[] args) {
		TestTtsp ttsp = new TestTtsp();
		
		
		JFrame jframe = new JFrame("TTSP - Time Precision Error");
		ttsp.setPrecisionErrorChart(new PrecisionErrorChart());
		jframe.getContentPane().add(ttsp.getPrecisionErrorChart(), "Center");
		jframe.setBounds(200, 120, 600, 280);
		jframe.setVisible(true);
		jframe.addWindowListener(new WindowAdapter() {

			public void windowClosing(WindowEvent windowevent)
			{
				System.exit(0);
			}

		});

		JFrame jframe2 = new JFrame("TTSP - Synchronization Period");
		ttsp.setSyncPeriodChart(new SyncPeriodChart());
		jframe2.getContentPane().add(ttsp.getSyncPeriodChart(), "Center");
		jframe2.setBounds(200, 120, 600, 280);
		jframe2.setVisible(true);
		jframe2.addWindowListener(new WindowAdapter() {

			public void windowClosing(WindowEvent windowevent)
			{
				System.exit(0);
			}

		});		
		
		
		try {
			Thread.sleep(10000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
		}
 	}
}