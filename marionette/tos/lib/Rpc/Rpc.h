//$Id$

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
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
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * @author Kamin Whitehouse
 * @author Michael Okola (TinyOS 2.x porting)
 */

#ifndef __RPC_H__
#define __RPC_H__

struct @rpc {
};


enum rpcMsgs {
  AM_RPCCOMMANDMSG         = 211,
  AM_RPCRESPONSEMSG        = 212,
  //  AM_RPCERRORMSG        = 213
};

/*** error codes ***/
enum rpcErrorCodes {
  RPC_SUCCESS            = 0, /* packet contains return values */
  RPC_GARBAGE_ARGS       = 1, /* can't decode arguments */
  RPC_RESPONSE_TOO_LARGE = 2, /* can we check for this at compile time? */
  RPC_PROCEDURE_UNAVAIL  = 3, /* you must be smoking */
  RPC_SYSTEM_ERR         = 4  /* I must be smoking */
};

typedef struct RpcCommandMsg {
  nx_uint8_t     transactionID;   /*the id of the complete transaction*/
//uint16_t     msgSeqNo;       /*the number of this message within this transaction*/
  nx_uint8_t     commandID;       /*the command that should be run*/
  nx_uint16_t     address;        /*the address that this msg should be received by*/
  nx_uint16_t     returnAddress;  /*the address that the return val should be sent to*/
  nx_uint8_t      responseDesired;/*whether the node should send a response or not*/
  nx_uint8_t      dataLength;
  nx_uint8_t      data[0];
} __attribute__ ((packed)) RpcCommandMsg;

typedef struct RpcResponseMsg {
  nx_uint8_t     transactionID;  /*the id of the complete transaction*/
//uint16_t     msgSeqNo;      /*the number of this message within this transaction*/
  nx_uint8_t     commandID;      /*the command that should be run*/
  nx_uint16_t     sourceAddress; /*the address that the return val came from*/
  nx_uint8_t      errorCode;     /*see error codes above*/
  nx_uint8_t      dataLength;
  nx_uint8_t      data[0];
} __attribute__ ((packed)) RpcResponseMsg;


#endif //__RPC_H__
