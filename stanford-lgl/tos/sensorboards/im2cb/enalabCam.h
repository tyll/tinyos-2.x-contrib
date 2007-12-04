#ifndef _IM2CB_H
#define _IM2CB_H

#define MAX_HEIGHT			240
#define MAX_WIDTH			320
#define BYTES_PER_PIXEL		2
#define FRAME_BUF_SIZE		MAX_HEIGHT*MAX_WIDTH*BYTES_PER_PIXEL	// 16-bit color
#define FRAME_SIZE			sizeof(frame_t)

#define WINDOW_HZERO	0x1A
#define WINDOW_VZERO	0x03
#define WINDOW_HMAX		0xBA
#define WINDOW_VMAX		0xF3

typedef struct {
	uint16_t height;			// height of frame in pixels
	uint16_t width;				// width of fram in pixels
	uint8_t color;				// color model (defined by .h file for OV)
	uint32_t size;				// image size in bytes
	uint32_t time_stamp;		// frame timestamp
} __attribute__ ((packed)) frame_header_t;

typedef struct {
	frame_header_t *header;		// frame header
	uint32_t size;				// frame buffer size
	uint8_t *buf;				// frame buffer
} frame_t;

typedef struct {
	uint16_t x;
	uint16_t y;
	uint16_t width;
	uint16_t height;
} __attribute__ ((packed)) window_t;

#endif /* _IM2CB_H */
