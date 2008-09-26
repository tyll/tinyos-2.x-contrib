

interface ILZSS 
{
    
	command result_t compress_start();
    
    command result_t push(void *data, int len);

    event void pushDone(result_t res);
	
    event void compressed(void *data, int len);
	
	command result_t compressed_done(); //basically continue

    command result_t compress_end();
	
	
}
