/*
* Copyright (c) 2007 University of Iowa 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of The University of Iowa  nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Timesync suite of interfaces, components, testing tools, and documents.
 * @author Ted Herman
 * Development supported in part by NSF award 0519907. 
 */
//--EOCpr712 (do not remove this line, which terminates copyright include)

#include <unistd.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <strings.h>
#include <errno.h>
#include <sys/poll.h>

// primitive Listen program (to be used with serialforwarder, ie.
// the 'sf' program in $TOSDIR/../tools/src
//   **** NICE ENHANCEMENTS WOULD BE ********
//   1.  automatic start of the sf program;
//   2.  add command-line parameters to set TPS, debug options
//   3.  allow commands to be issued for fault injection, etc.
//

// Emulate TinyOS/NesC programming environment

#define FALSE 0
#define TRUE  1

/***** NOTE:  need to define by hand because of __attribute__ ((packed)) ***/
typedef struct micaTOS_Msg
{
   /* The following fields are transmitted/received by serial forwarder. */
   uint8_t pad;
   uint8_t fcf[2];
   uint8_t dest[2];
   uint8_t length;
   uint8_t pad2;
   uint8_t type;
   uint8_t data[28];  
   } micaTOS_Msg;
typedef micaTOS_Msg * micaTOS_MsgPtr;

typedef struct telosTOS_Msg
{
   uint8_t pad; 
   uint8_t fcf[2];
   uint8_t dest[2];
   uint8_t length;
   uint8_t pad2;
   uint8_t type;
   int8_t data[28];
   } telosTOS_Msg;
typedef telosTOS_Msg * telosTOS_MsgPtr;

enum { AM_BEACON=40,
       AM_BEACON_PROBE=41,
       AM_PROBE_ACK=42,
       AM_PROBE_DEBUG=43,
       AM_NEIGHBOR=44,
       AM_NEIGHBOR_DEBUG=45,
       AM_SKEW=47,
       AM_UART=50
       }; 

typedef struct beaconMsg {
uint16_t sndId;     // Id of sender
int16_t  prevDiff;  // difference of most recent received Beacon
uint8_t Local[6];   // local clock of sender (48 bit, H and L) 
uint8_t Virtual[6]; // virtual time of sender (48 bit, H and L)
uint8_t Xor[6];     // XOR of the above two clocks
uint8_t mode;    // sender's mode 
uint8_t NbrSize; // neighborhood size of sender
uint8_t Delay[4];  // processing and MAC delay of sending beacon 
} beaconMsg; 
typedef beaconMsg * beaconMsgPtr;

typedef struct beaconProbeAck {
  uint16_t count;
  uint16_t sndId;     // id of sender
  uint8_t Local[6];   // local clock for Ack (48 bit, H and L)
  uint8_t Virtual[6]; // virtual time for Ack (48 bit, H and L)
  float  skew;        // current skew adjustment amount
  float calibRatio;   // reported OTime.calibrate() value
  } beaconProbeAck; 
typedef beaconProbeAck * beaconProbeAckPtr; 

// Structure of Neighborhood Message
typedef struct neighborMsg {
  uint16_t sndId;     // Id of sender
  uint16_t nodes[12];  // neighbors heard from recently
} neighborMsg;
typedef neighborMsg * neighborMsgPtr;

// DebugMsg is generated only in testing versions
typedef struct beaconDebugMsg {
  uint16_t sndId;    // id of sender
  uint8_t  type;     // a one-byte "type" of debugging
  uint8_t  stuff[25];   // anything can go here
  } beaconDebugMsg;  // 28 bytes of debugging data   
typedef beaconDebugMsg * beaconDebugMsgPtr;

// Skew diffusion/gossip message
typedef struct skewMsg {
  uint16_t sndId;    // Id of sender
  uint16_t rootId;   // Id of "root" initiator of diffusion
  uint16_t minId;    // Id of node with minimum known skew 
  uint8_t initStamp[6];  // Vclock of initiation
  float skewMin;     // minimum known skew
  uint8_t seqno;     // sequence number (for repeats)
  } skewMsg;
typedef skewMsg * skewMsgPtr;

enum { MICA128 = 1, TELOS = 2, MICAZ = 3 };  // types of motes
char motetype = 0;

uint32_t TPS;

struct timeval startT;   // time at start of Spy run

/***** Convert a mote (atmel) uint32_t *********/
uint32_t moteInt(uint8_t * g) {
   uint32_t b;
   b = (g[0]&0xff);
   b += (g[1]&0xff) << 8;
   b += (g[2]&0xff) << 16;
   b += (g[3]&0xff) << 24;
   return b;
   }

/***** Convert a mote nx_uint32_t *********/
uint32_t nx_moteInt(uint8_t * g) {
   uint32_t b;
   b = (g[3]&0xff);
   b += (g[2]&0xff) << 8;
   b += (g[1]&0xff) << 16;
   b += (g[0]&0xff) << 24;
   return b;
   }

/******** show raw hex data ***********/   
void showhex( void * p, int n ) {
   int i;
   uint8_t * c = (uint8_t *) p;
   for (i=0;i<n;i++) printf("%2.2x ",*(c+i));
   }

/**** Write TOS_Msg to Socket *******/
void putStreamMica( int socket, micaTOS_MsgPtr p ) {
   int i, r;
   uint8_t n;
   char * s;
   extern int errno;
   n = p->length + sizeof(micaTOS_Msg) - 29;
   s = (char *) p;
   r = write(socket, &n, 1); 
   // printf("sent %x\n",n);
   if (r < 0) { perror("putStream error"); exit(errno); }

   for (i = 0; i < n; i++) {
      r = write(socket, &s[i], 1); 
      // printf("sent %x\n",*(s+i));
      if (r < 0) { perror("putStream error"); exit(errno); }
      }
} 

/**** Read Stream from Socket ******/
void getStreamMica( int socket, micaTOS_MsgPtr p ) {
   int i, r;
   char * s;
   uint8_t n;
   extern int errno;
   s = (char *) p;

   // fprintf(stderr,"trying to read from socket\n");
   r = read(socket, &n, 1); 
   if (r < 0) { perror("getStream error"); exit(errno); }
   if (r == 0) { fprintf(stderr,"connection broken!\n"); exit(0); }
   fprintf(stderr,"got message for %d bytes\n",n-6); 
   
   // now read the data
   if ( n > sizeof(micaTOS_Msg) ) { 
          fprintf(stderr,"wierd message for %d bytes returned\n",n);
          exit(1);
          }
   for (i = 0; i < n; i++) {
      r = read(socket, &s[i], 1); 
      if (r < 0) { perror("getStream error"); exit(errno); }
      if (r == 0) { fprintf(stderr,"connection broken!\n"); exit(0); }
      }
   showhex(s,n);
   printf("\n");
   return;
} 

/**** Read Stream from Socket ******/
void getStreamTelos( int socket, telosTOS_MsgPtr p ) {
   int i, r;
   char * s;
   uint8_t n;
   extern int errno;
   s = (char *) p;

   r = read(socket, &n, 1); 
   if (r < 0) { perror("getStream error"); exit(errno); }
   if (r == 0) { fprintf(stderr,"connection broken!\n"); exit(0); }
   // printf("got message for %d byte payload ",n-8); 
   
   // now read the data
   if ( n > sizeof(telosTOS_Msg) ) { 
          fprintf(stderr,"wierd message for %d bytes returned\n",n);
          exit(1);
          }
   for (i = 0; i < n; i++) {
      r = read(socket, &s[i], 1); 
      if (r < 0) { perror("getStream error"); exit(errno); }
      if (r == 0) { fprintf(stderr,"connection broken!\n"); exit(0); }
      }
   // showhex(s,n);
   // printf("\n");
   
   return;
} 

/**** Exchange SF Protocol Number ******/
void exchange( int socket ) {
   int i, r;
   char s[2];
   extern int errno;
   for (i = 0; i < 2; i++) {
      r = read(socket, &s[i], 1); 
      if (r < 0) { perror("getExchange error"); exit(errno); }
      if (r == 0) { fprintf(stderr,"connection broken!\n"); exit(0); }
      }
   if ( !(s[0] == 'U' & s[1] == ' ') ) {
      fprintf(stderr,"SFProtocol exchange failed\n"); exit(0);
      }
   s[1] = ' ';
   for (i = 0; i < 2; i++) {
      r = write(socket, &s[i], 1); 
      if (r < 0) { perror("putExchange error"); exit(errno); }
      }
   }

void displayNeighbor(neighborMsgPtr p) {
   int i;
   struct timeval T;

   // show elapsed time since start of run
   gettimeofday(&T,NULL);
   T.tv_sec -= startT.tv_sec;
   if (T.tv_usec >= startT.tv_usec)  T.tv_usec -= startT.tv_usec;
   else {
      T.tv_sec--;
      T.tv_usec += 1000000;
      T.tv_usec -= startT.tv_usec;
      }
   printf("t=%d.%03d ",T.tv_sec,T.tv_usec/1000);
   printf("sndId=%d ",p->sndId);
   printf("nbrs=[ ");
   for (i=0;i<12;i++) printf("%d ",p->nodes[i]);
   printf("]\n");
   }

void displayProbeDebug(beaconDebugMsgPtr p) {
   int i;
   struct timeval T;

   // show elapsed time since start of run
   gettimeofday(&T,NULL);
   T.tv_sec -= startT.tv_sec;
   if (T.tv_usec >= startT.tv_usec)  T.tv_usec -= startT.tv_usec;
   else {
      T.tv_sec--;
      T.tv_usec += 1000000;
      T.tv_usec -= startT.tv_usec;
      }
   printf("t=%d.%03d Pdbg ",T.tv_sec,T.tv_usec/1000);
   printf("sndId=%d ",p->sndId);
   showhex(p->stuff,24);
   printf("\n");
   }

void displayNeighborDebug(beaconDebugMsgPtr p) {
   int i;
   struct timeval T;

   // show elapsed time since start of run
   gettimeofday(&T,NULL);
   T.tv_sec -= startT.tv_sec;
   if (T.tv_usec >= startT.tv_usec)  T.tv_usec -= startT.tv_usec;
   else {
      T.tv_sec--;
      T.tv_usec += 1000000;
      T.tv_usec -= startT.tv_usec;
      }
   printf("t=%d.%03d Ndbg ",T.tv_sec,T.tv_usec/1000);
   printf("sndId=%d ",p->sndId);
   showhex(p->stuff,24);
   printf("\n");
   }

void displaySkew(skewMsgPtr p) {
   int i;
   double V;
   struct timeval T;

   // show elapsed time since start of run
   gettimeofday(&T,NULL);
   T.tv_sec -= startT.tv_sec;
   if (T.tv_usec >= startT.tv_usec)  T.tv_usec -= startT.tv_usec;
   else {
      T.tv_sec--;
      T.tv_usec += 1000000;
      T.tv_usec -= startT.tv_usec;
      }
   printf("t=%d.%03d Skewcast ",T.tv_sec,T.tv_usec/1000);
   printf("sndId=%d ",p->sndId);
   printf("rootId=%d ",p->rootId);
   printf("minId=%d ",p->minId);
   printf("seqno=%d ",p->seqno);
   // display init time in skew message
   V = (double) *(uint16_t *)p->initStamp;
   V *= 4294967295.0 / (double) TPS;
   V += (double) moteInt(&p->initStamp[2]) / (double) TPS;
   printf("initStamp=%f ",V);
   // minimum known skew 
   printf("skewMin=%e\n",p->skewMin);
   }

void displayProbeAck(beaconProbeAckPtr p ) {
   int i, j, k, n; 
   int id1, id2;
   double L, V, s, y, mean;
   struct timeval T;
   struct recordProbe { 
      int id;
      int seqno;
      double Vclock;
      float skew;
      float calibRatio;
      };
   static struct recordProbe R[50] = { -1, -1 };

   // show elapsed time since start of run
   gettimeofday(&T,NULL);
   T.tv_sec -= startT.tv_sec;
   if (T.tv_usec >= startT.tv_usec)  T.tv_usec -= startT.tv_usec;
   else {
      T.tv_sec--;
      T.tv_usec += 1000000;
      T.tv_usec -= startT.tv_usec;
      }
   // printf("t=%d.%03d ",T.tv_sec,T.tv_usec/1000);

   // show sequence number, id
   // printf("-- probeAck: count=%d id=%d ",p->count,p->sndId);

   // display local time in beacon message
   L = (double) *(uint16_t *)p->Local;
   L *= 4294967295.0 / (double) TPS;
   L += (double) moteInt(&p->Local[2]) / (double) TPS;

   // display virtual time in beacon message
   V = (double) *(uint16_t *)p->Virtual;
   V *= 4294967295.0 / (double) TPS;
   V += (double) moteInt(&p->Virtual[2]) / (double) TPS;

   // printf(" Ltime=%f Vtime=%f ",L,V);

   // show current skew adjustment
   // printf(" skew=%d\n",p->skew);

   // check for this probe ack being a new one 
   if (p->count != R[0].seqno && R[0].seqno!= -1) { 
      /**** time to generate statistics ****/
      // first, calculate mean time in batch
      for (i=n=0, j=R[0].seqno, s=0.0; i<50; i++) {  
         if (R[i].seqno == j) {
            n++;
            s += R[i].Vclock;
            }
         else break;
         }
      mean = s / (double) n;
      // then, get mean of difference from mean
      for (i=0, j=R[0].seqno, s=0.0; i<50; i++) { 
         if (R[i].seqno == j) 
            s += (R[i].Vclock > mean) ?  
                    (R[i].Vclock - mean) : 
                    (mean - R[i].Vclock);
         else break;
         }
      s /= (double) n;

      // display result 
	  if (n > 1) {
	      printf("t=%d.%03d ",T.tv_sec,T.tv_usec/1000);
          printf("accuracy for count=%d is %d microsec ",j, (int) (s*1.0e6));
		  }

      // also, show max 
      id1 = id2 = 0;
      for (i=0, j=R[0].seqno, s=0.0; i<50; i++) {
         if (R[i].seqno != j) break; 
         for (k=0; k<50; k++) { 
            if (R[k].seqno != j) break; 
            y = (R[k].Vclock > R[i].Vclock) ? 
                  R[k].Vclock - R[i].Vclock :
                  R[i].Vclock - R[k].Vclock;
            if (y>s) {
               s = y;
               id1 = R[i].id;
               id2 = R[k].id;
               }
            }
         }
      if (n > 1) printf("max=%d n=%d ",(int) (s*1.0e6),n);
      if (id1 != 0) printf("max apart are %d and %d\n",id1,id2);
	  else printf("\n");

      // display skew values for the motes in the recorded array
      for (i=n=0, j=R[0].seqno; i<50; i++) {
         if (R[i].seqno!=j) break;
         if (R[i].skew != 0.0) n++; 
         }
	  printf("t=%d.%03d ",T.tv_sec,T.tv_usec/1000);
      printf("skews are:");
      for (i=0, j=R[0].seqno; i<50; i++) {
         if (R[i].seqno!=j) break;
         if (R[i].skew != 0.0) printf(" %d(%e)",R[i].id,R[i].skew); 
         else printf(" %d(-)",R[i].id);
         }
      printf("\n");

      // display calib values for the motes in the recorded array
      for (i=n=0, j=R[0].seqno; i<50; i++) {
         if (R[i].seqno!=j) break;
         if (R[i].calibRatio != 0.0) n++; 
         }
	  printf("t=%d.%03d ",T.tv_sec,T.tv_usec/1000);
      printf("calibration ratios are:");
      for (i=0, j=R[0].seqno; i<50; i++) {
         if (R[i].seqno!=j) break;
         if (R[i].calibRatio != 0.0) printf(" %d(%e)",R[i].id,R[i].calibRatio); 
         else printf(" %d(-)",R[i].id);
         }
      printf("\n");

      }

   // add entry table, if possible
   for (i=0; i<50; i++) 
      if (R[i].seqno != p->count) break;
   if (i >= 50) return;

   // found available entry, now record data
   R[i].seqno = p->count;
   R[i].id = p->sndId;
   R[i].Vclock = V;
   R[i].skew = p->skew;
   R[i].calibRatio = p->calibRatio;
   }

void displayBeac( beaconMsgPtr p ) {
   struct timeval T;
   double L,V,delay;
   char lnib,rnib;
   uint32_t w;
 
   // show elapsed time since start of run
   gettimeofday(&T,NULL);
   T.tv_sec -= startT.tv_sec;
   if (T.tv_usec >= startT.tv_usec)  T.tv_usec -= startT.tv_usec;
   else {
      T.tv_sec--;
      T.tv_usec += 1000000;
      T.tv_usec -= startT.tv_usec;
      }
   printf("t=%d.%03d ",T.tv_sec,T.tv_usec/1000);

   // show mode id, latest "diff" value
   printf("id=%d ",p->sndId);
   printf("diff=%d ",p->prevDiff);

   // display local time in beacon message
   L = (double) *(uint16_t *)p->Local;
   L *= 4294967295.0 / (double) TPS;
   L += (double) moteInt(&p->Local[2]) / (double) TPS;

   // display virtual time in beacon message
   V = (double) *(uint16_t *)p->Virtual;
   V *= 4294967295.0 / (double) TPS;
   V += (double) moteInt(&p->Virtual[2]) / (double) TPS;

   // obtain MAC delay interval from beacon
   delay = (double)nx_moteInt((uint8_t *)p->Delay) / (double) TPS;
   // add delay to other times (adjusting properly)
   L += delay;
   V += delay;

   // show times of beacon
   printf(" Ltime=%f Vtime=%f delay=%f ",L,V,delay);

   // print current mode, number of neighbors
   lnib = (p->mode >> 4) & 0xf;
   rnib =  p->mode & 0xf;
   lnib = (lnib > 9) ? 'A'+lnib-9 : '0' + lnib;
   rnib = (rnib > 9) ? 'A'+rnib-9 : '0' + rnib;
   printf("mode=%c%c ",lnib,rnib);
   printf("nsize=%d\n",p->NbrSize);
   }

void printHelp() { 
   printf("Syntax   spy  [-z|-t]\n");
   printf("\t\t -z for a micaz mote and MIB serial forwarding\n");
   printf("\t\t -t for a telos-type mote and USB serial forwarding\n");
   }

int main(int argc, char **argv) {

   int i,k,r;
   int sock;
   extern int errno;
   extern int h_errno;
   struct sockaddr_in toServer; 
   struct hostent * h;
   struct pollfd waitor;
   micaTOS_Msg bufferMica;
   telosTOS_Msg bufferTelos;
   uint8_t AMtype;
   uint8_t AMlength;
   uint8_t * dataP;
   uint8_t x;
   extern char *optarg;
   extern int optind, opterr, optopt;

   /** Parse arguments to set parameters **/
   while (TRUE) {
     k = getopt(argc, argv, "8tz"); 
     if (k == -1) break;
     switch ((char)k) {
       case '8':  motetype = MICA128; break;
       case 'z':  motetype = MICAZ; break;
       case 't':  motetype = TELOS; break;
       case '?':  printHelp(); exit(1); 
       }
     }
   if (motetype == 0) { printHelp(); exit(1); }
   if (motetype == MICAZ) TPS = 921778;   
   if (motetype == TELOS) TPS = 1024*1024;

   gettimeofday( &startT, NULL );

   bzero((char *) &toServer, sizeof(toServer));
   toServer.sin_family = AF_INET;
   toServer.sin_port = htons(9001);
   h = gethostbyname("localhost");
   if (h == NULL) { perror("gethostbyname error"); exit(h_errno); }
   bcopy(h->h_addr, (char *) &toServer.sin_addr, h->h_length);

   sock = socket(AF_INET, SOCK_STREAM, 0);
   if (sock < 0) { perror("unable to create socket"); exit(errno); }
   i = 1;
   r = setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, (char *) &i, sizeof (i));
   if (r < 0) { perror("setsockopt error"); 
                close(sock); exit(errno); }
   r = connect(sock, (struct sockaddr *) &toServer, sizeof(toServer)); 
   if (r < 0) { perror("connect error"); exit(errno); }

   // use the "poll()" function so that we don't get stuck
   // trying to read from a socket that has no data
   waitor.fd = sock;
   waitor.events =  POLLIN;

   // do the silly "version exchange" that SFProtocol.java needs
   exchange(sock);

   /***** Loop to read any response(s) ********************/
   while (TRUE) {
     // here would be a chance to read from the keyboard someday ...
     poll(&waitor,1,250);
     if (!(waitor.revents & POLLIN)) continue;  // no message!

     if (motetype == TELOS) {
       getStreamTelos(sock,&bufferTelos);
       AMtype = bufferTelos.type;
       AMlength = bufferTelos.length;
       dataP = bufferTelos.data;
       }
     else {
       getStreamMica(sock,&bufferMica);
       AMtype = bufferMica.type;
       AMlength = bufferMica.length;
       dataP = bufferMica.data;
       }

     switch (AMtype) {  // handle different AM msg types
       case AM_BEACON: displayBeac((beaconMsgPtr) dataP); break;
       case AM_PROBE_ACK:  
            displayProbeAck((beaconProbeAckPtr) dataP); break;
       case AM_NEIGHBOR:
            displayNeighbor((neighborMsgPtr) dataP); break;
       case AM_UART: 
	    displayBeac((beaconMsgPtr) dataP); break;
       case AM_PROBE_DEBUG:
	    displayProbeDebug((beaconDebugMsgPtr) dataP); break;
       case AM_NEIGHBOR_DEBUG:
	    displayNeighborDebug((beaconDebugMsgPtr) dataP); break;
       case AM_SKEW:
	    displaySkew((skewMsgPtr) dataP); break;
       default:  break;
       }
     }
   }


