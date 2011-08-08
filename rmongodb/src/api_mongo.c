#include <R.h>
#include "net.h"
#include "api_mongo.h"
#include "api_bson.h"
#include "symbols.h"
#include "utility.h"

static void mongoFinalizer(SEXP ptr) {
    if (!R_ExternalPtrAddr(ptr)) return;
    mongo_destroy((mongo*)R_ExternalPtrAddr(ptr));
    R_ClearExternalPtr(ptr);
}


mongo* _checkMongo(SEXP mongo_conn) {
    _checkClass(mongo_conn, "mongo");
    SEXP ptr = getAttrib(mongo_conn, sym_mongo);
    if (ptr == R_NilValue)
        error("Attribute \"mongo\" is missing from mongo class object\n");
    mongo* conn = (mongo*)R_ExternalPtrAddr(ptr);
    if (!conn)
        error("mongo connection object appears to have been destroyed.\n");
    return conn;
}


SEXP rmongo_destroy(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    mongo_destroy(conn);
    R_ClearExternalPtr(getAttrib(mongo_conn, sym_mongo));
    return R_NilValue;
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
    mongo* conn = _checkMongo(mongo_conn);
    mongo_host_port hp;
    SEXP host = getAttrib(mongo_conn, sym_host);
    int len = LENGTH(host);
    int i;
    if (len == 0)
        error("No hosts defined\n");
    const char* name = CHAR(STRING_ELT(getAttrib(mongo_conn, sym_name), 0));
    if (name[0] == '\0') {
        for (i = 0; i < len; i++) {
            mongo_parse_host(CHAR(STRING_ELT(host, i)), &hp);
            if (mongo_connect(conn, hp.host, hp.port) == MONGO_OK)
                break;
        }
        if (i == len) {
            if (len == 1)
                Rprintf("Unable to connect to %s:%d, error code = %d\n", hp.host, hp.port, conn->err);
            else
                Rprintf("Unable to connect to any of the given hosts, error code = %d\n", conn->err);
            return mongo_conn;
        }
    }
    else {
        mongo_replset_init(conn, name);
        for (i = 0; i < len; i++) {
            mongo_parse_host(CHAR(STRING_ELT(host, i)), &hp);
            mongo_replset_add_seed(conn, hp.host, hp.port);
        }
        if (mongo_replset_connect(conn) != MONGO_OK)
            Rprintf("Unable to connect to replset\n");
    }

    int timeout = asInteger(getAttrib(mongo_conn, sym_timeout));
    if (timeout > 0)
        mongo_set_op_timeout(conn, timeout);

    SEXP username = getAttrib(mongo_conn, sym_username);
    if (CHAR(STRING_ELT(username, 0))[0] != '\0') {
        SEXP password = getAttrib(mongo_conn, install("password"));
        SEXP db = getAttrib(mongo_conn, install("db"));
        SEXP ret = mongo_authenticate(mongo_conn, username, password, db);
        if (!LOGICAL(ret)[0]) {
            mongo_disconnect(conn);
            Rprintf("Authentication failed.\n");
        }
    }

    return mongo_conn;
}


SEXP rmongo_reconnect(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    if (mongo_reconnect(conn) != MONGO_OK)
        Rprintf("Unable to reconnect\n");
    return mongo_conn;
 }


SEXP rmongo_disconnect(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    mongo_disconnect(conn);
    return mongo_conn;
 }


SEXP mongo_get_socket(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = conn->sock;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_is_connected(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = conn->connected;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_get_err(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = conn->err;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_clear_err(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    conn->err = MONGO_CONN_SUCCESS;
    return mongo_conn;
}


SEXP mongo_get_server_err(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = conn->lasterrcode;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_get_server_err_string(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    SEXP ret;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar(conn->lasterrstr ? conn->lasterrstr : ""));
    UNPROTECT(1);
    return ret;
}


SEXP rmongo_insert(SEXP mongo_conn, SEXP ns, SEXP b) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    if (TYPEOF(b) == VECSXP) {
        int len = LENGTH(b);
        bson** blist = Calloc(len, bson*);
        int i;
        int success = 1;
        for (i = 0; i < len && success; i++) {
            SEXP _b = VECTOR_ELT(b, i);
            if (!_isBSON(_b))
                success = 0;
            else
                blist[i] = _checkBSON(_b);
        }
        if (success)
            LOGICAL(ret)[0] = (mongo_insert_batch(conn, _ns, blist, len) == MONGO_OK);
        Free(blist);
        if (!success)
            error("Expected list of mongo.bson class objects");
    }
    else {
        ;
        bson* _b = _checkBSON(b);
        LOGICAL(ret)[0] = (mongo_insert(conn, _ns, _b) == MONGO_OK);
    }
    UNPROTECT(1);
    return ret;
}


SEXP rmongo_update(SEXP mongo_conn, SEXP ns, SEXP cond, SEXP op, SEXP flags) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    bson* _cond = _checkBSON(cond);
    bson* _op = _checkBSON(op);
    int _flags = 0;
    int i;
    int len = LENGTH(flags);
    for (i = 0; i < len; i++)
        _flags |= INTEGER(flags)[i];
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (mongo_update(conn, _ns, _cond, _op, _flags) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP rmongo_remove(SEXP mongo_conn, SEXP ns, SEXP cond) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    bson* _cond = _checkBSON(cond);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (mongo_remove(conn, _ns, _cond) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP rmongo_find_one(SEXP mongo_conn, SEXP ns, SEXP query, SEXP fields)
{
    mongo* conn = _checkMongo(mongo_conn);
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    bson* _query = _checkBSON(query);
    bson* _fields = _checkBSON(fields);
    bson out;
    if (mongo_find_one(conn, _ns, _query, _fields, &out) != MONGO_OK) {
        bson_destroy(&out);
        return R_NilValue;
    }
    SEXP ret = _mongo_bson_create(&out);
    bson_destroy(&out);
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


mongo_cursor* _checkCursor(SEXP cursor) {
    _checkClass(cursor, "mongo.cursor");
    SEXP ptr = getAttrib(cursor, sym_mongo_cursor);
    if (ptr == R_NilValue)
        error("Attribute \"mongo.cursor\" is missing from mongo.cursor class object\n");
    mongo_cursor* _cursor = (mongo_cursor*)R_ExternalPtrAddr(ptr);
 /* NULL cursor value indicates no records returned from find
    if (!_cursor)
        error("mongo.cursor object appears to have been destroyed.\n");
*/
    return _cursor;
}


SEXP rmongo_find(SEXP mongo_conn, SEXP ns, SEXP query, SEXP fields, SEXP limit, SEXP skip, SEXP options)
{
    mongo* conn = _checkMongo(mongo_conn);
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    bson* _query = _checkBSON(query);
    bson* _fields = _checkBSON(fields);
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
    mongo_cursor* _cursor = _checkCursor(cursor);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = !_cursor ? FALSE : (mongo_cursor_next(_cursor) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_cursor_value(SEXP cursor) {
    mongo_cursor* _cursor = _checkCursor(cursor);
    if (!_cursor || !_cursor->current.data)
        return R_NilValue;
    SEXP ret = _mongo_bson_create(&_cursor->current);
    UNPROTECT(3);
    return ret;
}


SEXP rmongo_cursor_destroy(SEXP cursor) {
    mongo_cursor* _cursor = _checkCursor(cursor);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = mongo_cursor_destroy(_cursor);
    SEXP ptr = getAttrib(cursor, sym_mongo_cursor);
    R_ClearExternalPtr(ptr);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_index_create(SEXP mongo_conn, SEXP ns, SEXP key, SEXP options) {
    mongo* conn = _checkMongo(mongo_conn);
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
        _key = _checkBSON(key);
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
    if (success == MONGO_OK) {
        bson_destroy(&out);
        return R_NilValue;
    }
    SEXP ret = _mongo_bson_create(&out);
    bson_destroy(&out);
    UNPROTECT(3);
    return ret;
}


SEXP rmongo_count(SEXP mongo_conn, SEXP ns, SEXP query) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    char* p = strchr((char*)_ns, '.');
    if (!p)
        error("Expected a '.' in the namespace.");
    int len = p - (char*)_ns;
    char* db = Calloc(len+1, char);
    strncpy(db, _ns, len);
    db[len] = '\0';
    bson* _query = _checkBSON(query);
    SEXP ret;
    PROTECT(ret = allocVector(REALSXP, 1));
    REAL(ret)[0] = mongo_count(conn, db, p+1, _query);
    Free(db);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_command(SEXP mongo_conn, SEXP db, SEXP command) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _db = CHAR(STRING_ELT(db, 0));
    bson* _command = _checkBSON(command);
    bson out;
    if (mongo_run_command(conn, _db, _command, &out) != MONGO_OK) {
        bson_destroy(&out);
        return R_NilValue;
    }
    SEXP ret = _mongo_bson_create(&out);
    bson_destroy(&out);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_simple_command(SEXP mongo_conn, SEXP db, SEXP cmdstr, SEXP arg) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _db = CHAR(STRING_ELT(db, 0));
    const char* _cmdstr = CHAR(STRING_ELT(cmdstr, 0));
    bson out;
    int success;
    if (TYPEOF(arg) == STRSXP)
        success = (mongo_simple_str_command(conn, _db, _cmdstr, CHAR(STRING_ELT(arg, 0)), &out) == MONGO_OK);
    else
        success = (mongo_simple_int_command(conn, _db, _cmdstr, asInteger(arg), &out) == MONGO_OK);
    if (!success) {
        bson_destroy(&out);
        return R_NilValue;
    }
    SEXP ret = _mongo_bson_create(&out);
    bson_destroy(&out);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_drop_database(SEXP mongo_conn, SEXP db) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _db = CHAR(STRING_ELT(db, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (mongo_cmd_drop_db(conn, _db) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_drop_collection(SEXP mongo_conn, SEXP ns) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _ns = CHAR(STRING_ELT(ns, 0));
    char* p = strchr((char*)_ns, '.');
    if (!p)
        error("Expected a '.' in the namespace.");
    int len = p - (char*)_ns;
    char* db = Calloc(len+1, char);
    strncpy(db, _ns, len);
    db[len] = '\0';
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (mongo_cmd_drop_collection(conn, db, p+1, NULL) == MONGO_OK);
    Free(db);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_reset_error(SEXP mongo_conn, SEXP db) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _db = CHAR(STRING_ELT(db, 0));
    mongo_cmd_reset_error(conn, _db);
    return R_NilValue;
}


SEXP mongo_get_last_error(SEXP mongo_conn, SEXP db) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _db = CHAR(STRING_ELT(db, 0));
    bson out;
    if (mongo_cmd_get_last_error(conn, _db, &out) == MONGO_OK) {
        bson_destroy(&out);
        return R_NilValue;
    }
    SEXP ret = _mongo_bson_create(&out);
    bson_destroy(&out);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_get_prev_error(SEXP mongo_conn, SEXP db) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _db = CHAR(STRING_ELT(db, 0));
    bson out;
    if (mongo_cmd_get_prev_error(conn, _db, &out) == MONGO_OK) {
        bson_destroy(&out);
        return R_NilValue;
    }
    SEXP ret = _mongo_bson_create(&out);
    bson_destroy(&out);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_is_master(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = mongo_cmd_ismaster(conn, NULL);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_add_user(SEXP mongo_conn, SEXP user, SEXP pass, SEXP db)
{
    mongo* conn = _checkMongo(mongo_conn);
    const char* _db = CHAR(STRING_ELT(db, 0));
    const char* _user = CHAR(STRING_ELT(user, 0));
    const char* _pass = CHAR(STRING_ELT(pass, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (mongo_cmd_add_user(conn, _db, _user, _pass) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_authenticate(SEXP mongo_conn, SEXP user, SEXP pass, SEXP db) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _user = CHAR(STRING_ELT(user, 0));
    const char* _pass = CHAR(STRING_ELT(pass, 0));
    const char* _db = CHAR(STRING_ELT(db, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (mongo_cmd_authenticate(conn, _db, _user, _pass) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


const char* _get_host_port(mongo_host_port* hp) {
    static char _hp[sizeof(hp->host+12)];
    sprintf(_hp, "%s:%d", hp->host, hp->port);
    return _hp;
}


SEXP mongo_get_primary(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    SEXP ret;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar(_get_host_port(conn->primary)));
    UNPROTECT(1);
    return ret;
}


SEXP mongo_get_hosts(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    mongo_replset* r = conn->replset;
    if (!r) return R_NilValue;
    int count = 0;
    mongo_host_port* hp;
    for (hp = r->hosts; hp; hp = hp->next)
        ++count;
    SEXP ret;
    PROTECT(ret = allocVector(STRSXP, count));
    int i = 0;
    for (hp = r->hosts; hp; hp = hp->next, i++)
        SET_STRING_ELT(ret, i, mkChar(_get_host_port(hp)));
    UNPROTECT(1);
    return ret;
}


SEXP mongo_set_timeout(SEXP mongo_conn, SEXP timeout) {
    mongo* conn = _checkMongo(mongo_conn);
    int _timeout = asInteger(timeout);
    mongo_set_op_timeout(conn, _timeout);
    return mongo_conn;
}


SEXP mongo_get_timeout(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = conn->op_timeout_ms;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_rename(SEXP mongo_conn, SEXP from_ns, SEXP to_ns) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _from_ns = CHAR(STRING_ELT(from_ns, 0));
    const char* _to_ns = CHAR(STRING_ELT(to_ns, 0));
    bson cmd;
    bson_init(&cmd);
    bson_append_string(&cmd, "renameCollection", _from_ns);
    bson_append_string(&cmd, "to", _to_ns);
    bson_finish(&cmd);
    bson out;
    if (mongo_run_command(conn, "admin", &cmd, &out) == MONGO_OK) {
        bson_destroy(&cmd);
        bson_destroy(&out);
        return R_NilValue;
    }
    bson_destroy(&cmd);
    SEXP ret = _mongo_bson_create(&out);
    bson_destroy(&out);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_get_databases(SEXP mongo_conn) {
    mongo* conn = _checkMongo(mongo_conn);
    bson out;
    if (mongo_simple_int_command(conn, "admin", "listDatabases", 1, &out) != MONGO_OK) {
        bson_destroy(&out);
        return R_NilValue;
    }
    bson_iterator it, databases, database;
    bson_iterator_init(&it, &out);
    bson_iterator_next(&it);
    bson_iterator_subiterator(&it, &databases);
    int count = 0;
    while (bson_iterator_next(&databases))
        count++;
    SEXP ret;
    PROTECT(ret = allocVector(STRSXP, count));
    bson_iterator_subiterator(&it, &databases);
    int i = 0;
    while (bson_iterator_next(&databases)) {
        bson_iterator_subiterator(&databases, &database);
        bson_iterator_next(&database);
        SET_STRING_ELT(ret, i++, mkChar(bson_iterator_string(&database)));
    }
    bson_destroy(&out);
    UNPROTECT(1);
    return ret;
}
