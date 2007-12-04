#include "dma.h"

interface dmaArray{
	async command uint32_t array_getBaseIndex(DescArray *DAPtr);
	async command DMADescriptor_t* array_get(DescArray *DAPtr, uint8_t descIndex);
	command void init(DescArray *DAPtr, uint32_t num_bytes, uint32_t sourceAddr, void *buf);
	command void setSourceAddr(DMADescriptor_t* descPtr, uint32_t val);
	command void setTargetAddr(DMADescriptor_t* descPtr, uint32_t val);
	command void enableSourceAddrIncrement(DMADescriptor_t* descPtr, bool enable);
	command void enableTargetAddrIncrement(DMADescriptor_t* descPtr, bool enable);
	command void enableSourceFlowControl(DMADescriptor_t* descPtr, bool enable);
	command void enableTargetFlowControl(DMADescriptor_t* descPtr, bool enable);
	command void setMaxBurstSize(DMADescriptor_t* descPtr, DMAMaxBurstSize_t size);
	command void setTransferLength(DMADescriptor_t* descPtr, uint16_t length);
	command void setTransferWidth(DMADescriptor_t* descPtr, DMATransferWidth_t width);
}
