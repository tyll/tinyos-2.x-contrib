#ifndef _UART_RAW_MSG_H
#define _UART_RAW_MSG_H

// The reason for this being more complicated than necessary is
// for efficiency 
// We divide a single type byte to indicate the type of the record,
//  i.e., the way to access the union, and also a subtype within each
//  type. 
enum {
    MSG_TYPE_SINGLE_CHG = 0,
    MSG_TYPE_MULTI_CHG  = 1,
    MSG_TYPE_COUNT_EV   = 2,
    MSG_TYPE_POWER_CHG  = 3,
    MSG_TYPE_FLUSH_REPORT = 4,

    MSG_TYPE_OFFSET = 4,

    SINGLE_CHG_NORMAL = 1,
    SINGLE_CHG_ENTER_INT = 2, 
    SINGLE_CHG_EXIT_INT = 3,
    SINGLE_CHG_BIND = 4,
 
    MULTI_CHG_ADD = 1,
    MULTI_CHG_REM = 2,
    MULTI_CHG_IDL = 3,
 
    //"Exported" constants
    //Context changes for single-context resources
    TYPE_SINGLE_CHG_NORMAL    = (MSG_TYPE_SINGLE_CHG << MSG_TYPE_OFFSET) | SINGLE_CHG_NORMAL,
    TYPE_SINGLE_CHG_ENTER_INT = (MSG_TYPE_SINGLE_CHG << MSG_TYPE_OFFSET) | SINGLE_CHG_ENTER_INT,
    TYPE_SINGLE_CHG_EXIT_INT  = (MSG_TYPE_SINGLE_CHG << MSG_TYPE_OFFSET) | SINGLE_CHG_EXIT_INT,
    TYPE_SINGLE_CHG_BIND      = (MSG_TYPE_SINGLE_CHG << MSG_TYPE_OFFSET) | SINGLE_CHG_BIND,
    //Context changes for multi-context resources
    TYPE_MULTI_CHG_ADD = (MSG_TYPE_MULTI_CHG << MSG_TYPE_OFFSET) | MULTI_CHG_ADD,
    TYPE_MULTI_CHG_REM = (MSG_TYPE_MULTI_CHG << MSG_TYPE_OFFSET) | MULTI_CHG_ADD,
    TYPE_MULTI_CHG_IDL = (MSG_TYPE_MULTI_CHG << MSG_TYPE_OFFSET) | MULTI_CHG_IDL,
    //Power-state changes
    TYPE_POWER_CHG = MSG_TYPE_POWER_CHG << MSG_TYPE_OFFSET,
    //Count of events of a particular type.
    TYPE_COUNT_EV = MSG_TYPE_COUNT_EV << MSG_TYPE_OFFSET,
    TYPE_FLUSH_REPORT = MSG_TYPE_FLUSH_REPORT << MSG_TYPE_OFFSET,
    
    QUANTO_LOG_AM_TYPE = 55,
    AM_NX_ENTRY_T = QUANTO_LOG_AM_TYPE,
};


//12 bytes per entry.
typedef struct entry_t {
    uint8_t type;       //type of the entry, see enum above
    uint8_t res_id;     //resource id this entry refers to
    uint32_t time;      //local time of the node
    uint32_t ic;        //icount
    union {
        uint16_t act;         //for single and multiple act changes
        uint16_t powerstate;  //for powerstate changes
        uint16_t event_count; //for count entries
    };
} entry_t;

#ifndef _QUANTO_C
typedef nx_struct nx_entry_t {
    //nx_union {
        nx_uint8_t type;       //type of the entry, see enum above
        //nx_union {
            //nx_uint8_t entry_type:4;
            //nx_uint8_t entry_subtype:4;
        //};
    //};
    nx_uint8_t res_id;     //resource id this entry refers to
    nx_uint32_t time;      //local time of the node
    nx_uint32_t ic;        //icount
    nx_uint16_t arg;
//    nx_union {          // THIS UNION BREAKS MIG PYTHON
//        nx_uint16_t arg;
//        nx_uint16_t act;         //for single and multiple act changes
//        nx_uint16_t powerstate;  //for powerstate changes
//        nx_uint16_t event_count; //for count entries
//    };
} nx_entry_t;

typedef nx_struct quanto_log_msg_t {
    nx_entry_t entry;
} quanto_log_msg_t;

typedef nx_struct quanto_log_cnt_msg_t {
    nx_uint8_t seq;
    nx_entry_t entry;
} quanto_log_cnt_msg_t;
#endif //_QUANTO_C

#endif
