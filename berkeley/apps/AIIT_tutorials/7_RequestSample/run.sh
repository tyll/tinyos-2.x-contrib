#!/bin/sh
if cygpath -w / >/dev/null 2>/dev/null; then
  CLASSPATH="RequestReading.jar;$CLASSPATH"
else
  CLASSPATH="RequestReading.jar:$CLASSPATH"
fi

java RequestReading -comm serial@/dev/ttyUSB0:telos
