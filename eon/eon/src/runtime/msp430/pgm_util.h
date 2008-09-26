#ifndef _PGM_UTIL_H_
#define _PGM_UTIL_H_


#define PROGMEM	 

inline int32_t read_pgm_int32(int32_t* pptr)
{
	//int32_t result;
	//memcpy((void*)&result, pptr, sizeof(int32_t));
	return (*pptr);
}

inline int16_t read_pgm_int16(int16_t* pptr)
{
	//int16_t result;
	//memcpy(&result, pptr, sizeof(int16_t));
	//return result;
	return (*pptr);
}


inline int8_t read_pgm_int8(int8_t* pptr)
{
	//int8_t result;
	//memcpy(&result, pptr, sizeof(int8_t));
	//return result;
	return (*pptr);
}


#endif
