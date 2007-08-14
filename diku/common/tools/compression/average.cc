/**************************************************************************
 * 
 * average.cc
 *
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
#include <math.h>

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

void calc_average(FILE *f)
{
  char buffer[1024];
  int lines = 0;
  long double total_digi_x = 0;
  long double total_digi_y = 0;
  long double total_digi_z = 0;
  long double total_digi = 0;
  long double total_analog_x = 0;
  long double total_analog_y = 0;
  long double total_sestoft_x = 0;
  long double total_sestoft_y = 0;


  while (fgets(buffer, 1024, f)) {
    int val[6];
    
    if (parse_line(buffer, val)) {
      long double digi_x = (val[1] / 2048.0) * 2.0;
      long double digi_y = (val[2] / 2048.0) * 2.0;
      long double digi_z = (val[3] / 2048.0) * 2.0;
      long double analog_x = (3300.0 * (val[4] - 512)) / (1024.0 * 174.0);
      long double analog_y = (3300.0 * (val[5] - 512)) / (1024.0 * 174.0);
      long double sestoft_x = val[4] * -0.02169495 - 1.2354176;
      long double sestoft_y = val[5] * 0.02230613 - 1.213;

      total_digi_x += digi_x;
      total_digi_y += digi_y;
      total_digi_z += digi_z;
      total_digi += sqrt(digi_x * digi_x + digi_y * digi_y + digi_z * digi_z);

      total_analog_x += analog_x;
      total_analog_y += analog_y;

      total_sestoft_x += sestoft_x;
      total_sestoft_y += sestoft_y;

      lines++;
    }
  }

  printf("Digital Average X: %1.3Lf\n", total_digi_x / (double)lines);
  printf("Digital Average Y: %1.3Lf\n", total_digi_y / (double)lines);
  printf("Digital Average Z: %1.3Lf\n", total_digi_z / (double)lines);
  printf("Digital Average: %1.3Lf\n", total_digi / (double)lines);

  printf("Analog Average X: %1.3Lf\n", total_analog_x / (double)lines);
  printf("Analog Average Y: %1.3Lf\n", total_analog_y / (double)lines);
  printf("Sestoft Average X: %1.3Lf\n", total_sestoft_x / (double)lines);
  printf("Sestoft Average Y: %1.3Lf\n", total_sestoft_y / (double)lines);
}


int main(int argc, char *argv[])
{
  char *filename;

  if (argc != 2) {
    std::cout << "Usage:\n"
	      << "  average\n" << std::endl;
    exit(0);
  }

  filename = argv[1];

  FILE *f;
  printf("Opening file '%s'\n", filename);
  f = fopen(filename, "r");
  if (!f) {
    perror("Could not open input file");
    exit(1);
  }

  calc_average(f);
  
  return 0;
}
