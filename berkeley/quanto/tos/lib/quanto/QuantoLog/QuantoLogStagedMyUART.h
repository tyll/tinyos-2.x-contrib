#ifndef _QUANTO_MY_UART_H
#define _QUANTO_MY_UART_H

#include "RawUartMsg.h"
#include "my_message.h"
enum {
    QLOG_CONTINUOUS = TRUE,
    QLOG_ONESHOT   = FALSE,
};
enum {
    LOGSIZE = 700,                     //MAKE LOGSIZE A MULTIPLE OF N
    N = (MY_MESSAGE_LENGTH-1)/sizeof(nx_entry_t), // N = 120/12 = 10
};

typedef nx_struct quanto_vlog_msg_t {
    nx_uint8_t n;
    nx_entry_t entries[N];
} quanto_vlog_msg_t;

#endif
