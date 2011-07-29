#include <Rinternals.h>

SEXP mongo_create();
SEXP rmongo_connect(SEXP connection);
SEXP mongo_isConnected(SEXP connection);
SEXP mongo_getSocket(SEXP connection);
SEXP mongo_getErr(SEXP connection);


SEXP rmongo_insert(SEXP connection, SEXP ns, SEXP bson);
SEXP rmongo_update(SEXP connection, SEXP ns, SEXP cond, SEXP op, SEXP flags);
SEXP rmongo_remove(SEXP mongo_conn, SEXP ns, SEXP cond);
SEXP rmongo_find_one(SEXP mongo_conn, SEXP ns, SEXP query, SEXP fields);
SEXP rmongo_find(SEXP mongo_conn, SEXP ns, SEXP query, SEXP fields, SEXP limit, SEXP skip, SEXP options);
SEXP rmongo_cursor_next(SEXP cursor);
SEXP mongo_cursor_value(SEXP cursor);
SEXP mongo_index_create(SEXP mongo_conn, SEXP ns, SEXP key, SEXP options);
