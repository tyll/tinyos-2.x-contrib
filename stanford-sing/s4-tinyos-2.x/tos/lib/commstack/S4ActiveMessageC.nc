module S4ActiveMessageC {
  provides {
    interface AMPacket;
    interface Packet;
    interface PacketAcknowledgements;
  }
  uses {
    interface AMPacket as S4AMPacket;
    interface Packet as S4Packet;
    interface SplitControl;
    interface PacketAcknowledgements as S4Acks;

  }
}

implementation {
  
  event void SplitControl.startDone(error_t err){
  
  }
  
  event void SplitControl.stopDone(error_t err){
    
  }
  
  command am_addr_t AMPacket.address(){
    return call S4AMPacket.address();
  }

  command am_group_t AMPacket.group(message_t* amsg) {
    return call S4AMPacket.group(amsg);

  }

  command void AMPacket.setGroup(message_t* msg, am_group_t group) {
    return call S4AMPacket.setGroup(msg, group);

  }

  command am_group_t AMPacket.localGroup() {
    return call S4AMPacket.localGroup();
  }

  
  command am_addr_t AMPacket.destination(message_t *amsg){
    return call S4AMPacket.destination(amsg);
  }
  
  command bool AMPacket.isForMe(message_t *amsg) {
    return call S4AMPacket.isForMe(amsg);
  }

  command void AMPacket.setDestination(message_t *amsg, am_addr_t addr){
    return call S4AMPacket.setDestination(amsg, addr);
  }
  
  command void AMPacket.setType(message_t *amsg, am_id_t t){
    return call S4AMPacket.setType(amsg, t);
  }
  
  command am_id_t AMPacket.type(message_t *amsg){
    return call S4AMPacket.type(amsg);
  }

  command am_addr_t AMPacket.source(message_t *amsg){
      return call S4AMPacket.source(amsg);
  }

  command void AMPacket.setSource(message_t *amsg, am_addr_t addr){
      return call S4AMPacket.setSource(amsg, addr);
  }
  
  
  command void Packet.setPayloadLength(message_t *msg, uint8_t len) {
    return call S4Packet.setPayloadLength(msg, len);
  }
  
  command uint8_t Packet.payloadLength(message_t *msg) {
      return call S4Packet.payloadLength(msg);
  }
  
  command uint8_t Packet.maxPayloadLength() {
    return call S4Packet.maxPayloadLength();
  }

  command void* Packet.getPayload(message_t *msg, uint8_t len){
    return call S4Packet.getPayload(msg, len);
  }

  command void Packet.clear(message_t *msg) {
    return call S4Packet.clear(msg);
  }
  
  async command error_t PacketAcknowledgements.noAck(message_t *msg){
    return call S4Acks.noAck(msg);
  }
  
  async command error_t PacketAcknowledgements.requestAck(message_t *msg){
    return call S4Acks.requestAck(msg);
  }
  
  async command bool PacketAcknowledgements.wasAcked(message_t *msg) {
    return call S4Acks.wasAcked(msg);
  }

}
