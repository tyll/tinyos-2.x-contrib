#define WINDOW_SIZE (1024 + 512)
#define LOOK_AHEAD_SIZE 32

#define LENGTH_BITS 5
#define OFFSET_BITS 11 /* If OFFSET_BITS is lower than 9, we need to
			  change the do_compress algorithm */

