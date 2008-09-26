#ifndef _TINYUNITTEST_H_
#define _TINYUNITTEST_H_

#define __TINY_TEST(COND,COMMENT) 	\
do { 	\
	if (COND) {	\
		fprintf(stdout, "@@UNITTEST@@: SUCCESS : " COMMENT "\n"); \
	} else { \
		fprintf(stdout, "@@UNITTEST@@: FAILED : " __FILE__ " @ %d : " #COND " : " COMMENT "\n", __LINE__); \
	} \
}while (0)


#define __TINY_TEST_VAR(COND,COMMENT,VARS) 	\
do { 	\
	if (COND) {	\
		fprintf(stdout, "@@UNITTEST@@: SUCCESS : " COMMENT "\n", VARS); \
	} else { \
		fprintf(stdout, "@@UNITTEST@@: FAILED : " __FILE__ " @ %d : " #COND " : " COMMENT "\n", __LINE__, VARS); \
	} \
}while (0)


#define __TINY_TEST_INFO(COND,COMMENT) 	\
do { 	\
	if (COND) {	\
		fprintf(stdout, "@@UNITTEST@@: INFO(TRUE) : " __FILE__ " @ %d : " #COND " : " COMMENT "\n", __LINE__); \
	} else { \
		fprintf(stdout, "@@UNITTEST@@: INFO(FALSE) : " __FILE__ " @ %d : " #COND " : " COMMENT "\n", __LINE__); \
	} \
}while (0)




#endif

