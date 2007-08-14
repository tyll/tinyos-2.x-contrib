/**
 * Prototypes for Keil built-in functions, that differ from glibc
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

#ifndef STRING_H
#define STRING_H

extern int strlen (char *);
extern void *memcpy (void *s1, void *s2, int n);
extern char memcmp (void *s1, void *s2, int n);
extern void *memset  (void *s, char val, int n);

#endif //STRING_H

