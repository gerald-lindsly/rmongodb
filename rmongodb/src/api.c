/* Copyright (C) 2008-2011 10gen Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
#include <R.h>
#include <R_ext/Rdynload.h>
#include <R_ext/Visibility.h>

#include "api_bson.h"
#include "api_mongo.h"
#include "api_gridfs.h"
#include "symbols.h"
#include "env.h"

static const R_CallMethodDef callMethods[] = {
    { ".mongo.create", (DL_FUNC) mmongo_create, 0 },
    { ".mongo.connect", (DL_FUNC) rmongo_connect, 1 },
    { ".mongo.is.connected", (DL_FUNC) mmongo_is_connected, 1 },
    { ".mongo.get.err", (DL_FUNC) mmongo_get_err, 1 },
    { ".mongo.reconnect", (DL_FUNC) rmongo_reconnect, 1 },
    { ".mongo.disconnect", (DL_FUNC) rmongo_disconnect, 1 },
    { ".mongo.destroy", (DL_FUNC) rmongo_destroy, 1 },
    { ".mongo.get.socket", (DL_FUNC) mmongo_get_socket, 1 },
    { ".mongo.get.primary", (DL_FUNC) mmongo_get_primary, 1 },
    { ".mongo.get.hosts", (DL_FUNC) mongo_get_hosts, 1 },
    { ".mongo.set.timeout", (DL_FUNC) mongo_set_timeout, 2 },
    { ".mongo.get.timeout", (DL_FUNC) mongo_get_timeout, 1 },
    { ".mongo.get.last.err", (DL_FUNC) mongo_get_last_err, 2 },
    { ".mongo.get.prev.err", (DL_FUNC) mongo_get_prev_err, 2 },
    { ".mongo.reset.err", (DL_FUNC) mongo_reset_err, 2 },
    { ".mongo.is.master", (DL_FUNC) mongo_is_master, 1 },
    { ".mongo.add.user", (DL_FUNC) mongo_add_user, 4 },
    { ".mongo.authenticate", (DL_FUNC) mongo_authenticate, 4 },
    { ".mongo.get.server.err", (DL_FUNC) mmongo_get_server_err, 1 },
    { ".mongo.get.server.err.string", (DL_FUNC) mmongo_get_server_err_string, 1 },
    { ".mongo.insert", (DL_FUNC) rmongo_insert, 3 },
    { ".mongo.insert.batch", (DL_FUNC) rmongo_insert_batch, 3 },
    { ".mongo.update", (DL_FUNC) rmongo_update, 5 },
    { ".mongo.remove", (DL_FUNC) rmongo_remove, 3 },
    { ".mongo.find.one", (DL_FUNC) rmongo_find_one, 4 },
    { ".mongo.find", (DL_FUNC) rmongo_find, 8 },
    { ".mongo.cursor.next", (DL_FUNC) rmongo_cursor_next, 1 },
    { ".mongo.cursor.value", (DL_FUNC) mongo_cursor_value, 1 },
    { ".mongo.cursor.destroy", (DL_FUNC) rmongo_cursor_destroy, 1 },
    { ".mongo.index.create", (DL_FUNC) mongo_index_create, 4 },
    { ".mongo.count", (DL_FUNC) rmongo_count, 3 },
    { ".mongo.command", (DL_FUNC) mongo_command, 3 },
    { ".mongo.simple.command", (DL_FUNC) mongo_simple_command, 4 },
    { ".mongo.drop.database", (DL_FUNC) mongo_drop_database, 2 },
    { ".mongo.drop", (DL_FUNC) mongo_drop, 2 },
    { ".mongo.rename", (DL_FUNC) mongo_rename, 3 },
    { ".mongo.get.databases", (DL_FUNC) mongo_get_databases, 1 },
    { ".mongo.get.database.collections", (DL_FUNC) mongo_get_database_collections, 2 },

    { ".mongo.bson.empty", (DL_FUNC) mongo_bson_empty, 0},
    { ".mongo.bson.size", (DL_FUNC) mongo_bson_size, 1},
    { ".mongo.bson.destroy", (DL_FUNC) mongo_bson_destroy, 1},
    { ".mongo.bson.print", (DL_FUNC) mongo_bson_print, 1},
    { ".mongo.bson.to.list", (DL_FUNC) mongo_bson_to_list, 1},
    { ".mongo.bson.from.list", (DL_FUNC) mongo_bson_from_list, 1},

    { ".mongo.bson.iterator.create", (DL_FUNC) mongo_bson_iterator_create, 1},
    { ".mongo.bson.find", (DL_FUNC) mongo_bson_find, 2},
    { ".mongo.bson.value", (DL_FUNC) mongo_bson_value, 2},
    { ".mongo.bson.iterator.next", (DL_FUNC) mongo_bson_iterator_next, 1},
    { ".mongo.bson.iterator.key", (DL_FUNC) mongo_bson_iterator_key, 1},
    { ".mongo.bson.iterator.type", (DL_FUNC) mongo_bson_iterator_type, 1},
    { ".mongo.bson.iterator.value", (DL_FUNC) mongo_bson_iterator_value, 1},

    { ".mongo.oid.create", (DL_FUNC) mongo_oid_create, 0},
    { ".mongo.oid.time", (DL_FUNC) mongo_oid_time, 1},
    { ".mongo.oid.from.string", (DL_FUNC) mongo_oid_from_string, 1},
    { ".mongo.oid.to.string", (DL_FUNC) mongo_oid_to_string, 1},
    { ".mongo.oid.print", (DL_FUNC) mongo_oid_print, 1},

    { ".mongo.timestamp.create", (DL_FUNC) mongo_timestamp_create, 2},
    { ".mongo.code.create", (DL_FUNC) mongo_code_create, 1},
    { ".mongo.code.w.scope.create", (DL_FUNC) mongo_code_w_scope_create, 2},
    { ".mongo.symbol.create", (DL_FUNC) mongo_symbol_create, 1},
    { ".mongo.undefined.create", (DL_FUNC) mongo_undefined_create, 0},
    { ".mongo.regex.create", (DL_FUNC) mongo_regex_create, 2},

    { ".mongo.bson.buffer.create", (DL_FUNC) mongo_bson_buffer_create, 0},
    { ".mongo.bson.from.buffer", (DL_FUNC) mongo_bson_from_buffer, 1},
    { ".mongo.bson.buffer.append.int", (DL_FUNC) mongo_bson_buffer_append_int, 3},
    { ".mongo.bson.buffer.append.bool", (DL_FUNC) mongo_bson_buffer_append_bool, 3},
    { ".mongo.bson.buffer.append.long", (DL_FUNC) mongo_bson_buffer_append_long, 3},
    { ".mongo.bson.buffer.append.double", (DL_FUNC) mongo_bson_buffer_append_double, 3},
    { ".mongo.bson.buffer.append.complex", (DL_FUNC) mongo_bson_buffer_append_complex, 3},
    { ".mongo.bson.buffer.append.null", (DL_FUNC) mongo_bson_buffer_append_null, 2},
    { ".mongo.bson.buffer.append.undefined", (DL_FUNC) mongo_bson_buffer_append_undefined, 2},
    { ".mongo.bson.buffer.append.string", (DL_FUNC) mongo_bson_buffer_append_string, 3},
    { ".mongo.bson.buffer.append.symbol", (DL_FUNC) mongo_bson_buffer_append_symbol, 3},
    { ".mongo.bson.buffer.append.code", (DL_FUNC) mongo_bson_buffer_append_code, 3},
    { ".mongo.bson.buffer.append.code.w.scope", (DL_FUNC) mongo_bson_buffer_append_code_w_scope, 3},
    { ".mongo.bson.buffer.append.raw", (DL_FUNC) mongo_bson_buffer_append_raw, 4},
    { ".mongo.bson.buffer.append.time", (DL_FUNC) mongo_bson_buffer_append_time, 3},
    { ".mongo.bson.buffer.append.timestamp", (DL_FUNC) mongo_bson_buffer_append_timestamp, 3},
    { ".mongo.bson.buffer.append.regex", (DL_FUNC) mongo_bson_buffer_append_symbol, 3},
    { ".mongo.bson.buffer.append.oid", (DL_FUNC) mongo_bson_buffer_append_oid, 3},
    { ".mongo.bson.buffer.append.bson", (DL_FUNC) mongo_bson_buffer_append_bson, 3},
    { ".mongo.bson.buffer.append.element", (DL_FUNC) mongo_bson_buffer_append_element, 3},
    { ".mongo.bson.buffer.append", (DL_FUNC) mongo_bson_buffer_append, 3},
    { ".mongo.bson.buffer.append.list", (DL_FUNC) mongo_bson_buffer_append_list, 3},
    { ".mongo.bson.buffer.append.object", (DL_FUNC) mongo_bson_buffer_append_object, 3},
    { ".mongo.bson.buffer.start.object", (DL_FUNC) mongo_bson_buffer_start_object, 2},
    { ".mongo.bson.buffer.start.array", (DL_FUNC) mongo_bson_buffer_start_array, 2},
    { ".mongo.bson.buffer.finish.object", (DL_FUNC) mongo_bson_buffer_finish_object, 1},
    { ".mongo.bson.buffer.size", (DL_FUNC) mongo_bson_buffer_size, 1},

    { ".mongo.gridfs.create", (DL_FUNC) mongo_gridfs_create, 3},
    { ".mongo.gridfs.destroy", (DL_FUNC) mongo_gridfs_destroy, 1},
    { ".mongo.gridfs.store.file", (DL_FUNC) mongo_gridfs_store_file, 4},
    { ".mongo.gridfs.store", (DL_FUNC) mongo_gridfs_store, 4},
    { ".mongo.gridfs.remove.file", (DL_FUNC) mongo_gridfs_remove_file, 2},
    { ".mongo.gridfs.find", (DL_FUNC) mongo_gridfs_find, 2},
    { ".mongo.gridfile.destroy", (DL_FUNC) mongo_gridfile_destroy, 1},
    { ".mongo.gridfile.get.descriptor", (DL_FUNC) mongo_gridfile_get_descriptor, 1},
    { ".mongo.gridfile.get.filename", (DL_FUNC) mongo_gridfile_get_filename, 1},
    { ".mongo.gridfile.get.length", (DL_FUNC) mongo_gridfile_get_length, 1},
    { ".mongo.gridfile.get.chunk.size", (DL_FUNC) mongo_gridfile_get_chunk_size, 1},
    { ".mongo.gridfile.get.chunk.count", (DL_FUNC) mongo_gridfile_get_chunk_count, 1},
    { ".mongo.gridfile.get.content.type", (DL_FUNC) mongo_gridfile_get_content_type, 1},
    { ".mongo.gridfile.get.upload.date", (DL_FUNC) mongo_gridfile_get_upload_date, 1},
    { ".mongo.gridfile.get.md5", (DL_FUNC) mongo_gridfile_get_md5, 1},
    { ".mongo.gridfile.get.metadata", (DL_FUNC) mongo_gridfile_get_metadata, 1},
    { ".mongo.gridfile.get.chunk", (DL_FUNC) mongo_gridfile_get_chunk, 2},
    { ".mongo.gridfile.get.chunks", (DL_FUNC) mongo_gridfile_get_chunks, 3},
    { ".mongo.gridfile.read", (DL_FUNC) mongo_gridfile_read, 2},
    { ".mongo.gridfile.seek", (DL_FUNC) mongo_gridfile_seek, 2},
    { ".mongo.gridfile.writer.create", (DL_FUNC) mongo_gridfile_writer_create, 3},
    { ".mongo.gridfile.writer.write", (DL_FUNC) mongo_gridfile_writer_write, 2},
    { ".mongo.gridfile.writer.finish", (DL_FUNC) mongo_gridfile_writer_finish, 1},

    { NULL, NULL, 0 }
};


static void* _malloc(size_t size) {
    return (void*)Calloc(size, char);
}


static void* _realloc(void* p, size_t size) {
    return (void*)Realloc(p, size, char);
}


static void _free(void* p) {
    Free(p);
}

static void _err_handler(const char* errmsg) {
    error(errmsg);
}


void attribute_visible R_init_rmongodb(DllInfo *dll) {
    R_registerRoutines(dll, NULL, callMethods, NULL, NULL);

    mongo_env_sock_init();
    install_mongo_symbols();
    bson_malloc_func = _malloc;
    bson_realloc_func = _realloc;
    bson_free_func = _free;
    bson_printf = (bson_printf_func)Rprintf;
    bson_errprintf = (bson_printf_func)REprintf;
    set_bson_err_handler(_err_handler);

    Rprintf("rmongodb package (mongo-r-driver) loaded\n"
            "Use 'help(\"mongo\")' to get started.\n\n");
}