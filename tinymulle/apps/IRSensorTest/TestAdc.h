
#ifndef TEST_ADC_H
#define TEST_ADC_H

typedef nx_struct test_serial_msg {
  nx_uint16_t data;
} adc_msg_t;

enum {
  AM_ADC_MSG = 8,
};

#endif
