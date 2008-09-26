

#ifndef SCHEDULER_H_INCLUDED
#define SCHEDULER_H_INCLUDED



/**************************
 * The queues in the run time system represent pending
 * incoming edges in the graph.  
 **************************/
#define QUEUE_DELAY 100
#define QUEUE_LENGTH 5
#define NEXT_IDX(X) ((X + 1) % QUEUE_LENGTH)

typedef struct EdgeIn
{
  uint8_t src_id;		//This limits the number of nodes to 2^8.
  uint8_t dst_id;
  bool src;
  uint8_t idx;
  //these are being removed to allow better concurrency management
  //uint8_t *invar;
  //uint8_t *outvar;
} EdgeIn;

typedef struct EdgeQueue
{
  uint8_t head, tail;
  //uint16_t lock;
  EdgeIn edges[QUEUE_LENGTH];
} EdgeQueue;



#endif
