//Author: LabJack
//Aug. 8, 2008
//Example UE9 helper functions.  Function descriptions are in ue9.h.
#include "ue9.h"


void normalChecksum(uint8 *b, int n)
{
  b[0]=normalChecksum8(b, n);
}


void extendedChecksum(uint8 *b, int n)
{
  uint16 a;

  a = extendedChecksum16(b, n);
  b[4] = (uint8)(a & 0xff);
  b[5] = (uint8)((a / 256) & 0xff);
  b[0] = extendedChecksum8(b);
}


uint8 normalChecksum8(uint8 *b, int n)
{
  int i;
  uint16 a, bb;

  //Sums bytes 1 to n-1 unsigned to a 2 byte value. Sums quotient and
  //remainder of 256 division.  Again, sums quotient and remainder of
  //256 division.
  for(i = 1, a = 0; i < n; i++)
    a+=(uint16)b[i];

  bb = a / 256;
  a = (a - 256 * bb) + bb;
  bb = a / 256;

  return (uint8)((a-256*bb)+bb);
}


uint16 extendedChecksum16(uint8 *b, int n)
{
  int i, a = 0;

  //Sums bytes 6 to n-1 to a unsigned 2 byte value
  for(i = 6; i < n; i++)
    a += (uint16)b[i];

  return a;
}


/* Sum bytes 1 to 5. Sum quotient and remainder of 256 division. Again, sum
   quotient and remainder of 256 division. Return result as uint8. */
uint8 extendedChecksum8(uint8 *b)
{
  int i, a, bb;

  //Sums bytes 1 to 5. Sums quotient and remainder of 256 division. Again, sums 
  //quotient and remainder of 256 division.
  for(i = 1, a = 0; i < 6; i++)
    a+=(uint16)b[i];

  bb = a / 256;
  a = (a - 256 * bb) + bb;
  bb = a / 256;

  return (uint8)((a - 256 * bb) + bb);  
}


int openTCPConnection(char *ipAddress, int port)
{
  int socketFd;
  struct sockaddr_in address;

  #ifdef WIN32
  WSADATA info;
  struct hostent *he;

  if (WSAStartup(MAKEWORD(1,1), &info) != 0)
  {
    printf("Error: Cannot initilize winsock\n");
    return 0;
  }
  #endif

  socketFd = socket(PF_INET, SOCK_STREAM,IPPROTO_TCP);

  if(socketFd == -1)
  {
    fprintf(stderr,"Could not create socket. Exiting\n");
    return -1;
  }

  address.sin_family=AF_INET;
  address.sin_port=htons(port);

  #ifdef WIN32
  he = gethostbyname(ipAddress);
  address.sin_addr = *((struct in_addr *)he->h_addr);
  #else
  inet_pton(AF_INET, ipAddress, &address.sin_addr);

  int window_size = 128 * 1024;  //current window size is 128 kilobytes
  int rw = 0;
  socklen_t size = sizeof(rw);
  int err;
  err = setsockopt(socketFd, SOL_SOCKET, SO_RCVBUF, (char*)&window_size, sizeof(window_size));

  err = getsockopt(socketFd, SOL_SOCKET, SO_RCVBUF, (char*)&rw, &size );
  #endif

  if((connect(socketFd,(struct sockaddr *)&address,sizeof(address))) < 0)
  {
    fprintf(stderr,"Could not connect to %s:%d\n",inet_ntoa(address.sin_addr), port);
    return -2;
  }

  return socketFd;
}


int closeTCPConnection(int fd)
{
  #ifdef WIN32
  int err;

  err = closesocket(fd);
  WSACleanup();

  return err;
  #else
  return close(fd);
  #endif
}


long getTickCount()
{
#ifdef WIN32
  return ( (long)(GetTickCount()) );
#else
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
#endif
}


long getCalibrationInfo(int fd, ue9CalibrationInfo *caliInfo)
{
  uint8 sendBuffer[8];
  uint8 recBuffer[136];
  int sentRec = 0;

  /* reading block 0 from memory */
  sendBuffer[1] = (uint8)(0xF8);  //command byte
  sendBuffer[2] = (uint8)(0x01);  //number of data words
  sendBuffer[3] = (uint8)(0x2A);  //extended command number
  sendBuffer[6] = (uint8)(0x00);
  sendBuffer[7] = (uint8)(0x00);  //Blocknum = 0
  extendedChecksum(sendBuffer, 8);

  sentRec = send(fd, sendBuffer, 8, 0);

  if(sentRec < 8)
  {
    if(sentRec == -1)
      goto sendError0;
    else  
      goto sendError1;
  }

  sentRec= recv(fd, recBuffer, 136, 0);

  if(sentRec < 136)
  {
    if(sentRec == -1)
      goto recvError0;
    else  
      goto recvError1;
  }

  if(recBuffer[1] != (uint8)(0xF8) || recBuffer[2] != (uint8)(0x41) || recBuffer[3] != (uint8)(0x2A))
    goto commandByteError;

  //block data starts on byte 8 of the buffer
  caliInfo->unipolarSlope[0] = FPuint8ArrayToFPDouble(recBuffer + 8, 0);
  caliInfo->unipolarOffset[0] = FPuint8ArrayToFPDouble(recBuffer + 8, 8);
  caliInfo->unipolarSlope[1] = FPuint8ArrayToFPDouble(recBuffer + 8, 16);
  caliInfo->unipolarOffset[1] = FPuint8ArrayToFPDouble(recBuffer + 8, 24);
  caliInfo->unipolarSlope[2] = FPuint8ArrayToFPDouble(recBuffer + 8, 32);
  caliInfo->unipolarOffset[2] = FPuint8ArrayToFPDouble(recBuffer + 8, 40);
  caliInfo->unipolarSlope[3] = FPuint8ArrayToFPDouble(recBuffer + 8, 48);
  caliInfo->unipolarOffset[3] = FPuint8ArrayToFPDouble(recBuffer + 8, 56);

  /* reading block 1 from memory */
  sendBuffer[7] = (uint8)(0x01);    //Blocknum = 1
  extendedChecksum(sendBuffer, 8);

  sentRec = send(fd, sendBuffer, 8, 0);

  if(sentRec < 8)
  {
    if(sentRec == -1)
      goto sendError0;
    else  
      goto sendError1;
  }

  sentRec= recv(fd, recBuffer, 136, 0);

  if(sentRec < 136)
  {
    if(sentRec == -1)
      goto recvError0;
    else  
      goto recvError1;
  }

  if(recBuffer[1] != (uint8)(0xF8) || recBuffer[2] != (uint8)(0x41) || recBuffer[3] != (uint8)(0x2A))
    goto commandByteError;

  //block data starts on byte 8 of the buffer
  caliInfo->bipolarSlope = FPuint8ArrayToFPDouble(recBuffer + 8, 0);
  caliInfo->bipolarOffset = FPuint8ArrayToFPDouble(recBuffer + 8, 8);

  /* reading block 2 from memory */
  sendBuffer[7] = (uint8)(0x02);    //Blocknum = 2
  extendedChecksum(sendBuffer, 8);

  sentRec = send(fd, sendBuffer, 8, 0);

  if(sentRec < 8)
  {
    if(sentRec == -1)
      goto sendError0;
    else  
      goto sendError1;
  }

  sentRec= recv(fd, recBuffer, 136, 0);

  if(sentRec < 136)
  {
    if(sentRec == -1)
      goto recvError0;
    else  
      goto recvError1;
  }

  if(recBuffer[1] != (uint8)(0xF8) || recBuffer[2] != (uint8)(0x41) || recBuffer[3] != (uint8)(0x2A))
    goto commandByteError;

  //block data starts on byte 8 of the buffer
  caliInfo->DACSlope[0] = FPuint8ArrayToFPDouble(recBuffer + 8, 0);
  caliInfo->DACOffset[0] = FPuint8ArrayToFPDouble(recBuffer + 8, 8);
  caliInfo->DACSlope[1] = FPuint8ArrayToFPDouble(recBuffer + 8, 16);
  caliInfo->DACOffset[1] = FPuint8ArrayToFPDouble(recBuffer + 8, 24);
  caliInfo->tempSlope = FPuint8ArrayToFPDouble(recBuffer + 8, 32);
  caliInfo->tempSlopeLow = FPuint8ArrayToFPDouble(recBuffer + 8, 48);
  caliInfo->calTemp = FPuint8ArrayToFPDouble(recBuffer + 8, 64);
  caliInfo->Vref = FPuint8ArrayToFPDouble(recBuffer + 8, 72);
  caliInfo->VrefDiv2 = FPuint8ArrayToFPDouble(recBuffer + 8, 88);
  caliInfo->VsSlope = FPuint8ArrayToFPDouble(recBuffer + 8, 96);


  /* reading block 3 from memory */
  sendBuffer[7] = (uint8)(0x03);    //Blocknum = 3
  extendedChecksum(sendBuffer, 8);

  sentRec = send(fd, sendBuffer, 8, 0);

  if(sentRec < 8)
  {
    if(sentRec == -1)
      goto sendError0;
    else  
      goto sendError1;
  }

  sentRec= recv(fd, recBuffer, 136, 0);

  if(sentRec < 136)
  {
    if(sentRec == -1)
      goto recvError0;
    else  
      goto recvError1;
  }

  if(recBuffer[1] != (uint8)(0xF8) || recBuffer[2] != (uint8)(0x41) || recBuffer[3] != (uint8)(0x2A))
    goto commandByteError;

  //block data starts on byte 8 of the buffer
  caliInfo->hiResUnipolarSlope = FPuint8ArrayToFPDouble(recBuffer + 8, 0);
  caliInfo->hiResUnipolarOffset = FPuint8ArrayToFPDouble(recBuffer + 8, 8);

  /* reading block 4 from memory */
  sendBuffer[7] = (uint8)(0x04);    //Blocknum = 4
  extendedChecksum(sendBuffer, 8);

  sentRec = send(fd, sendBuffer, 8, 0);

  if(sentRec < 8)
  {
    if(sentRec == -1)
      goto sendError0;
    else  
      goto sendError1;
  }

  sentRec= recv(fd, recBuffer, 136, 0);

  if(sentRec < 136)
  {
    if(sentRec == -1)
      goto recvError0;
    else  
      goto recvError1;
  }

  if(recBuffer[1] != (uint8)(0xF8) || recBuffer[2] != (uint8)(0x41) || recBuffer[3] != (uint8)(0x2A))
    goto commandByteError;

  //block data starts on byte 8 of the buffer
  caliInfo->hiResBipolarSlope = FPuint8ArrayToFPDouble(recBuffer + 8, 0);
  caliInfo->hiResBipolarOffset = FPuint8ArrayToFPDouble(recBuffer + 8, 8);
  caliInfo->prodID = 9;
  
  return 0;

sendError0: 
  printf("Error : getCalibrationInfo send failed\n");
  return -1;

sendError1:
  printf("Error : getCalibrationInfo send did not send all of the buffer\n");
  return -1;

recvError0:
  printf("Error : getCalibrationInfo recv failed\n");
  return -1;

recvError1:
  printf("Error : getCalibrationInfo recv did not receive all of the buffer\n");
  return -1;

commandByteError:
  printf("Error : received buffer at byte 1, 2, or 3 are not 0xA3, 0x01, 0x2A \n");
  return -1;
}


long getLJTDACCalibrationInfo(int fd, ue9LJTDACCalibrationInfo *caliInfo, uint8 DIOAPinNum) {
  int err;
  uint8 options, speedAdjust, sdaPinNum, sclPinNum, address, numByteToSend, numBytesToReceive, errorcode;
  uint8 bytesCommand[1];
  uint8 bytesResponse[32];
  uint8 ackArray[4];

  err = 0;

  //Setting up I2C command for LJTDAC
  options = 0;                //I2COptions : 0
  speedAdjust = 0;            //SpeedAdjust : 0 (for max communication speed of about 130 kHz)
  sdaPinNum = DIOAPinNum+1;   //SDAPinNum : FIO channel connected to pin DIOB
  sclPinNum = DIOAPinNum;     //SCLPinNum : FIO channel connected to pin DIOA
  address = (uint8)(0xA0);    //Address : h0xA0 is the address for EEPROM
  numByteToSend = 1;          //NumI2CByteToSend : 1 byte for the EEPROM address
  numBytesToReceive = 32;     //NumI2CBytesToReceive : getting 32 bytes starting at EEPROM address specified in I2CByte0

  bytesCommand[0] = 64;       //I2CByte0 : Memory Address (starting at address 64 (DACA Slope)

  //Performing I2C low-level call
  err = I2C(fd, options, speedAdjust, sdaPinNum, sclPinNum, address, numByteToSend, numBytesToReceive, bytesCommand, &errorcode, ackArray, bytesResponse);

  if(errorcode != 0)
  {
    printf("Getting LJTDAC calibration info error : received errorcode %d in response\n", errorcode);
    err = -1;
  }

  if(err == -1)
    return err;

  caliInfo->DACSlopeA = FPuint8ArrayToFPDouble(bytesResponse, 0);
  caliInfo->DACOffsetA = FPuint8ArrayToFPDouble(bytesResponse, 8);
  caliInfo->DACSlopeB = FPuint8ArrayToFPDouble(bytesResponse, 16);
  caliInfo->DACOffsetB = FPuint8ArrayToFPDouble(bytesResponse, 24);
  caliInfo->prodID = 9;

  return err;
}


double FPuint8ArrayToFPDouble(uint8 *buffer, int startIndex) 
{ 
  uint32 resultDec = 0;
  uint32 resultWh = 0;
  int i;

  for(i = 0; i < 4; i++)
  {
    resultDec += (uint32)buffer[startIndex + i] * pow(2, (i*8));
    resultWh += (uint32)buffer[startIndex + i + 4] * pow(2, (i*8));
  }

  return ( (double)((int)resultWh) + (double)(resultDec)/4294967296.0 );
}


long isCalibrationInfoValid(ue9CalibrationInfo *caliInfo)
{
  if(caliInfo == NULL)
    goto invalid;
  if(caliInfo->prodID != 9)
    goto invalid;
  return 1;
invalid:
  printf("Error: Invalid calibration info.\n");
  return -1;
}


long isLJTDACCalibrationInfoValid(ue9LJTDACCalibrationInfo *caliInfo)
{
  if(caliInfo == NULL)
    goto invalid;
  if(caliInfo->prodID != 9)
    goto invalid;
  return 1;
invalid:
  printf("Error: Invalid LJTDAC calibration info.\n");
  return -1;
}


long binaryToCalibratedAnalogVoltage(ue9CalibrationInfo *caliInfo, uint8 gainBip, uint8 resolution, uint16 bytesVoltage, double *analogVoltage)
{
  double slope;
  double offset;

  if(isCalibrationInfoValid(caliInfo) == -1)
    return -1;

  if(resolution < 18)
  {
    switch( (unsigned int)gainBip )
    {
      case 0:
        slope = caliInfo->unipolarSlope[0];
        offset = caliInfo->unipolarOffset[0];
        break;
      case 1:
        slope = caliInfo->unipolarSlope[1];
        offset = caliInfo->unipolarOffset[1];
        break;
      case 2:
        slope = caliInfo->unipolarSlope[2];
        offset = caliInfo->unipolarOffset[2];
        break;
      case 3:
        slope = caliInfo->unipolarSlope[3];
        offset = caliInfo->unipolarOffset[3];
        break;
      case 8:
        slope = caliInfo->bipolarSlope;
        offset = caliInfo->bipolarOffset;
        break;
      default:
        goto invalidGainBip;
    }
  }
  else  //UE9 Pro high res
  {
    switch( (unsigned int)gainBip )
    {
      case 0:
        slope = caliInfo->hiResUnipolarSlope;
        offset = caliInfo->hiResUnipolarOffset;
        break;
      case 8:
        slope = caliInfo->hiResBipolarSlope;
        offset = caliInfo->hiResBipolarOffset;
        break;
      default:
        goto invalidGainBip;
    }
  }

  *analogVoltage = (slope * bytesVoltage) + offset;
  return 0;

invalidGainBip:
  printf("binaryToCalibratedAnalogVoltage error: invalid GainBip.\n");
  return -1;
}


long analogToCalibratedBinaryVoltage(ue9CalibrationInfo *caliInfo, int DACNumber, double analogVoltage, uint16 *bytesVoltage)
{
  double slope;
  double offset;
  double tempBytesVoltage;

  if(isCalibrationInfoValid(caliInfo) == -1)
    return -1;
    
  switch(DACNumber) 
  {
    case 0:
      slope = caliInfo->DACSlope[0];
      offset = caliInfo->DACOffset[0];
      break;
    case 1:
      slope = caliInfo->DACSlope[1];
      offset = caliInfo->DACOffset[1];
      break;
    default:
      printf("analogToCalibratedBinaryVoltage error: invalid DACNumber.\n");
      return -1;
  }

  tempBytesVoltage = slope * analogVoltage + offset;

  //Checking to make sure bytesVoltage will be a value between 0 and 4095, 
  //or that a uint16 overflow does not occur.  A too high analogVoltage 
  //(above 5 volts) or too low analogVoltage (below 0 volts) will cause a 
  //value not between 0 and 4095.
  if(tempBytesVoltage < 0)
    tempBytesVoltage = 0;
  if(tempBytesVoltage > 4095)
    tempBytesVoltage = 4095;

  *bytesVoltage = (uint16)tempBytesVoltage; 

  return 0;
}


long LJTDACAnalogToCalibratedBinaryVoltage(ue9LJTDACCalibrationInfo *caliInfo, int DACNumber, double analogVoltage, uint16 *bytesVoltage)
{
  double slope;
  double offset;
  double tempBytesVoltage;

  if(isLJTDACCalibrationInfoValid(caliInfo) == -1)
    return -1;

  switch(DACNumber)
  {
    case 0:
      slope = caliInfo->DACSlopeA;
      offset = caliInfo->DACOffsetA;
      break;
    case 1:
      slope = caliInfo->DACSlopeB;
      offset = caliInfo->DACOffsetB;
      break;
    default:
      printf("LJTDACAnalogToCalibratedBinaryVoltage error: invalid DACNumber.\n");
      return -1;
  }

  tempBytesVoltage = slope*analogVoltage + offset;

  //Checking to make sure bytesVoltage will be a value between 0 and 65535.  A
  //too high analogVoltage (above 10 volts) or too low analogVoltage (below
  //-10 volts) will create a value not between 0 and 65535.
  if(tempBytesVoltage < 0)
    tempBytesVoltage = 0;
  if(tempBytesVoltage > 65535)
    tempBytesVoltage = 65535;

  *bytesVoltage = (uint16)tempBytesVoltage; 

  return 0;
}


long binaryToCalibratedAnalogTemperature(ue9CalibrationInfo *caliInfo, int powerLevel, uint16 bytesTemperature, double *analogTemperature)
{
  double slope = 0;

  if(isCalibrationInfoValid(caliInfo) == -1)
    return -1;

  switch( (unsigned int)powerLevel )
  {
    case 0:     //high power 
      slope = caliInfo->tempSlope;
      break;
    case 1:     //low power
      slope = caliInfo->tempSlopeLow;
      break;
    default:
      printf("binaryToCalibratedAnalogTemperatureK error: invalid powerLevel.\n");
      return -1;
  }

  *analogTemperature = (double)(bytesTemperature)*slope;
  return 0;
}


long binaryToUncalibratedAnalogVoltage(uint8 gainBip, uint8 resolution, uint16 bytesVoltage, double *analogVoltage)
{
  double slope;
  double offset;

  if(resolution < 18)
  {
    switch( (unsigned int)gainBip )
    {
      case 0:
        slope = 0.000077503;
        offset = -0.012;
        break;
      case 1:
        slope = 0.000038736;
        offset = -0.012;
        break;
      case 2:
        slope = 0.000019353;
        offset = -0.012;
        break;
      case 3:
        slope = 0.0000096764;
        offset = -0.012;
        break;
      case 8:
        slope = 0.00015629;
        offset = -5.1760;
        break;
      default:
        goto invalidGainBip;
    }
  }
  else  //UE9 Pro high res
  {
    switch( (unsigned int)gainBip )
    {
      case 0:
        slope = 0.000077503;
        offset = 0.012;
        break;
      case 8:
        slope = 0.00015629;
        offset = -5.176;
        break;
      default:
        goto invalidGainBip;
    }
  }

  *analogVoltage = (slope*bytesVoltage) + offset;
  return 0;

invalidGainBip:
  printf("binaryToUncalibratedAnalogVoltage error: invalid GainBip.\n");
  return -1;
}


long analogToUncalibratedBinaryVoltage(double analogVoltage, uint16 *bytesVoltage)
{
  double tempBytesVoltage;

  tempBytesVoltage = 842.59*analogVoltage;

  //Checking to make sure bytesVoltage will be a value between 0 and 4095,
  //or that a uint16 overflow does not occur.  A too high analogVoltage 
  //(above 5 volts) or too low analogVoltage (below 0 volts) will cause a
  //value not between 0 and 4095.
  if(tempBytesVoltage < 0)
    tempBytesVoltage = 0;
  if(tempBytesVoltage > 4095)
    tempBytesVoltage = 4095;

  *bytesVoltage = (uint16)tempBytesVoltage;

  return 0;
}


long binaryToUncalibratedAnalogTemperature(uint16 bytesTemperature, double *analogTemperature)
{
  *analogTemperature = (double)(bytesTemperature)*0.012968;
  return 0;
}


long I2C(int fd, uint8 I2COptions, uint8 SpeedAdjust, uint8 SDAPinNum, uint8 SCLPinNum, uint8 AddressByte, uint8 NumI2CBytesToSend, uint8 NumI2CBytesToReceive, uint8 *I2CBytesCommand, uint8 *Errorcode, uint8 *AckArray, uint8 *I2CBytesResponse) {
  uint8 *sendBuff, *recBuff;
  int sendChars, recChars, sendSize, recSize, i, ret;
  uint16 checksumTotal = 0;
  uint32 ackArrayTotal, expectedAckArray;

  *Errorcode = 0;
  ret = 0;
  sendSize = 6 + 8 + ((NumI2CBytesToSend%2 != 0)?(NumI2CBytesToSend + 1):(NumI2CBytesToSend));
  recSize = 6 + 6 + ((NumI2CBytesToReceive%2 != 0)?(NumI2CBytesToReceive + 1):(NumI2CBytesToReceive));

  sendBuff = malloc(sizeof(uint8)*sendSize);
  recBuff = malloc(sizeof(uint8)*recSize);

  sendBuff[sendSize - 1] = 0;

  //I2C command
  sendBuff[1] = (uint8)(0xF8);          //command byte
  sendBuff[2] = (sendSize - 6)/2;       //number of data words = 4 + NumI2CBytesToSend
  sendBuff[3] = (uint8)(0x3B);          //extended command number

  sendBuff[6] = I2COptions;             //I2COptions
  sendBuff[7] = SpeedAdjust;            //SpeedAdjust
  sendBuff[8] = SDAPinNum;              //SDAPinNum
  sendBuff[9] = SCLPinNum;              //SCLPinNum
  sendBuff[10] = AddressByte;           //AddressByte: bit 0 needs to be zero, 
                                        //             bits 1-7 is the address
  sendBuff[11] = 0;                     //Reserved
  sendBuff[12] = NumI2CBytesToSend;     //NumI2CByteToSend
  sendBuff[13] = NumI2CBytesToReceive;  //NumI2CBytesToReceive

  for(i = 0; i < NumI2CBytesToSend; i++)
    sendBuff[14 + i] = I2CBytesCommand[i];  //I2CByte

  extendedChecksum(sendBuff, sendSize);

  //Sending command to UE9
  sendChars = send(fd, sendBuff, sendSize, 0);
  if(sendChars < sendSize)
  {
    if(sendChars == 0)
      printf("I2C Error : write failed\n");
    else
      printf("I2C Error : did not write all of the buffer\n");
    ret = -1;
	goto cleanmem;
  }

  //Reading response from UE9
  recChars = recv(fd, recBuff, recSize, 0);
  if(recChars < recSize)
  {
    if(recChars == 0)
      printf("I2C Error : read failed\n");
    else
    {
      printf("I2C Error : did not read all of the buffer\n");
      if(recChars >= 12)
        *Errorcode = recBuff[6];
    }
    ret = -1;
	goto cleanmem;
  }

  *Errorcode = recBuff[6];

  AckArray[0] = recBuff[8];
  AckArray[1] = recBuff[9];
  AckArray[2] = recBuff[10];
  AckArray[3] = recBuff[11];

  for(i = 0; i < NumI2CBytesToReceive; i++)
    I2CBytesResponse[i] = recBuff[12 + i];

  if((uint8)(extendedChecksum8(recBuff)) != recBuff[0])
  {
    printf("I2C Error : read buffer has bad checksum (%d)\n", recBuff[0]);
    ret = -1;
  }

  if(recBuff[1] != (uint8)(0xF8))
  {
    printf("I2C Error : read buffer has incorrect command byte (%d)\n", recBuff[1]);
    ret = -1;
  }

  if(recBuff[2] != (uint8)((recSize - 6)/2))
  {
    printf("I2C Error : read buffer has incorrect number of data words (%d)\n", recBuff[2]);
    ret = -1;
  }

  if(recBuff[3] != (uint8)(0x3B))
  {
    printf("I2C Error : read buffer has incorrect extended command number (%d)\n", recBuff[3]);
    ret = -1;
  }

  checksumTotal = extendedChecksum16(recBuff, recSize);
  if( (uint8)((checksumTotal / 256) & 0xff) != recBuff[5] || (uint8)(checksumTotal & 255) != recBuff[4])
  {
    printf("I2C error : read buffer has bad checksum16 (%d)\n", checksumTotal);
    ret = -1;
  }

  //ackArray should ack the Address byte in the first ack bit, but did not until control firmware 1.84
  ackArrayTotal = AckArray[0] + AckArray[1]*256 + AckArray[2]*65536 + AckArray[3]*16777216;
  expectedAckArray = pow(2.0,  NumI2CBytesToSend+1)-1;
  if(ackArrayTotal != expectedAckArray)
    printf("I2C error : expected an ack of %d, but received %d\n", expectedAckArray, ackArrayTotal);

cleanmem:
  free(sendBuff);
  free(recBuff);
  sendBuff = NULL;
  recBuff = NULL;

  return ret;
}


long eAIN(int fd, ue9CalibrationInfo *caliInfo, long ChannelP, long ChannelN, double *Voltage, long Range, long Resolution, long Settling, long Binary, long Reserved1, long Reserved2)
{
  uint8 IOType, Channel, AINM, AINH, ainGain;
  uint16 bytesVT;

  if(Range == LJ_rgBIP5V)
    ainGain = 8;
  else if(Range == LJ_rgUNI5V)
    ainGain = 0;
  else if(Range == LJ_rgUNI2P5V)
    ainGain = 1;
  else if(Range == LJ_rgUNI1P25V)
    ainGain = 2;
  else if(Range == LJ_rgUNIP625V)
    ainGain = 3;
  else
  {
      printf("eAIN error: Invalid Range\n");
      return -1;
  }

  if(ehSingleIO(fd, 4, (uint8)ChannelP, ainGain, (uint8)Resolution, (uint8)Settling, &IOType, &Channel, NULL, &AINM, &AINH) < 0)
    return -1;

  bytesVT = AINM + AINH*256;

  if(Binary != 0)
  {
    *Voltage = (double)bytesVT;
  }
  else
  {
    if(isCalibrationInfoValid(caliInfo) == -1)
    {
      if(Channel == 133 || ChannelP == 141)
      {
        binaryToUncalibratedAnalogTemperature(bytesVT, Voltage);
      }
      else
      {
        if(binaryToUncalibratedAnalogVoltage(ainGain, Resolution, bytesVT, Voltage) < 0)
          return -1;
      }
    }
    else
    {
      if(ChannelP == 133 || ChannelP == 141)
      {
        if(binaryToCalibratedAnalogTemperature(caliInfo, 0, bytesVT, Voltage) < 0)
          return -1;
      }
      else
      {
        if(binaryToCalibratedAnalogVoltage(caliInfo, ainGain, (uint8)Resolution, bytesVT, Voltage) < 0)
          return -1;
      }
    }
  }

  return 0;
}


long eDAC(int fd, ue9CalibrationInfo *caliInfo, long Channel, double Voltage, long Binary, long Reserved1, long Reserved2)
{
  uint8 IOType, channel;
  uint16 bytesVoltage;

  if(isCalibrationInfoValid(caliInfo) == -1)
  {
    analogToUncalibratedBinaryVoltage(Voltage, &bytesVoltage);
  }
  else
  {
    if(analogToCalibratedBinaryVoltage(caliInfo, (uint8)Channel, Voltage, &bytesVoltage) < 0) 
      return -1;
  }

  return ehSingleIO(fd, 5, (uint8)Channel, (uint8)( bytesVoltage & (0x00FF) ), (uint8)(( bytesVoltage /256 ) + 192), 0, &IOType, &channel, NULL, NULL, NULL);
}


long eDI(int fd, long Channel, long *State)
{
  uint8 state;

  if(Channel > 22)
  {
    printf("eDI error: Invalid Channel");
    return -1;
  }

  if(ehDIO_Feedback(fd, (uint8)Channel, 0, &state) < 0)
    return -1;
  *State = state;

  return 0;
}


long eDO(int fd, long Channel, long State)
{
  uint8 state;

  state = (uint8)State;
  if(Channel > 22)
  {
    printf("Error: Invalid Channel");
    return -1;
  }

  return ehDIO_Feedback(fd, (uint8)Channel, 1, &state);
}


long eTCConfig(int fd, long *aEnableTimers, long *aEnableCounters, long TCPinOffset, long TimerClockBaseIndex, long TimerClockDivisor, long *aTimerModes, double *aTimerValues, long Reserved1, long Reserved2)
{
  uint8 enableMask;
  uint8 timerMode[6], counterMode[2];
  uint16 timerValue[6];
  int numTimers, numTimersStop, i;

  //Setting EnableMask
  enableMask = 128;  //Bit 7: UpdateConfig

  if(aEnableCounters[1] != 0)
    enableMask += 16; //Bit 4: Enable Counter1

  if(aEnableCounters[0] |= 0)
    enableMask += 8;  //Bit 3: Enable Counter0

  numTimers = 0;
  numTimersStop = 0;

  for(i = 0; i < 6; i++)
  {
    if(aEnableTimers[i] != 0 && numTimersStop == 0)
    {
      numTimers++;
      timerMode[i] = (uint8)aTimerModes[i];     //TimerMode
      timerValue[i] = (uint16)aTimerValues[i];  //TimerValue
    }
    else
    {
      numTimersStop = 1;
      timerMode[i] = 0;
      timerValue[i] = 0;
    }
  }
  enableMask += numTimers;  //Bits 2-0: Number of Timers

  counterMode[0] = 0;  //Counter0Mode
  counterMode[1] = 0;  //Counter1Mode

  return ehTimerCounter(fd, (uint8)TimerClockDivisor, enableMask, (uint8)TimerClockBaseIndex, 0, timerMode, timerValue, counterMode, NULL, NULL);
}


long eTCValues(int fd, long *aReadTimers, long *aUpdateResetTimers, long *aReadCounters, long *aResetCounters, double *aTimerValues, double *aCounterValues, long Reserved1, long Reserved2)
{
  uint8 updateReset, timerMode[6], counterMode[2];
  uint16 timerValue[6];
  uint32 timer[6], counter[2];
  int i;
  long errorcode;

  //UpdateReset
  updateReset = 0;
  for(i = 0; i < 6; i++)
  {
    updateReset += ((aUpdateResetTimers[i] != 0) ? pow(2, i) : 0);
    timerMode[i] = 0;
    timerValue[i] = 0;
  }
  for(i = 0; i < 2; i++)
  {
    updateReset += ((aResetCounters[i] != 0) ? pow(2, 6 + i) : 0);
    counterMode[i] = 0;
  }

  if( (errorcode = ehTimerCounter(fd, 0, 0, 0, updateReset, timerMode, timerValue, counterMode, timer, counter)) != 0)
    return errorcode;

  for(i = 0; i < 6; i++)
    aTimerValues[i] = timer[i];

  for(i = 0; i < 2; i++)
    aCounterValues[i] = counter[i];

  return 0;
}


long ehSingleIO(int fd, uint8 inIOType, uint8 inChannel, uint8 inDirBipGainDACL, uint8 inStateResDACH, uint8 inSettlingTime, uint8 *outIOType, uint8 *outChannel, uint8 *outDirAINL, uint8 *outStateAINM, uint8 *outAINH)
{
  uint8 sendBuff[8], recBuff[8];
  int sendChars, recChars;

  sendBuff[1] = (uint8)(0xA3);    //command byte
  sendBuff[2] = inIOType;         //IOType
  sendBuff[3] = inChannel;        //Channel
  sendBuff[4] = inDirBipGainDACL; //Dir/BipGain/DACL
  sendBuff[5] = inStateResDACH;   //State/Resolution/DACH
  sendBuff[6] = inSettlingTime;  //Settling time
  sendBuff[7] = 0;                //Reserved
  sendBuff[0] = normalChecksum8(sendBuff, 8);

  //Sending command to UE9
  sendChars = send(fd, sendBuff, 8, 0);;
  if(sendChars < 8)
  {
    if(sendChars == 0)
      printf("SingleIO error : write failed\n");
    else
      printf("SingleIO error : did not write all of the buffer\n");
    return -1;
  }

  //Reading response from UE9
  recChars = recv(fd, recBuff, 8, 0);;
  if(recChars < 8)
  {
    if(recChars == 0)
      printf("SingleIO error : read failed\n");
    else
      printf("SingleIO error : did not read all of the buffer\n");
      return -1;
  }

  if((uint8)(normalChecksum8(recBuff, 8)) != recBuff[0])
  {
    printf("SingleIO error : read buffer has bad checksum\n");
    return -1;
  }

  if(recBuff[1] != (uint8)(0xA3))
  {
    printf("SingleIO error : read buffer has wrong command byte\n");
    return -1;
  }

  if(outIOType != NULL)
    *outIOType = recBuff[2];
  if(outChannel != NULL)
    *outChannel = recBuff[3];
  if(outDirAINL != NULL)
    *outDirAINL = recBuff[4];
  if(outStateAINM != NULL)
    *outStateAINM = recBuff[5];
  if(outAINH != NULL)
    *outAINH = recBuff[6];

  return 0;
}


long ehDIO_Feedback(int fd, uint8 channel, uint8 direction, uint8 *state)
{
  uint8 sendBuff[34], recBuff[64];
  int sendChars, recChars;
  int i;
  uint8 tempDir, tempState, tempByte;
  uint16 checksumTotal;

  sendBuff[1] = (uint8)(0xF8);  //command byte
  sendBuff[2] = (uint8)(0x0E);  //number of data words
  sendBuff[3] = (uint8)(0x00);  //extended command number

  for(i = 6; i < 34; i++)
    sendBuff[i] = 0;

  tempDir = ((direction < 1) ? 0 : 1);
  tempState = ((*state < 1) ? 0 : 1);

  if(channel <=  7)
  {
    tempByte = pow(2, channel);
    sendBuff[6] = tempByte;
    if(tempDir)
        sendBuff[7] = tempByte;
    if(tempState)
        sendBuff[8] = tempByte;
  }
  else if(channel <= 15)
  {
    tempByte = pow( 2, (channel - 8));
    sendBuff[9] = tempByte;
    if(tempDir)
        sendBuff[10] = tempByte;
    if(tempState)
        sendBuff[11] = tempByte;
  }
  else if(channel <= 19)
  {
    tempByte = pow( 2, (channel - 16));
    sendBuff[12] = tempByte;
    if(tempDir)
        sendBuff[13] = tempByte*16;
    if(tempState)
        sendBuff[13] += tempByte;
  }
  else if(channel <= 22)
  {
    tempByte = pow( 2, (channel - 20));
    sendBuff[14] = tempByte;
    if(tempDir)
        sendBuff[15] = tempByte*16;
    if(tempState)
        sendBuff[15] += tempByte;
  }
  else
  {
    printf("DIO Feedback error: Invalid Channel\n");
    return -1;
  }

  extendedChecksum(sendBuff, 34);

  //Sending command to UE9
  sendChars = send(fd, sendBuff, 34, 0);;
  if(sendChars < 34)
  {
    if(sendChars == 0)
      printf("DIO Feedback error : write failed\n");
    else  
      printf("DIO Feedback error : did not write all of the buffer\n");
    return -1;
  }

  //Reading response from UE9
  recChars = recv(fd, recBuff, 64, 0);
  if(recChars < 64)
  {
    if(recChars == 0)
      printf("DIO Feedback error : read failed\n");
    else  
      printf("DIO Feedback error : did not read all of the buffer\n");
    return -1;
  }

  checksumTotal = extendedChecksum16(recBuff, 64);
  if( (uint8)((checksumTotal / 256) & 0xff) != recBuff[5])
  {
    printf("DIO Feedback error : read buffer has bad checksum16(MSB)\n");
    return -1;
  }

  if( (uint8)(checksumTotal & 0xff) != recBuff[4])
  {
    printf("DIO Feedback error : read buffer has bad checksum16(LBS)\n");
    return -1;
  }

  if( extendedChecksum8(recBuff) != recBuff[0])
  {
    printf("DIO Feedback error : read buffer has bad checksum8\n");
    return -1;
  }

  if(recBuff[1] != (uint8)(0xF8) || recBuff[2] != (uint8)(0x1D) || recBuff[3] != (uint8)(0x00))
  {
    printf("DIO Feedback error : read buffer has wrong command bytes \n");
    return -1;
  }

  if(channel <=  7)
    *state = ((recBuff[7]&tempByte) ? 1 : 0);
  else if(channel <= 15)
    *state = ((recBuff[9]&tempByte) ? 1 : 0);
  else if(channel <= 19)
    *state = ((recBuff[10]&tempByte) ? 1 : 0);
  else if(channel <= 22)
    *state = ((recBuff[11]&tempByte) ? 1 : 0);

  return 0;
}


long ehTimerCounter(int fd, uint8 inTimerClockDivisor, uint8 inEnableMask, uint8 inTimerClockBase, uint8 inUpdateReset, uint8 *inTimerMode, uint16 *inTimerValue, uint8 *inCounterMode, uint32 *outTimer, uint32 *outCounter)
{
  uint8 sendBuff[30], recBuff[40];
  int sendChars, recChars, i, j;
  uint16 checksumTotal;

  sendBuff[1] = (uint8)(0xF8);  //command byte
  sendBuff[2] = (uint8)(0x0C);  //number of data words
  sendBuff[3] = (uint8)(0x18);  //extended command number

  sendBuff[6] = inTimerClockDivisor;  //TimerClockDivisor
  sendBuff[7] = inEnableMask;  //EnableMask
  sendBuff[8] = inTimerClockBase;  //TimerClockBase

  sendBuff[9] = inUpdateReset;  //UpdateReset

  for(i = 0; i < 6; i++)
  {
    sendBuff[10 + i*3] = inTimerMode[i];                        //TimerMode
    sendBuff[11 + i*3] = (uint8)(inTimerValue[i]&0x00FF);       //TimerValue (low byte)
    sendBuff[12 + i*3] = (uint8)((inTimerValue[i]&0xFF00)/256); //TimerValue (high byte)
  }

  for(i = 0; i < 2; i++)
    sendBuff[28 + i] = inCounterMode[i];  //CounterMode

  extendedChecksum(sendBuff, 30);

  //Sending command to UE9
  sendChars = send(fd, sendBuff, 30, 0);;
  if(sendChars < 30)
  {
    if(sendChars == 0)
      printf("ehTimerCounter error : write failed\n");
    else
      printf("ehTimerCounter error : did not write all of the buffer\n");
    return -1;
  }

  //Reading response from UE9
  recChars = recv(fd, recBuff, 40, 0);
  if(recChars < 40)
  {
    if(recChars == 0)
      printf("ehTimerCounter error : read failed\n");
    else
      printf("ehTimerCounter error : did not read all of the buffer\n");
    return -1;
  }

  checksumTotal = extendedChecksum16(recBuff, 40);
  if( (uint8)((checksumTotal / 256) & 0xff) != recBuff[5])
  {
    printf("ehTimerCounter error : read buffer has bad checksum16(MSB)\n");
    return -1;
  }

  if( (uint8)(checksumTotal & 0xff) != recBuff[4])
  {
    printf("ehTimerCounter error : read buffer has bad checksum16(LBS)\n");
    return -1;
  }

  if( extendedChecksum8(recBuff) != recBuff[0])
  {
    printf("ehTimerCounter error : read buffer has bad checksum8\n");
    return -1;
  }

  if(recBuff[1] != (uint8)(0xF8) || recBuff[2] != (uint8)(0x11) || recBuff[3] != (uint8)(0x18))
  {
    printf("ehTimerCounter error : read buffer has wrong command bytes for TimerCounter\n");
    return -1;
  }

  if(outTimer != NULL)
  {
    for(i = 0; i < 6; i++)
    {
      outTimer[i] = 0;
      for(j = 0; j < 4; j++)
        outTimer[i] += recBuff[8 + j + i*4]*pow(2, 8*j);
    }
  }

  if(outCounter != NULL)
  {
    for(i = 0; i < 2; i++)
    {
      outCounter[i] = 0;
      for(j = 0; j < 4; j++)
        outCounter[i] += recBuff[32 + j + i*4]*pow(2, 8*j);
    }
  }

  return recBuff[6];
}
