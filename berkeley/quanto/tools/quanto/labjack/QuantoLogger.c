/**
 * Captures data on EIO and FIO on an external trigger and streams the
 * data over a TCP stream.  The required message exchanges between the
 * host the LabJack device is as follows:
 * 
 *   1. Host ----[StreamConfig]---> LabJack  // Command
 *   2. Host <---[StreamConfig]---- LabJack  // Response
 *   3. Host ----[StreamStart]----> LabJack  // Command
 *   4. Host <---[StreamData]------ LabJack  // Response
 *      ...           ...             ...
 *      ...           ...             ...
 *      ...           ...             ...
 *   7. Host <---[StreamData]------ LabJack  // Response
 *   8. Host ----[StreamStop]-----> LabJack  // Command
 *   9. Host <---[StreamStop]------ LabJack  // Response
 * 
 */
#include "ue9.h"
#include <signal.h>

char *ipAddress;
const int porta = 52360;
const int portb = 52361;
const int ainResolution = 12;
const uint8 NumChannels = 1;

int StreamConfig(int sfd);
int StreamStart(int sfd);
int StreamData(int sfda, int sfdb, ue9CalibrationInfo *caliInfo);
int StreamStop(int sfda, int displayError);
int flushStream(int sfd);
int flush(int sfda);

/**
 * Closes the control and data streams to the LabJack.
 * @param   sda the socket descriptor for the control stream.
 * @param   sdb the socket descriptor for the data stream.
 */
int StreamClose(int sda, int sdb) {
  return closeTCPConnection(sda) + closeTCPConnection(sdb);
}

/**
 * Stops the stream and then flushes the stream buffer.
 * @param   sd the socket descriptor to flush.
 */
int flush(int sd) {
  fprintf(stderr, "Flushing stream.\n");
  StreamStop(sd, 0);
  flushStream(sd);
  return 0;
}

void cleanup(int s) {
    fflush(stdout);
    exit(s);
}

int main(int argc, char **argv) {
  ue9CalibrationInfo caliInfo;
  int fda, fdb;
  fda = -1;
  fdb = -1;

  signal(SIGINT, cleanup);

  if(argc != 2) {
    fprintf(stderr, "Usage: QuantoLogger <remote-address>\n");
    exit(0);
  }

  ipAddress = argv[1];

  if( (fda = openTCPConnection(ipAddress, porta)) < 0) {
    exit(0);
  }
  flush(fda);
  if( (fdb = openTCPConnection(ipAddress, portb)) < 0) {
    StreamClose(fda, fdb);
  }

  if(StreamConfig(fda) != 0) {
    StreamClose(fda, fdb);
  }
  if(StreamStart(fda) != 0) {
    StreamClose(fda, fdb);
  }
  StreamData(fda, fdb, &caliInfo);
  StreamStop(fda, 1);
  exit(0);
}

/**
 * Configures LabJack to capture EIO and FIO on FIOx falling edge.
 * @param sfd socket connected to the control stream.
 */
int StreamConfig(int sfd) {
  int sendBuffSize;
  uint8 *sendBuff;
  uint8 recBuff[8];
  int sendChars, recChars;
  uint16 checksumTotal, scanInterval;

  sendBuffSize = 12 + 2*NumChannels;
  sendBuff = malloc(sizeof(uint8)*sendBuffSize);

  sendBuff[1] = (uint8)(0xF8);      //command byte
  sendBuff[2] = NumChannels + 3;    //number of data words : NumChannels + 3
  sendBuff[3] = (uint8)(0x11);      //extended command number
  sendBuff[6] = (uint8)NumChannels; //NumChannels
  sendBuff[7] = ainResolution;      //resolution
  sendBuff[8] = 0;                  //SettlingTime = 0
  sendBuff[9] = 0x40;               //Ext trig
  scanInterval = 4000;
  sendBuff[10] = (uint8)(scanInterval & 0x00FF); //scan interval (low byte)
  sendBuff[11] = (uint8)(scanInterval / 256);	 //scan interval (high byte)
  sendBuff[12] = 193;
  sendBuff[13] = 0;

  extendedChecksum(sendBuff, sendBuffSize);

  // Send command to UE9
  sendChars = send(sfd, sendBuff, sendBuffSize, 0);
  if(sendChars < sendBuffSize) {
    if(sendChars == -1) {
      fprintf(stderr,"Error : send failed (StreamConfig)\n");
    }
    else {
      fprintf(stderr, "Error : did not send all of the buffer (StreamConfig)\n");
      free(sendBuff);
      sendBuff = NULL;
      return -1;
    }
  }

  // Receive response from UE9
  recChars = recv(sfd, recBuff, 8, 0);
  if(recChars < 8) {
    if(recChars == -1) {
      fprintf(stderr, "Error : receive failed (StreamConfig)\n");
    }
    else {
      fprintf(stderr, "Error : did not receive all of the buffer (StreamConfig)\n");
    }
    free(sendBuff);
    sendBuff = NULL;
  }

  checksumTotal = extendedChecksum16(recBuff, 8);

  if( (uint8)((checksumTotal / 256) & 0xff) != recBuff[5]) {
    fprintf(stderr, "Error : received buffer has bad checksum16(MSB) (StreamConfig)\n");
    free(sendBuff);
    sendBuff = NULL;
    return -1;
  }

  if( (uint8)(checksumTotal & 0xff) != recBuff[4]) {
    fprintf(stderr, "Error : received buffer has bad checksum16(LBS) (StreamConfig)\n");
    free(sendBuff);
    sendBuff = NULL;
    return -1;
  }

  if( extendedChecksum8(recBuff) != recBuff[0]) {
    fprintf(stderr, "Error : received buffer has bad checksum8 (StreamConfig)\n");
    free(sendBuff);
    sendBuff = NULL;
    return -1;
  }

  if(recBuff[1] != (uint8)(0xF8) || 
     recBuff[2] != (uint8)(0x01) || 
     recBuff[3] != (uint8)(0x11) || 
     recBuff[7] != (uint8)(0x00)) {
    fprintf(stderr, "Error : received buffer has wrong command bytes (StreamConfig)\n");
    free(sendBuff);
    sendBuff = NULL;
    return -1;
  }

  if(recBuff[6] != 0) {
    fprintf(stderr, "Errorcode # %d from StreamConfig received.\n", 
	   (unsigned int)recBuff[6]);
    free(sendBuff);
    sendBuff = NULL;
    return -1;
  }
  return 0;
}

/**
 * Send command to start streaming.
 * @param sfd socket connected to control stream.
 */
int StreamStart(int sfd) {
  uint8 sendBuff[2], recBuff[4];
  int sendChars, recChars;

  sendBuff[0] = (uint8)(0xA8);  //CheckSum8
  sendBuff[1] = (uint8)(0xA8);  //command byte

  // Send command to UE9
  sendChars = send(sfd, sendBuff, 2, 0);
  if(sendChars < 2) {
    if(sendChars == -1) {
      fprintf(stderr, "Error : send failed\n");
    }
    else {
      fprintf(stderr, "Error : did not send all of the buffer\n");
    }
    return -1;
  }

  // Receive response from UE9
  recChars = recv(sfd, recBuff, 4, 0);
  if(recChars < 4) {
    if(recChars == -1) {
      fprintf(stderr, "Error : receive failed\n");
    }
    else {
      fprintf(stderr, "Error : did not receive all of the buffer\n");
    }
    return -1;
  }

  if( recBuff[1] != (uint8)(0xA9) || recBuff[3] != (uint8)(0x00) ) {
    fprintf(stderr, "Error : received buffer has wrong command bytes \n");
    return -1;
  }

  if(recBuff[2] != 0) {
    fprintf(stderr, "Errorcode # %d from StreamStart received.\n", 
	   (unsigned int)recBuff[2]);
    return -1;
  }
  return 0;
}


/**
 * Reads the StreamData.
 */
int StreamData(int sfda, int sfdb, ue9CalibrationInfo *caliInfo) {
  uint8_t j, cnt, start_frame, first, sync;
  uint8_t buf[46];

  first = 1;
  sync  = 0;

  fprintf(stderr, "QuantoLogger: Reading StreamData\n");

  while(1) {
  //for (i = 0 ; i < 100; i++) {
    cnt = 0;
    do {
      cnt += recv(sfdb, &buf[cnt], 46-cnt, 0);
    } while(cnt < 46);

    //printf("%d : ", buf[10]);
    for (j = 12; j < 44; j = j+1) {
      if (!(j % 2)) {
        //control byte
        start_frame = (buf[j] & 0x2);
        if (!sync && start_frame)
            sync = 1;
        if (first) {
            start_frame = 0;
            first = 0;
        }
      } else {
        if (sync) {
          if (start_frame) {
              printf("\n");
	          fflush(stdout);
          }
          printf("%02X ", buf[j]);
        } else {
            //skipping bytes, not synchronized
            fprintf(stderr,".");
        } 
      }
    }
  }
  return 0;
}


/**
 * Sends a StreamStop low-level command to stop streaming.
 * @param sfd socket to control stream.
 */
int StreamStop(int sfd, int displayError) {
  uint8 sendBuff[2], recBuff[4];
  int sendChars, recChars;

  sendBuff[0] = (uint8)(0xB0);  //CheckSum8
  sendBuff[1] = (uint8)(0xB0);  //command byte

  sendChars = send(sfd, sendBuff, 2, 0);
  if(sendChars < 2) {
    if(displayError) {
      if(sendChars == -1) {
        fprintf(stderr, "Error : send failed (StreamStop)\n");
      }
      else {
        fprintf(stderr, "Error : did not send all of the buffer (StreamStop)\n");
      }
      return -1;
    }
  }

  //Receiving response from UE9
  recChars = recv(sfd, recBuff, 4, 0);
  if(recChars < 4) {
    if(displayError) {
      if(recChars == -1) {
        fprintf(stderr, "Error : receive failed (StreamStop)\n");
      }
      else {
        fprintf(stderr, "Error : did not receive all of the buffer (StreamStop)\n");
      }
    }
    return -1;
  }

  if( recBuff[1] != (uint8)(0xB1) || recBuff[3] != (uint8)(0x00) ) {
    if(displayError) {
      fprintf(stderr, "Error : received buffer has wrong command bytes (StreamStop)\n");
    }
    return -1;
  }

  if(recBuff[2] != 0) {
    if(displayError)
      fprintf(stderr, "Errorcode # %d from StreamStop received.\n", 
	     (unsigned int)recBuff[2]);
    return -1;
  }

  return 0;
}

/**
 * Sends a command to clear the stream buffer.
 * @param sfd socket to control stream.
 */
int flushStream(int sfd) {
  uint8 sendBuff[2], recBuff[2];
  int sendChars, recChars;

  sendBuff[0] = (uint8)(0x08);  //CheckSum8
  sendBuff[1] = (uint8)(0x08);  //command byte

  // Send command to UE9
  sendChars = send(sfd, sendBuff, 2, 0);
  if(sendChars < 2) {
    if(sendChars == -1) {
      fprintf(stderr, "Error : send failed (flushStream)\n");
    }
    else {
      fprintf(stderr, "Error : did not send all of the buffer (flushStream)\n");
    }
    return -1;
  }

  // Receive response from UE9
  recChars = recv(sfd, recBuff, 4, 0);
  if(recChars < 2) {
    if(recChars == -1) {
      fprintf(stderr, "Error : receive failed (flushStream)\n");
    }
    else {
      fprintf(stderr, "Error : did not receive all of the buffer (flushStream)\n");
    }
    return -1;
  }

  if(recBuff[0] != (uint8)(0x08) || recBuff[1] != (uint8)(0x08)) {
    fprintf(stderr, "Error : received buffer has wrong command bytes (flushStream)\n");
    return -1;
  }
  return 0;
}
