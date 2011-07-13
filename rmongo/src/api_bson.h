#include <Rinternals.h>

SEXP mongo_bson_empty();
SEXP mongo_bson_clear(SEXP b);
SEXP mongo_bson_copy(SEXP b);
SEXP mongo_bson_size(SEXP b);
SEXP mongo_bson_buffer_create();
SEXP mongo_bson_from_buffer(SEXP buf);
SEXP mongo_bson_buffer_append_int(SEXP buf, SEXP name, SEXP value);
SEXP mongo_bson_buffer_append_string(SEXP buf, SEXP name, SEXP value);