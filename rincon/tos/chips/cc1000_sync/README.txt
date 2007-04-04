This is an experimental version of a CC1000 synchronous low power listening
stack.  This has not been updated in awhile.  It's possible to take this
stack and use it as a starting point to continue testing and making improvements.
We stopped development of this stack after getting it pretty stable because
the CC2420 became top priority.

MessageTransport is actually the CC2420's "PacketLink".  Also notice that
CC1000ActiveMessageC doesn't really give you preprocessor options like
the CC2420 stack does to add or remove layers from the stack. From what
I recall, it was clean-up stuff like that that was required before
finalizing this stack.

