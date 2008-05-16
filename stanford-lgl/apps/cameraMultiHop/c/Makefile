TOSDIR = /opt/tinyos-2.x/tos
SFDIR = $(TOSDIR)/../support/sdk/c/sf
APPDIR = $(LGLDIR)/apps/cameraMultiHop/camNode
JPGDIR = $(LGLDIR)/support/sdk/c/compress
CAMCMDDIR = $(LGLDIR)/support/sdk/c/camera_cmd

EXE = get_jpg
CAMSRC = $(CAMCMDDIR)/camera_cmd.c $(CAMCMDDIR)/img_stat.c $(CAMCMDDIR)/cmd_msg.c $(CAMCMDDIR)/bigmsg_frame_part.c
SRC = get_jpg.c
SRC += $(CAMSRC)
SRC += $(JPGDIR)/jpegUncompress.c $(JPGDIR)/huffmanUncompress.c

INCLS = -I. -I$(APPDIR) -I$(JPGDIR) -I$(CAMCMDDIR) -I$(SFDIR)
LIBS += $(SFDIR)/libmote.a -ljpeg
CFLAGS += -g -Wall

all: get_jpg

$(CAMSRC):
	@echo building ${CAMCMDDIR}
	@cd ${CAMCMDDIR} && make && cd -

$(SFDIR)/libmote.a:
	@echo !!!!!! WARNING - c based comm lib not found !!!!!!
	@echo please build ${SFDIR}
	exit 1

get_jpg: get_jpg.c $(CAMSRC) $(SFDIR)/libmote.a
	$(CC) $(CFLAGS) -o $(EXE) $(SRC) $(INCLS) $(LIBS)

clean:
	rm *.exe *.jpg
