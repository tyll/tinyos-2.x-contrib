#!/bin/sh
if cygpath -w / >/dev/null 2>/dev/null; then
  CLASSPATH="PrintReading.jar;$CLASSPATH"
else
  CLASSPATH="PrintReading.jar:$CLASSPATH"
fi

java PrintReading -comm serial@/dev/ttyUSB0:telos
