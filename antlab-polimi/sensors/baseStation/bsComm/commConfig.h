/*
 * Author: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */
// NOTE: please "includes AM;" before including this file
#ifndef _RADIOBIGMSG_H_
#define _RADIOBIGMSG_H_
#define BIGMSG_HEADER_LENGTH 2
#define BIGMSG_DATA_SHIFT 6
#define BIGMSG_DATA_LENGTH (1<<BIGMSG_DATA_SHIFT)
#define VIDEO_DATA_LENGTH 100
#define TOSH_DATA_LENGTH  (BIGMSG_HEADER_LENGTH+VIDEO_DATA_LENGTH)

enum
{
	AM_RADIO_RADIOBIGMSG=7,
       AM_BIGMSG_FRAME_PART=0x6E,
       AM_BIGMSG_FRAME_REQUEST=0x6F,
       AM_VIDEO_FRAME_PART=0x70,
};

typedef nx_struct video_frame_part{
	nx_uint8_t frame_id;	
	nx_uint8_t part_id;
	nx_uint8_t buf[VIDEO_DATA_LENGTH];
} video_frame_part_t;

typedef nx_struct bigmsg_frame_part{
	nx_uint16_t part_id;
	nx_uint8_t buf[BIGMSG_DATA_LENGTH];
} bigmsg_frame_part_t;

typedef nx_struct bigmsg_frame_request{
	nx_uint16_t part_id;
	nx_uint16_t send_next_n_parts;
} bigmsg_frame_request_t;

typedef nx_struct video_frame_request{
	nx_uint8_t frame_id;	
	nx_uint8_t part_id;
	nx_uint8_t send_next_n_parts;
} video_frame_request_t;
#endif //_RADIOBIGMSG_H_


