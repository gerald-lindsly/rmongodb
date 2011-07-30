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


SEXP mongo_get_socket(SEXP mongo_conn) {
    _checkMongo(mongo_conn);
    SEXP ret;
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = conn->sock;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_is_connected(SEXP mongo_conn) {
    _checkMongo(mongo_conn);
    SEXP ret;
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = conn->connected;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_get_err(SEXP mongo_conn) {
    _checkMongo(mongo_conn);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    INTEGER(ret)[0] = conn->err;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_get_server_err(SEXP connection) {
    _checkMongo(connection);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(connection, sym_mongo));
    INTEGER(ret)[0] = conn->lasterrcode;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_get_server_err_string(SEXP connection) {
    _checkMongo(connection);
    SEXP ret;
    PROTECT(ret = allocVector(STRSXP, 1));
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(connection, sym_mongo));
    SET_STRING_ELT(ret, 0, mkChar(conn->lasterrstr));
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


SEXP rmongo_cursor_destroy(SEXP cursor) {
    _checkCursor(cursor);
    SEXP ptr = getAttrib(cursor, sym_mongo_cursor);
    mongo_cursor* _cursor = (mongo_cursor*)R_ExternalPtrAddr(ptr);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = mongo_cursor_destroy(_cursor);
    R_ClearExternalPtr(ptr);
    UNPROTECT(1);
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


SEXP rmongo_count(SEXP mongo_conn, SEXP ns, SEXP query) {
    _checkMongo(mongo_conn);
    _checkBSON(query);
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    char* p = strchr((char*)_ns, '.');
    if (!p)
        error("Expected a '.' in the namespace.");
    int len = p - (char*)_ns;
    char* db = Calloc(len+1, char);
    strncpy(db, _ns, len);
    db[len] = '\0';
    bson* _query = (bson*)R_ExternalPtrAddr(getAttrib(query, sym_mongo_bson));
    int64_t count = mongo_count(conn, db, p+1, _query);
    Free(db);
    SEXP ret;
    PROTECT(ret = allocVector(REALSXP, 1));
    REAL(ret)[0] = count;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_command(SEXP mongo_conn, SEXP db, SEXP command) {
    _checkMongo(mongo_conn);
    _checkBSON(command);
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    const char* _db = CHAR(STRING_ELT(db, 0));
    bson* _command = (bson*)R_ExternalPtrAddr(getAttrib(command, sym_mongo_bson));
    bson out;
    if (mongo_run_command(conn, _db, _command, &out) != MONGO_OK)
        return R_NilValue;
    SEXP ret = _mongo_bson_create(&out);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_simple_command(SEXP mongo_conn, SEXP db, SEXP cmdstr, SEXP arg) {
    _checkMongo(mongo_conn);
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    const char* _db = CHAR(STRING_ELT(db, 0));
    const char* _cmdstr = CHAR(STRING_ELT(cmdstr, 0));
    bson out;
    int success;
    if (TYPEOF(arg) == STRSXP)
        success = mongo_simple_str_command(conn, _db, _cmdstr, CHAR(STRING_ELT(arg, 0)), &out);
    else
        success = mongo_simple_int_command(conn, _db, _cmdstr, asInteger(arg), &out);
    if (!success)
        return R_NilValue;
    SEXP ret = _mongo_bson_create(&out);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_drop_database(SEXP mongo_conn, SEXP db) {
    _checkMongo(mongo_conn);
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    const char* _db = CHAR(STRING_ELT(db, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (mongo_cmd_drop_db(conn, _db) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_drop_collection(SEXP mongo_conn, SEXP ns) {
    _checkMongo(mongo_conn);
    mongo* conn = (mongo*)R_ExternalPtrAddr(getAttrib(mongo_conn, sym_mongo));
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    char* p = strchr((char*)_ns, '.');
    if (!p)
        error("Expected a '.' in the namespace.");
    int len = p - (char*)_ns;
    char* db = Calloc(len+1, char);
    strncpy(db, _ns, len);
    db[len] = '\0';
    bson out;
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (mongo_cmd_drop_collection(conn, db, p+1, &out) == MONGO_OK);
    Free(db);
    UNPROTECT(1);
    return ret;
}


