This package connects with the TinyOS Progress Indicator library

The Progress Indicator library allows a mote to send an update(..) command
to its progress component, which is sent only over UART and heard
by this Java class.  

Each MoteProgressListener must implement the MoteProgressListener
interface, and register itself with the MoteProgressProvider
along with the application ID to listen for.  The FileTransfer
component's BulkTransfer has its own application ID registered
with its Progress component's parameterized interface, which
will get forwarded on to the appropriate listener on the Java end.

This allows the developer to implement separately updated progress meters
depending on which components are installed to the mote.

@author David Moss

