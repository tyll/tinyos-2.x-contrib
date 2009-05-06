#TOSDIR = /opt/tinyos-2.x/tos
SFDIR = $(TOSDIR)/../support/sdk/c/sf
APPDIR = $(LGL_CONTRIB)/apps/cameraMultiHop/camNode
JPGDIR = $(LGL_CONTRIB)/support/sdk/c/compress
EXE = camera_cmd_test
LIB = libcamera_cmd.a

SRC = camera_cmd_test.c
LIBS += $(LIB) -lmote -ljpeg
INCLS = -I. -I$(APPDIR) -I$(JPGDIR) -I$(SFDIR)

LIBSRC = camera_cmd.c
LIBSRC += img_stat.c cmd_msg.c status.c bigmsg_frame_part.c
LIBSRC += $(JPGDIR)/jpegUncompress.c $(JPGDIR)/huffmanUncompress.c
LIBOBJS += camera_cmd.o
LIBOBJS += img_stat.o cmd_msg.o status.o bigmsg_frame_part.o
LIBOBJS += jpegUncompress.o huffmanUncompress.o

CFLAGS += -DTOSH_DATA_LENGTH=100 -Wall

all: img_stat.h cmd_msg.h status.h bigmsg_frame_part.h $(LIB) $(EXE)

img_stat.h:
	mig -target=null c $(APPDIR)/cameraJpegTest.h img_stat -o $@

cmd_msg.h:
	mig -target=null c $(APPDIR)/cameraJpegTest.h cmd_msg -o $@
	
status.h:
	mig -target=null c $(APPDIR)/cameraJpegTest.h status -o $@

bigmsg_frame_part.h:
	mig -DTOSH_DATA_LENGTH=100 -target=null c $(LGL_CONTRIB)/libs/BigMsgCTP/BigMsg.h bigmsg_frame_part -o $@

camera_cmd.o: camera_cmd.c
	$(CC) -c $(CFLAGS) $(LIBSRC) $(INCLS)

$(LIB): camera_cmd.o
	ar cru $(LIB) $(LIBOBJS)
	ranlib $(LIB)

$(EXE): camera_cmd_test.c $(LIB)
	$(CC) $(CFLAGS) -o $(EXE) $(SRC) $(LIBS) $(INCLS)

install:
	install -d /usr/local/lib /usr/local/include /usr/local/bin
	install -m 755 $(EXE) /usr/local/bin
	install -m 644 $(LIB) /usr/local/lib
	install -m 644 camera_cmd.h /usr/local/include

clean:
	$(RM) *.o *.a $(EXE) img_stat.* cmd_msg.* status.* bigmsg_frame_part.*
