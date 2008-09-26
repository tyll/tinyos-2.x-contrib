#ifndef SIMULATOR_H
#define SIMULATOR_H
#include <string>
#include <sys/types.h> 
#include <sys/stat.h> 
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <limits.h>
#include <float.h>
#include <iostream>
#include <fstream>
#include <stdlib.h>

using namespace std;

typedef struct
{
	int type;
	int64_t time;
	int64_t energy;
	int source;
	string request_types;
		
} event_t;

#define SIMULATOR
#define MYLONG_MAX 9223372036854775807LL
//#define MYLONG_MAX 0x7FFFFFFF

#define EVALUATE_ENERGY_POLICY	0
#define UPDATE_BATTERY			1
#define SERVICE_REQUEST			2
#define SERVICE_TIMER_NODE		3

#include <vector>
#include "evaluator.h"
#include "nodes.h"
#include <stdint.h>


//typedef null NULL;









void enter_into_log(string log_entry);
void run_request (int64_t request_time, int node_id, string request_types);
void update_power_level (event_t*);
void increase_battery(int64_t energy);

typedef struct
{
	string energy_profile;
	string::size_type current_index;
	string::size_type last_index;
	
	string get_next_line()
	{
		string ret;
		current_index = energy_profile.find('\n', last_index);
		if(current_index != string::npos)
		{
			ret = energy_profile.substr(last_index, current_index-last_index);
			last_index = current_index+1;
		}
		
		return ret;
	}
	
} energy_in_t;

typedef struct
{
	string energy_profile;
	string::size_type current_index;
	string::size_type last_index;
	
	string get_next_line()
	{
		string ret;
		current_index = energy_profile.find('\n', last_index);
		if(current_index != string::npos)
		{
			ret = energy_profile.substr(last_index, current_index-last_index);
			last_index = current_index+1;
		}
		return ret;
	}
	
} requests_in_t;

typedef struct
{
	string cost_profile;
	string::size_type current_index;
	string::size_type last_index;
	
	string get_next_line()
	{
		string ret;
		current_index = cost_profile.find('\n', last_index);
		if(current_index != string::npos)
		{
			ret = cost_profile.substr(last_index, current_index-last_index);
			last_index = current_index+1;
		}
		
		return ret;
	}
	
} pathcost_in_t;


pathcost_in_t* read_pathcost_in(char *file_name);


extern int64_t current_time;
extern int64_t current_battery_fullness;
extern int current_power_state;
extern double current_state_grade;
extern int64_t battery_capacity;
extern int64_t loss_per_unit_time;
extern int64_t energy_reeval_interval;
extern vector < string > *str_vector;
vector < event_t > *event_vector;
extern requests_in_t *requests_in;
extern energy_in_t *energy_in;
pathcost_in_t *pathcost_in;
extern FILE *fp;

vector < int64_t > path_costs[NUMPATHS] ;

void log(string str)
{
	enter_into_log(str);	
}


void load_path_costs()
{
	//cost format
	//pathid:val,val,val,val,val\n
	pathcost_in_t *costs = read_pathcost_in("costs");
	
	string newline = costs->get_next_line();
	string tmp;
	int pathnum;
	int64_t cost;
	
	
	
	while (!newline.empty())
	{
		string::size_type loc = newline.find( ":", 0 );
		if (loc != string::npos )
		{
			tmp = newline.substr(0, loc);
			pathnum = atoi((char *) tmp.c_str());
			newline.erase(0,loc+1);
			//printf("pathnum=%i\n",pathnum);
		} else {
			printf("Bad cost format\n");
			exit(1);
		}	
		
		do {
			loc = newline.find(",",0);
			if (loc != string::npos)
			{
				tmp = newline.substr(0,loc);
				cost = atoll((char*) tmp.c_str());
				newline.erase(0,loc+1);
				//insert cost
				path_costs[pathnum].push_back(cost);
				//printf("path_cost[%i] <- %lld\n",pathnum,cost);	
			}
		} while (loc != string::npos);
		newline = costs->get_next_line();
	}
	printf("Costs loaded\n");
}

void decrement_power_level (int path_sum ){
	
	int num_samples = path_costs[path_sum].size();
	
	if (num_samples == 0) return;
	
	int r = (rand() % num_samples);
	increase_battery(0-path_costs[path_sum].at(r));
	if (current_battery_fullness > 0)
	{
		eval_path_done(path_sum, current_power_state, path_costs[path_sum].at(r), current_time);
		//printf("decr_power(%i,%lld)\n",path_sum, path_costs[path_sum].at(r));
		char logmsg[256];
		sprintf(logmsg,"P:%lld:%d",current_time,path_sum);
		log(logmsg);
	}
}


pathcost_in_t* read_pathcost_in(char *file_name)
{
	int fd = open(file_name, O_RDONLY);
	struct stat buf;
	int err = fstat(fd, &buf);

	int file_size = buf.st_size;
	printf("%s File Size: %d\n", file_name, file_size);

	pathcost_in_t *ret = new pathcost_in_t;

	if (file_size > 0)
	  {
	   
	    char *read_it =(char *) mmap (0, file_size, PROT_READ, MAP_SHARED, fd, 0);
	
	    std::string str(read_it);


	    ret->cost_profile = str;
	    munmap(read_it, file_size);
	  } else {
	    ret->cost_profile = "";
	  }
	ret->current_index = 0;
	ret->last_index = 0;
	
	std::string::size_type curr_index = 0;
	std::string::size_type loc = 0;

	//printf("cost profile = %s\n",ret->cost_profile.c_str());

	close(fd);
	return ret;
}

requests_in_t* read_requests_in(char *file_name)
{
	int fd = open(file_name, O_RDONLY);
	struct stat buf;
	int err = fstat(fd, &buf);

	int file_size = buf.st_size;
	printf("%s File Size: %d\n", file_name, file_size);

	requests_in_t *ret = new requests_in_t;

	if (file_size > 0)
	  {
	   
	    char *read_it =(char *) mmap (0, file_size, PROT_READ, MAP_SHARED, fd, 0);
	
	    std::string str(read_it);


	    ret->energy_profile = str;
	    munmap(read_it, file_size);
	  } else {
	    ret->energy_profile = "";
	  }
	ret->current_index = 0;
	ret->last_index = 0;
	
	std::string::size_type curr_index = 0;
	std::string::size_type loc = 0;

	

	close(fd);
	return ret;
}



int get_tl_type(string &str)
{
	int ret = -1;
	string tmp;
	string::size_type loc = str.find( ":", 0 );
	if (loc != string::npos )
	{
		tmp = str.substr(0, loc);
		ret = atoi((char *) tmp.c_str());
		str.erase(0,loc+1);
	}
	return ret;
}

int64_t getTimerVal(int src, int state, double grade)
{
	int64_t max = timerVals[src][state][0];
	int64_t min = timerVals[src][state][1];
	
	double dmin = min;
	double dmax = max;
	double intval = (dmax + ((dmin-dmax)*(1-grade)));
	
	int64_t ret = (int64_t)intval;
	return ret;
}

int64_t get_tl_time(string &str)
{
	int64_t ret = MYLONG_MAX;
	string tmp;
	string::size_type loc = str.find( ":", 0 );
	if (loc != string::npos )
	{
		tmp = str.substr(0, loc);
		ret = atoll((char *) tmp.c_str());
	}
	return ret;
}

int64_t get_time(string str)
{
	int64_t ret = MYLONG_MAX;
	
	string::size_type loc = str.find( ":", 0 );
	if (loc != string::npos )
	{
		
		str = str.substr(0, loc);
		ret = atoll((char *) str.c_str());
	}
	return ret;
}

int64_t get_tl_time_erase(string &str)
{
	int64_t ret = MYLONG_MAX;
	string tmp;
	string::size_type loc = str.find( ":", 0 );
	if (loc != string::npos )
	{
		tmp = str.substr(0, loc);
		ret = atoll((char *) tmp.c_str());
		str.erase(0,loc+1);
	}
	return ret;
}


energy_in_t* read_energy_in(char *file_name)
{
	int fd = open(file_name, O_RDONLY);
	struct stat buf;
	int err = fstat(fd, &buf);
	
	int file_size = buf.st_size;
	printf("%s File Size: %d\n", file_name, file_size);
	char *read_it =(char *) mmap (0, file_size, PROT_READ, MAP_SHARED, fd, 0);
	
	std::string str(read_it);
	
	energy_in_t *ret = new energy_in_t;
	ret->energy_profile = str;
	ret->current_index = 0;
	ret->last_index = 0;
	
	std::string::size_type curr_index = 0;
	std::string::size_type loc = 0;
	
	munmap(read_it, file_size);

	close(fd);
	
	return ret;
}


/*
TODO: Eventually, I should be instering a "re-evaluate energy policy" function call somewhere around here...
*/
//vector<string>* make_timeline(energy_in_t *e_in, requests_in_t *r_in, char *output_file)
vector<string>* make_timeline(energy_in_t *e_in, requests_in_t *r_in)
{
	printf("making timeline...%d\n", sizeof(int64_t));
	
	
	vector<string> *ret = new vector<string>;
	//ret->push_back(string("alex"));
	string current_energy = e_in->get_next_line();
	string current_request = r_in->get_next_line();
	
	int64_t current_energy_time = get_time(current_energy);
	int64_t current_request_time = get_time(current_request);
	
	
	do
	{
		//printf("loop...%lld, %lld\n", current_request_time, current_energy_time);
		// if the next element is an "update energy element"
		if (current_energy_time < current_request_time)
		{
			// print to file current_energy
			
			
			char buf[64];
			sprintf(buf, "%d:", UPDATE_BATTERY);
			string str = string(buf) + current_energy;
			ret->push_back(str);
			
			//log(str);
			// get the next energy input reading
			
			//fprintf(fp, "%s\n", current_energy.c_str());
			//fprintf(fp, "%s\n", str.c_str());
			if (!current_energy.empty())
			{

				current_energy = e_in->get_next_line();
				//printf("\"%s\" before\n",current_energy.c_str());
				current_energy_time = get_time(current_energy);
				//printf("\"%s\" -> %lld\n",current_energy.c_str(), current_energy_time);
			}
			else
			{
				current_energy_time = MYLONG_MAX;
			}
		}
		else if (current_request_time != MYLONG_MAX)
		{
			//printf("now, here\n");
			// print to file current_request
			char buf[64];
			sprintf(buf, "%d:", SERVICE_REQUEST);
			string str = string(buf) + current_request;
			ret->push_back(str);
			//log(str);
			
			// get the next request
			if (!current_request.empty())
			{
				current_request = r_in->get_next_line();
				current_request_time = get_time(current_request);
			}
			else
			{
				current_request_time = MYLONG_MAX;
			}
		}
		//printf("loop...%s, %s\n", current_request.c_str(), current_energy.c_str());
	}while( !current_energy.empty() || !current_request.empty());
	printf("end loop...\n");
	return ret;
}



void decrement_idle (int64_t timestamp)
{
  static int64_t diff = 0;
  int64_t delta;
  
  
  diff += (timestamp - current_time);
  current_time = timestamp;
  if (diff < (15 * 60 * 1000)) //accumulate over 15 minutes
  	{
  		return;
  	}
  delta = ((diff * loss_per_unit_time) / 60000) * (-1);
  increase_battery(delta);
  diff = 0;
  
}

void increase_battery(int64_t energy){
	char buf[512];
	int64_t newfullness = current_battery_fullness + energy;
	int64_t waste=0;
	
	eval_increase_battery(energy);
	if (newfullness > battery_capacity)
	{
		waste += newfullness - battery_capacity;
		newfullness = battery_capacity;
	}
	if (newfullness < 0){
		newfullness=  0;
	}
	if (newfullness != current_battery_fullness || waste != 0)
	{
		sprintf(buf,"%lld:%lld:%lld",current_time, newfullness,waste);
		log(buf);
	}
	current_battery_fullness = newfullness;
}

void update_power_level(event_t* event){
	int64_t energy_source_power = event->energy;
	increase_battery(energy_source_power);
	eval_more_energy(energy_source_power, event->time);
}

void insert_event(vector < event_t* > * time_line, event_t *event, int index)
{
	vector< event_t* >::iterator it = time_line->begin() + index;
	
	//printf("event_str=%s\n",event.c_str());
	
	event_t* tmp = *it;
	int ctype = tmp->type;
	int64_t ctime = tmp->time;
	
	
	
	int etype = event->type;
	int64_t event_time = event->time;
	
	//printf("etype = %d, etime = %lld\n",etype, event_time);
	//printf("ctype = %d, ctime = %lld\n",ctype, ctime);
	while (it != time_line->end() && ctime <= event_time)
	{
		it++;
		if (it == time_line->end()) break;
		tmp = *it;
		
		ctype = tmp->type;
		ctime = tmp->time;
		//printf("e = (%i,%f)...c=(%i,%f)\n", etype, event_time, ctype, ctime);
	}
	//insert here
	time_line->insert(it, event);
	
}

void start_eval(vector < event_t* > *time_line)
{
//	char buf[512];
//	sprintf(buf, "%d:%d:0", 
//				EVALUATE_ENERGY_POLICY, 0);
	event_t *neweval = new event_t;
	neweval->type = EVALUATE_ENERGY_POLICY;
	neweval->time = 0;
	insert_event(time_line, neweval, 0);
}

void insert_eval(vector < event_t* > *time_line, int64_t time, int64_t index)
{
	//char buf[512];
	int64_t newtime = time + energy_reeval_interval;
	//sprintf(buf, "%d:%lld:0:", 
	//			EVALUATE_ENERGY_POLICY, newtime);
				
	event_t *neweval = new event_t;
	neweval->type = EVALUATE_ENERGY_POLICY;
	neweval->time = newtime;
	insert_event(time_line, neweval, index);
	
}

void start_timers(vector < event_t* > *time_line)
{

	int64_t timertime = 0;
	int64_t interval;
	//	char newtimerstr[512];
	
	
	int src_id;
	int node_id;
	int i;
	
	for (i=0; i < NUMSOURCES; i++)
	{
		if (srcNodes[i][0])
		{
			//it's timed
			//get interval
			printf("gTV(%i,%i,%f)\n",i,current_power_state, current_state_grade);
			printf("i=%d\n",i);
			interval = getTimerVal(i, current_power_state, current_state_grade);
			printf("i=%d\n",i);
			printf("gTV done(%lld)\n",interval);
			//sprintf(newtimerstr, "%d:%lld:%d:", 
			//	SERVICE_TIMER_NODE, timertime+interval, i);
			event_t *newtimer = new event_t;
			newtimer->type = SERVICE_TIMER_NODE;
			newtimer->time = timertime+interval;
			newtimer->source = i;
			
			printf("i=%d\n",i);
			//printf("insert(%s)\n",newtimerstr);
			insert_event(time_line, newtimer, 0);	
			printf("i=%d\n",i);
			printf("insert_event done\n");
			printf("i=%d\n",i);
		}
	}
}

void service_timer(event_t* event, 
					vector < event_t* > * time_line, 
					int index)
{
	//string timerstr = str;
	int64_t timertime = event->time;
	int64_t interval;
	//char newtimerstr[512];
	//char runstr[512];
	
	event_t* newtimer = new event_t;
	
	int src_id = event->source;
	int node_id = srcNodes[src_id][1];
	
	//sprintf(runstr, "%lld:%i:", 
	//		timertime, node_id);
	
	run_request(timertime, node_id, event->request_types);
	
	//need to insert next timer
	//get interval
	interval = getTimerVal(src_id, current_power_state, current_state_grade);
	
	//sprintf(newtimerstr, "%i:%lld:%i:", 
	//		SERVICE_TIMER_NODE, timertime+interval, src_id);
	newtimer->time = timertime+interval;
	newtimer->type = SERVICE_TIMER_NODE;
	newtimer->source = src_id;
	
	insert_event(time_line, newtimer, index);
	//printf("service_timer %s,%i\n",str.c_str(), index);
}


vector<event_t*> *convert_timeline(vector <string> *time_line)
{
	int i;
	vector < event_t *> *ret = new vector < event_t * >;
	for (i=0; i < time_line->size(); i++)
  	{
  		string str = time_line->at(i);
  		//convert to event_t
  		event_t *evt = new event_t;
  		evt->type = get_tl_type(str);
	  	evt->time = get_tl_time(str);
	  	
	  	string::size_type loc, loc2;
	  	
	  	switch (evt->type)
	    {
	    case UPDATE_BATTERY:
	      	loc = str.find(":", 0);
			if(loc != string::npos)
			{
				//string power_time_string = str.substr(0, loc);
				string energy_source_power_str = str.substr(loc+1);
				evt->energy = atoll(energy_source_power_str.c_str());
			} else {
				printf("ERROR PARSING UPDATE BATTERY!");
			}
	      break;
	    case SERVICE_REQUEST:
	    	
	    	loc = str.find(":", 0);
	    	loc2 = str.find(":", loc+1);
			if(loc != string::npos && loc2 != string::npos)
			{
				//string time_string = str.substr(0, loc);
				string src_str = str.substr(loc+1,loc2);
				string type_str = str.substr(loc2);
				evt->source = atoi(src_str.c_str());
				evt->request_types = type_str;
			} else {
				printf("ERROR PARSING SERVICE REQUEST!");
			}
	      	
	      	break;
	    case SERVICE_TIMER_NODE:
	    	loc = str.find(":", 0);
			if(loc != string::npos && loc2 != string::npos)
			{
				//string time_string = str.substr(0, loc);
				string src_str = str.substr(loc+1);
				evt->source = atoi(src_str.c_str());
			} else {
				printf("ERROR PARSING TIMER REQUEST!");
			}
	    	break;
	    case EVALUATE_ENERGY_POLICY:
	    	break;
	    }//switch
	    ret->push_back(evt);
	  	
  	}
  	return ret;
}


void parse_timeline (vector < string > *time_line, int64_t max_time)
{
  int size = time_line->size ();
  int i = 0;
  vector < event_t* > *newtime_line;
  //convert from strings to event_t
  
  printf("converting timeline...\n", max_time);
  newtime_line = convert_timeline(time_line);
  
  printf("starting sim...(%lld ms)\n", max_time);
  init_evaluator();
  printf("init_e\n");
  //insert initial timers
  start_timers(newtime_line);
  start_eval(newtime_line);
  
  /*for (i=0; i < time_line->size(); i++)
  {
  	log(time_line->at(i));
  }
  exit(1);*/
  
  while (i < newtime_line->size() && current_time < max_time)
    {
      event_t* current_event = newtime_line->at (i);
      //log(current_string);
		// now we get the type of the event
	  int event_type = current_event->type;
	  int64_t event_time = current_event->time;
	  
	  
	  decrement_idle(event_time);
	  switch (event_type)
	    {
	    case UPDATE_BATTERY:
	      update_power_level (current_event);
	      break;
	    case SERVICE_REQUEST:
	      run_request (current_event->time, current_event->source, current_event->request_types);
	      break;
	    case SERVICE_TIMER_NODE:
	    	service_timer(current_event, newtime_line, i);
	    	break;
	    case EVALUATE_ENERGY_POLICY:
	      {
	      	printf("eval policy\n");
			energy_evaluation_struct_t *eval_result =
		  	reevaluate_energy_level (newtime_line, i,
					   current_battery_fullness);
			current_power_state = eval_result->energy_state;
			current_state_grade = eval_result->state_grade;
			increase_battery(eval_result->cost_of_reevaluation);
			insert_eval(newtime_line, event_time, i);
			
			char logmsg[256];
			sprintf(logmsg,"E:%lld:%d:%lf",event_time, 
								current_power_state, current_state_grade);
			log(logmsg);
			fflush(stdout);
			usleep(10000);
			delete eval_result;
			break;
	      }
	    default:
	      printf ("Invalid option selected\n");
	      break;
	    }
	
	i++;
    }
  printf ("Simulation Over \n");
  printf ("battery left: %lld\n", current_battery_fullness);
  printf ("Percentage battery left: %lld\n",
	  ((current_battery_fullness * 100) / battery_capacity));
}

#endif
