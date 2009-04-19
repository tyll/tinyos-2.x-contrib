/**
 * author Robbie Adler
 **/

#ifndef __MMU_H__
#define __MMU_H__


/**
 * Initialize the processor's MMU unit.  The page table to use and some
 other parameters are defined in platform/pxa27x/mmu_table.s
 **/

void initMMU();

/**
 * Place the attached flash chip into synchronous mode
 **/
void initSyncFlash() __attribute__ ((long_call, section(".data")));

/**
 *  Enable the Instruction Cache.  This function currently also enabled
 *  the branch target buffer
**/
void enableICache();

/**
 *  Enable the data cache.  
**/
void enableDCache();


/**
 *  disable the data cache.  In order to ensure cache coherency, this function
 *  will also globally clean and invalidate the cache
 **/
void disableDCache();


/**
 *  invalidate the data cache for the buffer pointed to by address of length
 *  numbytes.  
 *
 * Notes: 
 * - invalidate = make cache lines invalid
 * - numbytes will be rounded up to the nearest multiple of 32.
 * - Address is required to be a virtual address 
 *
**/
void invalidateDCache(uint8_t *address, int32_t numbytes); 


/**
 *  clean the data cache for the buffer pointed to by address of length
 *  numbytes.  
 *
 * Notes: 
 * - clean = write back to memory if dirty
 * - numbytes will be rounded up to the nearest multiple of 32.
 * - Address is required to be a virtual address 
 *
**/
void cleanDCache(uint8_t *address, int32_t numbytes); 

/**
 *  globally clean (flush to memory if dirty) and invalidate the data cache
 * 
**/
void globalCleanAndInvalidateDCache();
#endif
