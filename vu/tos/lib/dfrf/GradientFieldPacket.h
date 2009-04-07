#if !defined(__GRADIENTFIELDPACKET_H__)
#define __GRADIENTFIELDPACKET_H__

typedef nx_struct gradientfield_packet {
		nx_uint8_t seq;	// 0-3: pulse counter, 4-7: sequence number
		nx_uint16_t rootAddress;	// address of the root of the gradient field
		nx_uint8_t hopCount;	// hop count of the sender
} gradient_field_packet_t;

enum {
  APPID_GRADIENTFIELD = 0x71,
};

#endif /* __GRADIENTFIELDPACKET_H__ */

