

#include <tossim.h>
#include <sf/SerialForwarder.h>
#include <sf/Throttle.h>
#include <map>
#include <utility>

using namespace std;

int main(int argc, char **argv) {
  Tossim* t = new Tossim(NULL);
  SerialForwarder *sf = new SerialForwarder(9001);
  map<int, int> motes; 
  map<int, int>::const_iterator iter;
  Throttle *throttle = new Throttle(t, 1);
  t->init();

  FILE *tables = fopen("table.txt", "w");
  FILE *flows = fopen("flows.txt", "w");
  //FILE *am = fopen("am.txt", "w");

  //t->addChannel("Scheduler", fdopen(1, "w"));
  //t->addChannel("TossimPacketModelC", fdopen(1, "w"));
  //t->addChannel("LedsC", fdopen(1, "w"));
  //t->addChannel("AM", am);
/*   t->addChannel("Acks", stdout); */
  //t->addChannel("Boot", stdout);
/*   t->addChannel("base", stdout); */
/*   t->addChannel("printf", stdout); */
/*   t->addChannel("Debug", stdout); */
/*   t->addChannel("Unique", stdout); */
/*   t->addChannel("SNRLoss", stdout); */
  //t->addChannel("CpmModelC", stdout);
  //t->addChannel("PacketLink", stdout);
  //t->addChannel("Lqi", stdout);
/*   t->addChannel("Footer", stdout); */
  t->addChannel("Drops", stdout);
  t->addChannel("Evictions", stdout);
  t->addChannel("Install", stdout);
  t->addChannel("Table", tables);
  t->addChannel("Flows", flows);
  t->addChannel("Test", stdout);
/*   t->addChannel("Status", stdout); */
  
  Radio* r = t->radio();
  
  FILE *fp = fopen(argv[1], "r");
  int from, to, noise;
  float gain;
  int maxNode;
  while (fscanf(fp, "gain\t%i\t%i\t%f\n", &from, &to, &gain) != EOF) {
    r->add(from, to, gain);
    motes[from] = 1;
    motes[to] = 1;
  }
  fclose(fp);


  throttle->initialize();

  // fp = fopen("casino-lab.txt", "r");
  fp = fopen("meyer-heavy.txt", "r");
  int i = 0;
  while(fscanf(fp,"%i\n", &noise) != EOF && i++ < 1000) {
    for (iter = motes.begin(); iter != motes.end(); ++iter ) {
      t->getNode(iter->first)->addNoiseTraceReading(noise);
    }
  }
  fclose(fp);

  for (iter = motes.begin(); iter != motes.end(); ++iter ) {
    printf("creating noise model for %i\n", iter->first);
    t->getNode(iter->first)->createNoiseModel();
  }
  for (iter = motes.begin(); iter != motes.end(); ++iter ) {
    printf("booting mote %i\n", iter->first);
    t->getNode(iter->first)->bootAtTime((31 + t->ticksPerSecond() / 10) * iter->first + 1);
  }                           

  sf->process();
  for (;;) {
    //throttle->checkThrottle();
    t->runNextEvent();
    sf->process();
  }
}
