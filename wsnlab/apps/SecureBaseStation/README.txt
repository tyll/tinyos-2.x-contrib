SECURE BASESTATION
is a modification of the standard BaseStation application that enables hardware encryption of messages sent over the air.


> To enable the security, define 'SECURE=Y' e.g. inside the Makefile or while typing the make command (e.g. SECURE=Y make telosb install,0).

> Default key is contained into "secure_key.h" and must match the key used by the remote nodes.

> NOTE: SecureBaseStation requires the latest T2 branch with CC2420 security support, 
        which can be downloaded from the GIT repository: http://hinrg.cs.jhu.edu/git/?p=jgko/tinyos-2.x.git
        using the command "git clone git://hinrg.cs.jhu.edu/git/jgko/tinyos-2.x.git"


Please refer to the standard BaseStation README for further details.


Known bugs: SecRadioPacket.payloadLength command seems to not work properly (see in-code comments).
            As a workaround, no matter what is the length of a message received from the radio, 
            it will be forwarded to the serial port as if it had the max allowed length. 
            Therefore, developers must take that into account (e.g. by including an additional "payload length" field which will contain the actual data length),
            particularly when the application uses variable-length data messages.
            This bug is only present when the security is enabled.

Known uses: The SPINE Framework v1.3 (http://spine.tilab.com)
