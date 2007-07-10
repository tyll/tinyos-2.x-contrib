TOS = ../../tos
PACKAGE = RobotCmd
APP=$(TOS)/../apps/TestMotorBoard
MIG = mig java
NCG = ncg java

# List of message classes to build
MSGS = RobotCmdMsg.java RobotAccelMsg.java NavigationMsg.java RC.java

INITIAL_TARGETS = $(MSGS)
OTHER_CLEAN = cleanmig

ROOT = ../
include $(ROOT)/Makefile.include

RobotCmdMsg.java:
	$(MIG) -java-classname=$(PACKAGE).RobotCmdMsg $(TOS)/lib/RobotCmdMsg.h RobotCmdMsg -o $@
	$(JAVAC) $@

RobotAccelMsg.java:
	$(MIG) -java-classname=$(PACKAGE).RobotAccelMsg $(TOS)/lib/RobotCmdMsg.h RobotAccelMsg -o $@
	$(JAVAC) $@

NavigationMsg.java:
	$(MIG) -java-classname=$(PACKAGE).NavigationMsg $(TOS)/lib/NavigationMsg.h NavigationMsg -o $@
	$(JAVAC) $@

RC.java:
	$(NCG) -java-classname=$(PACKAGE).RC $(TOS)/lib/MotorBoard.h MotorBoard.h RC -o $@
	$(JAVAC) $@

cleanmig:
	rm -f $(MSGS)

