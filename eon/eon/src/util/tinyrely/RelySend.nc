includes TinyRely;

interface RelySend
{
  /**
   * Send a message
   *
   * @return SUCCESS if the buffer will be sent, FAIL if not. If
   * SUCCESS, a sendDone should be expected, if FAIL, the event should
   * not be expected.
   */
  command result_t send(uint8_t connid, RelySegmentPtr seg);

  /**
   * Signals that a buffer was sent; success indicates whether the
   * send was successful or not.
   *
   * @return ignored.
   *
   */
  event result_t sendDone(uint8_t connid, relyresult success);
}
