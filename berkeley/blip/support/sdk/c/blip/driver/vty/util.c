
#include "vty.h"

void init_argv(char *cmd, int len, char **argv, int *argc) {
  int inArg = 0;
  *argc = 0;
  while (len > 0 && *argc < N_ARGS) {
    if (*cmd == ' ' || *cmd == '\n' || 
        *cmd == '\t' || *cmd == '\0' || 
        *cmd == '\r' || *cmd == '\4' ||
        len == 1){
      if (inArg) {
        *argc = *argc + 1;
        inArg = 0;
        *cmd = '\0';
      }
    } else if (!inArg) {
      argv[*argc] = cmd;
        inArg = 1;
    }
    cmd ++;
    len --;
  }
}
