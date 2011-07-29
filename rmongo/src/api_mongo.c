#include <R.h>
#include "net.h"
#include "api_mongo.h"
#include "api_bson.h"
#include "symbols.h"
#include "utility.h"

static void mongoFinalizer(SEXP ptr) {
    if (!R_ExternalPtrAddr(ptr)) return;
    mongo_destroy((mongo*)R_ExternalPtrAddr(ptr));
    R_ClearExternalPtr(ptr); /* not really needed */
}


void _checkMongo(SEXP mongo_conn) {
    _checkClass(mongo_conn, "mongo");
}


void _checkCursor(SEXP cursor) {
    _checkClass(cursor, "mongo.cursor");
}


SEXP mongo_create() {
    SEXP ret, ptr, cls;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
    mongo* conn = Calloc(1, mongo);
    ptr = R_MakeExternalPtr(conn, sym_mongo, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, mongoFinalizer, TRUE);
    setAttrib(ret, sym_mongo, ptr);
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo"));
    classgets(ret, cls);
    UNPROTECT(3);
    return ret;
}


SEXP rmongo_connect(SEXP mongo_conn) {
    _checkMongo(mongo_conn);
    int ret;
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    SEXP host = getAttrib(mongo_conn, sym_host);
    if (LENGTH(host) == 0)
        error("no hosts defined");
    if (LENGTH(host) == 1) {
        int port = INTEGER(getAttrib(mongo_conn, sym_port))[0];
        const char* shost = CHAR(STRING_ELT(host, 0));
        ret = mongo_connect(conn, shost, port);
        if (ret)
            Rprintf("Unable to connect to %s:%d, error code = %d\n", shost, port, conn->err);
    }
    else
        error("replset not implemeted yet");

    return mongo_conn;
}

SEXP mongo_getSocket(SEXP mongo_conn) {
    _checkMongo(mongo_conn);
    SEXP ret;
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = conn->sock;
    UNPROTECT(1);
    return ret;
}

SEXP mongo_isConnected(SEXP mongo_conn) {
    _checkMongo(mongo_conn);
    SEXP ret;
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = conn->connected;
    UNPROTECT(1);
    return ret;
}

SEXP mongo_getErr(SEXP mongo_conn) {
    _checkMongo(mongo_conn);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    INTEGER(ret)[0] = conn->err;
    UNPROTECT(1);
    return ret;
}


SEXP rmongo_insert(SEXP mongo_conn, SEXP ns, SEXP b) {
    _checkMongo(mongo_conn);
    _checkBSON(b);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    bson* _b = (bson*)R_ExternalPtrAddr(getAttrib(b, sym_mongo_bson));
    LOGICAL(ret)[0] = (mongo_insert(conn, _ns, _b) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP rmongo_update(SEXP mongo_conn, SEXP ns, SEXP cond, SEXP op, SEXP flags) {
    _checkMongo(mongo_conn);
    _checkBSON(cond);
    _checkBSON(op);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    bson* _cond = (bson*)R_ExternalPtrAddr(getAttrib(cond, sym_mongo_bson));
    bson* _op = (bson*)R_ExternalPtrAddr(getAttrib(op, sym_mongo_bson));
    int _flags = 0;
    int i;
    int len = LENGTH(flags);
    for (i = 0; i < len; i++)
        _flags |= INTEGER(flags)[i];
    LOGICAL(ret)[0] = (mongo_update(conn, _ns, _cond, _op, _flags) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP rmongo_remove(SEXP mongo_conn, SEXP ns, SEXP cond) {
    _checkMongo(mongo_conn);
    _checkBSON(cond);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    bson* _cond = (bson*)R_ExternalPtrAddr(getAttrib(cond, sym_mongo_bson));
    LOGICAL(ret)[0] = (mongo_remove(conn, _ns, _cond) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP rmongo_find_one(SEXP mongo_conn, SEXP ns, SEXP query, SEXP fields)
{
    _checkMongo(mongo_conn);
    _checkBSON(query);
    _checkBSON(fields);
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    bson* _query = (bson*)R_ExternalPtrAddr(getAttrib(query, sym_mongo_bson));
    bson* _fields = (bson*)R_ExternalPtrAddr(getAttrib(fields, sym_mongo_bson));
    bson out;
    if (mongo_find_one(conn, _ns, _query, _fields, &out) != MONGO_OK)
        return R_NilValue;
    SEXP ret = _mongo_bson_create(&out);
    UNPROTECT(3);
    return ret;
}


static void mongoCursorFinalizer(SEXP ptr) {
    if (!R_ExternalPtrAddr(ptr)) return;
    mongo_cursor* cursor = (mongo_cursor*)R_ExternalPtrAddr(ptr);
    mongo_cursor_destroy(cursor);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP _mongo_cursor_create(mongo_cursor* cursor)
{
    SEXP ret, ptr, cls;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
    ptr = R_MakeExternalPtr(cursor, sym_mongo_cursor, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, mongoCursorFinalizer, TRUE);
    setAttrib(ret, sym_mongo_cursor, ptr);
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.cursor"));
    classgets(ret, cls);
    UNPROTECT(3);
    return ret;
}


SEXP rmongo_find(SEXP mongo_conn, SEXP ns, SEXP query, SEXP fields, SEXP limit, SEXP skip, SEXP options)
{
    _checkMongo(mongo_conn);
    _checkBSON(query);
    _checkBSON(fields);
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    bson* _query = (bson*)R_ExternalPtrAddr(getAttrib(query, sym_mongo_bson));
    bson* _fields = (bson*)R_ExternalPtrAddr(getAttrib(fields, sym_mongo_bson));
    int _limit = asInteger(limit);
    int _skip = asInteger(skip);
    int _options = 0;
    int i;
    int len = LENGTH(options);
    for (i = 0; i < len; i++)
        _options |= INTEGER(options)[i];

    mongo_cursor* cursor = mongo_find(conn, _ns, _query, _fields, _limit, _skip, _options);
    return _mongo_cursor_create(cursor);
}


SEXP rmongo_cursor_next(SEXP cursor) {
    _checkCursor(cursor);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    mongo_cursor* _cursor = (mongo_cursor*)R_ExternalPtrAddr(getAttrib(cursor, sym_mongo_cursor));
    LOGICAL(ret)[0] = !_cursor ? FALSE : (mongo_cursor_next(_cursor) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_cursor_value(SEXP cursor) {
    _checkCursor(cursor);
    mongo_cursor* _cursor = (mongo_cursor*)R_ExternalPtrAddr(getAttrib(cursor, sym_mongo_cursor));
    if (!_cursor)
        return R_NilValue;
    SEXP ret = _mongo_bson_create(&_cursor->current);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_index_create(SEXP mongo_conn, SEXP ns, SEXP key, SEXP options) {
    _checkMongo(mongo_conn);
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    int _options = 0;
    int i;
    int len = LENGTH(options);
    for (i = 0; i < len; i++)
        _options |= INTEGER(options)[i];
    bson* _key;
    bson b;
    int keyIsBSON = _isBSON(key);
    if (keyIsBSON)
        _key = (bson*)R_ExternalPtrAddr(getAttrib(key, sym_mongo_bson));
    else {
        _key = &b;
        len = LENGTH(key);
        bson_init(&b);
        for (i = 0; i < len; i++)
            bson_append_int(&b, CHAR(STRING_ELT(key, i)), 1);
        bson_finish(&b);
    }
    bson out;
    int success = mongo_create_index(conn, _ns, _key, _options, &out);
    if (!keyIsBSON)
        bson_destroy(&b);
    if (success == MONGO_OK)
        return R_NilValue;
    SEXP ret = _mongo_bson_create(&out);
    UNPROTECT(3);
    return ret;
}


