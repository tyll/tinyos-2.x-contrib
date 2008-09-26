

#ifndef NODE_Q_H_INCLUDED
#define NODE_Q_H_INCLUDED



/**************************
 * The queues in the run time system represent pending
 * incoming edges in the graph.  
 **************************/
#define QUEUE_DELAY 3
#define QUEUE_LENGTH 30
#define NEXT_IDX(X) ((X + 1) % QUEUE_LENGTH)

typedef struct EdgeIn
{
  uint16_t node_id;		//This limits the number of nodes to 2^16.
  uint8_t **invar;
  uint8_t **outvar;
} EdgeIn;

typedef struct EdgeQueue
{
  uint16_t head, tail;
  uint16_t lock;
  EdgeIn edges[QUEUE_LENGTH];
} EdgeQueue;

bool
lockqueue (EdgeQueue * q)
{
  bool gotset = FALSE;
  atomic
  {
    if (q->lock == FALSE)
      {
	gotset = TRUE;
	q->lock = TRUE;
      }
  }				//atomic
  return gotset;
}

bool
unlockqueue (EdgeQueue * q)
{
  if (q->lock == FALSE)
    {
      return FALSE;
    }
  q->lock = TRUE;
  return TRUE;
}

result_t
queue_init (EdgeQueue * q)
{
  atomic
  {
    q->head = 0;
    q->tail = 0;
  }
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



  atomic
  {

    if (NEXT_IDX (q->tail) == q->head)
      {
	//queue is full
	result = FALSE;

      }
    else
      {

	memcpy (&q->edges[q->tail], &edge, sizeof (EdgeIn));
	q->tail = NEXT_IDX (q->tail);
	result = TRUE;
      }
  }				//atomic
  return result;
}


bool
dequeue (EdgeQueue * q, EdgeIn * edge)
{
  bool result = FALSE;


  atomic
  {
    if (q->tail == q->head)
      {
	//queue is empty
	result = FALSE;
      }
    else
      {

	memcpy (edge, &q->edges[q->head], sizeof (EdgeIn));
	q->head = NEXT_IDX (q->head);
	result = TRUE;
      }
  }				//atomic

  return result;
}



#endif
