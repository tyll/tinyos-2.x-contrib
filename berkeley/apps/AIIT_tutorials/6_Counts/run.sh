#!/bin/sh
if cygpath -w / >/dev/null 2>/dev/null; then
  CLASSPATH="PrintCounterReading.jar;$CLASSPATH"
else
  CLASSPATH="PrintCounterReading.jar:$CLASSPATH"
fi

java PrintCounterReading -comm serial@/dev/ttyUSB0:telos
