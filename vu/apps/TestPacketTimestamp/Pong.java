public class Pong {
  PongMsg pongMsg;

  public Pong(PongMsg m) {
    setPongMsg(m);
  }

  public void setPongMsg(PongMsg m) {
    this.pongMsg = m;
  }

  public PongMsg getPongMsg() {
    return this.pongMsg;
  }

}
