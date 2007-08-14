/**************************************************************************
 * 
 * compress.cc
 *
 * A test application for the compression algorithms.
 *
 * This file is licensed under the GNU GPL.
 *
 * (C) 2005, Klaus S. Madsen <klaussm@diku.dk>
 *
 */

#include <inttypes.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <iostream>
#include <dlfcn.h>

typedef void (*comp_func)(int16_t, int16_t, int16_t,
			  uint16_t, uint16_t);
typedef void (*flush_func)();


bool parse_line(char *buffer, int *res)
{
  char *colon = buffer;

  for (int i = 0; i < 6; i++) {
    colon = strchr(colon, ';');
    
    if (!colon)
      return false;

    colon++;

    res[i] = atoi(colon);
  }

  return true;
}

void compress_file(FILE *f, comp_func comp, flush_func flush)
{
  char buffer[1024];
  int lines = 0;

  while (fgets(buffer, 1024, f)) {
    int val[6];
    
    if (parse_line(buffer, val)) {
      comp(val[1], val[2], val[3], val[4], val[5]);
      lines++;
    }
  }

  flush();

  std::cerr << "Compressed " << lines << " lines of data" << std::endl;
}


int main(int argc, char *argv[])
{
  char *filename;
  std::string tmp;
  std::string algorithm;
  void *dl_handle;
  comp_func comp;
  flush_func flush;
  

  if (argc != 3) {
    std::cout << "Usage:\n"
	      << "  compress algorithm file\n" << std::endl;
    exit(0);
  }

  tmp = argv[1];
  std::string::size_type pos = tmp.find('_');

  if (pos != std::string::npos) {
    tmp = std::string(tmp, 0, pos);
  } 

  algorithm = argv[1];
  pos = algorithm.rfind('/');
  if (pos != std::string::npos) {
    algorithm = std::string(algorithm, pos, std::string::npos);
  }
  
  algorithm = std::string("./") + tmp + "/" + algorithm + "_comp.so";
  filename = argv[2];

  dl_handle = dlopen(algorithm.c_str(), RTLD_LAZY);
  if (!dl_handle) {
    std::cerr << "Failed to open " << algorithm << ": " << dlerror() 
	      << std::endl;
    exit(1);
  }
  comp = (comp_func)dlsym(dl_handle, "compress_sample");
  if (!comp) {
    std::cerr << "Error retrieving compress_sample "
	      << "function from library: " << dlerror() 
	      << std::endl;
    exit(1);
  }
  flush = (flush_func)dlsym(dl_handle, "flush");
  if (!flush) {
    std::cerr << "Error retrieving flush "
	      << "function from library: " << dlerror() 
	      << std::endl;
    exit(1);
  }

  FILE *f;
  f = fopen(filename, "r");
  if (!f) {
    perror("Could not open input file");
    exit(1);
  }

  compress_file(f, comp, flush);
  
  dlclose(dl_handle);
  
  return 0;
}
