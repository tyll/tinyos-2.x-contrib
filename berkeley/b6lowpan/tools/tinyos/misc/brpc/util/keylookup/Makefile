

all: client server

server:
	$(CC) -O -Wall -lmysqlclient -pedantic -o keylookup_server keylookup_server.c keylookup_server_impl.c keylookup_impl.c 

client:
	$(CC) -O -Wall -pedantic -o keylookup_client keylookup_client.c keylookup_client_impl.c keylookup_impl.c

clean:
	rm -rf keylookup_server keylookup_client


