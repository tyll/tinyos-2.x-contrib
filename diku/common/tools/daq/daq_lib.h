/**
 * The headerfile for the daq library
 */

#ifndef DAQ_LIB_H
#define DAQ_LIB_H

#ifdef __cplusplus
extern "C" {
#endif

#include <inttypes.h>

typedef int daq_card_t;

/**
 * daq_open opens the daq device pointed to by dev_file, and resets
 * the card.
 *
 * @param dev_file A string containing the device file to open.
 * @param daq Points to an instance of daq_card_t. Will be filled, if
 * the function is successful
 * @return 0, upon success. != 0 if failed.
 */
daq_card_t daq_open(const char* dev_file, daq_card_t *daq);

/**
 * daq_close closes a daq device, previously opened by daq_open.
 *
 * @param daq The device to close
 * @return 0 if successful, != 0 otherwise
 */
int daq_close(const daq_card_t *daq);


/**
 * daq_reset resets the open card pointed to by daq_card_t
 *
 * @param daq The card to reset
 * @return 0 if successful, != otherwise
 */
int daq_reset(const daq_card_t* daq);

typedef enum {
  DG_1000,
  DG_100,
  DG_10,
  DG_1,
} daq_gain_t;

typedef enum {
  DR_BIPOL5V,
  DR_BIPOL10V,
  DR_UNIPOL5V, /* Does not seem to work correctly */
  DR_UNIPOL10V,
} daq_range_t;

/**
 * daq_config_channel configures the channel that the daq-card should
 * use. It also makes sure to wait until the channel is setteled, so
 * that it can be put to use, immediately after the function returns.
 *
 * @param daq The card to set the channel for
 * @param channel The channel to use
 * @param gain The gain to use for the channel
 * @param range The range to use
 * @return 0 if OK.
 */
int daq_config_channel(const daq_card_t *daq, int channel, daq_gain_t gain, 
		       daq_range_t range);

/**
 * daq_config_channel_nowait does the same as daq_config_channel, only
 * it does not wait for the channel to settle.
 *
 * @param daq The card to set the channel for
 * @param channel The channel to use
 * @param gain The gain to use for the channel
 * @param range The range to use
 * @return 0 if OK.
 */
int daq_config_channel_nowait(const daq_card_t *daq, int channel, 
			      daq_gain_t gain, daq_range_t range);

/**
 * daq_settle_time calculates the settle time for a given channel
 * configuration.
 *
 * @param gain The gain used.
 * @param range The range used.
 * @return If > 0, the number of usecs to wait, before the channel is
 * setteled. <= 0 if error.
 */
int daq_settle_time(daq_gain_t gain, daq_range_t range);

/**
 * daq_wait_usec stalls the program for at least usec usecs :-)
 *
 * @param daq The card to wait for?
 * @param usec The number of usecs to wait
 * @return 0 if OK.
 */
int daq_wait_usec(const daq_card_t *daq, unsigned int usec);

/**
 * daq_get_sample retrieves a sample from the board. The channel, gain
 * and range must be configured in advance by a call to daq_config_channel*.
 *
 * @param daq The card to obtain a sample from
 * @param sample Upon return this will contain the value read from the card.
 * @return 0 if OK.
 */
int daq_get_sample(const daq_card_t *daq, uint16_t *sample);

/** 
 * daq_clear_scan clears the internal list of channels to scan.
 *
 * @param daq The card to clear the channel list for.
 * @return 0 if OK.
 */
int daq_clear_scan(const daq_card_t *daq);

/**
 * daq_add_scan adds a new channel/gain/range pair to the list of
 * channels to scan.
 *
 * @param daq The card that should have a new channel to scan
 * @param channel The channel that should be added to the list (The
 * same channel can be added multible times.
 * @param gain The gain for the specific channel
 * @param range The range for the channel
 * @return 0 if OK.
 */
int daq_add_scan(const daq_card_t *daq, int channel, daq_gain_t gain, daq_range_t range);

int daq_start_scan(const daq_card_t *daq, int sample_rate);

int daq_stop_scan(const daq_card_t *daq);

int daq_get_scan_sample(const daq_card_t *daq, uint16_t *sample);

double daq_convert_result(const daq_card_t *daq, uint16_t sample, 
			  daq_gain_t gain, daq_range_t range);

#ifdef __cplusplus
}
#endif

#endif
