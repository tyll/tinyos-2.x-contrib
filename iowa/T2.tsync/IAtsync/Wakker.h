typedef struct {
   uint8_t  id;        // id of client application
   uint8_t  indx;      // user's index for the alarm
   uint32_t wake_time; // in 1/8 seconds;  ffffffff => inactive
   } sched_list;
// The following is the maximum number of wakeups scheduled
// initial guess:  4 * the number of clients (on average, each
// client has at most three alarms scheduled) 
enum { ALRM_slots = 4*uniqueCount("Wakker") };  
