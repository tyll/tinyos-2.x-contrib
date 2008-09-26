

#ifndef NODE_Q_H_INCLUDED
#define NODE_Q_H_INCLUDED



/**************************
 * The queues in the run time system represent pending
 * incoming edges in the graph.  
 **************************/
#define QUEUE_DELAY 100
#define QUEUE_LENGTH 15
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



result_t
queue_init (EdgeQueue * q)
{
  	q->head = 0;
    q->tail = 0;
  
  return SUCCESS;
}

bool
isqueueempty (EdgeQueue * q)
{
  return (q->tail == q->head);
}

bool
enqueue (EdgeQueue * q, EdgeIn edge)
{
  bool result = FALSE;

    if (NEXT_IDX (q->tail) == q->head)
    {
		//queue is full
		result = FALSE;

 	} else {

		memcpy (&q->edges[q->tail], &edge, sizeof (EdgeIn));
		q->tail = NEXT_IDX (q->tail);
		result = TRUE;
    }

  return result;
}


bool
dequeue (EdgeQueue * q, EdgeIn * edge)
{
  bool result = FALSE;


  if (q->tail == q->head)
  {
	//queue is empty
	result = FALSE;
  } else {
	memcpy (edge, &q->edges[q->head], sizeof (EdgeIn));
	q->head = NEXT_IDX (q->head);
	result = TRUE;
  }
  

  return result;
}



#endif
