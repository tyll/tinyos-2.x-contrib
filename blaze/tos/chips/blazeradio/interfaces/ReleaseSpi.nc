

interface ReleaseSpi{

  async event void releaseSpi();
  
  async command void release(bool okay);

}


