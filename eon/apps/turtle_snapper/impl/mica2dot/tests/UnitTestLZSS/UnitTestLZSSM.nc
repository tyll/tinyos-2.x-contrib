includes structs;

module UnitTestLZSSM
{
  provides
  {
    interface StdControl;
    interface UnitTest;
    
  }
  uses
    {
      interface ILZSS;
    }
}
implementation
{
#include "fluxconst.h"
#include "tinyunittest.h"
//#include "structs.h"

#define TESTSIZE 250
#define PUSHSIZE 30
uint8_t indata[TESTSIZE];
uint8_t outdata[TESTSIZE];
int index = 0;
int incount;
int outcount;
int outidx;

	task void pushData();

  command result_t StdControl.init ()
  {
    return SUCCESS;
  }

  command result_t StdControl.start ()
  {
    return SUCCESS;
  }

  command result_t StdControl.stop ()
  {
    return SUCCESS;
  }

  command result_t UnitTest.StartTest ()
  {
  	result_t res;
	
	/*command result_t compress_start();
    
    command result_t push(void *data, int len);

    event void pushDone(result_t res);
	
    event void compressed(void *data, int len);
	
	command result_t compressed_done(); //basically continue

    command result_t compress_end();*/
	
	index = 0;
	incount = 0;
	outcount = 0;
	outidx = 0;
	res = call ILZSS.compress_start();
	__TINY_TEST(res == SUCCESS, "compress_start returned Fail");
	
	post pushData();
	
    return res;
  }

  
  task void pushData()
  {
  	result_t res;
	int numbytes;
	int i;
	
  	if (index >= TESTSIZE)
	{
		//done
		__TINY_TEST_INFO(index >= TESTSIZE, "DONE!!!!");
		res = call ILZSS.compress_end();	
		__TINY_TEST(res == SUCCESS, "compress_end returned Fail");
		
		//verify 
		for (i=0; i < TESTSIZE; i++)
		{
			__TINY_TEST(indata[i] == outdata[i], "indata matches outdata");
		}
		__TINY_TEST(incount == outcount, "incount == outcount");
		signal UnitTest.TestDone(SUCCESS);
		return;
	}
	
	
	if (TESTSIZE - index < PUSHSIZE)
	{
		numbytes = (TESTSIZE - index);
	} else {
		numbytes = PUSHSIZE;
	}
	res = call ILZSS.push(indata+index, numbytes);
	__TINY_TEST_VAR(res == SUCCESS, "push returned Fail (numbytes==%d)",numbytes);
	incount += numbytes;
	index += numbytes;
	__TINY_TEST_VAR(incount <= TESTSIZE, "incount is too large: %d", incount);
  }
  
  event void ILZSS.pushDone(result_t res)
  {
  	__TINY_TEST(res == SUCCESS, "pushDone FAILURE");
  	post pushData();
  }
  
  
  event void ILZSS.compressed(void *data, int len)
  {
  		result_t res;
		int i=DATA_MSG_DATA_LEN;
  		memcpy(outdata + outidx, data, len);
		__TINY_TEST_VAR(len <= DATA_MSG_DATA_LEN, "len too big (len=%d)",len);
		
		outidx += len;
		outcount += len;
		
		__TINY_TEST_VAR(outcount <= TESTSIZE, "outcount too large %d", outcount);
		res = call ILZSS.compressed_done();
		__TINY_TEST(res == SUCCESS, "compressed_done returned FAIL...odd");
  }
  
}
