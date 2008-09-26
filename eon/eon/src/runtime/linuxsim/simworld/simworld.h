#ifndef SIM_WORLD_H
#define SIM_WORLD_H

#include <pthread.h>

#define ACTION_USER 10
#define ENERGY_TIME 5 //seconds in between energy updates

typedef void (*__energyfunc) (int, int, unsigned int);

extern unsigned int predict_src_energy(unsigned int hours);

extern unsigned int get_current_time();

extern void log_output(int action, const char *template, ...);


extern int set_energy_callback(__energyfunc func);

extern int get_sensor_reading();

extern int recv_network_int(unsigned int to_seconds, int *timedout);

extern void send_network_int(int value);

//THREAD FUNCTIONS

int sim_pthread_create (pthread_t *__restrict __threadp,
			   __const pthread_attr_t *__restrict __attr,
			   void *(*__start_routine) (void *),
			   void *__restrict __arg);

void __attribute__((noreturn)) sim_pthread_exit(void *value_ptr);

unsigned int sim_sleep (unsigned int __seconds);

int sim_usleep (__useconds_t __useconds);

#endif

