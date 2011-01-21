/**
 * This file is modified from 
 * <code>tinyos-2.1.0/tos/chips/atm128/adc/Atm128Adc.h</code>
 *
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

#ifndef ATM328ADC_H
#define ATM328ADC_H

//================== 8 channel 10-bit ADC ==============================

/* Voltage Reference Settings */
enum {
    ATM328_ADC_VREF_OFF  = 0, // !< VR += AREF  and VR -= GND
    ATM328_ADC_VREF_AVCC = 1, // !< VR  += AVcc and VR -= GND
    ATM328_ADC_VREF_RSVD = 2, // !< Reserved
    ATM328_ADC_VREF_1_1  = 3, // !< VR  += 1.1V and VR -= GND
};

/* Voltage Reference Settings */
enum {
    ATM328_ADC_RIGHT_ADJUST = 0, 
    ATM328_ADC_LEFT_ADJUST = 1,
};


/* ADC Multiplexer Settings */
enum {
    ATM328_ADC_MUX_ADC0 = 0,
    ATM328_ADC_MUX_ADC1,
    ATM328_ADC_MUX_ADC2,
    ATM328_ADC_MUX_ADC3,
    ATM328_ADC_MUX_ADC4,
    ATM328_ADC_MUX_ADC5,
    ATM328_ADC_MUX_ADC6,
    ATM328_ADC_MUX_ADC7,
    ATM328_ADC_MUX_ADC8,
    ATM328_ADC_MUX_1_1 = 14,
    ATM328_ADC_MUX_GND,
};

/* ADC Prescaler Settings */
/* Note: each platform must define ATM328_ADC_PRESCALE to the smallest
   prescaler which guarantees full A/D precision. */
enum {
    ATM328_ADC_PRESCALE_2 = 0,
    ATM328_ADC_PRESCALE_2b,
    ATM328_ADC_PRESCALE_4,
    ATM328_ADC_PRESCALE_8,
    ATM328_ADC_PRESCALE_16,
    ATM328_ADC_PRESCALE_32,
    ATM328_ADC_PRESCALE_64,
    ATM328_ADC_PRESCALE_128,

    // This special value is used to ask the platform for the prescaler
    // which gives full precision.
    ATM328_ADC_PRESCALE
};

/* ADC Enable Settings */
enum {
    ATM328_ADC_ENABLE_OFF = 0,
    ATM328_ADC_ENABLE_ON,
};

/* ADC Start Conversion Settings */
enum {
    ATM328_ADC_START_CONVERSION_OFF = 0,
    ATM328_ADC_START_CONVERSION_ON,
};

/* ADC Free Running Select Settings */
enum {
    ATM328_ADC_FREE_RUNNING_OFF = 0,
    ATM328_ADC_FREE_RUNNING_ON,
};

/* ADC Interrupt Flag Settings */
enum {
    ATM328_ADC_INT_FLAG_OFF = 0,
    ATM328_ADC_INT_FLAG_ON,
};

/* ADC Interrupt Enable Settings */
enum {
    ATM328_ADC_INT_ENABLE_OFF = 0,
    ATM328_ADC_INT_ENABLE_ON,
};

/* ADC Auto Trigger Sources */
enum {
    ATM328_ADC_ATS_FREE_RUN = 0,
    ATM328_ADC_ATS_ANALOG_COMPARE,
    ATM328_ADC_ATS_EXINT_0,
    ATM328_ADC_ATS_TC0_COMP_A,
    ATM328_ADC_ATS_TC0_OVF,
    ATM328_ADC_ATS_TC1_COMP_B,
    ATM328_ADC_ATS_TC1_OVF,
    ATM328_ADC_ATS_TC1_CAPTURE,
};

/* ADC Multiplexer Selection Register */
typedef union
{
    uint8_t flat;
    struct
    {
        uint8_t mux   : 4;  //!< Analog Channel and Gain Selection Bits
        uint8_t rsvd  : 1;  //!< Reserved
        uint8_t adlar : 1;  //!< ADC Left Adjust Result
        uint8_t refs  : 2;  //!< Reference Selection Bits
    } bits;
} Atm328_ADMUX_t;

/* ADC Control and Status Register A */
typedef union
{
    uint8_t flat;
    struct
    {
        uint8_t adps  : 3;  //!< ADC Prescaler Select Bits
        uint8_t adie  : 1;  //!< ADC Interrupt Enable
        uint8_t adif  : 1;  //!< ADC Interrupt Flag
        uint8_t adate : 1;  //!< ADC Auto Trigger Enable
        uint8_t adsc  : 1;  //!< ADC Start Conversion
        uint8_t aden  : 1;  //!< ADC Enable
    } bits;
} Atm328_ADCSRA_t;

/* ADC Control and Status Register B */
typedef union
{
    uint8_t flat;
    struct
    {
        uint8_t adts  : 3;  //!< ADC Auto Trigger Source
        uint8_t rsvd1 : 3;  //!< Reserved
        uint8_t adme  : 1;  //!< Analog Comparator Mux Enable
        uint8_t rsvd2 : 1;  //!< Reserved
    } bits;
} Atm328_ADCSRB_t;

// The resource and client identifier strings for the ADC subsystem
#define UQ_ATM328ADC_RESOURCE "atm328adc.resource"

/* Configuration information */
typedef struct
{
    uint8_t channel;     //!< Must be one of the ATM328_ADC_MUX_xxx
    uint8_t ref_voltage; //!< Must be one of the ATM328_ADC_VREF_xxx values
    uint8_t prescaler;   //!< Must be one of the ATM328_ADC_PRESCALE_xxx values
} Atm328Adc_config_t;

#endif
