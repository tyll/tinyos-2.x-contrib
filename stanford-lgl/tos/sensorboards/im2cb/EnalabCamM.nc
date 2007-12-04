#include "enalabCam.h"
#include "camera.h"
#include "OV7649.h"

module EnalabCamM
{
    provides interface Init;
    provides interface EnalabCam;
    
    uses interface HplPXA27XQuickCaptInt as CIF;
	  uses interface HplOV7649 as OV;
	  
	  uses interface Leds;
    uses interface AMSend as DbgSend;
  	uses interface Packet; 
}
implementation
{
    // ======================= Data ==================================
	norace frame_t* currframe;
	norace window_t window_stat;
 
  task void send_dbg();
  
	void CIF_clear_frame(frame_t *frame)
	{
		uint32_t i;
		for (i=0; i < frame->size; i++) frame->buf[i] = 0;
	}
	
	command error_t Init.init()
	{
		// SET DEFAULT WINDOW
		window_stat.x = 0;
		window_stat.y = 0;
		window_stat.width = 320;
		window_stat.height = 240;
		
		call CIF.init(COLOR_UYVY);
		call OV.init(COLOR_UYVY);//COLOR_UYVY

		call EnalabCam.set_window(&window_stat);
		
		return SUCCESS;
	}


	command error_t EnalabCam.set_window(window_t *window)
	{
		uint8_t hstrt,hstop,vstrt,vstop;
		int val;
		window_t new_window;
	
		val = (2*WINDOW_HMAX)-(2*WINDOW_HZERO); 
		if (window->x > val) return -1;
		new_window.x = window->x;
	
		val = WINDOW_VMAX-WINDOW_VZERO; 
		if (window->y > val) return -1;
		new_window.y = window->y;
	
		val = (2*WINDOW_HMAX)-(2*WINDOW_HZERO)-(window->x) ; 
		if (window->width > val) return -1;
		if (window->width) new_window.width = window->width;
	
		val = WINDOW_VMAX-WINDOW_VZERO-(window->y); 
		if (window->height > val) return -1;
		if (window->height) new_window.height = window->height;
	
		//
		// HOW CAN WE ENSURE THE AREA OF THE WINDOW IS 16384 ???
		//
		
		hstrt = WINDOW_HZERO + new_window.x/2;
		hstop = WINDOW_HZERO + (new_window.x + new_window.width)/2;
		vstrt = WINDOW_VZERO + new_window.y;
		vstop = WINDOW_VZERO + new_window.y + new_window.height;
		
		//
		//  WE CANNOT CHANGE THE OV CAMERA WHILE CIF IS CAPTURING!!!!
		//
		call OV.config_window(hstrt, hstop, vstrt, vstop);
		
		window_stat.x = new_window.x;
		window_stat.y = new_window.y;
		window_stat.width = new_window.width;
		window_stat.height = new_window.height;
		// DO WE NEED A DELAY BEFORE NEXT CAPTURE ???
	
		call CIF.setImageSize(new_window.width, 
			new_window.height,
			(call OV.get_config())->color);
		return SUCCESS;
	}
	
	command window_t *EnalabCam.get_window()
	{
		return &window_stat;
	}

	void CIF_clear_header(frame_header_t *header)
	{
		header->height     = 0;
		header->width      = 0;
		header->color      = 0; // ! Color Depth	(Pixel Width)
		header->size       = 0;
		header->time_stamp = 0;
	}
 
	/******************************************************************
	 *  Camera Start
	 *  Function : acquire
	 *  	Tells the CIF to acquire a picture. 
	 *      Parameters
	 *          Input  :  address
	 *          Output :  Nothing
	 ******************************************************************/
	command frame_t* EnalabCam.acquire(uint8_t color, void *address)
	{

		currframe = (frame_t*) address;
		currframe->size   = FRAME_BUF_SIZE;
		currframe->header = (frame_header_t*) (address + sizeof(frame_t));
		currframe->buf    = (uint8_t*) (address + sizeof(frame_t) + sizeof(frame_header_t));

		call OV.init(color);

		CIF_clear_header(currframe->header);

		call CIF.init(color);
		call CIF.initDMA(currframe->size, currframe->buf);
		call CIF.enable();
	
		return currframe;
	}  

	/******************************************************************
	 *  Capture	Stop
	 *  Function : cancel()
	 *  	Cancels the current CIF operation.
	 *      Parameters
	 *          Input  :  Nothing
	 *          Output :  Nothing
	 ******************************************************************/
	command void EnalabCam.cancel()
	{
		call CIF.disableQuick();
	}
	
	async event void CIF.startOfFrame(){
		ov_stat_t *stat = call OV.get_config();
		frame_header_t *header = currframe->header;

		atomic{
			header->height     = window_stat.height;
			header->width      = window_stat.width;
		}
		header->color      = stat->color;
		header->size       = header->width * 2 * header->height;
		header->time_stamp = RCNR;
	
		//call CIF.initDMA(header->size, buf);
		CIFR |= CIFR_RESETF;
		call CIF.startDMA();
	}
 
  async event void CIF.endOfFrame(){
		call CIF.disableQuick(); 		
		signal EnalabCam.acquireDone();
	}
 
    async event void CIF.endOfLine(){;} 
    async event void CIF.recvDataAvailable(uint8_t channel){;} 
    async event void CIF.fifoOverrun(uint8_t channel){;} 

  message_t dbg_msg;
  task void send_dbg(){
//    dbg_msg32_t *tx_data = (dbg_msg32_t *)call Packet.getPayload(&dbg_msg, NULL);
//    tx_data->addr = (uint32_t)currframe;
//    tx_data->reg_val = currframe->size;
//  	dbg_msg.data[0] = started;
    call DbgSend.send(AM_BROADCAST_ADDR, &dbg_msg, 8);
  }
  event void DbgSend.sendDone(message_t* bufPtr, error_t error) {}

}
