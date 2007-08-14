#include <stdio.h>
#include <iostream>
#include <queue>

uint32_t *raw[5];
uint32_t *diffs[5];

void init_frequency_table()
{
  raw[0] = new uint32_t[4096];
  raw[1] = new uint32_t[4096];
  raw[2] = new uint32_t[4096];
  raw[3] = new uint32_t[2048];
  raw[4] = new uint32_t[2048];

  diffs[0] = new uint32_t[8192];
  diffs[1] = new uint32_t[8192];
  diffs[2] = new uint32_t[8192];
  diffs[3] = new uint32_t[4096];
  diffs[4] = new uint32_t[4096];
}

char *raw_names[9] = 
  { "digital.x.freq.out",
    "digital.y.freq.out",
    "digital.z.freq.out",
    "analog.x.freq.out",
    "analog.y.freq.out",
    "digital.total.freq.out",
    "analog.total.freq.out",
    "digital.xyz.freq.out", 
    "analog.xyz.freq.out" };

char *diff_names[9] = 
  { "digital.x.diff.freq.out",
    "digital.y.diff.freq.out",
    "digital.z.diff.freq.out",
    "analog.x.diff.freq.out",
    "analog.y.diff.freq.out",
    "digital.total.diff.freq.out", 
    "analog.total.diff.freq.out",
    "digital.xyz.diff.freq.out",
    "analog.xyz.diff.freq.out" };

void print_frequency_tables()
{
  FILE * rawfiles[9];
  FILE * difffiles[9];

  for (int i = 0; i < 9; i++) {
    rawfiles[i] = fopen(raw_names[i], "w");
    if (!rawfiles[i]) {
      perror("Error creating frequency file");
      exit(1);
    }
  }
  for (int i = 0; i < 9; i++) {
    difffiles[i] = fopen(diff_names[i], "w");
    if (!difffiles[i]) {
      perror("Error creating frequency file");
      exit(1);
    }
  }

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 8196; j++) {
      fprintf(difffiles[i], "%d\t%d\n", j - 4096, diffs[i][j]);
    }
    for (int j = 0; j < 4096; j++) {
      fprintf(rawfiles[i], "%d\t%d\n", j - 2048, raw[i][j]);
    }
  }

  for (int i = 0; i < 8196; i++) {
    fprintf(difffiles[5], "%d\t%d\n", i - 4096, 
	    diffs[0][i] + diffs[1][i] + diffs[2][i]);
    fprintf(difffiles[7], "%d\t%d\t%d\t%d\n",
	    i - 4096, diffs[0][i], diffs[1][i], diffs[2][i]);
  }

  for (int i = 0; i < 4096; i++) {
    fprintf(rawfiles[5], "%d\t%d\n", i - 2048, 
	    raw[0][i] + raw[1][i] + raw[2][i]);
    fprintf(rawfiles[7], "%d\t%d\t%d\t%d\n", i - 2048, 
	    raw[0][i], raw[1][i], raw[2][i]);
  }

  for (int i = 3; i < 5; i++) {
    for (int j = 0; j < 4096; j++) {
      fprintf(difffiles[i], "%d\t%d\n", j - 2048, diffs[i][j]);
    }
    for (int j = 0; j < 2048; j++) {
      fprintf(rawfiles[i], "%d\t%d\n", j, raw[i][j]);
    }
  }

  for (int i = 0; i < 4096; i++) {
    fprintf(difffiles[6], "%d\t%d\n", i - 2048, 
	    diffs[3][i] + diffs[4][i]);
    fprintf(difffiles[8], "%d\t%d\t%d\n", i - 2048, 
	    diffs[3][i], diffs[4][i]);
  }

  for (int i = 0; i < 2048; i++) {
    fprintf(rawfiles[6], "%d\t%d\n", i, 
	    raw[3][i] + raw[4][i]);
    fprintf(rawfiles[8], "%d\t%d\t%d\n", i, 
	    raw[3][i], raw[4][i]);
  }

  for (int i = 0; i < 9; i++) {
    fclose(rawfiles[i]);
    fclose(difffiles[i]);
  }
}

void destroy_frequency_table()
{
  for (int i = 0; i < 5; i++) {
    delete [] diffs[i];
    delete [] raw[i];
  }
}

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

  bool res_val = true;

  for (int i = 0; i < 3; i++) {
    res_val &= res[i + 1] < 2048 && res[i + 1] >= -2048;
  }

  for (int i = 3; i < 5; i++) {
    res_val &= res[i + 1] < 2048 && res[i + 1] >= 0;
  }

  return res_val;
}

void fill_frequency_table(FILE *f)
{
  char buffer[1024];
  int lastval[6];
  bool res;

  fgets(buffer, 1024, f);
  res = parse_line(buffer, lastval);

  if (!res) {
    std::cerr << "Error reading data file. Res = " << res << std::endl;
    std::cerr << "Buffer: " << buffer;
    exit(1);
  }

  while (fgets(buffer, 1024, f)) {
    int val[6];

    res = parse_line(buffer, val);
    if (res) {
      if (lastval[0] + 1 == val[0]) {
	// If the sample number is only one apart, we update the
	// frequencies.

	for (int i = 0; i < 3; i++) {
	  diffs[i][val[i + 1] - lastval[i + 1] + 4096]++;
	}

	for (int i = 3; i < 5; i++) {
	  diffs[i][val[i + 1] - lastval[i + 1] + 2048]++;
	}
      }

      for (int i = 0; i < 3; i++) {
	raw[i][val[i + 1] + 2048]++;
      }

      for (int i = 3; i < 5; i++) {
	raw[i][val[i + 1]]++;
      }

      memcpy(lastval, val, sizeof(*val));
    } else {
      std::cerr << "Skipping line: " << buffer;
    }
  }
}

int main(int argc, char * argv[])
{
  init_frequency_table();
  fill_frequency_table(stdin);
  print_frequency_tables();
  destroy_frequency_table();

  return 0;
}
