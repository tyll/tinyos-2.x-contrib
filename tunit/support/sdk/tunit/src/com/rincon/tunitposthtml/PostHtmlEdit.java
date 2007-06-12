package com.rincon.tunitposthtml;

import java.io.File;

import com.rincon.tunit.TUnit;

/**
 * After Tunit Report runs, post-edit those reports to jack in png's.
 * @author David Moss
 *
 */
public class PostHtmlEdit {

  
  /**
   * Constructor
   *
   */
  public PostHtmlEdit() {
    TUnit tunit = new TUnit();
    new TraverseHtml(new File(TUnit.getBaseReportDirectory(), "/html"));
    System.out.println("TUnit Post HTML Edit Done");
  }
  
  /**
   * @param args
   */
  public static void main(String[] args) {
    org.apache.log4j.BasicConfigurator.configure();
    new PostHtmlEdit();
  }

}
