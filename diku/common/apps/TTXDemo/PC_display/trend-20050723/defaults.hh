/*
 * defaults: trend defaults and constants
 * Copyright(c) 2004-2005 by wave++ "Yuri D'Elia" <wavexx@users.sf.net>
 * Distributed under GNU LGPL WITHOUT ANY WARRANTY.
 */

#ifndef defaults_hh
#define defaults_hh

// GL headers
#include "gl.hh"


namespace Trend
{
  // Keys
  const unsigned char quitKey =	27;
  const unsigned char autolimKey = 'a';
  const unsigned char resetlimKey = 'A';
  const unsigned char setlimKey = 'L';
  const unsigned char dimmedKey = 'd';
  const unsigned char distribKey = 'D';
  const unsigned char smoothKey = 'S';
  const unsigned char scrollKey = 's';
  const unsigned char valuesKey = 'v';
  const unsigned char markerKey = 'm';
  const unsigned char gridKey = 'g';
  const unsigned char setResKey = 'G';
  const unsigned char pauseKey = ' ';
  const unsigned char latKey = 'l';

  // Some types
  enum input_t {absolute, incremental, differential};
  enum format_t {f_ascii, f_float, f_double, f_short, f_int, f_long};

  // Defaults
  const input_t input = absolute;
  const format_t format = f_ascii;
  const bool dimmed = false;
  const bool fifo = false;
  const bool distrib = false;
  const bool smooth = false;
  const bool scroll = false;
  const bool values = false;
  const bool marker = true;
  const bool latency = false;
  const bool grid = false;
  const double gridres = 1.;
  const int mayor = 10;

  // Colors
  const GLfloat backCol[3] = {0.,  0.,  0. };
  const GLfloat textCol[3] = {1.,  1.,  1. };
  const GLfloat gridCol[3] = {0.5, 0.,  0.5};
  const GLfloat lineCol[3] = {1.,  1.,  1. };
  const GLfloat markCol[3] = {0.5, 0.5, 0. };
  const GLfloat intrCol[3] = {0.,  1.,  0. };

  // Exit
  const int success = 0;
  const int fail = 1;
  const int args = 2;
  const int fifo_error = 3;

  // Constants
  const int maxNumLen = 128;
  const int fontHeight = 13;
  const int strSpc = 2;
  const int intrRad = 4;
  const int intrNum = 3;
  const int distribWidth = 30;
  const int maxGridDens = 4;
  const int latAvg = 5;
}

#endif
