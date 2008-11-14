
# nesc RPC bindings.  a lot of code is generated straight from the c
# bindings.
#
# @author Stephen Dawson-Haggerty <stevedh@eecs.berkeley.edu>
#

from brpcgen_c import brpcgen_c

class brpcgen_nesc:
    def __init__(self, program):
        self.program = program
        prog_name = program[0].lower()
        self.prog_name = prog_name[0].upper() + prog_name[1:]
        self.c_binding = brpcgen_c(program)

    def print_interface(self, iface):
        print >>iface, "#include \"brpc.h\""
        print >>iface, "interface", self.prog_name, "{"
        print >>iface, "  command r_error_t connect(struct sockaddr_in6 *server);"

        prog_name = self.program[0].lower()
        for cmd in self.program[1]:
            if cmd[0] == 'command': rv = 'r_error_t'
            else: rv = 'void'
            print >>iface, ' ', cmd[0], rv, cmd[1],
            self.c_binding.print_arg_list(iface, cmd[2])
            print >>iface, ";"
        print >>iface, "}"

    def print_client(self, tos_client):
        print >>tos_client, '''
#include <ip_malloc.h>
module %s {
  provides interface %s;
  uses interface UDP;
} implementation {
  struct sockaddr_in6 server;


  command r_error_t %s.connect(struct sockaddr_in6 *s) {
    ip_memcpy(&server, s, sizeof(struct sockaddr_in6));
  }
''' % (self.prog_name + "ClientC", self.prog_name, self.prog_name)

        for cmd in self.program[1]:
            print >>tos_client, "r_error_t handle_%s_%s_impl" % \
                  (self.c_binding.name(), cmd[1].lower()),
            self.c_binding.print_arg_list(tos_client, [(1, 'arg', 'void *')] + cmd[2])
            print >>tos_client, "{"
            if cmd[0] == 'event':
                self.c_binding.print_dispatch_args(tos_client, \
                                                   "  signal %s.%s" % (self.prog_name, \
                                                                       cmd[1]), "", cmd[2])
            print >>tos_client, "}"
        print >>tos_client, '''
#define htonl hton32
#define htons hton16
#define ntohl ntoh32
#define ntohs ntoh16
'''
        self.c_binding.print_impl(tos_client)
        print >>tos_client, "  event void UDP.recvfrom(struct sockaddr_in6 *from, void *data,"
        print >>tos_client, "                          uint16_t len, struct ip_metadata *meta) {"
        print >>tos_client, "    dispatch_%s(NULL, data, len);" % (self.c_binding.name())
        print >>tos_client, "  }"
    
        for cmd in self.program[1]:
            if cmd[0] == 'command':
                print >>tos_client, "  command r_error_t %s.%s" % (self.prog_name, cmd[1]),
                self.c_binding.print_arg_list(tos_client, cmd[2])
                print >>tos_client, "{"
                print >>tos_client, '''
  uint8_t *buf = (uint8_t *)ip_malloc(100);
  uint8_t *b = buf;
  if (buf == NULL) return ENOMEM;
'''
                self.c_binding.print_dispatch_args(tos_client, \
                                                   "  pack_" + self.c_binding.name() + "_" + cmd[1].lower(),
                                    "&b, 100", cmd[2])
                print >>tos_client, "    call UDP.sendto(&server, buf, b - buf);"
                print >>tos_client, "    ip_free(buf);"
                print >>tos_client, "  }"
                
        print >>tos_client, "}"
    


    def autogen(self):
        files = [(self.print_interface, "%s.nc"),
                 (self.print_client   , "%sClient.nc")]
        
        for (gen, n) in files:
            name = n % self.prog_name
            print name
            fh = open(name, 'w')
            gen(fh)
            fh.close()
