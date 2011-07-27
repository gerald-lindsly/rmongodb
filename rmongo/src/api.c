#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>

#include "api_bson.h"
#include "api_mongo.h"

int sock_init();


#define CDEF(name)  {"mongo." #name, (DL_FUNC) &name, sizeof(name ## _t)/sizeof(name ## _t[0]), name ##_t}

static R_NativePrimitiveArgType sock_connect_t[] = {INTSXP, STRSXP};
static R_NativePrimitiveArgType sock_close_t[] = {INTSXP};

static const R_CMethodDef CEntries[] = {
    {"mongo.sock_init", (DL_FUNC)sock_init, 0, NULL},
    {NULL, NULL, 0}
};


static const R_CallMethodDef callMethods[] = {
    { ".mongo.connection.create", (DL_FUNC) connection_create, 0 },
    { ".mongo.connection.connect", (DL_FUNC) connection_connect, 1 },
    { ".mongo.connection.getSocket", (DL_FUNC) connection_getSocket, 1 },
    { ".mongo.connection.isConnected", (DL_FUNC) connection_isConnected, 1 },
    { ".mongo.connection.getErr", (DL_FUNC) connection_getErr, 1 },

    { ".mongo.bson.empty", (DL_FUNC) mongo_bson_empty, 0},
    { ".mongo.bson.clear", (DL_FUNC) mongo_bson_clear, 1},
    { ".mongo.bson.copy", (DL_FUNC) mongo_bson_copy, 1},
    { ".mongo.bson.size", (DL_FUNC) mongo_bson_size, 1},
    { ".mongo.bson.print", (DL_FUNC) mongo_bson_print, 1},
    { ".mongo.bson.to.list", (DL_FUNC) mongo_bson_to_list, 1},

    { ".mongo.bson.iterator.create", (DL_FUNC) mongo_bson_iterator_create, 1},
    { ".mongo.bson.find", (DL_FUNC) mongo_bson_find, 3},
    { ".mongo.bson.iterator.more", (DL_FUNC) mongo_bson_iterator_more, 1},
    { ".mongo.bson.iterator.next", (DL_FUNC) mongo_bson_iterator_next, 1},
    { ".mongo.bson.iterator.key", (DL_FUNC) mongo_bson_iterator_key, 1},
    { ".mongo.bson.iterator.type", (DL_FUNC) mongo_bson_iterator_type, 1},
    { ".mongo.bson.iterator.value", (DL_FUNC) mongo_bson_iterator_value, 1},

    { ".mongo.oid.from.string", (DL_FUNC) mongo_oid_from_string, 1},
    { ".mongo.string.from.oid", (DL_FUNC) mongo_string_from_oid, 1},
    { ".mongo.oid.print", (DL_FUNC) mongo_oid_print, 1},

    { ".mongo.timestamp.create", (DL_FUNC) mongo_timestamp_create, 2},
    { ".mongo.code.create", (DL_FUNC) mongo_code_create, 1},
    { ".mongo.code.w.scope.create", (DL_FUNC) mongo_code_w_scope_create, 2},
    { ".mongo.symbol.create", (DL_FUNC) mongo_symbol_create, 1},
    { ".mongo.undefined.create", (DL_FUNC) mongo_undefined_create, 0},

    { ".mongo.bson.buffer.create", (DL_FUNC) mongo_bson_buffer_create, 0},
    { ".mongo.bson.from.buffer", (DL_FUNC) mongo_bson_from_buffer, 1},
    { ".mongo.bson.buffer.append.int", (DL_FUNC) mongo_bson_buffer_append_int, 3},
    { ".mongo.bson.buffer.append.bool", (DL_FUNC) mongo_bson_buffer_append_bool, 3},
    { ".mongo.bson.buffer.append.long", (DL_FUNC) mongo_bson_buffer_append_long, 3},
    { ".mongo.bson.buffer.append.double", (DL_FUNC) mongo_bson_buffer_append_double, 3},
    { ".mongo.bson.buffer.append.complex", (DL_FUNC) mongo_bson_buffer_append_complex, 3},
    { ".mongo.bson.buffer.append.null", (DL_FUNC) mongo_bson_buffer_append_null, 2},
    { ".mongo.bson.buffer.append.undefined", (DL_FUNC) mongo_bson_buffer_append_undefined, 2},
    { ".mongo.bson.buffer.append.time", (DL_FUNC) mongo_bson_buffer_append_time, 3},
    { ".mongo.bson.buffer.append.timestamp", (DL_FUNC) mongo_bson_buffer_append_timestamp, 3},
    { ".mongo.bson.buffer.append.string", (DL_FUNC) mongo_bson_buffer_append_string, 3},
    { ".mongo.bson.buffer.append.code", (DL_FUNC) mongo_bson_buffer_append_code, 3},
    { ".mongo.bson.buffer.append.code.w.scope", (DL_FUNC) mongo_bson_buffer_append_code_w_scope, 3},
    { ".mongo.bson.buffer.append.symbol", (DL_FUNC) mongo_bson_buffer_append_symbol, 3},
    { ".mongo.bson.buffer.append.oid", (DL_FUNC) mongo_bson_buffer_append_oid, 3},
    { ".mongo.bson.buffer.append.bson", (DL_FUNC) mongo_bson_buffer_append_bson, 3},
    { ".mongo.bson.buffer.append.element", (DL_FUNC) mongo_bson_buffer_append_element, 3},
    { ".mongo.bson.buffer.append", (DL_FUNC) mongo_bson_buffer_append, 3},
    { ".mongo.bson.buffer.start.object", (DL_FUNC) mongo_bson_buffer_start_object, 2},
    { ".mongo.bson.buffer.start.array", (DL_FUNC) mongo_bson_buffer_start_array, 2},
    { ".mongo.bson.buffer.finish.object", (DL_FUNC) mongo_bson_buffer_finish_object, 1},

    { ".mongo.insert", (DL_FUNC) rmongo_insert, 3 },
    { NULL, NULL, 0 }
};


void attribute_visible R_init_rmongo(DllInfo *dll) {
    R_registerRoutines(dll, CEntries, callMethods, NULL, NULL);
}