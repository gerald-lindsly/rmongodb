#include <Rinternals.h>

SEXP connection_create();
SEXP connection_connect(SEXP connection);
SEXP connection_isConnected(SEXP connection);
SEXP connection_getSocket(SEXP connection);
SEXP connection_getErr(SEXP connection);


SEXP rmongo_insert(SEXP connection, SEXP ns, SEXP bson);
