package com.rincon.tunit.report.charts;


/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import javax.imageio.ImageIO;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.DateAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.labels.StandardXYToolTipGenerator;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYItemRenderer;
import org.jfree.data.general.SeriesException;
import org.jfree.data.time.Minute;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;

/**
 * Write statistical data to a .png file
 * 
 * @author David Moss
 * 
 */
public class StatisticsChart {

  /**
   * Write statistical information to a .png file dictated by the data found in
   * a StatisticsLogData object.
   * 
   * @param data
   * @param width TODO
   * @param height TODO
   * @throws IOException
   */
  public static void write(StatisticsLogData data, int width, int height) throws IOException {
    final TimeSeries series1 = new TimeSeries(data.getUnits1(), Minute.class);

    StatsEntry focusedEntry;
    for (int i = 0; i < data.size(); i++) {
      focusedEntry = data.get(i);
      try {
        series1.add(new Minute(focusedEntry.getDate()), focusedEntry.getValue1());
      } catch (SeriesException e) {
        // Don't add two results for the same minute
      }

      // Duplicate this point so we can see it if it's the only point
      if (data.size() == 1) {
        series1.add(new Minute(focusedEntry.getDate()).next(), focusedEntry
            .getValue1());
      }
    }

    final TimeSeriesCollection dataset = new TimeSeriesCollection(series1);
    JFreeChart chart;

    if (data.hasTwoUnits()) {
      final TimeSeries series2 = new TimeSeries(data.getUnits2(), Minute.class);
      for (int i = 0; i < data.size(); i++) {
        focusedEntry = data.get(i);
        try {
          series2.add(new Minute(focusedEntry.getDate()), focusedEntry
              .getValue2());

        } catch (SeriesException e) {
          // Don't add two results for the same minute
        }

        // Duplicate this point so we can see it if it's the only point
        if (data.size() == 1) {
          series2.add(new Minute(focusedEntry.getDate()).next(), focusedEntry
              .getValue2());
        }
      }
      dataset.addSeries(series2);

      chart = ChartFactory.createXYAreaChart(data.getTitle(), "[Time]",
          "[Units]", dataset, PlotOrientation.VERTICAL, true, // legend
          true, // tool tips
          false // URLs
          );

    } else {
      chart = ChartFactory.createXYLineChart(data.getTitle(), "[Time]", data
          .getUnits1(), dataset, PlotOrientation.VERTICAL, false, // legend
          true, // tool tips
          false // URLs
          );
    }

    chart = formatChart(chart);
    chart.setBackgroundPaint(Color.white);
    chart.setBorderPaint(Color.black);
    chart.setBorderVisible(true);
    BufferedImage bufImg = chart.createBufferedImage(width, height);

    ImageIO.write(bufImg, "png", new File(data.getReportDir(), data.getTitle()
        + ".png"));

  }

  private static JFreeChart formatChart(final JFreeChart chart) {
    final XYPlot plot = chart.getXYPlot();
    plot.setBackgroundPaint(Color.WHITE);
    plot.setForegroundAlpha(0.65f);
    plot.setDomainGridlinePaint(Color.GRAY);
    plot.setRangeGridlinePaint(Color.GRAY);

    final ValueAxis domainAxis = new DateAxis("Time");
    domainAxis.setLowerMargin(0.0);
    domainAxis.setUpperMargin(0.0);
    domainAxis.setTickMarkPaint(Color.black);
    plot.setDomainAxis(domainAxis);
    plot.setForegroundAlpha(0.9f);

    final XYItemRenderer renderer = plot.getRenderer();
    renderer.setToolTipGenerator(new StandardXYToolTipGenerator(
        StandardXYToolTipGenerator.DEFAULT_TOOL_TIP_FORMAT,
        new SimpleDateFormat("MM/dd/yyyy hh:mm a"), new DecimalFormat(
            "#,##0.00")));

    return chart;
  }

}
