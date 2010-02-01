#include <tossim.h>
#include <stdio.h>
#include <fstream>
#include <iostream>
using namespace::std;

#include <vector>

int main() {
 srand(time(NULL));

 Tossim* t = new Tossim(NULL);
 Radio* r = t->radio();
 t->addChannel("TestBVR", stdout);
// t->addChannel("BVR-debug", stdout);
// t->addChannel("S4-debug", stdout);
// t->addChannel("BVR", stdout);
// t->addChannel("S4UserRouter", stdout);
 t->addChannel("S4Router", stdout);
//  t->addChannel("S4-beacon", stdout);
// t->addChannel("S4-state-func", stdout); 

 fstream filestr;

 char nextLine[1024];

 std::vector<int> v;

 fstream filestr_noise;
 filestr_noise.open("meyer-heavy.txt", fstream::in);
   
 while (!filestr_noise.eof()) {
         filestr_noise.getline(nextLine, 1024);
         v.push_back(atoi(nextLine));
 }

 filestr_noise.close();

 fstream filestr2;
 filestr2.open ("grid-topology.txt", fstream::in );


 while (!filestr2.eof()) {
	 filestr2.getline(nextLine, 1024);
     char* s0 = strtok(nextLine, "\t");
     char* s1 = strtok( NULL, "\t");
     char* s2 = strtok( NULL, "\t");
     char* s3 = strtok( NULL, "\t");

     if (s0 == NULL)
       break;

	 if (!strncmp(s0, "gain", strlen(s0))) {
	    if ( atof(s3) > -104.0){
	       r->add(atoi(s1), atoi(s2), atof(s3));
	       std::cout << "Adding connection: "<< s1<< " "<< s2<< " "<< s3<<std::endl;
	     }
     }
	 else if (! strncmp(s0 , "noise", strlen(s0))){
	       t->getNode(atoi(s1))->bootAtTime(rand() % 1234567890);

	       std::cout << "Adding node: "<< s1<< " "<< s2<< " "<< s3<<std::endl;
              Mote* m = t->getNode(atoi(s1));
              for (int j = 0; j < v.size(); j++) {
                int noiseReading = v[j]; 
                m->addNoiseTraceReading(noiseReading);
                
              }
              m->createNoiseModel();

     }
  }

  std::cout << "Starting the simulation\n";
  int i = 0;
  while (t->time()/ t->ticksPerSecond() < 1500) {
      t->runNextEvent();
      //std::cout << t->time()/ t->ticksPerSecond() << std::endl;
  }

  printf("Ended\n");
}
