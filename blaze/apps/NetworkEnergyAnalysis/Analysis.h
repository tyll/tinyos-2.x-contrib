
#ifndef ANALYSIS_H
#define ANALYSIS_H

typedef nx_struct AnalysisMsg {
  nx_uint32_t intervalBetweenMessagesMs;
  nx_uint16_t worInterval;
  nx_uint8_t nodesInSurroundingNetwork;
} AnalysisMsg;

enum {
  AM_DUMMYMSG = 0x4,
  AM_ANALYSISMSG = 0x5,
};

#endif

