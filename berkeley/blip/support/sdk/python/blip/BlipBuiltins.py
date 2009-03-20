# -*- python -*-

import time
import socket
import re,struct
import Ping6Cmd
import Ping6Reply
import IdentCmd
import ShellConstants
from ParseException import ParseException

import NWProgConsts, NWProgReq, NWProgReply, ShortDelugeIdent

import getopt

def toRealStr(bdata):
    rc = ''
    for c in bdata:
        rc += chr(c)
        if c == 0: return rc
    return rc

class CmdError:
    def cmd_id(self):
        return ShellConstants.ShellConstants.BSHELL_ERROR
    def cmd_name(self):
        return None
    def display(self,msg):
        code, = struct.unpack(">H", msg)
        if code == ShellConstants.ShellConstants.BSHELL_ERROR_NOTFOUND:
            print "ERROR: mote does not implement command!"

class CmdEcho:
    """echo <args ...>"""
    def cmd_id(self):
        return ShellConstants.ShellConstants.BSHELL_ECHO

    def cmd_name(self):
        return "echo"

    def parse(self, cmd):
        data = ' '.join(cmd[1:])
        return data

    def display(self, msg):
        print msg

class CmdPing:
    """ping6 [-c count] [-i interval] ip_address"""
    def cmd_id(self):
        return ShellConstants.ShellConstants.BSHELL_PING6
    def cmd_name(self):
        return "ping6"
    def parse(self, cmd):
        count = 10
        interval = 1024
        opts,args = getopt.getopt(cmd[1:], 'i:c:')
        for o,a, in opts:
            if o == '-i':
                interval = int(a)
            elif o == '-c':
                count = int(a)
                
        cmdmsg = Ping6Cmd.Ping6Cmd()
        cmdmsg.set_cnt(count)
        cmdmsg.set_dt(interval)
        addr = socket.inet_pton(socket.AF_INET6, cmd[1])
        cmdmsg.set_addr([ord(c) for c in addr])
        return cmdmsg.data
    
class PingReply:
    def cmd_id(self):
        return ShellConstants.ShellConstants.BSHELL_PING6_REPLY
    def cmd_name(self):
        return None
    def display(self,msg):
        repmsg = Ping6Reply.Ping6Reply(data=msg)
        addr = repmsg.get_addr()
        addr_str = ''
        for c in addr:
            addr_str += chr(c)
        addr_pretty = socket.inet_ntop(socket.AF_INET6, addr_str)
        print "%s icmp_seq=%i ttl=%i time=%i " % (addr_pretty,
                                                  repmsg.get_seqno(),
                                                  repmsg.get_ttl(),
                                                  repmsg.get_dt())

class PingDone:
    def cmd_id(self):
        return ShellConstants.ShellConstants.BSHELL_PING6_DONE
    def cmd_name(self):
        return None
    def display(self,msg):
        sent, rcvd = struct.unpack(">HH", msg)
        print "%i packets transmitted, %i received" % (sent, rcvd)

class CmdIdent:
    """ident"""
    def cmd_id(self):
        return ShellConstants.ShellConstants.BSHELL_IDENT
    def cmd_name(self):
        return "ident"
    def display(self, msg):
        i = IdentCmd.IdentCmd(data=msg)
        print "Appname:", toRealStr(i.get_appname())
        print "Username:", toRealStr(i.get_username())
        print "Hostname:", toRealStr(i.get_hostname())
        print "Build time:", time.ctime(i.get_timestamp())
        
    def parse(self, cmd):
        return ""

class CmdUptime:
    """uptime"""
    def cmd_id(self):
        return ShellConstants.ShellConstants.BSHELL_UPTIME
    def cmd_name(self):
        return "uptime"
    def display(self, msg):
        hi,lo = struct.unpack(">LL", msg)
        uptime = lo + (hi << 32)
        days = (uptime / 3600 * 24)
        hours = (uptime - days) / 3600
        minutes = (uptime - days - hours) / 60
        seconds = uptime % 60
        print "up %i days %i:%.2i.%.2i" % (days, hours, minutes, seconds)

    def parse(self, cmd):
        return ""

class NWProg:
    """nwprog [list | boot <imgno> [when] | reboot]"""

    def cmd_id(self):
        return ShellConstants.ShellConstants.BSHELL_NWPROG
    def cmd_name(self):
        return "nwprog"

    def parse(self, cmd):
        cmdmsg = NWProgReq.NWProgReq()
        if cmd[1] == 'reboot':
            cmdmsg.set_cmd(NWProgConsts.NWProgConsts.NWPROG_CMD_REBOOT)
            return cmdmsg.data
        elif cmd[1] == 'list':
            cmdmsg.set_cmd(NWProgConsts.NWProgConsts.NWPROG_CMD_LIST)
            return cmdmsg.data
        elif cmd[1] == 'boot':
            if len(cmd) < 3:
                print self.__doc__
                return
            cmdmsg.set_cmd(NWProgConsts.NWProgConsts.NWPROG_CMD_BOOT)
            cmdmsg.set_imgno(int(cmd[2]))

            if len(cmd) == 4:
                cmdmsg.set_cmd_data_when(int(cmd[3]))
            else:
                cmdmsg.set_cmd_data_when(30)
            return cmdmsg.data
        

    def display(self, msg):
        extra_data = msg[NWProgReq.DEFAULT_MESSAGE_SIZE:]
        repmsg = NWProgReq.NWProgReq(msg[0:NWProgReq.DEFAULT_MESSAGE_SIZE])
        if repmsg.get_cmd() == NWProgConsts.NWProgConsts.NWPROG_CMD_READDONE:
            print "%i valid image(s)" % repmsg.get_cmd_data_nimages()
        elif repmsg.get_cmd() == NWProgConsts.NWProgConsts.NWPROG_CMD_IMAGEIFO:
            t, = struct.unpack(">L", extra_data[48:52])

            print "Image %i:" % repmsg.get_imgno()
            print "  Appname:", extra_data[0:16]
            print "  Username:", extra_data[16:32]
            print "  Hostname:", extra_data[32:48]
            print "  Build time:", time.ctime(t)
            
        elif repmsg.get_cmd() == NWProgConsts.NWProgConsts.NWPROG_CMD_BOOT:
            print "REBOOT %i" % repmsg.get_cmd_data_when()
