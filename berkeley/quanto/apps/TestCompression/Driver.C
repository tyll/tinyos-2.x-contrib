#include <tossim.h>

int main() {
	Tossim* t = new Tossim(NULL);
	t->addChannel("TC", stdout);
	Mote* m = t->getNode(0);
	m->bootAtTime(1);
	for (int i = 0; i < 1000000; i++) {
		t->runNextEvent();
	}
}
