SECURE BASESTATION 
is a modification of the standard BaseStation application that enables hardware encryption of messages sent over the air.


> To enable the security, define 'SECURE=Y' e.g. inside the Makefile or while typing the make command (e.g. SECURE=Y make telosb install,0).

> Default key is contained into "secure_key.h" and must match the key used by the remote nodes.



Please refer to the standard BaseStation README for further details.



Known uses: The SPINE Framework v1.3 (http://spine.tilab.com)
