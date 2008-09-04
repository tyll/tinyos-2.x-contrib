package com.rincon.tunit.run;

import java.io.IOException;

import org.apache.log4j.Logger;

import com.rincon.tunit.TUnit;
import com.rincon.tunit.exec.CmdExec;
import com.rincon.tunit.report.TestReport;
import com.rincon.tunit.report.TestResult;

public class CmdFlagExecutor {

  /** Logging */
  private static Logger log = Logger.getLogger(CmdFlagExecutor.class);
  
  /**
   * Execute any suite.properties @cmd flag if settings are correct.
   * 
   * @param type "start", "run", or "stop" only. This gets reported to the user.
   * @param command The command to run, i.e. "cmd /c dir" or "/bin/sh [blah]"
   * @param report The report to save results to
   */
  protected static void executeCmdFlag(String type, String command, TestReport report) {
    if(TUnit.isCmdFlagEnabled() && !command.matches("")) {
      log.info("Running " + type + " cmd: " + command);
      try {
        String output = CmdExec.outputToString(CmdExec.runBlockingCommand(command));
        
        TestResult result = new TestResult("@cmd " + type + " " + command + " " + output);
        
        
        if(CmdExec.lastExitVal > 0) {
          log.error(output);
          result.error("@cmd " + type + " error", "Exit value was " + CmdExec.lastExitVal + " when executing: @cmd " + type + " " + command + "\n\n" + output);
          
        } else {
          log.info(output);
        }
        
        report.addResult(result);
        report.addSystemOut("@cmd " + type + " " + command + "\n" + output);
        
      } catch (IOException e) {
        log.fatal("Fatal error running " + type + " cmd " + command
            + "\n" + e.getMessage() + "\n" + e.getStackTrace());
        TestResult result = new TestResult("@cmd " + type + " " + command);
        result.error("@cmd execution error", "Fatal error running @cmd " + type + ": " + command);
        report.addResult(result);
      }
    }
  }
  
}
