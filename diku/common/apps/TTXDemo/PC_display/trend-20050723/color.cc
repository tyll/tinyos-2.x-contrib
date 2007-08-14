/*
 * color: color parsing/lookup functions - implementation
 * Copyright(c) 2004 by wave++ "Yuri D'Elia" <wavexx@users.sf.net>
 * Distributed under GNU LGPL WITHOUT ANY WARRANTY.
 */

/*
 * Headers
 */

// interface
#include "color.hh"

// system headers
#include <cstdlib>
using std::strtoul;


/*
 * Implementation
 */

GLfloat*
parseColor(GLfloat* buf, const char* color)
{
  // parse the value
  unsigned long v = strtoul((color[0] == '#'? color + 1: color), NULL, 16);
  
  // separate the components
  buf[0] = static_cast<float>((v >> 16) & 0xFF) / 255.;
  buf[1] = static_cast<float>((v >> 8) & 0xFF) / 255.;
  buf[2] = static_cast<float>((v) & 0xFF) / 255.;

  return buf;
}
