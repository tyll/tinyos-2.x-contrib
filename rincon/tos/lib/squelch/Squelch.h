
#ifndef SQUELCH_H
#define SQUELCH_H

/**
 * The size of each squelch table
 */
#ifndef SQUELCH_TABLE_SIZE
#define SQUELCH_TABLE_SIZE 10
#endif

/**
 * Minimum number of measurements before being settled
 */
#ifndef SQUELCH_MIN_COUNT
#define SQUELCH_MIN_COUNT 20
#endif

/**
 * Initial squelch threshold
 */
#ifndef SQUELCH_INITIAL_THRESHOLD
#define SQUELCH_INITIAL_THRESHOLD 70
#endif

/**
 * Scaling numerator
 */
#ifndef SQUELCH_NUMERATOR
#define SQUELCH_NUMERATOR 7
#endif

/**
 * Scaling denominator
 */
#ifndef SQUELCH_DENOMINATOR
#define SQUELCH_DENOMINATOR 8
#endif


/**
 * Unique identifier for squelch clients
 */
#ifndef UQ_SQUELCH_CLIENT
#define UQ_SQUELCH_CLIENT "Unique.Squelch.Client"
#endif


#endif

