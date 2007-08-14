/**************************************************************************
 * 
 * decompress.cc
 *
 * A test application for the decompression algorithms.
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

typedef int (*decomp_func)(int16_t*, int16_t*, int16_t*,
			   uint16_t*, uint16_t*);

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

void decompress_file(FILE *f, decomp_func decomp)
{
  char buffer[1024];
  int lines = 0;
  int last_val = 0;

  while (fgets(buffer, 1024, f)) {
    int val[6];
    int16_t digi_val[3];
    uint16_t analog_val[2];
    
    if (parse_line(buffer, val)) {
      last_val = decomp(digi_val, digi_val + 1, digi_val + 2, 
		       analog_val, analog_val + 1);
      lines++;

      if (val[1] != digi_val[0] || val[2] != digi_val[1] 
	  || val[3] != digi_val[2]) {
	std::cerr << "At line " << lines 
		  << " in the original data, the values are:\n"
		  << "  " << val[1] << ", " << val[2] << ", " 
		  << val[3] << std::endl;
	std::cerr << "In the uncompressed data the values are:\n"
		  << "  " << digi_val[0] << ", " << digi_val[1]
		  << ", " << digi_val[2] << std::endl;
	exit(1);
      }
    }
  }

  std::cerr << "Decompressed " << lines << " matching lines of data" 
	    << std::endl;
  if (last_val != 0) {
    std::cerr << "Last value returned was: " << last_val << std::endl;
  }
}

typedef void (*no_params_func)();

int main(int argc, char *argv[])
{
  char *filename;
  std::string tmp;
  std::string algorithm;
  void *dl_handle;
  decomp_func decomp;
  no_params_func init_func, exit_func;
  

  if (argc != 3) {
    std::cout << "Usage:\n"
	      << "  decompress algorithm file\n" << std::endl;
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
  
  algorithm = std::string("./") + tmp + "/" + algorithm + "_decomp.so";
  filename = argv[2];

  dl_handle = dlopen(algorithm.c_str(), RTLD_LAZY);
  if (!dl_handle) {
    std::cerr << "Failed to open " << algorithm << ": " << dlerror() 
	      << std::endl;
    exit(1);
  }
  decomp = (decomp_func)dlsym(dl_handle, "decompress_sample");
  if (!decomp) {
    std::cerr << "Error retrieving compress_sample "
	      << "function from library: " << dlerror() 
	      << std::endl;
    exit(1);
  }

  init_func = (no_params_func)dlsym(dl_handle, "init_comp");
  exit_func = (no_params_func)dlsym(dl_handle, "end_comp");

  FILE *f;
  f = fopen(filename, "r");
  if (!f) {
    perror("Could not open input file");
    exit(1);
  }

  if (init_func) {
    init_func();
  }

  decompress_file(f, decomp);

  if (exit_func) {
    exit_func();
  }
  
  dlclose(dl_handle);
  
  return 0;
}
