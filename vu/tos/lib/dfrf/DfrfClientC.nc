generic configuration DfrfClientC(uint8_t appId, typedef payload_t, uint8_t uniqueLength, uint16_t bufferSize) {
  provides {
    interface StdControl;
    interface DfrfSend<payload_t>;
    interface DfrfReceive<payload_t>;
  }
  uses {
    interface DfrfPolicy as Policy;
  }
} implementation {
  components new DfrfClientP(payload_t, uniqueLength, bufferSize) as Client, DfrfEngineC as Engine;

  StdControl = Client;
  Client.SubDfrfControl -> Engine.DfrfControl[appId];
  Client.SubDfrfSend -> Engine.DfrfSend[appId];
  Client.SubDfrfReceive -> Engine.DfrfReceive[appId];

  DfrfSend = Client.DfrfSend;
  DfrfReceive = Client.DfrfReceive;

  Engine.DfrfPolicy[appId] = Policy;
}
