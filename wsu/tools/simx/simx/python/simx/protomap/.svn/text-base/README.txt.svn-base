ProtoMap provides a thin IO layer to manage asynchronous
BufferProtocol messages from multiple clients. It uses a simple
protocol and handles "RPC" through messages. It also handles in-line
resolving of PB message formats which avoids any explicit intermediate
object-resoluton step. ProtoMap only works through a reliable channel
(such as TCP) and, as such, employs no checksum or compression, and
only uses minimal framing.

Initial handshake:

When a client connects the server challenges with "PROTOMAPx" where x
represents the version encoded into a single byte, such that ASCII 'a'
represents version 1, 'b' represents 2, and so on.  If the client does
not accept the version it must disconnect. There is no provision for a
client to announce a reason for a disconnect prior the finishing the
handshake. After the initial handshake framing proceeds as follows:

The protocol format for version 1 of PROTOMAP is:

All fields are encoded in big-endian.

fixed header, 4 bytes
  high-byte   - flags
    bits 7:7  - 1 = "tracked message"
    bits 6:2  - unused
    bits 1:0  - 0 = "resolved message", 1 = "named message", 2/3 - unused
  low 3 bytes - length of packet, including header and options

options, variable bytes
  track, 2 bytes   - present iff "tracked message"
                     tracking id, never 0
  id, 2 bytes      - present iff "resolved message"
                     id mapping to ProtocolBuffer type
                     id's in the range [-1, -99] are for internal use
  nlen, 1 byte     - present iff "named message" (implies name)
  name, nlen bytes - present iff "named message"

payload, variable bytes - ProtocolBuffer message

ProtoMap operates in a peer-peer fashion. All clients can act as
servers and vice-versa. As a server, each program has a map
associating message names, IDs and handlers. As a client, each program
has a map from a particular message name to an ID.

Once a client connects to a server it can start sending and recieving
messages. If it attempts to send a message which does not currently
have a mapping, the message will be sent using the full PB name. Upon
receipt of a message using the full name, the server should respond
with the resolved ID, if it exists, or inform the client an unknown
message was transmitted. The client should then cache and use the
mapping information for future messages to the specific server.

If a client disconnects from a server it must forget all mappings and
all mappings /must/ be on a per-connection basis. This allows each
client to have a different mapping and voids needing to maintain a
global lookup.

Messages with IDs -1 to -99 are reserved for internal use.

-1: MessageRejected

The server rejected the message. This can occur for multiple reasons,
the most common being that the server does not know how to handle a
particular message.

-2: MappedName

Server response when a message sent with a PB name is used and a
mapping exists.
