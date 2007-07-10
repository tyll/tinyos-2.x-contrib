
#ifndef  _THROTTLE_H_
#define  _THROTTLE_H_


#include <errno.h>
#include <time.h>
#include <sys/time.h>
#include "tossim.h"

class Throttle {

    public:

        Throttle(Tossim* tossim, const int ms);
        ~Throttle();

        void initialize();
        void finalize();

        void checkThrottle();
        void printStatistics();

    private:

        double simStartTime;
        double simEndTime;
        double simPace;

        Tossim* sim;

        long throttleCount;

        double getTime();
        double toDouble(struct timeval* tv);
        int simSleep(double seconds);
};
#endif   // ----- #ifndef _THROTTLE_H_  ----- 
