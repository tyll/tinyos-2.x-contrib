#!/bin/sh
if cygpath -w / >/dev/null 2>/dev/null; then
  CLASSPATH="PrintReadingArr.jar;$CLASSPATH"
else
  CLASSPATH="PrintReadingArr.jar:$CLASSPATH"
fi

java PrintReadingArr -comm serial@/dev/ttyUSB0:telos
