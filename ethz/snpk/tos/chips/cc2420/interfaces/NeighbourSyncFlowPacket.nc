#include "message.h"

interface NeighbourSyncFlowPacket {
	/**
	 * set state of MORE_FLAG
	 * This command can only be applied to packets that do _not_ contain the neighboursync footer, e.g. higher
	 * layer components should access this interface
	 */
	command	void setMore(message_t* msg);
	command	void clearMore(message_t* msg);
}
