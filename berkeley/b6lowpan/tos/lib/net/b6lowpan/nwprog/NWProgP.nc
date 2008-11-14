
#include <Storage.h>
#include "imgNum2volumeId.h"
#include "Deluge.h"

module NWProgP {
  provides interface BootImage;
  uses {
    interface Boot;
    interface UDP as Recv;
    interface StorageMap[uint8_t imag_num];
    interface NetProg;
    interface BlockWrite[uint8_t img_num];
    interface Resource;
    event void storageReady();
  }
} implementation {

  enum {
    S_IDLE,
    S_BUSY,
  };
  uint8_t state;
  struct sockaddr_in6 endpoint;
  prog_reply_t reply;

  // Begin-added by Jaein Jeong
  command error_t BootImage.erase(uint8_t img_num) {
    error_t error = call BlockWrite.erase[img_num]();
    return error;
  }
  // End-added

  command void BootImage.reboot() {
    call NetProg.reboot();
  }

  command error_t BootImage.boot(uint8_t img_num) {
    return call NetProg.programImageAndReboot(call StorageMap.getPhysicalAddress[img_num](0));
  }

  event void Boot.booted() {
    state = S_IDLE;
  }

  void sendDone(error_t error) {
    reply.error = error;
    call Recv.sendto(&endpoint, &reply, sizeof(prog_reply_t));
  }

  event void Recv.recvfrom(struct sockaddr_in6 *from,
                           void *payload, uint16_t len,
                           struct ip_metadata *meta) {
    prog_req_t *req = (prog_req_t *)payload;
    uint8_t imgNum = imgNum2volumeId(req->imgno);
    error_t error = FAIL;
    void *buffer;
    // just copy the payload out and write it into flash
    // we'll send the ack from the write done event.
    if (state != S_IDLE) return;
    
    memcpy(&endpoint, from, sizeof(struct sockaddr_in6));
    memcpy(&reply.req, req, sizeof(prog_req_t));

    if (!call Resource.isOwner()) {
      error = call Resource.immediateRequest();
    }
    if (error == SUCCESS) {
      switch (req->cmd) {
      case NWPROG_CMD_ERASE:
        error = call BlockWrite.erase[imgNum]();
        break;
      case NWPROG_CMD_WRITE:
        len -= sizeof(prog_req_t);
        buffer = ip_malloc(len);
        if (buffer == NULL) {
          error = ENOMEM;
          break;
        }
        memcpy(buffer, req->data, len);
        error = call BlockWrite.write[imgNum](req->offset,
                                              buffer,
                                              len);
        if (error != SUCCESS) ip_free(buffer);
        break;
      default:
        error = FAIL;
      }
    }

    if (error != SUCCESS) {
      sendDone(error);
      call Resource.release();
    } else {
      state = S_BUSY;
    }
  }

  event void BlockWrite.writeDone[uint8_t img_num](storage_addr_t addr, void* buf, storage_len_t len, error_t error) {
    if (state != S_BUSY) return;
    sendDone(error);
    call Resource.release();
    state = S_IDLE;
    ip_free(buf);
  }

  event void BlockWrite.eraseDone[uint8_t img_num](error_t error) {
    if (state != S_BUSY) return;
    if (error == SUCCESS) 
      call BlockWrite.sync[img_num]();
    else {
      sendDone(error);
      state = S_IDLE;
      call Resource.release();
    }
  }

  event void BlockWrite.syncDone[uint8_t img_num](error_t error) { 
    if (state != S_BUSY) return;
    sendDone(error);
    state = S_IDLE;
    call Resource.release();
  }

  event void Resource.granted() {

  }

  default command error_t BlockWrite.write[uint8_t imgNum](storage_addr_t addr, void* buf, storage_len_t len) { return FAIL; }
  default command error_t BlockWrite.erase[uint8_t imgNum]() { return FAIL; }
  default command error_t BlockWrite.sync[uint8_t imgNum]() { return FAIL; }

}
