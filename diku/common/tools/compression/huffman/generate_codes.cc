#include <stdio.h>
#include <iostream>
#include <queue>
#include <assert.h>

uint32_t *frequency[3];
uint32_t *total_freq = 0;

#ifdef HUFFMAN_WHOLE_SYMBOLS
# define NUMBER_OF_ELEMENTS 4096
#else
# define NUMBER_OF_ELEMENTS 256
#endif

void init_frequency_table()
{
  frequency[0] = new uint32_t[NUMBER_OF_ELEMENTS];
  frequency[1] = new uint32_t[NUMBER_OF_ELEMENTS];
  frequency[2] = new uint32_t[NUMBER_OF_ELEMENTS];

  memset(frequency[0], 0, sizeof(uint32_t) * NUMBER_OF_ELEMENTS);
  memset(frequency[1], 0, sizeof(uint32_t) * NUMBER_OF_ELEMENTS);
  memset(frequency[2], 0, sizeof(uint32_t) * NUMBER_OF_ELEMENTS);
}

void print_frequency_tables()
{
  //  std::cout << "Printing digital table" << std::endl;
  /*  for (int j = 0; j < 8192; j++) {
    std::cout << j << "\t" << frequency[0][j] << "\t" 
	      << frequency[1][j] << "\t" << frequency[2][j] << "\n";
  }
  */
  /*
  for (int j = 0; j < 2048; j++) {
    std::cout << j << "\t" << frequency[3][j] << "\t" 
	      << frequency[4][j] << "\n";
  }
  */
  /*
  for (int j = 0; j < 8192; j++) {
    std::cout << j << "\t" << total_freq[j] << "\n";
  }
  */

  FILE *freq = fopen("freq.out", "w");

  uint32_t total = 0;
  for (int i = 0; i < NUMBER_OF_ELEMENTS; i++) {
    fprintf(freq, "%d: %d\n", i, total_freq[i]);
    total += total_freq[i];
  }

  fclose(freq);

  std::cerr << "Total number of elements: " << total << std::endl;
}

void merge_frequency_tables()
{
  total_freq = new uint32_t[NUMBER_OF_ELEMENTS];

  for (int i = 0; i < NUMBER_OF_ELEMENTS; i++)
    total_freq[i] = frequency[0][i] + frequency[1][i] + frequency[2][i];
}

void destroy_frequency_table()
{
  for (int i = 0; i < 3; i++)
    delete [] frequency[i];

  if (total_freq)
    delete [] total_freq;
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

  return true;
}

void fill_frequency_table(FILE *f)
{
  char buffer[1024];
  int lastval[6];
  bool res;
  FILE *out = fopen("freq2.out", "w");

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
      uint16_t data[3];
#ifdef HUFFMAN_DIFFERENCE
      if (lastval[0] + 1 == val[0]) {
				// If the sample number is only one apart, we update the
				// frequencies.
				for (int i = 0; i < 3; i++) {
# ifdef HUFFMAN_WHOLE_SYMBOLS
					data[i] = ((val[i + 1] + 2048) - (lastval[i + 1] + 2048) + 4096) 
						& 0xFFF;
# else
					data[i] = (val[i + 1] + 2048) - (lastval[i + 1] + 2048) + 4096;
# endif
				}
      }
#else
      for (int i = 0; i < 3; i++) {
#ifdef HUFFMAN_WHOLE_SYMBOLS
				data[i] = val[i + 1] + 2048;
#else
				data[i] = val[i + 1];
#endif
      }
#endif
			
      for (int i = 0; i < 3; i++) {
#ifdef HUFFMAN_WHOLE_SYMBOLS
				if (data[i] > NUMBER_OF_ELEMENTS) {
					std::cerr << "Value " << data[i] << " is out of bounds" 
										<< std::endl;
					exit(1);
				}
				frequency[i][data[i]]++;
				fprintf(out, "%d\n", data[i]);
#else
				frequency[i][data[i] & 0xFF]++;
				frequency[i][(data[i] >> 8) & 0xFF]++;
#endif
      }
			
      memcpy(lastval, val, sizeof(val));
    }
  }
  fclose(out);
}

enum node_type_t {
  NT_Node,
  NT_Leaf,
};

struct huffman_node_t {
  uint32_t frequency;
  node_type_t type;
  huffman_node_t *left;
  huffman_node_t *right;
  int value;
  int depth;
  int number;
  static int cur_number;

  std::string toString() {
    char buf[1000];
    if (type == NT_Node) {
      snprintf(buf, 1000, "Node: frequency: %d, value: %d, depth: %d", 
	       frequency, value, depth);
    } else if (type == NT_Leaf) {
      snprintf(buf, 1000, "Leaf: frequency: %d, value: %d", 
	       frequency, value);
    } else {
      return "Unknown type";
    }
    return buf;
  }

  huffman_node_t() {
    type = NT_Leaf;
    frequency = 0;
    value = -1;
    left = 0;
    right = 0;
    depth = 1;
  }

  huffman_node_t(int v, uint32_t f) {
    type = NT_Leaf;
    frequency = f;
    value = v;
    left = 0;
    right = 0;
    depth = 1;
  }
  
  huffman_node_t(huffman_node_t *l, huffman_node_t *r) {
    number = cur_number++;
    type = NT_Node;
    frequency = l->frequency + r->frequency;
    value = std::min(l->value, r->value);
    left = l;
    right = r;
    depth = std::max(l->depth, r->depth) + 1;
  }
};

int huffman_node_t::cur_number = 0;

class pri_queue_compare {
public:
  bool operator()(const huffman_node_t *a, const huffman_node_t *b) 
  {
    if (a->frequency > b->frequency) {
      return true;
    } else if (a->frequency == b->frequency) {
      return a->depth > b->depth;
    } else {
      return false;
    }
  }
};

huffman_node_t *huffman = 0;

void generate_huffman_table()
{
  std::priority_queue<huffman_node_t*, std::vector<huffman_node_t*>,
    pri_queue_compare> q;
  
  // Fill the priority queue with the data from the frequency table.
  for (int i = 0 ; i < NUMBER_OF_ELEMENTS; i++) {
      q.push(new huffman_node_t(i, total_freq[i]));
  }

  std::cerr << "Queue size: " << q.size() << std::endl;

  // Insert the end of block marker.
  huffman_node_t *left = new huffman_node_t();
  huffman_node_t *right = q.top();
  q.pop();

  huffman_node_t *n = new huffman_node_t(left, right);
  q.push(n);

  while (q.size() > 1) {
    huffman_node_t *left = q.top();
    q.pop();
    huffman_node_t *right = q.top();
    q.pop();

    huffman_node_t *n = new huffman_node_t(left, right);

    /*    
    std::cerr << "Combining " << left->toString() << " with " 
	      << right->toString() << " and getting " 
	      << n->toString() << std::endl;
    */
    q.push(n);
  }

  if (q.size() == 1) {
    huffman = q.top();
    q.pop();
  } else {
    std::cerr << "Ran out of nodes?" << std::endl;
  }
}


struct huffman_code_t {
  uint8_t bits;
  uint64_t value;
};

huffman_code_t final_codes[NUMBER_OF_ELEMENTS + 1];

void print_codes_helper(huffman_node_t *n, uint64_t s, int bits)
{
  switch (n->type) {
  case NT_Node:
    print_codes_helper(n->left, s << 1 | 0x01, bits + 1);
    print_codes_helper(n->right, s << 1, bits + 1);
    break;
  case NT_Leaf:
    if (n->value == -1) {
      final_codes[NUMBER_OF_ELEMENTS].bits = bits;
      final_codes[NUMBER_OF_ELEMENTS].value = s;
    } else {
      final_codes[n->value].bits = bits;
      final_codes[n->value].value = s;
    }
    break;
  }
}

void print_nodes(huffman_node_t *n)
{
  if (n->type == NT_Node) {
    print_nodes(n->left);
    print_nodes(n->right);
    
    std::cout << "struct huffman_node_t node_" 
	      << n->number << " = { NT_Node, " << n->value << ", ";
    if (n->left->type == NT_Node) {
      std::cout << "&node_" << n->left->number;
    } else {
      if (n->left->value == -1) {
	std::cout << "&leaf_" << NUMBER_OF_ELEMENTS;
      } else {
	std::cout << "&leaf_" << n->left->value;
      }
    }
    
    std::cout << ", ";

    if (n->right->type == NT_Node) {
      std::cout << "&node_" << n->right->number;
    } else {
      if (n->right->value == -1) {
	std::cout << "&leaf_" << NUMBER_OF_ELEMENTS;
      } else {
	std::cout << "&leaf_" << n->right->value;
      }
    }

    std::cout << " };\n";
  } 
}

int highest_bit(uint8_t n) {
  int j = 8;
  for (uint8_t i = 0x80; i != 0; i = i >> 1) {
    if ((n & i) != 0) 
      return j;
    j--;
  }
  return 0;
}

uint8_t write_bits_used = 0;
uint16_t write_bits_buffer;
uint16_t write_bits_count = 0;
const int new_array_point = 32000;
bool used_second_array = false;

void write_bits(uint8_t data, uint8_t len)
{
  assert(len <= 8);
  assert(write_bits_used < 8);

  if (write_bits_used == 0) {
    write_bits_buffer = 0;
  }

  write_bits_buffer |= (uint16_t)data << (16 - len - write_bits_used);
  write_bits_used += len;
  
  while (write_bits_used >= 8) {
    if (write_bits_count == new_array_point - 1) {
      std::cout << (write_bits_buffer >> 8) << "};\n"
		<< "#define USE_TWO_ARRAYS\n"
		<< "prog_uint8_t const huffman_code2[] = {\n";
      used_second_array = true;
    } else {
      std::cout << (write_bits_buffer >> 8) << ", ";
    }

    if (++write_bits_count % 16 == 0) {
      std::cout << std::endl;
    }
    
    write_bits_buffer <<= 8;
    write_bits_used -= 8;      
  }

  assert(write_bits_used < 8);
}

void print_codes(huffman_node_t *n)
{
  print_codes_helper(n, 0, 0);

  char *data_type;
  char *integer_postfix;
  uint8_t highest_bits = 0;
  uint8_t lowest_bits = 255;
  int total_bits = 0;

  for (int i = 0; i < NUMBER_OF_ELEMENTS + 1; i++) {
    highest_bits = std::max(final_codes[i].bits, highest_bits);
    lowest_bits = std::min(final_codes[i].bits, lowest_bits);
    total_bits += final_codes[i].bits;
  }

  if (highest_bits <= 8) {
    data_type = "uint8_t";
    integer_postfix = "";
  } else if (highest_bits <= 16) {
    data_type = "uint16_t";
    integer_postfix = "";
  } else if (highest_bits <= 32) {
    data_type = "uint32_t";
    integer_postfix = "UL";
  } else if (highest_bits <= 64) {
    data_type = "uint64_t";
    integer_postfix = "ULL";
  } else {
    std::cerr << "Too many bits required (highest_bits = " 
	      << (int)highest_bits << ")" << std::endl;
    exit(1);
  }

  std::cerr << "Max bits required: " << (int)highest_bits << std::endl;
  std::cerr << "Min bits required: " << (int)lowest_bits << std::endl;
  std::cerr << "Avg bits required: " << (double)total_bits / (double)NUMBER_OF_ELEMENTS << std::endl;

  uint8_t length_bits = highest_bit(highest_bits - 1);

  std::cout << "#define LENGTH_BITS " << (int)length_bits
	    << std::endl;
  std::cout << "#define VALUE_BITS " << (int)highest_bits << std::endl;

#ifdef HUFFMAN_DIFFERENCE
  std::cout << "#define HUFFMAN_DIFFERENCE\n";
#endif

#ifdef HUFFMAN_WHOLE_SYMBOLS
  std::cout << "#define HUFFMAN_WHOLE_SYMBOLS\n";
#endif

  std::cout << "#define NUMBER_OF_HUFFMAN_CODES " 
	    << NUMBER_OF_ELEMENTS + 1 << std::endl;

  std::cout << "#define NEW_ARRAY_POINT " << new_array_point << std::endl;

  std::cout << "prog_uint8_t const huffman_code[] = {\n";
  for (int i = 0; i < NUMBER_OF_ELEMENTS + 1; i++) {
    write_bits(final_codes[i].bits - 1, length_bits);

    uint8_t bits = highest_bits;

    while (bits != 0) {
      if (bits < 8) {
	write_bits(final_codes[i].value & ((1 << bits) - 1), bits);
	bits = 0;
      } else {
	write_bits(final_codes[i].value >> (bits - 8), 8);
	bits -= 8;
      }
    }
  }

  std::cout << (write_bits_buffer >> 8) << "};\n\n";

  for (int i = 0; i < NUMBER_OF_ELEMENTS + 1; i++) {
    std::cout << "/* Element: " << i << " Bits: " << (int) final_codes[i].bits 
	      << " Value: " << final_codes[i].value << " Freq: " 
	      << total_freq[i] << " */" << std::endl;
  }

  std::cout << "#ifdef DECOMPRESSOR\n";

  std::cout << "enum node_type_t {\n"
	    << "  NT_Leaf,\n"
	    << "  NT_Node,\n"
	    << "};\n\n";

  std::cout << "struct huffman_node_t {\n"
	    << "  enum node_type_t type;\n"
	    << "  uint16_t value;\n"
	    << "  struct huffman_node_t *left;\n"
	    << "  struct huffman_node_t *right;\n"
	    << "};\n\n";

  /* First output all the leafs. */
  
  for (int i = 0; i < NUMBER_OF_ELEMENTS + 1; i++) {
    std::cout << "struct huffman_node_t leaf_" 
	      << i << " = { NT_Leaf, " << i << ", 0, 0 };\n";
  }

  /* Output all nodes in the tree */
  print_nodes(n);

  std::cout << "struct huffman_node_t *huffman_root = &node_" 
	    << n->number << ";\n\n";

  std::cout << "#endif\n\n";
}

int main(int argc, char * argv[])
{
  FILE *f;
  
  if (argc < 2) {
    std::cerr << "You must specify the file to read" << std::endl;
    exit(1);
  }

  f = fopen(argv[1], "r");
  if (!f) {
    perror("Could not open input file");
    exit(1);
  }

  init_frequency_table();
  fill_frequency_table(f);
  merge_frequency_tables();
  print_frequency_tables();
  generate_huffman_table();
  print_codes(huffman);
  
  destroy_frequency_table();

  return 0;
}
