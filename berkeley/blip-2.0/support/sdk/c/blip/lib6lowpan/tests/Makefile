
CFLAGS=-U__BLOCKS__ -DPC -DUNIT_TESTING -g -I../../../../../../tos/types -I.. -I../../ -DHAVE_CONFIG_H
LIBS=../lib6lowpan.a
TARGETS=test_bit_range_zero_p test_pack_tcfl test_pack_multicast test_pack_address \
	test_lowpan_pack_headers test_unpack_tcfl test_unpack_address \
	test_unpack_multicast test_unpack_ipnh test_unpack_udp test_pack_nhc_chain \
	text_lowpan_frag_get

all: $(TARGETS)

clean:
	rm $(TARGETS)

test_bit_range_zero_p: test_bit_range_zero_p.c $(LIBS)
	$(CC) -o $@ $(CFLAGS) $< $(LIBS) 

test_pack_tcfl: test_pack_tcfl.c $(LIBS)
	$(CC) -o $@ $(CFLAGS) $< $(LIBS) 

test_pack_multicast: test_pack_multicast.c $(LIBS) 

test_pack_address: test_pack_address.c $(LIBS)
	$(CC) -o $@ $(CFLAGS) $< $(LIBS) 

test_lowpan_pack_headers: test_lowpan_pack_headers.c $(LIBS)
	$(CC) -o $@ $(CFLAGS) $< $(LIBS) -DHAVE_LOWPAN_EXTERN_MATCH_CONTEXT

test_unpack_tcfl: test_unpack_tcfl.c $(LIBS)
	$(CC) -o $@ $(CFLAGS) $< $(LIBS) 

test_unpack_address: test_unpack_address.c $(LIBS)
	$(CC) -o $@ $(CFLAGS) $< $(LIBS) 

test_unpack_multicast: test_unpack_multicast.c $(LIBS)
	$(CC) -o $@ $(CFLAGS) $< $(LIBS) 

test_unpack_ipnh: test_unpack_ipnh.c $(LIBS)
	$(CC) -o $@ $(CFLAGS) $< $(LIBS) 

test_unpack_udp: test_unpack_udp.c $(LIBS)
	$(CC) -o $@ $(CFLAGS) $< $(LIBS) 

test_pack_nhc_chain: test_pack_nhc_chain.c $(LIBS)
	$(CC) -o $@ $(CFLAGS) $< $(LIBS) 

test_lowpan_frag_get: test_lowpan_frag_get.o $(LIBS)
	$(CC)  -o $@ $(CFLAGS) $< $(LIBS) 

test_in_cksum: test_in_cksum.o $(LIBS)
	$(CC)  -o $@ $(CFLAGS) $< $(LIBS) 

test_lowpan_recon_start: test_lowpan_recon_start.o $(LIBS)
	$(CC)  -o $@ $(CFLAGS) $< $(LIBS) 

test_lowpan_unpack_headers: test_lowpan_unpack_headers.o $(LIBS)
	$(CC)  -o $@ $(CFLAGS) $< $(LIBS) 

.c.o:
	$(CC) -c -o $@ $< $(CFLAGS)


