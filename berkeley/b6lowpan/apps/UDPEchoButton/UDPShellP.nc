/*
 * "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

#include <ip.h>
#include <IPDispatch.h>
#include <ICMP.h>

#ifdef DELUGE
#include "Deluge.h"
#include "imgNum2volumeId.h"
#endif

module UDPShellP {
  uses {
    interface Boot;
    interface UDP;
    interface Leds;
    
    interface ICMPPing;
    interface Counter<TMilli, uint32_t> as Uptime;

#ifdef DELUGE
    interface BootImage;
    interface DelugeVerify;
    interface DelugePatch;
    interface DelugeReadIdent;
#endif
#ifdef FLASH
    interface BlockRead;
    interface BlockWrite;
#endif
  }

} implementation {

  bool session_active;
  struct sockaddr_in6 session_endpoint;
  uint32_t boot_time;
  uint64_t uptime; 

  event void Boot.booted() {
    uptime = 0;
    boot_time = call Uptime.get();
#ifdef FLASH
    if (call BlockWrite.erase() != SUCCESS)
       call Leds.led1Toggle();
#endif
  }

  struct cmd_str {
    uint8_t c_len;
    char    c_name[10];
    void (*action)(int, char **);
  };

  // and corresponding indeces
  enum {
    N_COMMANDS = 7,
    // the maximum number of arguments a command can take
    N_ARGS = 10,
    MAX_REPLY_LEN = 128,
    CMD_HELP = 0,
    CMD_ECHO = 1,
    CMD_PING6 = 2,
    CMD_TRACERT6 = 3,

    CMD_NO_CMD = 0xfe,
  };
  
  char reply_buf[MAX_REPLY_LEN];
  char *help_str = "sdsh-0.0\tbuiltins: [help, echo, ping6, tracert6, nwprog, uptime, flash]\n";
  char *nwprog_help_str = "nwprog [list | boot <imgno> | reboot | erase <imgno> | verify <imgno>]\n";
  const char *ping_fmt = "%x%02x:%x%02x:%x%02x:%x%02x:%x%02x:%x%02x:%x%02x:%x%02x: icmp_seq=%i ttl=%i time=%i ms\n";
  const char *ping_summary = "%i packets transmitted, %i received\n";
  const char *nwprog_verify_success = "CRC check for image %i is successful.\n";
  const char *nwprog_verify_fail = "CRC check for image %i has failed.\n";
  const char *nwprog_patch_success = "Patch in image %i is successfully decoded.\n";
  const char *nwprog_patch_fail = "Patch in image %i has not been decoded.\n";

  void action_help(int argc, char **argv) {
    call UDP.sendto(&session_endpoint, help_str, strlen(help_str));
  }

  void action_echo(int argc, char **argv) {
    int i, arg_len;
    char *payload = reply_buf;

    if (argc < 2) return;
    for (i = 1; i < argc; i++) {
      arg_len = strlen(argv[i]);
      if ((payload - reply_buf) + arg_len + 1 > MAX_REPLY_LEN) break;
      memcpy(payload, argv[i], arg_len);
      payload += arg_len;
      *payload = ' ';
      payload++;
    }
    *(payload - 1) = '\n';

    call UDP.sendto(&session_endpoint, reply_buf, payload - reply_buf);
  }

  void action_ping6(int argc, char **argv) {
    ip6_addr_t dest;

    if (argc < 2) return;
    inet6_aton(argv[1], dest);
    call ICMPPing.ping(dest, 1024, 10);
  }
  uint8_t nwprog_currentvol, nwprog_validvols;  

  void action_nwprog(int argc, char **argv) {
#ifdef DELUGE
    if (argc >= 2) {
      if (memcmp(argv[1], "list", 4) == 0) {
        // Read the specific volume
        if (argc > 2) {
          uint8_t img = atoi(argv[2]);
          call DelugeReadIdent.readVolume(img);
        }
        // Read the number of volumes
        else {
          call DelugeReadIdent.readNumVolumes();
        } 
        return;
      } else if (memcmp(argv[1], "boot", 4) == 0 && argc == 3) {
        uint8_t boot_image = atoi(argv[2]);
        boot_image = imgNum2volumeId(boot_image);
        call BootImage.boot(boot_image);
        return;
      } else if (memcmp(argv[1], "reboot", 6) == 0) {
        call BootImage.reboot();
      } else if (memcmp(argv[1], "erase", 5) == 0 && argc == 3) {
        uint8_t img = atoi(argv[2]);
        img = imgNum2volumeId(img);
        call BootImage.erase(img);
        return;
      } else if (memcmp(argv[1], "verify", 6) == 0 && argc == 3) {
        uint8_t img = atoi(argv[2]);
        call DelugeVerify.verifyImg(img);
        return;
      } else if (memcmp(argv[1], "patch", 5) == 0 && argc == 5) {
        uint8_t img_patch = atoi(argv[2]);
        uint8_t img_src   = atoi(argv[3]);
        uint8_t img_dst   = atoi(argv[4]);
        call DelugePatch.decodePatch(img_patch, img_src, img_dst);
        return;
      }

    }
    call UDP.sendto(&session_endpoint, nwprog_help_str, strlen(nwprog_help_str));
#endif
  }

  void action_flash(int argc, char **argv) {
#ifdef FLASH
    static char read_buf[16];
    uint16_t r_len;
    if (memcmp(argv[1], "write", 5) == 0) {
      uint16_t addr = atoi(argv[2]);
      uint16_t len = strlen(argv[3]);
      error_t rc;
      if (len < 16) {
        memcpy(read_buf, argv[3], len);
        rc = FAIL;
        rc = call BlockWrite.write(addr, read_buf, len);
      } else rc = ESIZE;
      r_len = snprintf(reply_buf, MAX_REPLY_LEN, "write submitted addr: 0x%x len: %i error: %i\n",
                       addr, len, rc);
    } else if (memcmp(argv[1], "read", 4) == 0) {
      uint16_t addr = atoi(argv[2]);
      uint16_t len = atoi(argv[3]);
      error_t rc;
      if (len < 16)
        rc = call BlockRead.read(addr, read_buf, len);
      else rc = ESIZE;
      r_len = snprintf(reply_buf, MAX_REPLY_LEN, "read submitted addr: 0x%x len: %i error: %i\n",
                       addr, len, rc);
    } else {
      return;
    }
    call UDP.sendto(&session_endpoint, reply_buf, r_len);
#endif
  }

  void action_uptime(int argc, char **argv) {
    int len;
    uint32_t tval = call Uptime.get();
    atomic
      tval = (uptime + tval - boot_time) / 1024;
    len = snprintf(reply_buf, MAX_REPLY_LEN, "up %li seconds\n",
                   (uint32_t)tval);
    call UDP.sendto(&session_endpoint, reply_buf, len);
  }

  // commands 
  struct cmd_str commands[N_COMMANDS] = {{4, "help", action_help},
                                         {4, "echo", action_echo},
                                         {5, "ping6", action_ping6},
                                         {8, "tracert6", action_echo},
                                         {6, "nwprog", action_nwprog},
                                         {6, "uptime", action_uptime},
                                         {5, "flash", action_flash}};

  // break up a command given as a string into a sequence of null terminated
  // strings, and initialize the argv array to point into it.
  void init_argv(char *cmd, uint16_t len, char **argv, int *argc) {
    int inArg = 0;
    *argc = 0;
    while (len > 0 && *argc < N_ARGS) {
      if (*cmd == ' ' || *cmd == '\n' || *cmd == '\t' || *cmd == '\0' || len == 1){
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

  int lookup_cmd(char *cmd) {
    int i;
    for (i = 0; i < N_COMMANDS; i++) {
      if (memcmp(cmd, commands[i].c_name, commands[i].c_len) == 0 
          && cmd[commands[i].c_len] == '\0')
        return i;
    }
    return CMD_NO_CMD;
  }

  event void UDP.recvfrom(struct sockaddr_in6 *from, void *data, 
                          uint16_t len, struct ip_metadata *meta) {
    char *argv[N_ARGS];
    int argc, cmd;

    if (len < 4) return;
    
    memcpy(&session_endpoint, from, sizeof(struct sockaddr_in6));
    init_argv((char *)data, len, argv, &argc);

    if (argc > 0) {
      cmd = lookup_cmd(argv[0]);
      if (cmd != CMD_NO_CMD) {
        commands[cmd].action(argc, argv);
      }
    }
  }

  event void ICMPPing.pingReply(ip6_addr_t source, struct icmp_stats *stats) {
    int len;
    len = snprintf(reply_buf, MAX_REPLY_LEN, ping_fmt,
                   source[0],source[1],source[2],source[3],
                   source[4],source[5],source[6],source[7],
                   source[8],source[9],source[10],source[11],
                   source[12],source[13],source[14],source[15],
                   stats->seq, stats->ttl, stats->rtt);
    call UDP.sendto(&session_endpoint, reply_buf, len);

  }

  event void ICMPPing.pingDone(uint16_t ping_rcv, uint16_t ping_n) {
    int len;
    len = snprintf(reply_buf, MAX_REPLY_LEN, ping_summary, ping_n, ping_rcv);
    call UDP.sendto(&session_endpoint, reply_buf, len);
  }
#ifdef DELUGE
  uint8_t volumeID2imgNum(uint8_t volumeID) {
    switch(volumeID) {
    case VOLUME_GOLDENIMAGE: return 0;
    case VOLUME_DELUGE1: return 1;
    case VOLUME_DELUGE2: return 2;
    case VOLUME_DELUGE3: return 3;
    }
  }

  event void DelugePatch.decodePatchDone(uint8_t imgNumPatch, uint8_t imgNumSrc,
                                         uint8_t imgNumDst, error_t error) {
    uint16_t len; 

    if (error == SUCCESS) {
      len = snprintf(reply_buf, MAX_REPLY_LEN, nwprog_patch_success, imgNumPatch);
    } else {
      len = snprintf(reply_buf, MAX_REPLY_LEN, nwprog_patch_fail, imgNumPatch);
    }
    call UDP.sendto(&session_endpoint, reply_buf, len);
  }

  event void DelugeVerify.verifyImgDone(uint8_t imgNum, error_t error) {
    uint16_t len; 

    if (error == SUCCESS) {
      len = snprintf(reply_buf, MAX_REPLY_LEN, nwprog_verify_success, imgNum);
    } else {
      len = snprintf(reply_buf, MAX_REPLY_LEN, nwprog_verify_fail, imgNum);
    }
    call UDP.sendto(&session_endpoint, reply_buf, len);
  }

  event void DelugeReadIdent.readNumVolumesDone(
    uint8_t validVolumes, uint8_t volumeFields, error_t error) {
    int len;
    if (error == SUCCESS) {
      len = snprintf(reply_buf, MAX_REPLY_LEN,
            "%i valid images%s%s%s%s\n",
            validVolumes,
            (volumeFields & 0x01) ? "\n\timage 0 valid" : "",
            (volumeFields & 0x02) ? "\n\timage 1 valid" : "",
            (volumeFields & 0x04) ? "\n\timage 2 valid" : "",
            (volumeFields & 0x08) ? "\n\timage 3 valid" : "");
      call UDP.sendto(&session_endpoint, reply_buf, len);
    }
  }

  event void DelugeReadIdent.readVolumeDone(
    uint8_t imgNum, DelugeIdent* ident, error_t error) {
    int len;
    if (error == SUCCESS) {
      if (ident->uidhash != DELUGE_INVALID_UID) {
        len = snprintf(reply_buf, MAX_REPLY_LEN,
              "image: %i\n\t[size: %li]\n\t[name: %s]\n\t[user: %s]\n\t[host: %s]\n\t[arch: %s]\n\t[time: 0x%lx]\n",
              volumeID2imgNum(imgNum), ident->size, (char *)ident->appname, (char *) ident->username,
              (char *)ident->hostname, (char *)ident->platform, (uint32_t)ident->timestamp);
      }
    }
    else {
      len = snprintf(reply_buf, MAX_REPLY_LEN,
            "image %i is not valid.\n",
            volumeID2imgNum(imgNum));
    }
    call UDP.sendto(&session_endpoint, reply_buf, len);
  }

#endif

  async event void Uptime.overflow() {
    atomic
      uptime += 0xffffffff;
  }

#ifdef FLASH
  event void BlockRead.readDone(storage_addr_t addr, void* buf, storage_len_t len,
                                error_t error) {
    uint16_t r_len = snprintf(reply_buf, MAX_REPLY_LEN,"read done addr: 0x%x len: %i error: %i data: ", 
                              addr, len, error);
    if (len < MAX_REPLY_LEN - r_len - 1)
      memcpy(reply_buf + r_len, buf, len);
    reply_buf[r_len + len + 1] = '\n';
    call UDP.sendto(&session_endpoint, reply_buf, r_len + len + 1);
    
  }

  event void BlockRead.computeCrcDone(storage_addr_t addr, storage_len_t len,
                                         uint16_t crc, error_t error) {

  }

  event void BlockWrite.writeDone(storage_addr_t addr, void* buf, storage_len_t len,
                                  error_t error) {
    uint16_t r_len = snprintf(reply_buf, MAX_REPLY_LEN,"write done addr: 0x%x len: %i error: %i\n", 
                              addr, len, error);
    call UDP.sendto(&session_endpoint, reply_buf, r_len);
  }

  event void BlockWrite.eraseDone(error_t error) {
    call Leds.led0Toggle();
  }

  event void BlockWrite.syncDone(error_t error) {

  }
#endif
}
