#include <Rinternals.h>

#include "bson.h"

SEXP mongo_sys_time();

SEXP mongo_bson_empty();
SEXP mongo_bson_clear(SEXP b);
SEXP mongo_bson_copy(SEXP b);
SEXP mongo_bson_size(SEXP b);
SEXP mongo_bson_print(SEXP b);

SEXP mongo_bson_iterator_create(SEXP b);
SEXP mongo_bson_find(SEXP b, SEXP name, SEXP iter);
SEXP mongo_bson_iterator_more(SEXP b);
SEXP mongo_bson_iterator_next(SEXP b);
SEXP mongo_bson_iterator_key(SEXP b);
SEXP mongo_bson_iterator_type(SEXP b);
SEXP mongo_bson_iterator_value(SEXP iter);
SEXP mongo_bson_to_list(SEXP b);

SEXP mongo_timestamp_create(SEXP t, SEXP i);
SEXP mongo_code_create(SEXP code);
SEXP mongo_code_w_scope_create(SEXP code, SEXP scope);
SEXP mongo_symbol_create(SEXP code);
SEXP mongo_undefined_create();
SEXP mongo_regex_create(SEXP pattern, SEXP options);
SEXP mongo_binary_create(SEXP type, SEXP length);
SEXP mongo_binary_set(SEXP bin, SEXP index, SEXP value);
SEXP mongo_binary_get(SEXP bin, SEXP index);

SEXP mongo_oid_from_string(SEXP s);
SEXP mongo_string_from_oid(SEXP oid);
SEXP mongo_oid_create();
SEXP mongo_oid_time(SEXP oid);
SEXP mongo_oid_print(SEXP oid);

SEXP mongo_bson_buffer_create();
SEXP mongo_bson_from_buffer(SEXP buf);
SEXP mongo_bson_buffer_append_null(SEXP buf, SEXP name);
SEXP mongo_bson_buffer_append_int(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_bool(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_long(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_double(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_complex(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_string(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_code(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_code_w_scope(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_symbol(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_regex(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_binary(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_undefined(SEXP buf, SEXP name);
SEXP mongo_bson_buffer_append_time(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_timestamp(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_oid(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_bson(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_element(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_list(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_start_array(SEXP buf, SEXP name);
SEXP mongo_bson_buffer_start_object(SEXP buf, SEXP name);
SEXP mongo_bson_buffer_finish_object(SEXP buf);

SEXP _mongo_bson_create(bson* b);
