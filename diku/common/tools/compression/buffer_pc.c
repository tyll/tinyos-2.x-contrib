#include <stdio.h>
#include "buffer.h"

void handle_full_buffer(uint8_t *buffer, uint16_t nobytes)
{
  fwrite(buffer, nobytes, 1, stdout);
}
