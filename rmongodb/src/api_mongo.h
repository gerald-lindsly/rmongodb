#include <Rinternals.h>

SEXP mongo_create();
SEXP rmongo_connect(SEXP mongo_conn);
SEXP rmongo_reconnect(SEXP mongo_conn);
SEXP rmongo_disconnect(SEXP mongo_conn);
SEXP rmongo_destroy(SEXP mongo_conn);
SEXP mongo_is_connected(SEXP mongo_conn);
SEXP mongo_get_socket(SEXP mongo_conn);
SEXP mongo_get_primary(SEXP mongo_conn);
SEXP mongo_get_hosts(SEXP mongo_conn);
SEXP mongo_get_err(SEXP mongo_conn);
SEXP mongo_set_timeout(SEXP mongo_conn, SEXP timeout);
SEXP mongo_get_timeout(SEXP mongo_conn);

SEXP mongo_get_server_err(SEXP mongo_conn);
SEXP mongo_get_server_err_string(SEXP mongo_conn);

SEXP rmongo_insert(SEXP mongo_conn, SEXP ns, SEXP bson);
SEXP rmongo_update(SEXP mongo_conn, SEXP ns, SEXP cond, SEXP op, SEXP flags);
SEXP rmongo_remove(SEXP mongo_conn, SEXP ns, SEXP cond);
SEXP rmongo_find_one(SEXP mongo_conn, SEXP ns, SEXP query, SEXP fields);
SEXP rmongo_find(SEXP mongo_conn, SEXP ns, SEXP query, SEXP fields, SEXP limit, SEXP skip, SEXP options);
SEXP rmongo_cursor_next(SEXP cursor);
SEXP mongo_cursor_value(SEXP cursor);
SEXP rmongo_cursor_destroy(SEXP cursor);
SEXP mongo_index_create(SEXP mongo_conn, SEXP ns, SEXP key, SEXP options);
SEXP rmongo_count(SEXP mongo_conn, SEXP ns, SEXP query);
SEXP mongo_command(SEXP mongo_conn, SEXP db, SEXP command);
SEXP mongo_simple_command(SEXP mongo_conn, SEXP db, SEXP cmdstr, SEXP arg);
SEXP mongo_drop_database(SEXP mongo_conn, SEXP db);
SEXP mongo_drop(SEXP mongo_conn, SEXP ns);
SEXP mongo_rename(SEXP mongo_conn, SEXP from_ns, SEXP to_ns);
SEXP mongo_get_databases(SEXP mongo_conn);
SEXP mongo_get_database_collections(SEXP mongo_conn, SEXP db);
SEXP mongo_reset_err(SEXP mongo_conn, SEXP db);
SEXP mongo_get_last_err(SEXP mongo_conn, SEXP db);
SEXP mongo_get_prev_err(SEXP mongo_conn, SEXP db);
SEXP mongo_is_master(SEXP mongo_conn);
SEXP mongo_add_user(SEXP mongo_conn, SEXP db, SEXP user, SEXP pass);
SEXP mongo_authenticate(SEXP mongo_conn, SEXP db, SEXP user, SEXP pass);
