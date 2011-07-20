#include <R.h>
#include "api_bson.h"
#include "bson.h"
#include "symbols.h"

#include <stdlib.h>

static void bsonFinalizer(SEXP ptr)
{
    if (!R_ExternalPtrAddr(ptr)) return;
	bson* b = (bson*)R_ExternalPtrAddr(ptr);
    bson_destroy(b);
	Free(b);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP mongo_bson_empty()
{
	SEXP ret, ptr, cls;
	PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
	bson* obj = Calloc(1, bson);
	bson_empty(obj);
    ptr = R_MakeExternalPtr(obj, sym_mongo_bson, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, bsonFinalizer, TRUE);
    setAttrib(ret, sym_mongo_bson, ptr);
	PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.bson"));
    classgets(ret, cls);
    UNPROTECT(3);
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
	SEXP ret, ptr, cls;
	PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
	bson* obj = Calloc(1, bson);
	bson* _b = (bson*)R_ExternalPtrAddr(getAttrib(b, sym_mongo_bson));
	bson_copy(obj, _b);
    ptr = R_MakeExternalPtr(obj, sym_mongo_bson, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, bsonFinalizer, TRUE);
    setAttrib(ret, sym_mongo_bson, ptr);
	PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.bson"));
    classgets(ret, cls);
    UNPROTECT(3);
    return ret;
}


static void bson_bufferFinalizer(SEXP ptr)
{
    if (!R_ExternalPtrAddr(ptr)) return;
	bson_buffer* b = (bson_buffer*)R_ExternalPtrAddr(ptr);
    bson_buffer_destroy(b);
	Free(b);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP mongo_bson_buffer_create()
{
	SEXP ret, ptr;
	PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
	bson_buffer* buf = Calloc(1, bson_buffer);
	bson_buffer_init(buf);
    ptr = R_MakeExternalPtr(buf, sym_mongo_bson_buffer, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, bson_bufferFinalizer, TRUE);
    setAttrib(ret, sym_mongo_bson_buffer, ptr);
    UNPROTECT(2);
    return ret;
}


SEXP mongo_bson_from_buffer(SEXP buf)
{
	SEXP ret, ptr, cls;
	PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
	bson* obj = Calloc(1, bson);
    ptr = R_MakeExternalPtr(obj, sym_mongo_bson, R_NilValue);
    PROTECT(ptr);
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	bson_from_buffer(obj, _buf);
    R_RegisterCFinalizerEx(ptr, bsonFinalizer, TRUE);
    setAttrib(ret, sym_mongo_bson, ptr);

	PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.bson"));
    classgets(ret, cls);
    UNPROTECT(3);
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

SEXP mongo_bson_print(SEXP b)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson* _b = (bson*)R_ExternalPtrAddr(getAttrib(b, sym_mongo_bson));
	bson_print(_b);
    INTEGER(ret)[0] = 0;
    UNPROTECT(1);
    return ret;
}


static void bsonIteratorFinalizer(SEXP ptr)
{
    if (!R_ExternalPtrAddr(ptr)) return;
	bson* b = (bson*)R_ExternalPtrAddr(ptr);
	Free(b);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP mongo_bson_iterator_create(SEXP b)
{
	SEXP ret, ptr;
	PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
	bson_iterator* iter = Calloc(1, bson_iterator);
    ptr = R_MakeExternalPtr(iter, sym_mongo_bson_iterator, R_NilValue);
    PROTECT(ptr);
	bson* _b = (bson*)R_ExternalPtrAddr(getAttrib(b, sym_mongo_bson));
	bson_iterator_init(iter, _b->data);
    R_RegisterCFinalizerEx(ptr, bsonIteratorFinalizer, TRUE);
    setAttrib(ret, sym_mongo_bson_iterator, ptr);
    UNPROTECT(2);
	return ret;
}


SEXP mongo_bson_find(SEXP b, SEXP name, SEXP iter)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson* _b = (bson*)R_ExternalPtrAddr(getAttrib(b, sym_mongo_bson));
	const char* _name = CHAR(STRING_ELT(name, 0));
	bson_iterator* _iter = (bson_iterator*)R_ExternalPtrAddr(getAttrib(iter, sym_mongo_bson_iterator));
    INTEGER(ret)[0] = bson_find(_iter, _b, _name);
    UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_iterator_more(SEXP iter)
{
	SEXP ret;
	PROTECT(ret = allocVector(LGLSXP, 1));
	bson_iterator* _iter = (bson_iterator*)R_ExternalPtrAddr(getAttrib(iter, sym_mongo_bson_iterator));
	LOGICAL(ret)[0] = bson_iterator_more(_iter) != 0 ? TRUE : FALSE;
	UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_iterator_next(SEXP iter)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_iterator* _iter = (bson_iterator*)R_ExternalPtrAddr(getAttrib(iter, sym_mongo_bson_iterator));
    INTEGER(ret)[0] = bson_iterator_next(_iter);
    UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_iterator_key(SEXP iter)
{
	SEXP ret;
	PROTECT(ret = allocVector(STRSXP, 1));
	bson_iterator* _iter = (bson_iterator*)R_ExternalPtrAddr(getAttrib(iter, sym_mongo_bson_iterator));
    SET_STRING_ELT(ret, 0, mkChar(bson_iterator_key(_iter)));
    UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_iterator_type(SEXP iter)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_iterator* _iter = (bson_iterator*)R_ExternalPtrAddr(getAttrib(iter, sym_mongo_bson_iterator));
    INTEGER(ret)[0] = bson_iterator_type(_iter);
    UNPROTECT(1);
	return ret;
}


SEXP createPOSIXct(int t)
{
	SEXP ret, cls;
	PROTECT(ret = allocVector(INTSXP, 1));
	INTEGER(ret)[0] = t;
	PROTECT(cls = allocVector(STRSXP, 2));
    SET_STRING_ELT(cls, 0, mkChar("POSIXct"));
    SET_STRING_ELT(cls, 1, mkChar("POSIXt"));
    classgets(ret, cls);
	return ret;
}


SEXP _mongo_timestamp_create(int t, int i)
{
	SEXP ret, cls, inc;
	PROTECT(ret = allocVector(REALSXP, 1));
	REAL(ret)[0] = t;
	PROTECT(inc = allocVector(INTSXP, 1));
	INTEGER(inc)[0] = i;
    setAttrib(ret, sym_increment, inc);
	PROTECT(cls = allocVector(STRSXP, 3));
	SET_STRING_ELT(cls, 0, mkChar("POSIXct"));
	SET_STRING_ELT(cls, 1, mkChar("POSIXt"));
	SET_STRING_ELT(cls, 2, mkChar("mongo.timestamp"));
	classgets(ret, cls);
	return ret;
}


SEXP mongo_timestamp_create(SEXP t, SEXP i)
{
	SEXP ret = _mongo_timestamp_create(asInteger(t), asInteger(i));
	UNPROTECT(3);
	return ret;
}


static void bson_OIDfinalizer(SEXP ptr)
{
    if (!R_ExternalPtrAddr(ptr)) return;
	bson_oid_t* oid = (bson_oid_t*)R_ExternalPtrAddr(ptr);
	Free(oid);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP _mongo_oid_create(bson_oid_t* oid)
{
	SEXP ret, ptr, cls;
	PROTECT(ret = allocVector(INTSXP, 1));
    ptr = R_MakeExternalPtr(oid, sym_mongo_oid, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, bson_OIDfinalizer, TRUE);
    setAttrib(ret, sym_mongo_oid, ptr);
	PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.oid"));
    classgets(ret, cls);
	return ret;
}

SEXP mongo_oid_from_string(SEXP s)
{
	const char* _s = CHAR(STRING_ELT(s, 0));
	if (strlen(_s) != 24)
		error("OID string length muct be 24");
	bson_oid_t* oid = Calloc(1, bson_oid_t);
	bson_oid_from_string(oid, _s);
	SEXP ret = _mongo_oid_create(oid);
	UNPROTECT(3);
	return ret;
}


SEXP mongo_string_from_oid(SEXP oid)
{
	SEXP ret;
	PROTECT(ret = allocVector(STRSXP, 1));
	bson_oid_t* _oid = (bson_oid_t*)R_ExternalPtrAddr(getAttrib(oid, sym_mongo_oid));
	char s[25];
	bson_oid_to_string(_oid, s);
    SET_STRING_ELT(ret, 0, mkChar(s));
    UNPROTECT(1);
	return ret;
}


SEXP mongo_oid_print(SEXP oid)
{
	bson_oid_t* _oid = (bson_oid_t*)R_ExternalPtrAddr(getAttrib(oid, sym_mongo_oid));
	char s[25];
	bson_oid_to_string(_oid, s);
	Rprintf("{ $oid : \"%s\" }\n");
	return oid;
}


SEXP mongo_bson_iterator_value(SEXP iter)
{
	SEXP ret, cls;
	bson_iterator* _iter = (bson_iterator*)R_ExternalPtrAddr(getAttrib(iter, sym_mongo_bson_iterator));
	bson_type t = bson_iterator_type(_iter);
	switch (t) {
		case BSON_INT:
			PROTECT(ret = allocVector(INTSXP, 1));
			INTEGER(ret)[0] = bson_iterator_int(_iter);
			break;

		case BSON_DOUBLE:
			PROTECT(ret = allocVector(REALSXP, 1));
			REAL(ret)[0] = bson_iterator_double(_iter);
			break;

		case BSON_LONG:
			PROTECT(ret = allocVector(REALSXP, 1));
			REAL(ret)[0] = bson_iterator_long(_iter);
			break;

		case BSON_BOOL:
			PROTECT(ret = allocVector(LGLSXP, 1));
			LOGICAL(ret)[0] = bson_iterator_bool(_iter);
			break;

		case BSON_STRING:
			PROTECT(ret = allocVector(STRSXP, 1));
			SET_STRING_ELT(ret, 0, mkChar(bson_iterator_string(_iter)));
			break;

		case BSON_NULL:
			return R_NilValue;

		case BSON_OID: {
			bson_oid_t* oid = Calloc(1, bson_oid_t);
			memcpy(oid, bson_iterator_oid(_iter), sizeof(bson_oid_t));
			SEXP ret = _mongo_oid_create(oid);
			UNPROTECT(3);
			return ret;
		}

		case BSON_DATE:
			ret = createPOSIXct(bson_iterator_date(_iter));
			UNPROTECT(2);
			return ret;

		case BSON_TIMESTAMP: {
			bson_timestamp_t ts = bson_iterator_timestamp(_iter);
			ret = _mongo_timestamp_create(ts.t, ts.i);
			UNPROTECT(3);
			return ret;
		}

		case 0:
			PROTECT(ret = allocVector(INTSXP, 1));
			INTEGER(ret)[0] = 0;
			break;

		default:
			error("Unhandled BSON type %d\n", t);
			ret = 0;  // uninitialized ret avoid warning
	}
	UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_buffer_append_int(SEXP buf, SEXP name, SEXP value)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	const char* _name = CHAR(STRING_ELT(name, 0));
	int _value = asInteger(value);
    INTEGER(ret)[0] = bson_append_int(_buf, _name, _value);
    UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_buffer_append_bool(SEXP buf, SEXP name, SEXP value)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	const char* _name = CHAR(STRING_ELT(name, 0));
	int _value = asLogical(value);
    INTEGER(ret)[0] = bson_append_bool(_buf, _name, _value);
    UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_buffer_append_double(SEXP buf, SEXP name, SEXP value)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	const char* _name = CHAR(STRING_ELT(name, 0));
	double _value = asReal(value);
    INTEGER(ret)[0] = bson_append_double(_buf, _name, _value);
    UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_buffer_append_long(SEXP buf, SEXP name, SEXP value)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	const char* _name = CHAR(STRING_ELT(name, 0));
	double _value = asReal(value);
    INTEGER(ret)[0] = bson_append_long(_buf, _name, _value);
    UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_buffer_append_null(SEXP buf, SEXP name)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	const char* _name = CHAR(STRING_ELT(name, 0));
    INTEGER(ret)[0] = bson_append_null(_buf, _name);
    UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_buffer_append_oid(SEXP buf, SEXP name, SEXP value)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	bson_oid_t* _value = (bson_oid_t*)R_ExternalPtrAddr(getAttrib(value, sym_mongo_oid));
	const char* _name = CHAR(STRING_ELT(name, 0));
    INTEGER(ret)[0] = bson_append_oid(_buf, _name, _value);
    UNPROTECT(1);
	return ret;
}

SEXP mongo_bson_buffer_append_time(SEXP buf, SEXP name, SEXP value)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	const char* _name = CHAR(STRING_ELT(name, 0));
	time_t _value = asInteger(value);
    INTEGER(ret)[0] = bson_append_date(_buf, _name, _value);
    UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_buffer_append_timestamp(SEXP buf, SEXP name, SEXP value)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	const char* _name = CHAR(STRING_ELT(name, 0));
	bson_timestamp_t ts;
	ts.t = asInteger(value);
	ts.i = asInteger(getAttrib(value, sym_increment));
    INTEGER(ret)[0] = bson_append_timestamp(_buf, _name, &ts);
    UNPROTECT(1);
	return ret;
}


SEXP mongo_bson_buffer_append_string(SEXP buf, SEXP name, SEXP value)
{
	SEXP ret;
	PROTECT(ret = allocVector(INTSXP, 1));
	bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(getAttrib(buf, sym_mongo_bson_buffer));
	const char* _name = CHAR(STRING_ELT(name, 0));
	const char* _value = CHAR(STRING_ELT(value,0));
    INTEGER(ret)[0] = bson_append_string(_buf, _name, _value);
    UNPROTECT(1);
	return ret;
}


SEXP mongo_sys_time() {
	time_t t;
	time(&t);
	SEXP ret = createPOSIXct(t);
	UNPROTECT(2);
	return ret;
}