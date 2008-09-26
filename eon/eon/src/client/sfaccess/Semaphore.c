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

#include "Semaphore.h"


/*
 * function must be called prior to semaphore use.
 *
 */
void
semaphore_init (Semaphore * s)
{
    s->v = 1;
    if (pthread_mutex_init (&(s->mutex), pthread_mutexattr_default) == -1)
     do_error ("Error setting up semaphore mutex");

    if (pthread_cond_init (&(s->cond), pthread_condattr_default) == -1)
     do_error ("Error setting up semaphore condition signal");
}

/*
 * function should be called when there is no longer a need for
 * the semaphore.
 *
 */
void
semaphore_destroy (Semaphore * s)
{
    if (pthread_mutex_destroy (&(s->mutex)) == -1)
     do_error ("Error destroying semaphore mutex");

    if (pthread_cond_destroy (&(s->cond)) == -1)
     do_error ("Error destroying semaphore condition signal");
}

/*
 * function increments the semaphore and signals any threads that
 * are blocked waiting a change in the semaphore.
 *
 */
int
semaphore_up (Semaphore * s)
{
    int         value_after_op;

    tw_pthread_mutex_lock (&(s->mutex));

    (s->v)++;
    value_after_op = s->v;

    tw_pthread_mutex_unlock (&(s->mutex));
    tw_pthread_cond_signal (&(s->cond));

    return (value_after_op);
}

/*
 * function decrements the semaphore and blocks if the semaphore is
 * <= 0 until another thread signals a change.
 *
 */
int
semaphore_down (Semaphore * s)
{
    int         value_after_op;

    tw_pthread_mutex_lock (&(s->mutex));
    while (s->v <= 0)
    {
     tw_pthread_cond_wait (&(s->cond), &(s->mutex));
    }

    (s->v)--;
    value_after_op = s->v;

    tw_pthread_mutex_unlock (&(s->mutex));

    return (value_after_op);
}

/*
 * function does NOT block but simply decrements the semaphore.
 * should not be used instead of down -- only for programs where
 * multiple threads must up on a semaphore before another thread
 * can go down, i.e., allows programmer to set the semaphore to
 * a negative value prior to using it for synchronization.
 *
 */
int
semaphore_decrement (Semaphore * s)
{
    int         value_after_op;

    tw_pthread_mutex_lock (&(s->mutex));
    s->v--;
    value_after_op = s->v;
    tw_pthread_mutex_unlock (&(s->mutex));

    return (value_after_op);
}

/*
 * function returns the value of the semaphore at the time the
 * critical section is accessed.  obviously the value is not guarenteed
 * after the function unlocks the critical section.  provided only
 * for casual debugging, a better approach is for the programmar to
 * protect one semaphore with another and then check its value.
 * an alternative is to simply record the value returned by semaphore_up
 * or semaphore_down.
 *
 */
int
semaphore_value (Semaphore * s)
{
    /* not for sync */
    int         value_after_op;

    tw_pthread_mutex_lock (&(s->mutex));
    value_after_op = s->v;
    tw_pthread_mutex_unlock (&(s->mutex));

    return (value_after_op);
}

/* -------------------------------------------------------------------- */
/* The following functions replace standard library functions in that   */
/* they exit on any error returned from the system calls.  Saves us     */
/* from having to check each and every call above.                      */
/* -------------------------------------------------------------------- */


int
tw_pthread_mutex_unlock (pthread_mutex_t * m)
{
    int         return_value;

    if ((return_value = pthread_mutex_unlock (m)) == -1)
     do_error ("pthread_mutex_unlock");

    return (return_value);
}

int
tw_pthread_mutex_lock (pthread_mutex_t * m)
{
    int         return_value;

    if ((return_value = pthread_mutex_lock (m)) == -1)
     do_error ("pthread_mutex_lock");

    return (return_value);
}

int
tw_pthread_cond_wait (pthread_cond_t * c, pthread_mutex_t * m)
{
    int         return_value;

    if ((return_value = pthread_cond_wait (c, m)) == -1)
     do_error ("pthread_cond_wait");

    return (return_value);
}

int
tw_pthread_cond_signal (pthread_cond_t * c)
{
    int         return_value;

    if ((return_value = pthread_cond_signal (c)) == -1)
     do_error ("pthread_cond_signal");

    return (return_value);
}


/*
 * function just prints an error message and exits 
 *
 */
void
do_error (char *msg)
{
    perror (msg);
    exit (1);
}

