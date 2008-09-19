typedef struct Event_Data{
	sim_event_t * tevent;
	struct Event_Data * next;
}Event_Data;

typedef struct Event_List{
	struct Event_Data *first;
}Event_List;

sim_time_t nodeTime;
bool noNode;

inline int adjust_queue(long long increase){
bool a = 1;
bool b = 0;
int prior=0;
Event_List list;
Event_Data *curr; 
Event_Data *prev;
long long increment=0;
list.first = (void *)0;
nodeTime=0;
noNode =1;
if(!sim_queue_is_empty () ){
	if( sim_time() <= sim_queue_peek_time()){
		//printf("Event Queue Unchanged\n");
		return 0;
	}
}
//printf("{  reading the queue\n");
while(!sim_queue_is_empty () ) { 
	
	

	sim_event_t * event = sim_queue_pop(); 
	if (current_node != event->mote){
		if(a){
			list.first = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ;
			list.first->tevent = event;
			curr=list.first;
			curr->next=(void *)0;
			a = 0;
		}
		else{
			curr->next = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ; 
			curr->next->tevent = event;
			curr = curr->next;
			curr->next=(void *)0;
		}
	}
	else{
		noNode = 0;
		if(  sim_time() <= event->time){
			if(a){
				list.first = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ;
				list.first->tevent = event;
				curr=list.first;
				curr->next=(void *)0;
				a = 0;
			}
			else{
				curr->next = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ; 
				curr->next->tevent = event;
				curr = curr->next;
				curr->next=(void *)0;
			}
			nodeTime = event->time;

			break;
		}
		else{
			if((currentPriority < event->priority) && (!isAtomic)){
				//printf("Event Preempted\n");
				prior = currentPriority;
				sim_queue_insert(event);
				sim_run_next_event();
				currentPriority = prior;
				//printf("Return from Preemption\n");
			}
			else{
				//printf("Event Delayed and Queue Rescheduled\n");
				event->time =  sim_time() + (++increment);
				//printf("%lld\n",event->time);
			
				if(a){
					list.first = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ;
					list.first->tevent = event;
					curr=list.first;
					curr->next=(void *)0;
					a = 0;
				}
				else{
					curr->next = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ; 
					curr->next->tevent = event;
					curr = curr->next;
					curr->next=(void *)0;
				}
			}
		}
		
	}
	if( sim_time() <= sim_queue_peek_time()){
			break;
	}

}

curr = list.first;
//printf("writing the queue\n");
increment=0;

while(curr != (void *)0 ) {
 
		if(curr->tevent->mote == sim_node())
			curr->tevent->time = sim_time() + (++increment);
		sim_queue_insert(curr->tevent ) ;
		prev = curr;
		curr= curr->next;
		free(prev);
		
		
}

//printf("writing done  }\n");
return 0;
}




inline int check_time(sim_time_t avr_time){
	//printf("%lld",sim_time());
	sim_time_t temp=((sim_time_t)avr_time * sim_ticks_per_sec());
    	temp /= 7372800ULL;			
	sim_set_time(sim_time()+temp);
	//printf("   %lld\n",sim_time());
		if (firstCall){
			firstCall = 0; 
			adjust_queue(temp);
		} 
		else{
			if(noNode) return 0;
			if((nodeTime != 0) && (nodeTime < sim_time())){
				adjust_queue(temp);
			}
			if(nodeTime == 0){
				adjust_queue(temp);
			}

                }		
	

return 0;
}

inline int adjust_queue_sch(long long increase){
bool a = 1;
bool b = 0;
int prior=0;
Event_List list;
Event_Data *curr; 
Event_Data *prev;
long long increment=0;
list.first = (void *)0;

if(!sim_queue_is_empty () ){
	if( sim_time() <= sim_queue_peek_time()){
		//printf("Event Queue Unchanged\n");
		return 0;
	}
}
//printf("{  reading the queue\n");
while(!sim_queue_is_empty () ) { 
	
	

	sim_event_t * event = sim_queue_pop(); 
	if (current_node != event->mote){
		if(a){
			list.first = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ;
			list.first->tevent = event;
			curr=list.first;
			curr->next=(void *)0;
			a = 0;
		}
		else{
			curr->next = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ; 
			curr->next->tevent = event;
			curr = curr->next;
			curr->next=(void *)0;
		}
	}
	else{

		if(  sim_time() <= event->time){
			if(a){
				list.first = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ;
				list.first->tevent = event;
				curr=list.first;
				curr->next=(void *)0;
				a = 0;
			}
			else{
				curr->next = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ; 
				curr->next->tevent = event;
				curr = curr->next;
				curr->next=(void *)0;
			}

			break;
		}
		else{
			
			
			event->time =  sim_time() + (++increment);
			if(a){
				list.first = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ;
				list.first->tevent = event;
				curr=list.first;
				curr->next=(void *)0;
				a = 0;
			}
			else{
				curr->next = ( Event_Data * ) malloc ( sizeof ( Event_Data ) ) ; 
				curr->next->tevent = event;
				curr = curr->next;
				curr->next=(void *)0;
			}
		}
		
	}
	if( sim_time() <= sim_queue_peek_time()){
			break;
	}

}

curr = list.first;
//printf("writing the queue\n");
increment=0;

while(curr != (void *)0 ) {
 
		if(curr->tevent->mote == sim_node())
			curr->tevent->time = sim_time() + (++increment);
		sim_queue_insert(curr->tevent ) ;
		prev = curr;
		curr= curr->next;
		free(prev);
		
		
}

//printf("writing done  }\n");
return 0;
}
inline int check_time_sch(sim_time_t avr_time){
	//printf("%lld",sim_time());
	sim_time_t temp=((sim_time_t)avr_time * sim_ticks_per_sec());
    	temp /= 7372800ULL;			
	sim_set_time(sim_time()+temp);
	//printf("   %lld\n",sim_time());
		adjust_queue_sch(temp);

return 0;
}

