#if !defined(__REMOTECONTROL_H__)
#define __REMOTECONTROL_H__

enum {
  APPID_REMOTECONTROL = 0x5e,
  AM_REMOTECONTROL = 0x5e,
};

typedef nx_struct reply
{
    nx_uint16_t nodeId;
    nx_uint8_t seqNum;
    nx_uint8_t unique_delimiter[0];
    nx_uint16_t ret;
} reply_t;

typedef nx_struct RemoteControlMsg
    {
        nx_uint8_t seqNum;     // sequence number (incremeneted at the base station)
        nx_uint16_t target;    // node id of final destination, or 0xFFFF for all, or 0xFF?? or a group of nodes
        nx_uint8_t dataType;   // what kind of command is this
        nx_uint8_t appId;      // app id of final destination
        nx_uint8_t data[0];    // variable length data packet
} remotecontrol_t;


#endif /* __REMOTECONTROL_H__ */
