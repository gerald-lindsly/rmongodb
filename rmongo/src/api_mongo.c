#include <R.h>
#include "net.h"
#include "api_mongo.h"
#include "symbols.h"

static void connectionFinalizer(SEXP ptr)
{
    if (!R_ExternalPtrAddr(ptr)) return;
    mongo_destroy((mongo_connection*)R_ExternalPtrAddr(ptr));
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP connection_create()
{
	SEXP ret, ptr;
	PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
	mongo_connection* conn = Calloc(1, mongo_connection);
    ptr = R_MakeExternalPtr(conn, sym_mongo_connection, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, connectionFinalizer, TRUE);
    setAttrib(ret, sym_mongo_connection, ptr);
    UNPROTECT(2);
    return ret;
}


SEXP connection_connect(SEXP connection)
{
	int ret;
	mongo_connection* conn = (mongo_connection*)R_ExternalPtrAddr(getAttrib(connection, sym_mongo_connection));
	SEXP host = getAttrib(connection, sym_host);
	if (LENGTH(host) == 0)
		error("no hosts defined");
	if (LENGTH(host) == 1) {
		int port = INTEGER(getAttrib(connection, sym_port))[0];
		const char* shost = CHAR(STRING_ELT(host, 0));
		ret = mongo_connect(conn, shost, port);
		if (ret)
			Rprintf("Unable to connect to %s:%d, error code = %d", shost, port, conn->err);
	}
	else
		error("replset not implemeted yet");

	return connection;
}

SEXP connection_getSocket(SEXP connection)
{
	SEXP ret;
	mongo_connection* conn = (mongo_connection*)R_ExternalPtrAddr(getAttrib(connection, sym_mongo_connection));
	PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = conn->sock;
    UNPROTECT(1);
    return ret;
}

SEXP connection_isConnected(SEXP connection)
{
	SEXP ret;
	mongo_connection* conn = (mongo_connection*)R_ExternalPtrAddr(getAttrib(connection, sym_mongo_connection));
	PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = conn->connected;
    UNPROTECT(1);
    return ret;
}

SEXP connection_getErr(SEXP connection)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	mongo_connection* conn = (mongo_connection*)R_ExternalPtrAddr(getAttrib(connection, sym_mongo_connection));
    INTEGER(ret)[0] = conn->err;
    UNPROTECT(1);
    return ret;
}


SEXP rmongo_insert(SEXP connection, SEXP ns, SEXP b)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	mongo_connection* conn = (mongo_connection*)R_ExternalPtrAddr(getAttrib(connection, sym_mongo_connection));
	const char* _ns = CHAR(STRING_ELT(ns, 0));
	bson* _b = (bson*)R_ExternalPtrAddr(getAttrib(b, sym_mongo_bson));
	INTEGER(ret)[0] = mongo_insert(conn, _ns, _b);
	printf("\n%d (%d), %s, %s\n", conn->sock, conn->err, _ns, _b->data);
    UNPROTECT(1);
	return ret;
}