GEN=Frame_partMsg.java CmdMsg.java

CAMERA_H=../camera.h

all: camera.jar

camera.jar: Camera.class
	jar cf $@ *.class

Frame_partMsg.java: $(CAMERA_H)
	mig -target=null -java-classname=Frame_partMsg java $(CAMERA_H) frame_part -o $@

CmdMsg.java: $(CAMERA_H)
	mig -target=null -java-classname=CmdMsg java $(CAMERA_H) cmd_msg -o $@

Constants.java: $(CAMERA_H)
	ncg -target=null -java-classname=Constants java $(CAMERA_H) camera.h -o $@

Camera.class: $(wildcard *.java) $(GEN)
	javac *.java

clean:
	rm -f *.class $(GEN)

veryclean: clean
	rm camera.jar
