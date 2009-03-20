#include <sys/socket.h>
#include <stdlib.h>
#include <stdio.h>
#include <mysql/mysql.h>
#include "keylookup_server.h"
#include "brpc.h"

MYSQL *conn;

void handle_keylookup_lookup ( struct sockaddr * source , uint8_t key [] , uint16_t key_len ) {
  MYSQL_RES *res;
  MYSQL_ROW *row;
  char query[1028];
  printf("lookup (%s) -> ", key);
  snprintf(query, 1028, "SELECT * FROM data WHERE k = '%s';", key);
  if (mysql_query(conn, query)) {
    fprintf(stderr, "%s\n", mysql_error(conn));
    return;
  }
  res = mysql_use_result(conn);
  row = mysql_fetch_row(res);
  if (row != NULL) {
    printf("(%s)\n", row[1]);
    signal_keylookup_lookupdone(source, row[1], strlen(row[1])+1);
  } else {
    printf ("NULL\n");
    signal_keylookup_lookupdone(source, '\0', 1);
  }
  mysql_free_result(res);
}
void handle_keylookup_insert ( struct sockaddr * source , uint8_t key [] , uint16_t key_len , 
                               uint8_t value [] , uint16_t value_len ) {
  char query[1028];
  printf("insert (%s:%s)\n", key, value);
  snprintf(query, 1028, "INSERT INTO data (`k`, `v`) VALUES ('%s', '%s') ON DUPLICATE KEY UPDATE `v` = '%s';",
           key, value, value);
  if (mysql_query(conn, query)) {
    fprintf(stderr, "%s\n", mysql_error(conn));
  }
  signal_keylookup_insertdone(source, key, key_len);
}

int main(int argc, char **argv) {
  char *server = "localhost";
  char *user = "root";
  char *password = "";
  char *database = "keyvalue";

  conn = mysql_init(NULL);

  if (!mysql_real_connect(conn, server, user, password, database, 0, NULL, 0)) {
    fprintf(stderr, "%s\n", mysql_error(conn));
    exit(1);
  }

  if (argc != 2) {
    fprintf(stderr, "\n\tusage: keylookup_server <port>\n\n");
    exit(1);
  }
  keylookup_server_init(atoi(argv[1]));
  while (1) {
    keylookup_server_next();
  }
}

