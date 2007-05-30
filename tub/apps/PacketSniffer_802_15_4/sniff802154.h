#ifndef SNIFF802154_H
#define SNIFF802154_H

enum {
  AM_RAW_PKT_T = 215,				/* AM id for Serial packet which contains a raw radio packet as payload */
  AM_CONTROL_PKT_T = 2,			/* AM id for Serial packet containing control information as payload (i.e. #channel) */
};

typedef nx_struct control_pkt_t {
  nx_uint8_t channel; 						/* which channel to listen on */
} control_pkt_t;

typedef nx_struct raw_pkt_t {
  nx_uint8_t PHR_length;					/* PHR: length (of PSDU) field in the phy header */
  nx_uint8_t PSDU_buffer[]; 			/* PSDU: MAC data fields (variable) 
                            				 The last two bytes of PSDU do not represent FCFS,
  																	 They represent the following:
  																		...(MPDU)... | RSSI (8bit) | CRC_OK (1bit) | Correlation (7bit) |
                            			*/
} raw_pkt_t;

#endif
