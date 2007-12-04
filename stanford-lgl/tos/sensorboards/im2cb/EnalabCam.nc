#include "enalabCam.h"
interface EnalabCam
{
	command frame_t *acquire(uint8_t color, void* address);
	async event void acquireDone();
	command void  cancel();
	
	command error_t set_window(window_t *window);
	command window_t *get_window(); 
}
