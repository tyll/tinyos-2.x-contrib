// $Id$

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

#include "crc.h"
#include "At45db.h"
#include "Timer.h"

/**
 * Private componenent for the Atmel's AT45DB HAL.
 *
 * @author David Gay
 * @author Jacob Sorber
 */

module At45dbP {
  provides {
    interface Init;
    interface At45db;
  }
  
}
implementation
{
#define CHECKARGS

#define wdbg(n)

#ifndef FLASH_READ_DELAY
#define FLASH_READ_DELAY 1500
#endif

#ifndef FLASH_WRITE_DELAY
#define FLASH_WRITE_DELAY 1500
#endif

#ifndef FLASH_SYNC_DELAY
#define FLASH_SYNC_DELAY 1500
#endif

#ifndef FLASH_FLUSH_DELAY
#define FLASH_FLUSH_DELAY 1500
#endif

#ifndef FLASH_COPY_DELAY
#define FLASH_COPY_DELAY 1500
#endif


#ifndef FLASH_ERASE_DELAY
#define FLASH_ERASE_DELAY 1500
#endif

typedef struct
{
	error_t result;
	uint16_t crc;
} crcresult_t;

  typedef struct {
    uint8_t data[AT45_PAGE_SIZE];
  } flash_page_t;
  
  flash_page_t _flash[AT45_MAX_PAGES];
  
void dbg_mem(char * channel, uint8_t *data, int len)
{
	char buf[2048];
	char el[10];
	int i;
	
	sprintf(buf, "MEM:");
	
	for (i=0; i < len; i++)
	{
		sprintf(el, "%X ",data[i]);
		strcat(buf,el);
	}
	
	strcat(buf,"\n");
	
	dbg(channel,buf);
	
}
  
  command error_t Init.init() {
   static int veryfirst = 1;
   int i;
   
   if (veryfirst)
   {
   		for (i=0; i < AT45_MAX_PAGES; i++)
		{
			memset(_flash[i].data, 0xff, AT45_PAGE_SIZE);
		}
		veryfirst = 0;
   }
    return SUCCESS;
  }
  

  bool invalid_access(at45page_t page, at45pageoffset_t offset, at45pageoffset_t n)
  {
  	return (page >= AT45_MAX_PAGES || offset >= AT45_PAGE_SIZE || 
		n > AT45_PAGE_SIZE || offset + n > AT45_PAGE_SIZE);		
  }
  /*
  
void requestDone(error_t result, uint16_t computedCrc, uint8_t newState) {
    uint8_t orequest = request;

    request = newState;
    switch (orequest)
      {
      case R_READ: signal At45db.readDone(result); break;
      case R_READCRC: signal At45db.computeCrcDone(result, computedCrc); break;
      case R_WRITE: signal At45db.writeDone(result); break;
      case R_SYNC: case R_SYNCALL: signal At45db.syncDone(result); break;
      case R_FLUSH: case R_FLUSHALL: signal At45db.flushDone(result); break;
      case R_ERASE: signal At45db.eraseDone(result); break;
      case R_COPY: signal At45db.copyPageDone(result); break;
      }
  }
*/
  void sim_read_done_handle(sim_event_t* e)
  {
  	dbg("At45db","READ DONE (%d)\n",*(error_t*)(e->data));
  	signal At45db.readDone(*(error_t*)(e->data));
  }
  
  command void At45db.read(at45page_t page, at45pageoffset_t offset, void *reqdata, at45pageoffset_t n) 
  {
  		sim_event_t *evt = (sim_event_t*)malloc(sizeof(sim_event_t));
		error_t *result = (error_t *)malloc(sizeof(error_t));
		
		dbg("At45db","READ %d : %d (%d)\n",page,offset,n);
		
		*result = SUCCESS;
		if (invalid_access(page,offset,n)) *result = FAIL;
		
		
		if (*result == SUCCESS)
		{
			memcpy(reqdata, _flash[page].data+offset, n);
			dbg_mem("At45db",reqdata, n);
		}
		
		evt->mote = sim_node();
		evt->time = sim_time() + FLASH_READ_DELAY;
		evt->handle = sim_read_done_handle;
		evt->cleanup = sim_queue_cleanup_data;
		evt->cancelled = 0;
		evt->force = 0;
		evt->data = result;
  	  
  	  sim_queue_insert(evt);
  }

  
  void sim_crc_done_handle(sim_event_t* e)
  {
  	crcresult_t* result = (crcresult_t*)(e->data);
  	dbg("At45db","CRC DONE (%d) %d\n",result->result, result->crc);
  	signal At45db.computeCrcDone(result->result, result->crc);
  }
  
  
  command void At45db.computeCrc(at45page_t page,
					at45pageoffset_t offset,
					at45pageoffset_t n,
					uint16_t baseCrc) {
    
    sim_event_t *evt = (sim_event_t*)malloc(sizeof(sim_event_t));
		crcresult_t *result = (crcresult_t *)malloc(sizeof(crcresult_t));
		uint16_t crc;
		int i;
		
		result->result = SUCCESS;
		if (invalid_access(page,offset,n)) result->result = FAIL;
		
		dbg("At45db","CRC %d : %d (%d) (%d)\n",page,offset,n, baseCrc);
		
		if (result->result == SUCCESS)
		{
			crc = baseCrc;
			for (i=offset; i < offset+n; i++)
			{
				crc = crcByte(crc,_flash[page].data[i]);
			}
			result->crc = crc;
		}
		
		evt->mote = sim_node();
		evt->time = sim_time() + 1;
		evt->handle = sim_crc_done_handle;
		evt->cleanup = sim_queue_cleanup_data;
		evt->cancelled = 0;
		evt->force = 0;
		evt->data = result;
  	  
  	  sim_queue_insert(evt);
  }

  void sim_write_done_handle(sim_event_t* e)
  {
  	dbg("At45db","WRITE DONE (%d)\n",*(error_t*)(e->data));
  	signal At45db.writeDone(*(error_t*)(e->data));
  }
  
  command void At45db.write(at45page_t page, at45pageoffset_t offset,
				    void *reqdata, at45pageoffset_t n) 
	{
    	sim_event_t *evt = (sim_event_t*)malloc(sizeof(sim_event_t));
		error_t *result = (error_t *)malloc(sizeof(error_t));
		
		*result = SUCCESS;
		if (invalid_access(page,offset,n)) *result = FAIL;
		
		dbg("At45db","WRITE %d : %d (%d) (%d)\n",page,offset,n,*result);
		
		if (*result == SUCCESS)
		{
			memcpy(_flash[page].data+offset, reqdata, n);
			dbg_mem("At45db",reqdata, n);
		}
		
		evt->mote = sim_node();
		evt->time = sim_time() + FLASH_WRITE_DELAY;
		evt->handle = sim_write_done_handle;
		evt->cleanup = sim_queue_cleanup_data;
		evt->cancelled = 0;
		evt->force = 0;
		evt->data = result;
  	  
  	  sim_queue_insert(evt);
  }

  void sim_erase_done_handle(sim_event_t* e)
  {
  	dbg("At45db","ERASE DONE (%d)\n",*(error_t*)(e->data));
  	signal At45db.eraseDone(*(error_t*)(e->data));
  }

  command void At45db.erase(at45page_t page, uint8_t eraseKind) {
    sim_event_t *evt = (sim_event_t*)malloc(sizeof(sim_event_t));
		error_t *result = (error_t *)malloc(sizeof(error_t));
		
		*result = SUCCESS;
		if (invalid_access(page,0,256)) *result = FAIL;
		
		dbg("At45db","ERASE %d : %d\n",page,eraseKind);
		
		if (*result == SUCCESS)
		{
			memset(_flash[page].data, 0xFF, AT45_PAGE_SIZE);
		}
		
		evt->mote = sim_node();
		evt->time = sim_time() + FLASH_ERASE_DELAY;
		evt->handle = sim_erase_done_handle;
		evt->cleanup = sim_queue_cleanup_data;
		evt->cancelled = 0;
		evt->force = 0;
		evt->data = result;
  	  
  	  sim_queue_insert(evt);
  }

  void sim_copy_done_handle(sim_event_t* e)
  {
  	dbg("At45db","COPY DONE (%d)\n",*(error_t*)(e->data));
  	signal At45db.copyPageDone(*(error_t*)(e->data));
  }
  
  command void At45db.copyPage(at45page_t from, at45page_t to) {
    sim_event_t *evt = (sim_event_t*)malloc(sizeof(sim_event_t));
		error_t *result = (error_t *)malloc(sizeof(error_t));
		
		*result = SUCCESS;
		if (from >= AT45_MAX_PAGES) *result = FAIL;
		if (to >= AT45_MAX_PAGES) *result = FAIL;
		if (to == from) *result = FAIL;
	
		dbg("At45db","COPYPAGE %d -> %d\n",from,to);
		
		if (*result == SUCCESS)
		{
			memcpy(_flash[to].data,_flash[from].data, AT45_PAGE_SIZE);
		}
		
		evt->mote = sim_node();
		evt->time = sim_time() + FLASH_COPY_DELAY;
		evt->handle = sim_copy_done_handle;
		evt->cleanup = sim_queue_cleanup_data;
		evt->cancelled = 0;
		evt->force = 0;
		evt->data = result;
  	  
  	  sim_queue_insert(evt);
  }


  void sim_sync_done_handle(sim_event_t* e)
  {
    dbg("At45db","SYNC DONE (%d)\n",*(error_t*)(e->data));
  	signal At45db.syncDone(*(error_t*)(e->data));
  }
  
  command void At45db.sync(at45page_t page) {
    sim_event_t *evt = (sim_event_t*)malloc(sizeof(sim_event_t));
		error_t *result = (error_t *)malloc(sizeof(error_t));
		
		*result = SUCCESS;
		if (page >= AT45_MAX_PAGES) *result = FAIL;
		
		dbg("At45db","SYNC %d\n",page);
				
		evt->mote = sim_node();
		evt->time = sim_time() + FLASH_SYNC_DELAY;
		evt->handle = sim_sync_done_handle;
		evt->cleanup = sim_queue_cleanup_data;
		evt->cancelled = 0;
		evt->force = 0;
		evt->data = result;
  	  
  	  sim_queue_insert(evt);
  }

  void sim_flush_done_handle(sim_event_t* e)
  {
  	dbg("At45db","FLUSH DONE (%d)\n",*(error_t*)(e->data));
  	signal At45db.flushDone(*(error_t*)(e->data));
  }
  
  command void At45db.flush(at45page_t page) {
    sim_event_t *evt = (sim_event_t*)malloc(sizeof(sim_event_t));
		error_t *result = (error_t *)malloc(sizeof(error_t));
		
		*result = SUCCESS;
		if (page >= AT45_MAX_PAGES) *result = FAIL;
		
		dbg("At45db","FLUSH %d\n",page);
				
		evt->mote = sim_node();
		evt->time = sim_time() + FLASH_FLUSH_DELAY;
		evt->handle = sim_flush_done_handle;
		evt->cleanup = sim_queue_cleanup_data;
		evt->cancelled = 0;
		evt->force = 0;
		evt->data = result;
  	  
  	  sim_queue_insert(evt);
  }

  command void At45db.syncAll() {
    sim_event_t *evt = (sim_event_t*)malloc(sizeof(sim_event_t));
		error_t *result = (error_t *)malloc(sizeof(error_t));
		
		*result = SUCCESS;
		
		dbg("At45db","SYNCALL\n");
				
		evt->mote = sim_node();
		evt->time = sim_time() + FLASH_SYNC_DELAY;
		evt->handle = sim_sync_done_handle;
		evt->cleanup = sim_queue_cleanup_data;
		evt->cancelled = 0;
		evt->force = 0;
		evt->data = result;
  	  
  	  sim_queue_insert(evt);
  }

  command void At45db.flushAll() {
    sim_event_t *evt = (sim_event_t*)malloc(sizeof(sim_event_t));
		error_t *result = (error_t *)malloc(sizeof(error_t));
		
		*result = SUCCESS;
		
		dbg("At45db","FLUSHALL\n");
				
		evt->mote = sim_node();
		evt->time = sim_time() + FLASH_FLUSH_DELAY;
		evt->handle = sim_flush_done_handle;
		evt->cleanup = sim_queue_cleanup_data;
		evt->cancelled = 0;
		evt->force = 0;
		evt->data = result;
  	  
  	  sim_queue_insert(evt);
  }
}
