/****************************************************************************\
*                                       
*                                Written by
*                     Tom Wagner (wagner@cs.umass.edu)
*                  at the Distributed Problem Solving Lab
*       Department of Computer Science, University of Massachusetts,
*                            Amherst, MA 01003
*                                     
*        Copyright (c) 1995 UMASS CS Dept. All rights are reserved.
*                                     
*           Development of this code was partially supported by:
*                        ONR grant N00014-92-J-1450
*                         NSF contract CDA-8922572
*                                      
* ---------------------------------------------------------------------------
* 
* This code is free software; you can redistribute it and/or modify it.
* However, this header must remain intact and unchanged.  Additional
* information may be appended after this header.  Publications based on
* this code must also include an appropriate reference.
* 
* This code is distributed in the hope that it will be useful, but 
* WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
* or FITNESS FOR A PARTICULAR PURPOSE.
* 
\****************************************************************************/

#ifndef SEMAPHORES
#define SEMAPHORES

#include <stdio.h>
#include <stdlib.h> 
#include <pthread.h>

#ifndef pthread_mutexattr_default
#define pthread_mutexattr_default NULL
#endif

#ifndef pthread_condattr_default
#define pthread_condattr_default NULL
#endif

typedef struct Semaphore
{
    int         v;
    pthread_mutex_t mutex;
    pthread_cond_t cond;
} Semaphore;


int         semaphore_down (Semaphore * s);
int         semaphore_decrement (Semaphore * s);
int         semaphore_up (Semaphore * s);
void        semaphore_destroy (Semaphore * s);
void        semaphore_init (Semaphore * s);
int         semaphore_value (Semaphore * s);
int         tw_pthread_cond_signal (pthread_cond_t * c);
int         tw_pthread_cond_wait (pthread_cond_t * c, pthread_mutex_t * m);
int         tw_pthread_mutex_unlock (pthread_mutex_t * m);
int         tw_pthread_mutex_lock (pthread_mutex_t * m);
void        do_error (char *msg);

#endif
