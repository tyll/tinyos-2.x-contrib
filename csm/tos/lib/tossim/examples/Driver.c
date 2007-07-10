#include <stdio.h>
#include <tossim.h>
#include <SerialForwarder.h>
#include <Throttle.h>
#include <radio.h>
#include <math.h>
#include <unistd.h>

int main() {
 Tossim* t = new Tossim(NULL);
 t-> init();

 Throttle throttle(t, 10);
 SerialForwarder sf(9001);

 for (int i = 0; i < 1; i++) {
   Mote* m = t->getNode(i);
   m->bootAtTime(rand() % t->ticksPerSecond());
 }


 t->addChannel("Serial", stdout);
 t->addChannel("TestSerialC", stdout);
 t->addChannel("Atm128AlarmC", stdout);

 Radio* r = t->radio();
 for (int i = 0; i < 1; i++) {
    r->setNoise(i, -105.0, 1.0);
   for (int j = 0; j < 1; j++) {
      r->add(i, j, -96.0 - (double)abs(i - j));
      r->add(j, i, -96.0 - (double)abs(i - j));
   }
 }

sf.process();

 throttle.initialize();
 while(t->time() < 600 * t->ticksPerSecond()) {
   throttle.checkThrottle();
   sf.process();
   t->runNextEvent();
 }
}
