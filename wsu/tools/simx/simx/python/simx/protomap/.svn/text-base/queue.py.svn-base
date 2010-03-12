from Queue import Queue

from warnings import warn


class QueueFullWarning(RuntimeWarning):
    """
    Warning issued when queue if full.
    """
    def __init__(self, queue):
        RuntimeWarning.__init__(self, "%s is full: dropping message" % queue)


class FifoQueue(Queue):
    """
    Like Queue, but discards old items if the capacity is reached.
    """
    def __init__(self, size, name="queue"):
        Queue.__init__(self, size)
        self.queue_name = name

    def fifo_put(self, item):
        """
        Put an item on the queue. Issues a warning and discards the
        oldest item if the capacity is reached.
        """
        if self.full():
            warn(QueueFullWarning(self.queue_name))
            self.get()
        self.put(item)
