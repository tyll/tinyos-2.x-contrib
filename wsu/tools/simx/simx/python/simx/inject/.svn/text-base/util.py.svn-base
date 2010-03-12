TRIGGER_MAGIC = 'tt'
SFCLIENT_MAGIC = 'U '


def is_trigger(magic):
    """
    Is this trigger magic?
    """
    return magic == TRIGGER_MAGIC


def is_sfclient(magic):
    """
    Is this sf-client magic?
    """
    return len(magic) >= 2 and magic[0] == SFCLIENT_MAGIC[0]


def sync_read(socket, size):
    """
    Perform a (temporary) blocking read. The amount read may be
    smaller than the amount requested if a timeout occurs.
    """
    timeout = socket.gettimeout()
    socket.settimeout(None)
    try:
        return socket.recv(size)
    finally:
        socket.settimeout(timeout)
