/** Dummy header to avoid inclusion of the standard library header **/
#ifndef _STDLIB_H_
#define _STDLIB_H_

/* The memset function in Codewarior doesnt work */
void    *memset(void *s, unsigned char c, int n)
{
  char *target = (char*)s;
  while(n > 0)
  {
    *target = c;
    target++;
    n--;
  }
  return s;
}
#endif
