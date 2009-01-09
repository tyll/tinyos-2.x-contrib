#include <TinyError.h>
#include <message.h>
#include <AM.h>

interface Socket {
	command void init();
	command error_t sendB(uint8_t id,am_addr_t addr, message_t* msg, uint8_t len);
}
