def sync_read(socket, size):
    """
    Perform a (temporary) blocking read.

    The amount read may be smaller than the amount requested if a
    timeout occurs.
    """
    timeout = socket.gettimeout()
    socket.settimeout(None)
    try:
        return socket.recv(size)
    finally:
        socket.settimeout(timeout)


def sync_write(socket, data):
    """
    Perform a (temporary) blocking write.
    """
    timeout = socket.gettimeout()
    socket.settimeout(None)
    try:
        while data:
            sent = socket.send(data)
            data = data[sent:]
    finally:
        socket.settimeout(timeout)
