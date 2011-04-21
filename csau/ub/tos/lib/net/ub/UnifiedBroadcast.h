
/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 6 2010
 */

#ifndef UNIFIEDBROADCAST_H
#define UNIFIEDBROADCAST_H

enum {
	AM_UNIFIEDBROADCAST_MSG = 131,
};

typedef struct broadcast_data {
	nx_uint8_t len; // length of id + data
	nx_am_id_t id;
	nx_uint8_t* data;
} broadcast_data_t;

//int broadcast_add(broadcast_data_t* data, void* buf, uint8_t len, uint8_t offset);
//int broadcast_extract(broadcast_data_t* data, void* buf, uint8_t len, uint8_t offset);

/*typedef struct broadcast_message {
	nx_uint8_t data[TOSH_DATA_LENGTH];
	} broadcast_message_t;*/


#endif


