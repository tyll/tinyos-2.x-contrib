/* 
 * additional HCI
 */

#ifndef __ADDITIONAL_HCI_H
#define __ADDITIONAL_HCI_H 
 
/* -----  HCI Commands ----- */
/* Additional OGF & OCF values */
 

//Inquiry result format with RSSI 7.3.54
#define OCF_WRITE_INQUIRY_MODE 0x0045
#define STD_INQ_RESULT 0x00
#define RSSI_INQ_RESULT 0x01
#define OCF_WRITE_INQUIRY_SCAN_TYPE 0x0043

#define OCF_WRITE_DEFAULT_LINK_POLICY	0x000F
typedef struct {
	uint16_t	policy;
} __attribute__ ((packed)) write_default_link_policy_cp;
#define WRITE_DEFAULT_LINK_POLICY_CP_SIZE 2

#define OCF_PERIODIC_INQ_MODE	0x0003
typedef struct {
	uint16_t 	max_period_len;
	uint16_t 	min_period_len;
	uint8_t     lap[3];
	uint8_t     inq_len;
	uint8_t     num_responses;
} __attribute__ ((packed)) periodic_inq_mode_cp;
#define PERIODIC_INQ_MODE_CP_SIZE 9

#endif
 