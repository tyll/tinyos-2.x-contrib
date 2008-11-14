
# base c RPC bindings which perform marshaling/unmarshaling, and
# provide a simple client and stateless server.
#
# @author Stephen Dawson-Haggerty <stevedh@eecs.berkeley.edu>
#

class brpcgen_c:
    def __init__(self, program):
        self.program = program
        self.prog_name = program[0].lower()

    def name(self):
        return self.prog_name

    #
    # utility print functions
    #
    def sizeof(self,arg):
        if arg == 'uint8_t':
            return 1
        if arg == 'uint16_t':
            return 2
        if arg == 'uint32_t':
            return 4
    
    def print_align_code(self, fh, align):
        if (align == 1): return
        print >>fh, "  if ((long int)(*__buf) % " + str(align) + " != 0)" 
        print >>fh, "    *__buf = *__buf + (" + str(align) + " - ((long int)(*__buf) % " + str(align) + "));"
    
    def print_write8(self, fh, n):
        print >>fh, "  *((uint8_t *)*__buf) = " + n + ";"
        print >>fh, "  *__buf += 1;"
    
    def print_write16(self, fh, n):
        print >>fh, "  *((uint16_t *)*__buf) = htons(" + n + ");"
        print >>fh, "  *__buf += 2;"
    
    def print_write32(self, fh, n):
        print >>fh, "  *((uint32_t *)*__buf) = htonl(" + n + ");"
        print >>fh, "  *__buf += 4;"
    
    def print_read8(self, fh, expr):
        print >>fh, "  " + expr + " = *((uint8_t *)__buf);";
        print >>fh, "  __buf += 1;"    
    
    def print_read16(self, fh, expr):
        print >>fh, "  " + expr + " = ntohs(*((uint16_t *)__buf));";
        print >>fh, "  __buf += 2;"
    
    def print_read32(self, fh, expr):
        print >>fh, "  " + expr + " = ntohl(*((uint32_t *)__buf));";
        print >>fh, "  __buf += 4;"
    
    def print_read_arg(self, fh, a):
        if a[2] == 'uint8_t':
            self.print_read8(self, fh, a[1])
        elif a[2] == 'uint16_t':
            self.print_read16(fh, a[1])
        elif a[2] == 'uint32_t':
            self.print_read32(fh, a[1])
                    
    
    def print_arg(self, fh, a):
        if a[0] == 0: index = "[i]"
        else: index = ""
        if a[2] == 'uint8_t':
            self.print_write8(fh, a[1].lower() + index)
        elif a[2] == 'uint16_t':
            self.print_write16(fh, a[1].lower() + index)
        elif a[2] == 'uint32_t':
            self.print_write32(fh, a[1].lower() + index)
    
    def print_pack_code(self, fh, f_no, i_no, args):
        print >>fh, "  /*",args, "*/"
        # don't align the f_no and the i_no as we assume the buffer starts aligned
        for a in args:
            if a[0] == 0:
                print >>fh, "  uint16_t i;"
                break
    
        # need 6 bytes for the function number and interface number
        len_check = "6"
        for a in args:
            if a[0] > 0:
                cnt = str(a[0])
                extra = "0"
            else:
                cnt = a[1] + "_len"
                extra = "2"
            len_check += " + (" + cnt + " * " + str(self.sizeof(a[2])) + ") + " + extra
    
        print >>fh, "  if (__buf_len < " + len_check + ") return ESHORT;"
    
        self.print_write32(fh, str(i_no));
        self.print_write16(fh, str(f_no));
    
        for a in args:
            eltlen = self.sizeof(a[2])
            if a[0] == 0:
                len_name = a[1].lower() + "_len"
                self.print_write16(fh, len_name)
                self.print_align_code(fh, eltlen)
                print >>fh, "  for (i = 0; i < " + len_name + "; i++) {"
                self.print_arg(fh, a)
                print >>fh, "  }"
            else:
                #print_align_code(fh, eltlen)
                self.print_arg(fh, a)
        print >>fh, "return SUCCESS;"
    
    def print_dispatch_code(self, fh, handler, args):
        print >>fh, "  /* " + str(args) + "*/"
        for a in args:
            if a[0] == 0:
                print >>fh, "  uint16_t i;"
                break
        for a in args:
            print >>fh, "  " + a[2],
            if a[0] == 0:
                print >>fh, "*", a[1], ";"
                print >>fh, "  uint16_t", a[1] + "_len;"
            else:
                print >>fh, a[1],";"
        for a in args:
            eltlen = self.sizeof(a[2])
            if a[0] == 0:
                self.print_read16(fh, a[1] + "_len")
                self.print_align_code(fh, eltlen)
                print >>fh, "  " + a[1] + " = (" + a[2] + "*)__buf;"
                print >>fh, "  __buf += (" + a[1] + "_len * " + str(self.sizeof(a[2])) + ");"
                if a[2] == 'uint16_t' or a[2] == 'uint32_t':
                    print >>fh, "  for (i = 0; i < %s; i++) {" % (a[1] + "_len")
                    print >>fh, "    %s[i] =" % a[1],
                    if a[2] == 'uint16_t' : print >>fh, "htons(%s[i]);" % a[1]
                    else: print >>fh, "htonl(%s[i]);" % a[1]
                    print >>fh, "  }"
            else:
                # print_align_code(fh, eltlen)
                self.print_read_arg(fh, a)
        self.print_dispatch_args(fh, handler, "arg", args)
        print >>fh, "return SUCCESS;"
        
    def print_dispatch_args(self, fh, handler, firstarg, args):
        print >>fh, "  " + handler + "(" + firstarg,
        if len(args) > 0 and firstarg != "": print >>fh, ",",
        for i in range(0, len(args)):
            a = args[i]
            print >>fh, a[1],
            if i < len(args)-1 or a[0] == 0:
                print >>fh, ",",
            if a[0] == 0:
                print >>fh, a[1] + "_len", 
                if i < len(args) - 1:
                    print >>fh, ",",
        print >>fh, ");"
    
    def print_arg_list(self, fh, args):
        print >>fh, "(",
        for i in range(0,len(args)):
            a = args[i]
            print >>fh, a[2],
            print >>fh, a[1] ,
            if a[0] == 0:
                print >>fh, "[]",
    
            if i < len(args)-1 or a[0] == 0:
                print >>fh, ',',
            
            if a[0] == 0:
                print >>fh, "uint16_t", a[1] + "_len",
                if i < len(args)-1:
                    print >>fh, ',',
        print >>fh, ")",
    
    def print_make_call(self, fh, destaddr, prog_name, fnname, args):
        print >>fh, "  uint8_t buf [1500];"
        print >>fh, "  uint8_t *b = buf;"
        print >>fh, "  int rv;"
        self.print_dispatch_args(fh, 'pack_' + prog_name + '_' + fnname, '&b, 1500', args)
        print >>fh, "  rv = sendto(sock, buf, (b - buf), 0, %s, sizeof(struct sockaddr_in6));" % destaddr
        print >>fh, "  if (rv < 0) return EFAIL;"
        print >>fh, "  return SUCCESS;"
    
    
    def print_impl(self, impl):
        print >>impl, "#include \"" + self.prog_name + "_client.h\""
        print >>impl, "#include \"" + self.prog_name + "_server.h\""
        print >>impl, "#include \"" + self.prog_name + "_impl.h\""

        func_number = 0
        for cmd in self.program[1]:
    
            print >>impl, "r_error_t pack_" + self.prog_name + "_" + cmd[1].lower(),
            self.print_arg_list(impl, [(1, '__buf', 'uint8_t **'),
                                       (1, '__buf_len', 'uint16_t')] + cmd[2])
            print >>impl, "{"
            self.print_pack_code(impl, func_number, self.program[2], cmd[2])
            print >>impl, "}"

            print >>impl, "r_error_t dispatch_" + self.prog_name + "_" + cmd[1].lower(),
            print >>impl, "(void *arg, uint8_t *__buf, uint16_t __buf_len) {"
            self.print_dispatch_code(impl, "handle_" + self.prog_name + \
                                     "_" + cmd[1].lower() + "_impl", cmd[2])
            print >>impl, "}"

            func_number += 1

        print >>impl, "r_error_t dispatch_" + self.prog_name + \
              "(void *arg, uint8_t *__buf, uint16_t __buf_len) {"

        print >>impl, "  uint16_t f_no;"
        print >>impl, "  uint32_t i_no;"
        self.print_read32(impl, "i_no");
        self.print_read16(impl, "f_no");
        print >>impl, "  if (i_no != " + str(self.program[2]) + ") return EWRONGIFACE;"
        print >>impl, "  switch (f_no) {"
        func_number = 0
        for cmd in self.program[1]:
            print >>impl, "  case %i: " % func_number,
            print >>impl, "return dispatch_" + self.prog_name + "_" + \
                  cmd[1].lower() + "(arg, __buf, __buf_len - 6);"
            func_number += 1
        print >>impl, "  default: return EWRONGFUNC;"
        print >>impl, "  }"
        print >>impl, "}"

    def print_impl_h(self, impl_h):
        print >>impl_h, "#ifndef " + self.prog_name.upper() + "_IMPL_H"
        print >>impl_h, "#define " + self.prog_name.upper() + "_IMPL_H"
        print >>impl_h, "#include \"brpc.h\""


        print >>impl_h, "#define " + self.prog_name.upper() + "_NUMBER " + str(self.program[2])

        func_number = 0
        for cmd in self.program[1]:
            print >>impl_h, "r_error_t pack_" + self.prog_name + "_" + cmd[1].lower(),
            self.print_arg_list(impl_h, [(1, '__buf', 'uint8_t **'),
                                         (1, '__buf_len', 'uint16_t')] + cmd[2])
            print >>impl_h, ";"
            func_number += 1
            print >>impl_h, "r_error_t dispatch_" + self.prog_name + \
                  "(void *arg, uint8_t *__buf, uint16_t __buf_len);"

            print >>impl_h, "void handle_" + self.prog_name + "_" + cmd[1].lower() + "_impl",
            self.print_arg_list(impl_h,  [(1, 'arg', 'void *')] + cmd[2])
            print >>impl_h, ";"


        print >>impl_h, "#define " + self.prog_name.upper() + "_NFUNCS " + str(func_number)

        print >>impl_h, "#endif"


    def print_server(self, sf):
        print >>sf, '''#include <sys/socket.h>
#include <stdlib.h>
#include <stdio.h>
#include "%s_server.h"
#include "brpc.h"

''' % self.prog_name
        for cmd in self.program[1]:
            if cmd[0] == 'command':
                print >>sf, "void handle_" + self.prog_name + "_" + cmd[1].lower(),
                self.print_arg_list(sf, [(1, 'source', 'struct sockaddr *')] + cmd[2])
                print >>sf, "{"
                print >>sf
                print >>sf, "}"
        print >>sf, '''
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "\\n\\tusage: %s_server <port>\\n\\n");
    exit(1);
  }
  %s_server_init(atoi(argv[1]));
  while (1) {
    %s_server_next();
  }
}
''' % (self.prog_name, self.prog_name, self.prog_name)
        

    def print_server_h(self, s_h):
        print >>s_h, "#ifndef _" + self.program[0].upper() + "_SERVER_H"
        print >>s_h, "#define _" + self.program[0].upper() + "_SERVER_H"
        print >>s_h, "#include <sys/socket.h>"
        print >>s_h, "#include \"brpc.h\""

        for cmd in self.program[1]:
            if cmd[0] == 'command':
                print >>s_h, "void handle_" + self.prog_name + "_" + cmd[1].lower(),
                self.print_arg_list(s_h,  [(1, 'source', 'struct sockaddr *')] + cmd[2])
                print >>s_h, ";"

            if cmd[0] == 'event':
                print >>s_h, "r_error_t signal_" + self.prog_name + "_" + cmd[1].lower(),
                self.print_arg_list(s_h,  [(1, 'dest', 'struct sockaddr *')] + cmd[2])
                print >>s_h, ";"
        print >>s_h, "int %s_server_init(int port);" % self.prog_name
        print >>s_h, "int %s_server_next();" % self.prog_name
        print >>s_h, "#endif"

    def print_server_impl(self, si):
        print >>si, '''
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include "%s_impl.h"
#include "%s_server.h"
int sock;
const struct in6_addr in6addr_any = IN6ADDR_ANY_INIT;


/*
 * define the dispatchers for commands and call points for events.
 */''' % (self.prog_name, self.prog_name)
        
        for cmd in self.program[1]:
            print >>si, "void handle_" + self.prog_name + "_" + cmd[1].lower() + "_impl",
            self.print_arg_list(si,  [(1, 'arg', 'void *')] + cmd[2])
            print >>si, "{"
            if cmd[0] == 'command':
                self.print_dispatch_args(si, "handle_" + self.prog_name + "_" + cmd[1].lower(),
                                         "(struct sockaddr *)arg", cmd[2])
                print >>si, "  return;"
            else:
                print >>si, "  return;"
            print >>si, "}"
        
            if cmd[0] == 'event':
                print >>si, "r_error_t signal_%s_%s" % (self.prog_name, cmd[1].lower()),
                self.print_arg_list(si, [(1, 'dest', 'struct sockaddr *')] + cmd[2])
                print >>si, "{"
                self.print_make_call(si, 'dest', self.prog_name, cmd[1].lower(), cmd[2])
                print >>si, "}"
                
        print >>si, '''

int %s_server_init(int port) { 
  struct sockaddr_in6 local;
  sock = socket(PF_INET6, SOCK_DGRAM, 0);
  if (sock < 0) return -1;
  local.sin6_family = AF_INET;;
  local.sin6_port = htons(port);
  local.sin6_addr = in6addr_any;
  if (bind(sock, (struct sockaddr *)&local, sizeof(local)) < 0)
    return -1;
  return 0;
}

int %s_server_next() {
  uint8_t buf[1500];
  socklen_t sockaddr_len;
  struct sockaddr_in6 endpoint;
  int rcvlen = recvfrom(sock, buf, 1500, 0,
                       (struct sockaddr *)&endpoint, &sockaddr_len);
  return dispatch_%s((void *)&endpoint, buf, rcvlen);
}

''' % (self.prog_name, self.prog_name, self.prog_name)
                
        
    def print_client(self, cl):
        print >>cl, '''
#include <stdlib.h>
#include <stdio.h>
#include <sys/socket.h>
#include "brpc.h"
#include "%s_client.h"
''' % self.prog_name

        for cmd in self.program[1]:
            if cmd[0] == 'event':
                print >>cl, "void handle_" + self.prog_name + "_" + cmd[1].lower(),
                self.print_arg_list(cl, cmd[2])
                print >>cl, "{"
                print >>cl
                print >>cl, "}"

        print >>cl, '''
int main(int argc, char **argv) {
  if (argc != 3) return 1;

  %s_client_init(argv[1], atoi(argv[2]));
  %s_client_next();
  return 0;
    
}''' % (self.prog_name, self.prog_name)
        

    def print_client_h(self,c_h):
        print >>c_h, "#ifndef _" + self.program[0].upper() + "_CLIENT_H"
        print >>c_h, "#define _" + self.program[0].upper() + "_CLIENT_H"
        print >>c_h, "#include <sys/socket.h>"
        print >>c_h, "#include \"brpc.h\""
        for cmd in self.program[1]:
            if cmd[0] == 'command':
                print >>c_h, "r_error_t call_" + self.prog_name + "_" + cmd[1].lower(),
                self.print_arg_list(c_h, cmd[2])
                print >>c_h, ";"

            if cmd[0] == 'event':
                print >>c_h, "void handle_" + self.prog_name + "_" + cmd[1].lower(),
                self.print_arg_list(c_h, cmd[2])
                print >>c_h, ";"

        print >>c_h, "int %s_client_init(char *svr, int port);" % self.prog_name
        print >>c_h, "int %s_client_next();" % self.prog_name
        print >>c_h, "#endif"


    def print_client_impl(self, ci):
        print >>ci, '''
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include "%s_impl.h"
#include "%s_server.h"
#include "%s_client.h"

int sock;
struct sockaddr_in6 server;
const struct in6_addr in6addr_any = IN6ADDR_ANY_INIT;

''' % (self.prog_name, self.prog_name, self.prog_name)
    
        for cmd in self.program[1]:
            print >>ci, "void handle_" + self.prog_name + "_" + cmd[1].lower() + "_impl",
            self.print_arg_list(ci,  [(1, 'arg', 'void *')] + cmd[2])
            print >>ci, "{"
            if cmd[0] == 'event':
                self.print_dispatch_args(ci, "handle_" + self.prog_name + "_" + cmd[1].lower(),
                                    "", cmd[2])

            print >>ci, "}"
        
            if cmd[0] == 'command':
                print >>ci, "r_error_t call_%s_%s" % (self.prog_name, cmd[1].lower()),
                self.print_arg_list(ci, cmd[2])
                print >>ci, "{"
                self.print_make_call(ci, '(struct sockaddr *)&server', self.prog_name, cmd[1].lower(), cmd[2])
                print >>ci, "}"
        
        print >>ci, '''
int %s_client_next() {
  uint8_t buf[1500];
  socklen_t sockaddr_len;
  struct sockaddr_in6 endpoint;
  int rcvlen = recvfrom(sock, buf, 1500, 0,
                       (struct sockaddr *)&endpoint, &sockaddr_len);
  if (rcvlen == -1) return -1;
  dispatch_%s((void *)&endpoint, buf, rcvlen);
  return 0;
}

int %s_client_init(char *host, int port) {
  struct sockaddr_in6 local;
  sock = socket(PF_INET6, SOCK_DGRAM, 0);
  if (sock < 0) return -1;
  local.sin6_family = AF_INET;
  local.sin6_port = 0;
  local.sin6_addr = in6addr_any;
  if (bind(sock, (struct sockaddr *)&local, sizeof(local)) < 0)
    return -1;

  server.sin6_family = AF_INET;
  server.sin6_port = htons(port);
  if (inet_pton(AF_INET6, host, &server.sin6_addr) <= 0)
    return -1;
  return 0;
}''' % (self.prog_name, self.prog_name, self.prog_name )
        

    def print_makefile(self, mk):
        print >>mk, '''

all: client server

server:
\t$(CC) -O -Wall -pedantic -o %s_server %s_server.c %s_server_impl.c %s_impl.c

client:
\t$(CC) -O -Wall -pedantic -o %s_client %s_client.c %s_client_impl.c %s_impl.c

clean:
\trm -rf %s_server %s_client

''' % (self.prog_name, self.prog_name, self.prog_name, self.prog_name,
       self.prog_name, self.prog_name, self.prog_name, self.prog_name,
       self.prog_name, self.prog_name)


    def autogen(self):
        files = [(self.print_impl        , "%s_impl.c"),
                 (self.print_impl_h      , "%s_impl.h"),
                 (self.print_server      , "%s_server.c"),
                 (self.print_server_h    , "%s_server.h"),
                 (self.print_server_impl , "%s_server_impl.c"),
                 (self.print_client      , "%s_client.c"),
                 (self.print_client_h    , "%s_client.h"),
                 (self.print_client_impl , "%s_client_impl.c"),
                 (self.print_makefile    , "Makefile.%s")]

        for (gen, n) in files:
            name = n % self.prog_name
            print name
            fh = open(name, 'w')
            gen(fh)
            fh.close()
