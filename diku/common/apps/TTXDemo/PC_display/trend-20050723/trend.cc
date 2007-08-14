/*
 * trend: display live data on a trend graph
 * Copyright(c) 2003-2005 by wave++ "Yuri D'Elia" <wavexx@users.sf.net>
 * Distributed under GNU LGPL WITHOUT ANY WARRANTY.
 */

/*
 * Headers
 */

// defaults
#include "defaults.hh"
#include "color.hh"
#include "timer.hh"
#include "rr.hh"

// system headers
#include <stdexcept>
#include <vector>
using std::vector;

#include <iostream>
using std::cout;
using std::cerr;
using std::cin;

#include <string>
using std::string;

#include <utility>
using std::pair;

#include <limits>
using std::numeric_limits;

// c system headers
#include <cstdlib>
using std::strtod;
using std::strtoul;

#include <cstring>
using std::memcpy;
using std::strlen;
using std::strpbrk;
using std::strchr;

#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <pthread.h>
#ifdef __sgi
#include <mutex.h>
#endif

// OpenGL/GLU
#include "gl.hh"

#ifndef NAN
#define NAN numeric_limits<double>::quiet_NaN()
#endif


/*
 * Data structures
 */

struct Value
{
  Value()
  {}

  Value(double value, size_t count)
  : value(value), count(count)
  {}

  double value;
  size_t count;
};


struct Intr
{
  // nearest value
  Value near;
  
  // intersection
  double value;
  double dist;
};

bool
operator<(const Intr& l, const Intr& r)
{
  return (l.dist < r.dist);
}


struct Grid
{
  double res;
  unsigned long mayor;
};

struct GrSpec
{
  Grid x;
  Grid y;
};


/*
 * Graph/Program state
 */

namespace
{
  // Basic data
  const char* fileName;
  pthread_mutex_t mutex;
  volatile unsigned long damaged = 0;
  Trend::input_t input = Trend::input;
  Trend::format_t format = Trend::format;

  // Data and fixed parameters
  rr<Value>* rrData;
  Value* rrBuf;
  Value* rrEnd;
  double loLimit;
  double hiLimit;
  double grZero = 0.;

  // Visual/Fixed settings
  size_t history;
  size_t divisions;
  size_t offset;
  const char* title = NULL;
  GLfloat backCol[3];
  GLfloat textCol[3];
  GLfloat gridCol[3];
  GLfloat lineCol[3];
  GLfloat markCol[3];
  GLfloat intrCol[3];

  // Visual/Changeable settings
  int width;
  int height;
  int lc;
  bool autoLimit;
  bool dimmed = Trend::dimmed;
  bool fifo = Trend::fifo;
  bool smooth = Trend::smooth;
  bool scroll = Trend::scroll;
  bool values = Trend::values;
  bool marker = Trend::marker;
  bool grid = Trend::grid;
  GrSpec grSpec;
  bool paused = false;

  // Indicator status
  bool intr = false;
  bool intrFg;
  double intrX;
  double intrY;

  // Distribution graph
  bool distrib = Trend::distrib;
  vector<double> distribData;

  // Latency
  bool latency = Trend::latency;
  ATimer atLat(Trend::latAvg);
}


/*
 * I/O and data manipulation
 */

// fill the round robin consistently with a single value
void
fillRr(double value, size_t start = 0)
{
  Value buf;
  buf.count = start;
  buf.value = value;

  for(size_t i = 0; i != history; ++i)
  {
    rrData->push_back(buf);
    if(!(++buf.count % divisions))
      buf.count = 0;
  }
}


// skip whitespace
void
skipSpc(FILE* fd)
{
  int c;

  do { c = getc_unlocked(fd); }
  while(isspace(c) && c != EOF);
  ungetc(c, fd);
}


// skip a space-separated string
void
skipStr(FILE* fd)
{
  int c;

  do { c = getc_unlocked(fd); }
  while(!isspace(c) && c != EOF);
  ungetc(c, fd);
}


// read a space-separated string
char*
readStr(FILE* fd, char* buf, size_t len)
{
  char* p(buf);
  int c;

  while(len--)
  {
    c = getc_unlocked(fd);
    if(c == EOF || isspace(c))
    {
      ungetc(c, fd);
      return p;
    }
    *p++ = c;
  }

  // overflow
  return NULL;
}


// read a number from an ascii stream
double
readANum(FILE* fd)
{
  // read a number
  double num;

  for(;;)
  {
    // read
    skipSpc(fd);
    char buf[Trend::maxNumLen];
    char* end = readStr(fd, buf, sizeof(buf) - 1);
    if(feof(fd))
      return NAN;

    if(!end)
    {
      // long string, skip it.
      skipStr(fd);
      continue;
    }
    *end = 0;
  
    // convert the number
    num = strtod(buf, &end);
    if(end != buf)
      break;
  }
  
  return num;
}


// read a number from a binary stream
template <class T> double
readNum(FILE* fd)
{
  T buf;
  return (fread(&buf, sizeof(buf), 1, fd)?
      static_cast<double>(buf): NAN);
}


// read up to the first number in the stream using the current format
double
readFNum(FILE* fd)
{
  double num;

  switch(format)
  {
  case Trend::f_ascii: num = readANum(fd); break;
  case Trend::f_float: num = readNum<float>(fd); break;
  case Trend::f_double: num = readNum<double>(fd); break;
  case Trend::f_short: num = readNum<short>(fd); break;
  case Trend::f_int: num = readNum<int>(fd); break;
  case Trend::f_long: num = readNum<long>(fd); break;
  }

  return num;
}


// producer thread
void*
producer(void* prg)
{
  // iostreams under gcc 3.x are completely unusable for advanced tasks such as
  // customizable buffering/locking/etc. They also removed the (really
  // standard) ->fd() access for "encapsulation"...
  FILE* in;

  for(size_t pos = (history % divisions);;)
  {
    // open the file and disable buffering
    in = fopen(fileName, "r");
    if(!in) break;
    setvbuf(in, NULL, _IONBF, 0);

    // check for useless file types
    struct stat stBuf;
    fstat(fileno(in), &stBuf);
    if(S_ISDIR(stBuf.st_mode))
      break;

    // first value for incremental data
    double old, num;
    if(input != Trend::absolute)
      old = readFNum(in);

    // read all data
    while(!isnan((num = readFNum(in))))
    {
      // determine the actual value
      switch(input)
      {
      case Trend::incremental:
        {
	  double tmp = num;
	  num = (num - old);
	  old = tmp;
        }
	break;

      case Trend::differential:
	old += num;
	num = old;
	break;
      }

      // append the value
      rrData->push_back(Value(num, pos));
#ifdef __sgi
      add_then_test((unsigned long*)(&damaged), 1);
#else
      pthread_mutex_lock(&mutex);
      ++damaged;
      pthread_mutex_unlock(&mutex);
#endif

      // wrap pos when possible
      if(!(++pos % divisions))
	pos = 0;
    }

    // close the stream and terminate the loop for regular files
    fclose(in);
    if(S_ISREG(stBuf.st_mode) || S_ISBLK(stBuf.st_mode))
      break;
  }

  // should never get so far
  cerr << reinterpret_cast<char*>(prg) << ": producer thread exiting\n";
  return NULL;
}


/*
 * OpenGL functions
 */

// project model coordinates
void
project(double xi, double yi, int& xo, int& yo)
{
  int width(distrib? ::width - Trend::distribWidth: ::width);
  int off(distrib? Trend::distribWidth: 0);

  xo = (off + static_cast<int>(xi * width / divisions));
  yo = static_cast<int>((yi - loLimit) * height / (hiLimit - loLimit));
}


// unproject video to model coordinates
void
unproject(int xi, int yi, double& xo, double& yo)
{
  int width = (distrib? ::width - Trend::distribWidth: ::width);
  int xr = (distrib? xi - Trend::distribWidth: xi);

  xo = (static_cast<double>(divisions) * xr / width);
  yo = hiLimit - (static_cast<double>(hiLimit - loLimit) * yi / height);
}


// OpenGL state initializer
void
init()
{
  // Smoothing
  if(smooth)
  {
    glEnable(GL_LINE_SMOOTH);
    glHint(GL_LINE_SMOOTH_HINT, GL_FASTEST);
  }
  else
    glDisable(GL_LINE_SMOOTH);

  // Blending should be enabled by default
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  // Clear color
  glClearColor(backCol[0], backCol[1], backCol[2], 0.0);
}


// Resize handler
void
reshape(const int w, const int h)
{
  width = w;
  height = h;

  glViewport(0, 0, w, h);
}


// write a normal string
void
drawString(const int x, const int y, const char* str)
{
  glRasterPos2i(x, y);
  for(const char* p = str; *p; ++p)
    glutBitmapCharacter(GLUT_BITMAP_8_BY_13, *p);
}


// write strings in the lower-left corner
void
drawLEString(const char* str)
{
  drawString(Trend::strSpc, Trend::strSpc + Trend::fontHeight * lc++, str);
}


// write an on-screen string using video coordinates
void
drawOSString(const int x, const int y, const char* str)
{
  using Trend::strSpc;
  using Trend::fontHeight;

  int len(strlen(str) * 8);
  int rx(x + strSpc);
  int ry(y + strSpc);

  // check x
  if((rx + strSpc + len) > width)
    rx = width - len - strSpc;
  if(rx < 0)
    rx = strSpc;

  // check y
  if((ry + strSpc + fontHeight) > height)
    ry = height - fontHeight - strSpc;
  if(ry < 0)
    ry = strSpc;

  drawString(rx, ry, str);
}


void
drawGridX(double gridres)
{
  // horizontal lines
  double it;
  glBegin(GL_LINES);

  if(scroll)
    for(it = divisions; it > 0; it -= gridres)
    {
      glVertex2d(it, loLimit);
      glVertex2d(it, hiLimit);
    }
  else
    for(it = gridres; it <= divisions; it += gridres)
    {
      glVertex2d(it, loLimit);
      glVertex2d(it, hiLimit);
    }

  glEnd();
}


void
drawGridY(double gridres)
{
  // vertical lines
  double it = loLimit - fmod(loLimit - grZero, gridres);
  if(it <= loLimit)
    it += gridres;

  glBegin(GL_LINES);
  for(; it < hiLimit; it += gridres)
  {
    glVertex2d(0, it);
    glVertex2d(divisions, it);
  }
  glEnd();
}


void
drawGrid()
{
  using Trend::maxGridDens;
  double r, d;

  // x
  r = (divisions / grSpec.x.res);
  d = (width / maxGridDens);

  if(r < (d * grSpec.x.mayor))
  {
    // minor lines
    if(grSpec.x.mayor != 1 && r < d)
    {
      glColor4f(gridCol[0], gridCol[1], gridCol[2], 0.5);
      drawGridX(grSpec.x.res);
    }

    // mayor lines
    if(grSpec.x.mayor)
    {
      glColor3fv(gridCol);
      drawGridX(grSpec.x.res * grSpec.x.mayor);
    }
  }

  // y
  r = ((hiLimit - loLimit) / grSpec.y.res);
  d = (height / maxGridDens);
  
  if(r < (d * grSpec.y.mayor))
  {
    // minor lines
    if(grSpec.y.mayor != 1 && r < d)
    {
      glColor4f(gridCol[0], gridCol[1], gridCol[2], 0.5);
      drawGridY(grSpec.y.res);
    }

    // mayor lines
    if(grSpec.y.mayor)
    {
      glColor3fv(gridCol);
      drawGridY(grSpec.y.res * grSpec.y.mayor);
    }
  }
}


void
drawMarker(const double x)
{
  glColor3fv(markCol);
  glBegin(GL_LINES);
  glVertex2d(x, loLimit);
  glVertex2d(x, hiLimit);
  glEnd();
}


void
drawCircle(const int x, const int y)
{
  using Trend::intrRad;

  // ok, it's not really a circle.
  glBegin(GL_LINE_LOOP);
  glVertex2i(x - intrRad, y);
  glVertex2i(x, y + intrRad);
  glVertex2i(x + intrRad, y);
  glVertex2i(x, y - intrRad);
  glEnd();
}


// get drawing position based on current settings
size_t
getPosition(size_t pos, const Value& value)
{
  return ((scroll? pos: value.count) % divisions);
}


size_t
drawLine()
{
  const Value* it = rrBuf;
  const Value* end = rrEnd;
  const size_t mark(history + offset - divisions);
  size_t pos;

  glBegin(GL_LINE_STRIP);
  for(size_t i = offset; it != end; ++i, ++it)
  {
    // shade the color
    double alpha(dimmed?
	(i > mark? 1.: .5):
	(static_cast<float>(i - offset) / history));
	
    glColor4f(lineCol[0], lineCol[1], lineCol[2], alpha);
    pos = getPosition(i, *it);
    if(!pos)
    {
      // Cursor at the end
      glVertex2d(divisions, it->value);
      glEnd();
      glBegin(GL_LINE_STRIP);
      glVertex2d(0, it->value);
    }
    else
      glVertex2d(pos, it->value);
  }
  glEnd();

  return pos;
}


void
drawDistrib()
{
  // reallocate only if necessary. we must avoid to reallocate in order to
  // not fragment memory (resize() on gcc 3 isn't very friendly)
  if(distribData.size() != static_cast<size_t>(height))
    distribData.resize(height);

  // calculate distribution
  const Value* it = rrBuf;
  const Value* end = rrEnd - 1;

  distribData.assign(distribData.size(), 0.);
  double max = 0;

  for(; it != end; ++it)
  {
    const Value* a = it;
    const Value* b = (it + 1);

    // projection
    double mul = (static_cast<double>(height) / (hiLimit - loLimit));
    int begin = static_cast<int>(mul * (a->value - loLimit));
    int end = static_cast<int>(mul * (b->value - loLimit));
    if(begin > end) std::swap(begin, end);

    // fixation
    if(end < 0 || begin > height) continue;
    if(begin < 0) begin = 0;
    if(end > height) end = height;

    // integration
    for(int y = begin; y != end; ++y)
    {
      if(++distribData[y] > max)
	max = distribData[y];
    }
  }
  if(max != 0.)
    max = 1. / max;

  // draw the results (optimize for continue zones)
  glPushMatrix();
  glLoadIdentity();
  gluOrtho2D(0, width, 0, height);

  using Trend::distribWidth;
  double oldColor = distribData[0] * max;
  glColor3d(oldColor, oldColor, oldColor);

  glBegin(GL_QUADS);
  glVertex2i(0, 0);
  glVertex2i(distribWidth, 0);

  for(int y = 1; y != (height - 1); ++y)
  {
    double color = distribData[y] * max;
    if(color != oldColor)
    {
      glVertex2i(distribWidth, y);
      glVertex2i(0, y);

      oldColor = color;
      glColor3d(color, color, color);

      glVertex2i(0, y);
      glVertex2i(distribWidth, y);
    }
  }

  glVertex2i(distribWidth, height);
  glVertex2i(0, height);
  glEnd();
  glPopMatrix();
}


void
drawIntr()
{
  // initial color and current position
  glColor3fv(intrCol);
  glBegin(GL_LINES);
  glVertex2d(intrX, loLimit);
  glVertex2d(intrX, hiLimit);
  glEnd();

  // scan for all intersections
  size_t trX = (static_cast<size_t>(floor(intrX)));
  if(trX == divisions) --trX;
  double mul = (intrX - trX);
  vector<Intr> intrs;

  // starting position
  size_t i;
  const Value* it;
  if(scroll)
  {
    it = rrBuf + (trX - offset % divisions);
    i = trX;
  }
  else
  {
    it = rrBuf + (trX - rrBuf->count);
    i = 0;
  }
  if(it < rrBuf)
    it += divisions;
  if(intrFg)
    it += ((rrEnd - it) / divisions) * divisions;

  const Value* end = rrEnd - 1;
  for(; it < end; i += divisions, it += divisions)
  {
    size_t pos = getPosition(i, *it);

    // fetch the next value
    Value next = *(it + 1);
    
    Intr buf;
    if(mul < 0.5)
    {
      buf.near.value = it->value;
      buf.near.count = pos;
    }
    else
    {
      buf.near.value = next.value;
      buf.near.count = getPosition(i + 1, next);
    }
    buf.value = it->value + mul * (next.value - it->value);
    buf.dist = fabs(buf.value - intrY);
    intrs.push_back(buf);
  }

  // no intersections found
  if(!intrs.size())
    return;

  // consider only the nearest n values
  std::sort(intrs.begin(), intrs.end());
  if(intrs.size() > static_cast<size_t>(Trend::intrNum))
    intrs.resize(Trend::intrNum);

  // draw intersections and estimate mean value
  double mean = 0;
  glBegin(GL_LINES);
  for(vector<Intr>::const_iterator it = intrs.begin();
      it != intrs.end(); ++it)
  {
    mean += it->value;
    glVertex2d(0, it->value);
    glVertex2d(divisions, it->value);

  }
  glEnd();
  mean /= intrs.size();

  // switch to video coordinates
  glPushMatrix();
  glLoadIdentity();
  gluOrtho2D(0, width, 0, height);

  // nearest point
  int nearX, nearY;
  project(intrs[0].near.count, intrs[0].near.value, nearX, nearY);
  drawCircle(nearX, nearY);
  if(!intrs[0].near.count)
    drawCircle(width, nearY);

  // plot values
  using Trend::strSpc;

  char buf[256];
  int curY = height;

  sprintf(buf, "nearest: %g, mean: %g", intrs[0].near.value, mean);
  drawString(strSpc, curY -= Trend::fontHeight + strSpc, buf);

  i = 1;
  for(vector<Intr>::const_iterator it = intrs.begin();
      it != intrs.end(); ++i, ++it)
  {
    sprintf(buf, "%d: %g", i, it->value);
    drawString(strSpc, curY -= Trend::fontHeight + strSpc, buf);
  }

  // restore model space
  glPopMatrix();
}


void
drawValues()
{
  const Value& last = rrBuf[history - 1];
  char buf[Trend::maxNumLen];
  glColor3fv(textCol);

  sprintf(buf, "%g", loLimit);
  drawOSString(width, 0, buf);

  sprintf(buf, "%g", hiLimit);
  drawOSString(width, height, buf);

  sprintf(buf, "%g", last.value);
  drawLEString(buf);
}


void
drawLatency()
{
  char buf[Trend::maxNumLen];
  glColor3fv(textCol);

  sprintf(buf, "lat: %g", atLat.avg());
  drawLEString(buf);
}


// redraw handler
void
display()
{
  // reset some data
  lc = 0;

  // setup model coordinates
  double zero = (distrib?
      -(static_cast<double>(Trend::distribWidth) * divisions /
	  (width - Trend::distribWidth)): 0);

  glClear(GL_COLOR_BUFFER_BIT);
  glLoadIdentity();
  gluOrtho2D(zero, divisions, loLimit, hiLimit);

  // background grid
  if(grid) drawGrid();
  size_t pos = drawLine();

  // other data
  if(distrib) drawDistrib();
  if(marker) drawMarker(pos);
  if(intr) drawIntr();

  // setup video coordinates
  glLoadIdentity();
  gluOrtho2D(0, width, 0, height);

  // video stuff
  if(values) drawValues();
  if(latency) drawLatency();

  // flush buffers
  glutSwapBuffers();
  atLat.stop();
}


void
removeNANs()
{
  const Value* begin = rrBuf;
  Value* it = rrEnd;
  double old = NAN;

  while(it-- != begin)
  {
    if(isnan(it->value))
      it->value = old;
    else if(it->value != old)
      old = it->value;
  }
}


void
setLimits()
{
  const Value* it = rrBuf;
  const Value* end = rrEnd;

  double lo(it->value);
  double hi(lo);

  for(; it != end; ++it)
  {
    if(it->value > hi)
      hi = it->value;
    if(it->value < lo)
      lo = it->value;
  }

  // some vertical bounds
  hiLimit = hi + grSpec.y.res;
  loLimit = lo - grSpec.y.res;
}


void
idle(int)
{
  // re-register the callback
  glutTimerFunc(1, idle, 0);
  if(paused)
    return;

  // check if a redraw is really necessary
  bool recalc = false;
#ifdef __sgi
  if(test_and_set((unsigned long*)(&damaged), 0))
    recalc = true;
#else
  // linux seems to support some unportable atomic stuff into asm/atomic
  pthread_mutex_lock(&mutex);
  if(damaged)
  {
    damaged = 0;
    recalc = true;
  }
  pthread_mutex_unlock(&mutex);
#endif

  if(recalc)
  {
    atLat.start();
    rrData->copy(rrBuf);

    // since we swiched from deque to rr, the size now is always fixed, and
    // the initial buffer is filled with NANs. We don't want NANs however,
    // and we don't want to handle this lone-case everywhere.
    if(isnan(rrBuf->value))
      removeNANs();

    // recalculate limits seldom
    if(autoLimit)
      setLimits();

    glutPostRedisplay();
  }
}


/*
 * Keyboard interaction
 */

// Parse a grid (res+mayor)
void
parseGrid(Grid& grid, char* spec)
{
  char* p = strchr(spec, '+');
  if(p)
  {
    *p++ = 0;
    if(*p) grid.mayor = strtoul(p, NULL, 0);
  }
  if(*spec) grid.res = strtod(spec, NULL);
}


// Parse a grid-spec
void
parseGrSpec(GrSpec& grid, char* spec)
{
  char* p = strchr(spec, 'x');
  if(p)
  {
    *p++ = 0;
    if(*p) parseGrid(grid.x, p);
  }
  if(*spec) parseGrid(grid.y, spec);
}


void
toggleStatus(const char* str, bool& var)
{
  var = !var;
  std::cout << str << ": " << (var? "enabled": "disabled") << std::endl;
}


double
getUnit(const char* str)
{
  cout << str << "? ";
  double u;
  cin >> u;

  return u;
}


void
getGrid()
{
  char buf[256];
  cout << "grid-spec? ";
  cin.get(buf, sizeof(buf));
  parseGrSpec(grSpec, buf);
  cin.get();
}


void
keyboard(const unsigned char key, const int x, const int y)
{
  switch(key)
  {
  case Trend::quitKey:
    exit(Trend::success);
    break;

  // redraw alteration
  case Trend::dimmedKey:
    toggleStatus("dimmed", dimmed);
    break;

  case Trend::distribKey:
    toggleStatus("distribution", distrib);
    break;

  case Trend::autolimKey:
    toggleStatus("autolimit", autoLimit);
    break;

  case Trend::resetlimKey:
    setLimits();
    cout << "limits reset\n";
    break;

  case Trend::setlimKey:
    loLimit = getUnit("-y");
    hiLimit = getUnit("+y");
    autoLimit = false;
    break;

  case Trend::smoothKey:
    toggleStatus("smoothing", smooth);
    init();
    break;

  case Trend::scrollKey:
    toggleStatus("scrolling", scroll);
    break;

  case Trend::valuesKey:
    toggleStatus("values", values);
    break;

  case Trend::markerKey:
    toggleStatus("marker", marker);
    break;

  case Trend::gridKey:
    toggleStatus("grid", grid);
    break;

  case Trend::setResKey:
    getGrid();
    break;

  case Trend::latKey:
    toggleStatus("latency", latency);
    break;

  case Trend::pauseKey:
    toggleStatus("paused", paused);

  default:
    return;
  }

  glutPostRedisplay();
}


void
motion(int x, int y)
{
  unproject(x, y, intrX, intrY);

  // the x position must be adjusted
  if(intrX < 0)
    intrX = 0.;
  else if(intrX > divisions)
    intrX = static_cast<double>(divisions);

  glutPostRedisplay();
}


void
mouse(int button, int state, int x, int y)
{
  // cause a motion event internally
  intr = (button != GLUT_RIGHT_BUTTON);
  intrFg = (glutGetModifiers() & GLUT_ACTIVE_CTRL);
  motion(x, y);
}


/*
 * CLI and options
 */

// Parse a hist/n, div*n, div spec
bool
parseHistSpec(size_t& hist, size_t& div, const char* spec)
{
  // find the separator first.
  // TODO: * is deprecated
  const char* p = strpbrk(spec, "/*x");
  if((p == spec) || (p && *(p + 1) == 0))
    return true;

  if(!p)
  {
    div = strtoul(spec, NULL, 0);
    hist = div + 1;
    return false;
  }
  else if(*p == '/')
  {
    hist = strtoul(spec, NULL, 0);
    div = strtoul(p + 1, NULL, 0);
    if(!div) return true;
    div = hist / div;
  }
  else
  {
    div = strtoul(spec, NULL, 0);
    hist = div * strtoul(p + 1, NULL, 0);
  }

  return false;
}


bool
parseInput(Trend::input_t& input, const char* arg)
{
  switch(arg[0])
  {
  case 'a': input = Trend::absolute; break;
  case 'i': input = Trend::incremental; break;
  case 'd': input = Trend::differential; break;

  default:
    return true;
  };

  return false;
}


bool
parseFormat(Trend::format_t& format, const char* arg)
{
  switch(arg[0])
  {
  case 'a': format = Trend::f_ascii; break;
  case 'f': format = Trend::f_float; break;
  case 'd': format = Trend::f_double; break;
  case 's': format = Trend::f_short; break;
  case 'i': format = Trend::f_int; break;
  case 'l': format = Trend::f_long; break;

  default:
    return true;
  };

  return false;
}


// Initialize globals through command line
int
parseOptions(int argc, char* const argv[])
{
  // starting options
  memcpy(backCol, Trend::backCol, sizeof(backCol));
  memcpy(textCol, Trend::textCol, sizeof(textCol));
  memcpy(gridCol, Trend::gridCol, sizeof(gridCol));
  memcpy(lineCol, Trend::lineCol, sizeof(lineCol));
  memcpy(markCol, Trend::markCol, sizeof(markCol));
  memcpy(intrCol, Trend::intrCol, sizeof(intrCol));
  grSpec.x.res = grSpec.y.res = Trend::gridres;
  grSpec.x.mayor = grSpec.y.mayor = Trend::mayor;

  int arg;
  while((arg = getopt(argc, argv, "dDFSsvlmgG:ht:A:E:R:I:M:N:irz:f:c:")) != -1)
    switch(arg)
    {
    case 'd':
      dimmed = !dimmed;
      break;

    case 'D':
      distrib = !distrib;
      break;
     
    case 'F':
      fifo = !fifo;
      break;

    case 'S':
      smooth = !smooth;
      break;

    case 's':
      scroll = !scroll;
      break;

    case 'v':
      values = !values;
      break;

    case 'l':
      latency = !latency;
      break;

    case 'm':
      marker = !marker;
      break;

    case 'g':
      grid = !grid;
      break;

    case 'G':
      parseGrSpec(grSpec, optarg);
      break;

    case 'z':
      grZero = strtod(optarg, NULL);
      break;

    case 't':
      title = optarg;
      break;

    case 'A':
      parseColor(backCol, optarg);
      break;

    case 'E':
      parseColor(textCol, optarg);
      break;

    case 'R':
      parseColor(gridCol, optarg);
      break;

    case 'I':
      parseColor(lineCol, optarg);
      break;

    case 'M':
      parseColor(markCol, optarg);
      break;

    case 'N':
      parseColor(intrCol, optarg);
      break;

    case 'c':
      if(parseInput(input, optarg))
      {
	cerr << argv[0] << ": bad input mode\n";
	return -1;
      }
      break;

    case 'i':
      // TODO: deprecated
      input = Trend::incremental;
      break;

    case 'r':
      // TODO: deprecated
      input = Trend::differential;
      break;

    case 'f':
      if(parseFormat(format, optarg))
      {
	cerr << argv[0] << ": bad format type\n";
	return -1;
      }
      break;

    case 'h':
      cout << argv[0] << " usage: " <<
	argv[0] << " [options] fifo <hist-spec|hist-sz x-div> [-y +y]\n" <<
	argv[0] << " version: $Revision$ $Date$\n";
      return 1;

    default:
      return -1;
    }

  // main parameters
  argc -= optind;
  if(argc < 2 || argc > 5)
  {
    cerr << argv[0] << ": bad parameters\n";
    return -1;
  }

  fileName = argv[optind++];
  if(argc == 2 || argc == 4)
  {
    if(parseHistSpec(history, divisions, argv[optind++]))
    {
      cerr << argv[0] << ": bad hist-spec\n";
      return -1;
    }
  }
  else
  {
    history = strtoul(argv[optind++], NULL, 0);
    divisions = strtoul(argv[optind++], NULL, 0);
  }

  // parameters may still be buggy
  if(!history || !divisions)
  {
    cerr << argv[0] << ": hist-sz or x-div can't be zero\n";
    return -1;
  }
  offset = divisions - (history % divisions) + 1;

  // optional limiting factors
  if(argc == 4 || argc == 5)
  {
    loLimit = strtod(argv[optind++], NULL);
    hiLimit = strtod(argv[optind++], NULL);
    autoLimit = false;
  }
  else
    autoLimit = true;

  return 0;
}

void deleteFifo()
{
  if (unlink(fileName)) {
    cerr << "Error deleting fifo: " << strerror(errno) << "\n";
  }
}

int
createFifo()
{
  umask(0000);
  int res = mkfifo(fileName, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP 
		   | S_IROTH | S_IWOTH);
  if (res) {
    cerr << "Error creating fifo: " << strerror(errno) << "\n";
    return -1;
  }

  if (atexit(deleteFifo)) 
    cerr << "Could not register atexit function. Proceeding anyway\n";

  return 0;
}

int
main(int argc, char* argv[]) try
{
  // parameters
  glutInit(&argc, argv);
  if(parseOptions(argc, argv))
    return Trend::args;

  // initialize rr buffers
  rrData = new rr<Value>(history);
  rrBuf = new Value[history];
  rrEnd = rrBuf + history;
  fillRr(NAN);

  if (fifo) {
    if (createFifo())
      return Trend::fifo_error;
  }

  // start the producer thread
  pthread_t thrd;
  pthread_mutex_init(&mutex, NULL);
  pthread_create(&thrd, NULL, producer, argv[0]);

  // display, main mindow and callbacks
  glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
  glutCreateWindow(title? title: argv[0]);
  glutReshapeFunc(reshape);
  glutDisplayFunc(display);
  glutKeyboardFunc(keyboard);
  glutMouseFunc(mouse);
  glutMotionFunc(motion);

  // first redraw
  init();
  idle(0);

  // processing
  glutMainLoop();
  return Trend::success;
}
catch(const std::exception& e)
{
  std::cerr << argv[0] << ": " << e.what() << std::endl;
  throw;
}
