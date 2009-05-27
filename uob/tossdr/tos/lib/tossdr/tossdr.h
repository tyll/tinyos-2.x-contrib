/*
 * "Copyright (c) 2005 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * Declaration of C++ objects representing TOSSDR abstractions.
 * Used to generate Python objects.
 *
 * @author Philip Levis, Markus Becker
 * @date   Apr 10 2009
 */

#ifndef TOSSDR_H_INCLUDED
#define TOSSDR_H_INCLUDED

#include <memory.h>
#include <tos.h>
#include <packet.h>
#include <hashtable.h>

typedef struct variable_string {
  char* type;
  char* ptr;
  int len;
  int isArray;
} variable_string_t;

typedef struct nesc_app {
  int numVariables;
  char** variableNames;
  char** variableTypes;
  int* variableArray;
} nesc_app_t;

class Variable {
 public:
  Variable(char* name, char* format, int array, int mote);
  ~Variable();
  variable_string_t getData();
  void setData(variable_string_t data);

 private:
  char* name;
  char* realName;
  char* format;
  int mote;
  void* ptr;
  char* data;
  size_t len;
  int isArray;
  variable_string_t str;
};

class Mote {
 public:
  Mote(nesc_app_t* app);
  ~Mote();

  unsigned long id();

  long long int euid();
  void setEuid(long long int id);

  long long int bootTime();
  void bootAtTime(long long int time);

  bool isOn();
  void turnOff();
  void turnOn();
  void setID(unsigned long id);

  Variable* getVariable(char* name);

 private:
  unsigned long nodeID;
  nesc_app_t* app;
  struct hashtable* varTable;
};

typedef void (*DATA2SDR_CB)(uint8_t* msg, uint8_t len, void*);
typedef bool (*SEND_CB)(bool cca, void*);

class Tossdr {
 public:
  Tossdr(nesc_app_t* app);
  ~Tossdr();

  void init();

  long long int time();
  long long int ticksPerSecond();
  char* timeStr();
  void setTime(long long int time);

  Mote* currentNode();
  Mote* getNode(unsigned long nodeID);
  void setCurrentNode(unsigned long nodeID);

  void addChannel(char* channel, FILE* file);
  bool removeChannel(char* channel, FILE* file);
  void randomSeed(int seed);

  bool runNextEvent();

  Packet* newPacket();

  void registerData2SdrCallback(DATA2SDR_CB fct, void* clientdata);
  void registerSendCallback(SEND_CB fct, void* clientdata);

 private:
  char timeBuf[256];
  nesc_app_t* app;
  Mote** motes;
};


#endif //TOSSDR_H_INCLUDED
