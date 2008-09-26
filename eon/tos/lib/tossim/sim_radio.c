#include <sim_radio.h>


radio_entry_t* connectivity[TOSSIM_MAX_NODES + 1];


radio_entry_t* sim_radio_allocate_link(int mote);
void sim_radio_deallocate_link(radio_entry_t* linkToDelete);

radio_entry_t* sim_radio_first(int src)
{
  if (src > TOSSIM_MAX_NODES) {
    return connectivity[TOSSIM_MAX_NODES];
  } 
  return connectivity[src];
}

radio_entry_t* sim_radio_next(radio_entry_t* currentLink)
{
  return currentLink->next;
}

void sim_radio_add(int src, int dest, int cap, double energy_per_pkt, sim_time_t expires)
{
  radio_entry_t* current;
  int temp = sim_node();
  if (src > TOSSIM_MAX_NODES) {
    src = TOSSIM_MAX_NODES;
  }
  sim_set_node(src);

  current = sim_radio_first(src);
  while (current != NULL) {
    if (current->mote == dest) {
      sim_set_node(temp);
      break;
    }
    current = current->next;
  }

  if (current == NULL) {
    current = sim_radio_allocate_link(dest);
    current->next = connectivity[src];
    connectivity[src] = current;
  }
  current->mote = dest;
  current->cap = cap;
  current->energy_per_pkt = energy_per_pkt;
  current->expires = expires;
  //dbg("Gain", "Adding link from %i to %i with capacity %i and energy/pkt %f uJ (expires %i)\n", src, dest, cap, energy_per_pkt,expires);
  sim_set_node(temp);
}

int sim_radio_capacity(int src, int dest)
{
  radio_entry_t* current;
  int temp = sim_node();
  sim_set_node(src);
  current = sim_radio_first(src);
  while (current != NULL) {
    if (current->mote == dest) {
      sim_set_node(temp);
      if (current->expires <= sim_time())
	{
		sim_radio_remove(src,dest);
		//dbg("Gain", "Link expired from %i to %i\n", src, dest);
		return 0;
	}
      //dbg("Gain", "Getting link from %i to %i with capacity %i\n", src, dest, current->cap);
      return current->cap;
    }
    current = current->next;
  }
  sim_set_node(temp);
  //dbg("Gain", "No link from %i to %i\n", src, dest);
  return 0;
}



void sim_radio_set_capacity(int src, int dest, int newcap)
{
  radio_entry_t* current;
  int temp = sim_node();
  sim_set_node(src);
  current = sim_radio_first(src);
  while (current != NULL) {
    if (current->mote == dest) {
      sim_set_node(temp);
      if (current->expires <= sim_time())
	{
		sim_radio_remove(src,dest);
		//dbg("Gain", "Link expired from %i to %i\n", src, dest);
		return;
	}
      //dbg("Gain", "Setting link from %i to %i to capacity %i\n", src, dest, newcap);
      current->cap = newcap;
      return;
    }
    current = current->next;
  }
  sim_set_node(temp);
  //dbg("Gain", "No link from %i to %i\n", src, dest);
  return;
}


bool sim_radio_consume_capacity(int src, int dest, int delta)
{
  radio_entry_t* current;
  int temp = sim_node();
  sim_set_node(src);
  current = sim_radio_first(src);
  while (current != NULL) {
    if (current->mote == dest) {
      sim_set_node(temp);
      if (current->expires <= sim_time())
	{
		sim_radio_remove(src,dest);
		//dbg("Gain", "Link expired from %i to %i\n", src, dest);
		return FALSE;
	}
      //dbg("Gain", "Setting link from %i to %i to capacity %i\n", src, dest, newcap);
      if (current->cap < delta) return FALSE;
      current->cap -= delta;
      
      if (current->cap == 0)
      {
      	sim_radio_remove(src,dest);
      }
      
      return TRUE;
    }
    current = current->next;
  }
  sim_set_node(temp);
  //dbg("Gain", "No link from %i to %i\n", src, dest);
  return FALSE;
}


bool sim_radio_connected(int src, int dest)
{
  radio_entry_t* current;
  int temp = sim_node();
  sim_set_node(src);
  current = sim_radio_first(src);
  while (current != NULL) {
    if (current->mote == dest && current->cap > 0 && current->expires > sim_time()) {
      sim_set_node(temp);
      return TRUE;
    }
    current = current->next;
  }
  sim_set_node(temp);
  return FALSE;
}
  
void sim_radio_remove(int src, int dest)
{
  radio_entry_t* current;
  radio_entry_t* prevLink;
  int temp = sim_node();
  
  if (src > TOSSIM_MAX_NODES) {
    src = TOSSIM_MAX_NODES;
  }

  sim_set_node(src);
    
  current = sim_radio_first(src);
  prevLink = NULL;
    
  while (current != NULL) {
    radio_entry_t* tmp;
    if (current->mote == dest) {
      if (prevLink == NULL) {
	connectivity[src] = current->next;
      }
      else {
	prevLink->next = current->next;
      }
      tmp = current->next;
      sim_radio_deallocate_link(current);
      current = tmp;
    }
    else {
      prevLink = current;
      current = current->next;
    }
  }
  sim_set_node(temp);
}


radio_entry_t* sim_radio_allocate_link(int mote) {
  radio_entry_t* newLink = (radio_entry_t*)malloc(sizeof(radio_entry_t));
  newLink->next = NULL;
  newLink->mote = mote;
  newLink->cap = 1;
  newLink->energy_per_pkt = 0.01;
  newLink->expires = 0;
  return newLink;
}

void sim_radio_deallocate_link(radio_entry_t* linkToDelete)
{
  free(linkToDelete);
}

