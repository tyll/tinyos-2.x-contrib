
#include <stdlib.h>
#include <signal.h>
#include <string.h>
#include "logging.h"
#include "vty.h"


void do_echo(int fd, int argc, char ** argv) {
  VTY_HEAD;
  if (argc > 1) {
    VTY_printf("%s\r\n", argv[1]);
    VTY_flush();
  }
}

struct vty_cmd echo = {"echo", do_echo};

void shutdown() {
  vty_shutdown();
  exit(0);
}

int main(int argc, char **argv) {
  int maxfd;
  fd_set fds;
  struct vty_cmd_table t;
  log_init();
  log_setlevel(LOGLVL_DEBUG);
  
  signal(SIGINT, shutdown);

  t.n = 1;
  t.table = &echo;


  vty_init(&t, atoi(argv[1]));
  while (1) {
    FD_ZERO(&fds);
    maxfd = vty_add_fds(&fds);

    select(maxfd+1, &fds, NULL, NULL, NULL);

    vty_process(&fds);
  }
  info("Done, exiting\n");

}
