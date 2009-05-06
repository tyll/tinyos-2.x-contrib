GEN=Bigmsg_frame_partMsg.java CmdMsg.java ImgStatMsg.java Constants.java

CAMERA_H=../cameraJpegTest.h
BIGMSG_H=../../../libs/BigMsg/BigMsg.h

all: camera.jar

camera.jar: Camera.class
	jar cf $@ *.class

Bigmsg_frame_partMsg.java: $(BIGMSG_H)
	mig -target=null -java-classname=Bigmsg_frame_partMsg java $(BIGMSG_H) bigmsg_frame_part -o $@

CmdMsg.java: $(CAMERA_H)
	mig -target=null -java-classname=CmdMsg java $(CAMERA_H) cmd_msg -o $@

ImgStatMsg.java: $(CAMERA_H)
	mig -target=null -java-classname=ImgStatMsg java $(CAMERA_H) img_stat -o $@

Constants.java: $(CAMERA_H)
	ncg -target=null -java-classname=Constants java $(CAMERA_H) camera.h -o $@

Camera.class: $(wildcard *.java) $(GEN)
	javac *.java

clean:
	rm -f *.class $(GEN)

veryclean: clean
	rm camera.jar
