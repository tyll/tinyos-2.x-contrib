Readme For Java Tool: commdata

Installation & Usage:
1. copy /commdata to tools/java/net/tinyos/
2. make
3. run commdata: 
   MOTECOM=serial@COMX:tmote java net.tinyos.commdata.commdata
4. click on any received msg in the upper subwindow, 
   the corresponding raw data will be showed in the lower subwindow.


User Notes:
1. the tool currently can identify the following msgs:
   ---------------------------------
   msg       typeNo    displayColor
   ---------------------------------
   Data       8         green
   Status     33        red
   Beacon     101       yellow
   ---------------------------------
   all the other msgs will be showed as "Unknown" msgs

   User can change the typeNo if necessary.
   [by searching "USER_DEFINE_START:" in commdata.java
    to find correct place for the definition of msg typeNo]

2. The tool will keep and display the latest 50 received msgs
   user can change it by changing the definition of "MAX_BUFFERED_MSG"
   in commdata.java
  
