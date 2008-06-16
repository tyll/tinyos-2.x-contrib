SFDIR = $(TOSDIR)/../support/sdk/c/sf
JPGDIR = $(LGL_CONTRIB)/support/sdk/c/compress
APPDIR = $(LGL_CONTRIB)/apps/cameraMultiHop/camNode
BIGMSGDIR = $(LGL_CONTRIB)/libs/BigMsgCTP
EXE = fake_mote.exe

SRC = fake_mote.c
LIBS += -lmote
INCLS = -I. -I$(APPDIR) -I$(SFDIR) -I$(JPGDIR) -I$(BIGMSGDIR)

SRC += img_stat.c cmd_msg.c bigmsg_frame_part.c

CFLAGS += -DTOSH_DATA_LENGTH=100 -Wall -g

all: img_stat.h cmd_msg.h bigmsg_frame_part.h $(EXE)

img_stat.h:
	mig -target=null c $(APPDIR)/cameraJpegTest.h img_stat -o $@

cmd_msg.h:
	mig -target=null c $(APPDIR)/cameraJpegTest.h cmd_msg -o $@
	
bigmsg_frame_part.h:
	mig -DTOSH_DATA_LENGTH=100 -target=null c $(LGL_CONTRIB)/libs/BigMsgCTP/BigMsg.h bigmsg_frame_part -o $@

$(EXE): fake_mote.c
	$(CC) $(CFLAGS) $(INCLS) -o $(EXE) $(SRC) $(LIBS)

clean:
	$(RM) *.o *.a $(EXE) img_stat.* cmd_msg.* bigmsg_frame_part.*
