TOSDIR = /opt/tinyos-2.x/tos
SFDIR = $(TOSDIR)/../support/sdk/c/sf
APPDIR = $(LGL_CONTRIB)/apps/cameraMultiHop/camNode
JPGDIR = $(LGL_CONTRIB)/support/sdk/c/compress
CAMCMDDIR = $(LGL_CONTRIB)/support/sdk/c/camera_cmd

EXE = get_jpg
SRC = get_jpg.c

INCLS = -I. -I$(APPDIR) -I$(JPGDIR) -I$(CAMCMDDIR) -I$(SFDIR)
LIBS += $(CAMCMDDIR)/libcamera_cmd.a $(SFDIR)/libmote.a -ljpeg
CFLAGS += -g -Wall

all: get_jpg

$(CAMCMDDIR)/libcamera_cmd.a:
	@echo building ${CAMCMDDIR}
	@cd ${CAMCMDDIR} && make && cd ${APPDIR}/../c

$(SFDIR)/libmote.a:
	@echo !!!!!! WARNING - c based comm lib not found !!!!!!
	@echo please build ${SFDIR}
	exit 1

get_jpg: get_jpg.c $(CAMCMDDIR)/libcamera_cmd.a $(SFDIR)/libmote.a
	$(CC) $(CFLAGS) -o $(EXE) $(SRC) $(INCLS) $(LIBS)

clean:
	rm *.exe *.jpg
