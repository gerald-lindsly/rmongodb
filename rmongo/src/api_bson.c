#include "api_bson.h"
#include "bson.h"
#include "symbols.h"

#include <stdlib.h>

static void bsonFinalizer(SEXP ptr)
{
    if (!R_ExternalPtrAddr(ptr)) return;
	bson* b = (bson*)R_ExternalPtrAddr(ptr);
    bson_destroy(b);
	free(b);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP mongo_bson_empty()
{
	SEXP ret, ptr;
	PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
	bson* obj = (bson*)bson_malloc(sizeof(bson));
	bson_empty(obj);
    ptr = R_MakeExternalPtr(obj, sym_mongo_bson, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, bsonFinalizer, TRUE);
    setAttrib(ret, sym_mongo_bson, ptr);
    UNPROTECT(2);
    return ret;
}


SEXP mongo_bson_clear(SEXP b)
{
	bson* _b = (bson*)R_ExternalPtrAddr(getAttrib(b, sym_mongo_bson));
	bson_destroy(_b);
	bson_empty(_b);
	return b;
}


SEXP mongo_bson_copy(SEXP b)
{
	SEXP ret, ptr;
	PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
	bson* obj = (bson*)bson_malloc(sizeof(bson));
	bson* _b = (bson*)R_ExternalPtrAddr(getAttrib(b, sym_mongo_bson));
	bson_copy(obj, _b);
    ptr = R_MakeExternalPtr(obj, sym_mongo_bson, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, bsonFinalizer, TRUE);
    setAttrib(ret, sym_mongo_bson, ptr);
    UNPROTECT(2);
    return ret;
}


static void bson_bufferFinalizer(SEXP ptr)
{
    if (!R_ExternalPtrAddr(ptr)) return;
	bson_buffer* b = (bson_buffer*)R_ExternalPtrAddr(ptr);
    bson_buffer_destroy(b);
	free(b);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP mongo_bson_buffer_create()
{
	printf("buffer create\n");
	SEXP ret, ptr;
	PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
	bson_buffer* buf = (bson_buffer*)bson_malloc(sizeof(bson_buffer));
	printf("1");
	bson_buffer_init(buf);
	printf("2");
    ptr = R_MakeExternalPtr(buf, sym_mongo_bson_buffer, R_NilValue);
    PROTECT(ptr);
	printf("3");
    R_RegisterCFinalizerEx(ptr, bson_bufferFinalizer, TRUE);
	printf("4");
    setAttrib(ret, sym_mongo_bson_buffer, ptr);
    UNPROTECT(2);
	printf("x");
    return ret;
}


SEXP mongo_bson_from_buffer(SEXP buf)
{
	printf("from buffer\n");
	SEXP ret, ptr;
	PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
	bson* obj = (bson*)bson_malloc(sizeof(bson));
    ptr = R_MakeExternalPtr(obj, sym_mongo_bson, R_NilValue);
    PROTECT(ptr);
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	bson_from_buffer(obj, _buf);
    R_RegisterCFinalizerEx(ptr, bsonFinalizer, TRUE);
    setAttrib(ret, sym_mongo_bson, ptr);
    UNPROTECT(2);
    return ret;
}


SEXP mongo_bson_size(SEXP b)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson* _b = (bson*)R_ExternalPtrAddr(getAttrib(b, sym_mongo_bson));
    INTEGER(ret)[0] = bson_size(_b);
    UNPROTECT(1);
    return ret;

}

SEXP mongo_bson_buffer_append_int(SEXP buf, SEXP name, SEXP value)
{
	printf("append int\n");
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	const char* _name = CHAR(STRING_ELT(name, 0));
	int _value = INTEGER(value)[0];
    INTEGER(ret)[0] = bson_append_int(_buf, _name, _value);
    UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_buffer_append_string(SEXP buf, SEXP name, SEXP value)
{
	printf("append string\n");
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	const char* _name = CHAR(STRING_ELT(name, 0));
	const char* _value = CHAR(STRING_ELT(value,0));
    INTEGER(ret)[0] = bson_append_string(_buf, _name, _value);
    UNPROTECT(1);
	return ret;
}


