/** This header file sets the values of the priorities of messages, and defines the size 
  * of the message queue
  *
  * @author jch
  */


#ifndef __PRIORITY_H__
#define __PRIORITY_H__

typedef uint8_t priority_t;


enum{

  P_LOWEST = 0,
  P_1, 
  P_2, 
  P_3,
  P_4,
  P_HIGHEST,

};

enum {

  QUEUE_SIZE = 5,

};

typedef struct queue_t{

  message_t* msg;
  uint8_t addr;
  uint8_t amId;
  uint8_t priority;
  uint8_t len;

} queue_t;



#endif