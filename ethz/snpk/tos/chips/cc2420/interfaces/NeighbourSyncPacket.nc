#include "message.h"

interface NeighbourSyncPacket {

/**
 * return state of MORE_FLAG
 * This command can only be applied to packets that still contain the neighboursync footer
 **/
	command	bool isMore(message_t* msg);

}
