module Mrf24PacketC
{
  provides
  {
    interface Mrf24PacketBody;
  }
}
implementation
{
  async command mrf24_header_t * ONE Mrf24PacketBody.getHeader(message_t * ONE msg)
  {
    return TCAST(mrf24_header_t* ONE, 
        (uint8_t*)msg + offsetof(message_t, data) - sizeof(mrf24_header_t));
  }

  async command mrf24_metadata_t * ONE Mrf24PacketBody.getMetadata(message_t * ONE msg)
  {
    return (mrf24_metadata_t*)msg->metadata;
  }
}
