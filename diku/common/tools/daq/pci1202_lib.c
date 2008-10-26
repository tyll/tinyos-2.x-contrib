// For open
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

// For close and usleep
#include <unistd.h>

// For ioctl
#include <sys/ioctl.h>

// For pci1202 ioctls
#include <ixpci.h>

#include "daq_lib.h"

int daq_open(const char* dev_file, daq_card_t *daq)
{
  int fd;
  fd = open(dev_file, O_RDWR);

  if (fd >= 0) {
    daq_reset(&fd);
    *daq = fd;
    return 0;
  }

  return fd;
}

int daq_close(const daq_card_t *daq)
{
  return close(*daq);
}

int daq_reset(const daq_card_t *daq)
{
  int err = ioctl(*daq, IXPCI_RESET);

  return err;
}

int daq_config_channel(const daq_card_t *daq, 
		       int channel, daq_gain_t gain, daq_range_t range)
{
  int res, settle_time = daq_settle_time(gain, range);

  if (settle_time > 0) {
    res = daq_config_channel_nowait(daq, channel, gain, range);
    if (res)
      return res;

    res = daq_wait_usec(daq, settle_time);
    return res;
  }

  return -1;
}

const int CONTROL_KEEP_FIFO                = 0x8000;
const int CONTROL_HANDSHAKE                = 0x2000;
const int CONTROL_COMMAND_RESET            = 0x0000;
const int CONTROL_COMMAND_SET_GAIN         = 0x0400;
const int CONTROL_COMMAND_ADD_QUEUE        = 0x1000;
const int CONTROL_COMMAND_START_MAGIC_SCAN = 0x1400;
const int CONTROL_COMMAND_STOP_MAGIC_SCAN  = 0x0800;
const int CONTROL_COMMAND_GET_ODM_NUMBER   = 0x1800;
const int CONTROL_PIC_RECOVERY             = 0xFFFF;

const int STATUS_NOT_FIFO_HALF_FULL        = 0x80;
const int STATUS_NOT_FIFO_FULL             = 0x40;
const int STATUS_NOT_FIFO_EMPTY            = 0x20;
const int STATUS_NOT_ADC_BUSY              = 0x10;
const int STATUS_EXTERNAL_TRIGGER          = 0x08;
const int STATUS_HANDSHAKE                 = 0x04;
const int STATUS_ODM_INDICATOR             = 0x02;
const int STATUS_NOT_TIMER_START           = 0x01;

static int do_set_config(const daq_card_t *daq, int config) 
{
  return ioctl(*daq, IXPCI_PIC_CONTROL, config);
}

static inline int encode_cgr(int channel, daq_gain_t gain, daq_range_t range)
{
  int config = 0;
  /* The numbers in these two switches are taken from the Users manual
     page 38/39 */

  switch (gain) {
  case DG_1000:
    config |= 0xC0;
    break;
  case DG_100:
    config |= 0x80;
    break;
  case DG_10:
    config |= 0x40;
    break;
  case DG_1:
    config |= 0;
    break;
  default:
    return -1;
  }

  switch (range) {
  case DR_BIPOL5V:
    config |= 0x0000;
    break;
  case DR_BIPOL10V:
    config |= 0x0100;
    break;
  case DR_UNIPOL5V:
    config |= 0x0300;
    break;
  case DR_UNIPOL10V:
    config |= 0x0200;
    break;
  default:
    return -2;
  }

  if (channel > 31 || channel < 0) 
    return -3;

  return config | channel;
}

int daq_config_channel_nowait(const daq_card_t *daq, 
			      int channel, daq_gain_t gain, daq_range_t range)
{
  int channel_config = encode_cgr(channel, gain, range);

  /* Now channel_config contains what we want */

  return do_set_config(daq, channel_config | CONTROL_KEEP_FIFO 
		       | CONTROL_COMMAND_SET_GAIN);
}

int daq_settle_time(daq_gain_t gain, daq_range_t range)
{
  /* From the users manual (page 39), it can be seen that the
     settlement time only is dependent of the gain */
  switch (gain) {
  case DG_1000:
    return 1300;
  case DG_100:
    return 140;
  case DG_10:
    return 28;
  case DG_1:
    return 23;
  }
  return 0;
}

int daq_wait_usec(const daq_card_t *daq, unsigned int usec)
{
  usleep(usec);
  return 0;
}

static int clear_fifo(const daq_card_t *daq)
{
  ixpci_reg_t reg;
  int res;

  reg.id = IXPCI_CR;
  reg.value = CONTROL_HANDSHAKE; /* Clear the FIFO */

  if ((res = ioctl(*daq, IXPCI_WRITE_REG, &reg)))
    return res;

  reg.value = CONTROL_KEEP_FIFO | CONTROL_HANDSHAKE;
  if ((res = ioctl(*daq, IXPCI_WRITE_REG, &reg)))
    return res;

  return 0;
}

int daq_get_sample(const daq_card_t *daq, uint16_t *sample)
{
  ixpci_reg_t reg;
  int res;

  if ((res = clear_fifo(daq)))
    return res;

  /* Write to the software trigger */
  reg.id = IXPCI_ADST;
  reg.value = 0xFFFF;
  if ((res = ioctl(*daq, IXPCI_WRITE_REG, &reg)))
    return res;

  /* Wait until the STATUS_NOT_FIFO_EMPTY flag is set. */
  reg.id = IXPCI_SR;
  do {
    if ((res = ioctl(*daq, IXPCI_READ_REG, &reg)))
      return res;
  } while (!(reg.value & STATUS_NOT_FIFO_EMPTY));

  /* Now we have a value in the FIFO. Read it! */
  reg.id = IXPCI_AD;
  if ((res = ioctl(*daq, IXPCI_READ_REG, &reg)))
    return res;

  *sample = reg.value;
  return 0;
}

static int enable_timer0(const daq_card_t *daq, int divv)
{
  ixpci_reg_t reg;
  int res;

  reg.id = IXPCI_8254CR;
  reg.value = 0x34; // Magic value!!!

  if ((res = ioctl(*daq, IXPCI_WRITE_REG, &reg)))
    return res;

  reg.id = IXPCI_8254C0;
  reg.value = divv & 0xFF; // Lower 8 bits
  
  if ((res = ioctl(*daq, IXPCI_WRITE_REG, &reg)))
    return res;

  reg.value = (divv >> 8) & 0xFF; // Higher 8 bits

  if ((res = ioctl(*daq, IXPCI_WRITE_REG, &reg)))
    return res;

  return 0;
}

static int disable_timer0(const daq_card_t *daq)
{
  return enable_timer0(daq, 0x0001);
}

int daq_clear_scan(const daq_card_t *daq)
{
  int res;

  if ((res = disable_timer0(daq)))
    return res;
  
  return do_set_config(daq, CONTROL_KEEP_FIFO | CONTROL_COMMAND_RESET);
}

int daq_add_scan(const daq_card_t *daq, int channel, daq_gain_t gain,
		 daq_range_t range)
{
  int command = encode_cgr(channel, gain, range);

  return do_set_config(daq, command | CONTROL_KEEP_FIFO 
		       | CONTROL_COMMAND_ADD_QUEUE);
}

int daq_start_scan(const daq_card_t *daq, int sample_rate)
{
  int res;

  if ((res = do_set_config(daq, CONTROL_KEEP_FIFO 
			   | CONTROL_COMMAND_START_MAGIC_SCAN)))
    return res;

  if ((res = clear_fifo(daq)))
    return res;

  if ((res = enable_timer0(daq, sample_rate)))
    return res;

  return 0;
}

int daq_stop_scan(const daq_card_t *daq)
{
  return disable_timer0(daq);
}

int daq_get_scan_sample(const daq_card_t *daq, uint16_t *sample)
{
  ixpci_reg_t reg;
  int res;

  reg.id = IXPCI_SR;
  do {
    if ((res = ioctl(*daq, IXPCI_READ_REG, &reg)))
      return res;
  } while (!(reg.value & STATUS_NOT_FIFO_EMPTY));

  if (!(reg.value & STATUS_NOT_FIFO_FULL))
    return -1;

  reg.id = IXPCI_AD;
  if ((res = ioctl(*daq, IXPCI_READ_REG, &reg)))
    return res;

  *sample = reg.value;
  return 0;
}

double daq_convert_result(const daq_card_t *daq, uint16_t sample, 
			  daq_gain_t gain, daq_range_t range)
{
  int zero;
  int max;
  double divisor;

  switch (range) {
  case DR_BIPOL5V:
    zero = 2048;
    max = 10;
    break;
  case DR_BIPOL10V:
    zero = 2048;
    max = 20;
    break;
  case DR_UNIPOL5V:
    zero = 0;
    max = 5;
    break;
  case DR_UNIPOL10V:
    zero = 0;
    max = 10;
    break;
  }

  switch (gain) {
  case DG_1000:
    divisor = 4096000.0;
    break;
  case DG_100:
    divisor = 409600.0;
    break;
  case DG_10:
    divisor = 40960.0;
    break;
  case DG_1:
    divisor = 4096.0;
    break;
  }

  return (((int)sample - zero) * max) / divisor;
}

