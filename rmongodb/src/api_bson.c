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
#include "api_bson.h"
#include "symbols.h"
#include "utility.h"

#include <stdlib.h>

#define MAXDIM 20

typedef bson bson_buffer;

SEXP mongo_bson_destroy(SEXP b) {
    bson* _b = _checkBSON(b);
    bson_destroy(_b);
    SEXP ptr = getAttrib(b, sym_mongo_bson);
    R_ClearExternalPtr(ptr);
    return R_NilValue;
}

bson_buffer* _checkBuffer(SEXP buf) {
    _checkClass(buf, "mongo.bson.buffer");
    SEXP ptr = getAttrib(buf, sym_mongo_bson_buffer);
    if (ptr == R_NilValue)
        error("Expected a \"mongo.bson.buffer\" attribute in object\n");
    bson_buffer* _buf = (bson_buffer*)R_ExternalPtrAddr(ptr);
    if (!_buf)
        error("mongo.bson.buffer object seems to have been destroyed or converted to a mongo.bson object.\n");
    return _buf;
}


bson_iterator* _checkIterator(SEXP iter) {
    _checkClass(iter, "mongo.bson.iterator");
    SEXP ptr = getAttrib(iter, sym_mongo_bson_iterator);
    if (ptr == R_NilValue)
        error("Expected a \"mongo.bson.iterator\" attribute in object\n");
    bson_iterator* _iter = (bson_iterator*)R_ExternalPtrAddr(ptr);
    if (!_iter)
        error("mongo.bson.iterator object appears to have been destroyed.\n");
    return _iter;
}


void _checkOID(SEXP oid) {
    _checkClass(oid, "mongo.oid");
}


const char* numstr(int i) {
    extern const char bson_numstrs[1000][4];
    if (i < 1000)
        return bson_numstrs[i];
    else {
        static char s[20];
        sprintf(s, "%d", i);
        return s;
    }
}


SEXP _mongo_code_create(const char* code) {
    SEXP ret, cls;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar(code));
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.code"));
    classgets(ret, cls);
    UNPROTECT(2);
    return ret;
}


SEXP mongo_code_create(SEXP code) {
    const char* _code = CHAR(STRING_ELT(code, 0));
    return _mongo_code_create(_code);
}


SEXP _mongo_code_w_scope_create(const char* code, bson* b) {
    SEXP ret, cls, _b;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar(code));
    PROTECT(cls = allocVector(STRSXP, 2));
    SET_STRING_ELT(cls, 0, mkChar("mongo.code.w.scope"));
    SET_STRING_ELT(cls, 1, mkChar("mongo.code"));
    classgets(ret, cls);
    _b = _mongo_bson_create(b);
    setAttrib(ret, sym_scope, _b);
    UNPROTECT(5);
    return ret;
}


SEXP mongo_code_w_scope_create(SEXP code, SEXP b) {
    bson* _b = _checkBSON(b);
    return _mongo_code_w_scope_create(CHAR(STRING_ELT(code, 0)), _b);
}


SEXP _mongo_regex_create(const char* pattern, const char* options) {
    SEXP ret, cls;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar(pattern));
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.regex"));
    classgets(ret, cls);
    SEXP opts;
    PROTECT(opts = allocVector(STRSXP, 1));
    SET_STRING_ELT(opts, 0, mkChar(options));
    setAttrib(ret, sym_options, opts);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_regex_create(SEXP pattern, SEXP options) {
    return _mongo_regex_create(CHAR(STRING_ELT(pattern, 0)), CHAR(STRING_ELT(options, 0)));
}


SEXP _raw_create(char type, const char* data, int len) {
    SEXP ret;
    PROTECT(ret = allocVector(RAWSXP, len));
    if (data) memcpy(RAW(ret), data, len);
    if (type) {
        SEXP _subtype;
        PROTECT(_subtype = allocVector(INTSXP, 1));
        INTEGER(_subtype)[0] = type;
        setAttrib(ret, sym_subtype, _subtype);
        UNPROTECT(1);
    }
    UNPROTECT(1);
    return ret;
}


SEXP _mongo_symbol_create(const char* symbol) {
    SEXP ret, cls;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar(symbol));
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.symbol"));
    classgets(ret, cls);
    UNPROTECT(2);
    return ret;
}


SEXP mongo_symbol_create(SEXP symbol) {
    const char* _symbol = CHAR(STRING_ELT(symbol, 0));
    return _mongo_symbol_create(_symbol);
}


SEXP mongo_undefined_create() {
    SEXP ret, cls;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar("UNDEFINED"));
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.undefined"));
    classgets(ret, cls);
    UNPROTECT(2);
    return ret;
}


SEXP mongo_bson_empty() {
    bson b;
    bson_empty(&b);
    SEXP ret = _mongo_bson_create(&b);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_bson_clear(SEXP b) {
    bson* _b = _checkBSON(b);
    bson_destroy(_b);
    bson_empty(_b);
    return b;
}


SEXP mongo_bson_copy(SEXP b) {
    bson* _b = _checkBSON(b);
    SEXP ret =_mongo_bson_create(_b);
    UNPROTECT(3);
    return ret;
}


static void bson_bufferFinalizer(SEXP ptr) {
    if (!R_ExternalPtrAddr(ptr)) return;
    bson_buffer* b = (bson_buffer*)R_ExternalPtrAddr(ptr);
    bson_destroy(b);
    Free(b);
    R_ClearExternalPtr(ptr);
}


SEXP _mongo_bson_buffer_create() {
    SEXP ret, ptr, cls;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
    bson_buffer* buf = Calloc(1, bson_buffer);
    bson_init(buf);
    ptr = R_MakeExternalPtr(buf, sym_mongo_bson_buffer, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, bson_bufferFinalizer, TRUE);
    setAttrib(ret, sym_mongo_bson_buffer, ptr);
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.bson.buffer"));
    classgets(ret, cls);
    return ret;
}


SEXP mongo_bson_buffer_create() {
    SEXP ret = _mongo_bson_buffer_create();
    UNPROTECT(3);
    return ret;
}


static void bson_OIDfinalizer(SEXP ptr) {
    if (!R_ExternalPtrAddr(ptr)) return;
    bson_oid_t* oid = (bson_oid_t*)R_ExternalPtrAddr(ptr);
    Free(oid);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP _mongo_oid_create(bson_oid_t* oid) {
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


SEXP mongo_oid_create() {
    bson_oid_t* oid = Calloc(1, bson_oid_t);
    bson_oid_gen(oid);
    SEXP ret = _mongo_oid_create(oid);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_bson_from_buffer(SEXP buf) {
    bson_buffer* _buf = _checkBuffer(buf);
    bson_finish(_buf);
    SEXP ret = _mongo_bson_create(_buf);
    SEXP ptr = getAttrib(buf, sym_mongo_bson_buffer);
    bson_bufferFinalizer(ptr);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_bson_size(SEXP b) {
    bson* _b = _checkBSON(b);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = bson_size(_b);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_print(SEXP b) {
    bson* _b = _checkBSON(b);
    bson_print(_b);
    return b;
}


static void bsonIteratorFinalizer(SEXP ptr) {
    if (!R_ExternalPtrAddr(ptr)) return;
    bson_iterator* iter = (bson_iterator*)R_ExternalPtrAddr(ptr);
    Free(iter);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP _mongo_bson_iterator_create(bson_iterator* iter) {
    SEXP ret, ptr, cls;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
    bson_iterator* _iter = Calloc(1, bson_iterator);
    memcpy(_iter, iter, sizeof(bson_iterator));
    PROTECT(ptr = R_MakeExternalPtr(_iter, sym_mongo_bson_iterator, R_NilValue));
    R_RegisterCFinalizerEx(ptr, bsonIteratorFinalizer, TRUE);
    setAttrib(ret, sym_mongo_bson_iterator, ptr);
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.bson.iterator"));
    classgets(ret, cls);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_bson_iterator_create(SEXP b) {
    bson_iterator iter;
    if (_objHasClass(b, "mongo.bson.iterator")) {
        SEXP ptr = getAttrib(b, sym_mongo_bson_iterator);
        if (ptr == R_NilValue)
            error("Expected a \"mongo.bson.iterator\" attribute in object\n");
        bson_iterator* _iter = (bson_iterator*)R_ExternalPtrAddr(ptr);
        bson_type t = bson_iterator_type(_iter);
        if (t == BSON_ARRAY || t == BSON_OBJECT)
            bson_iterator_subiterator(_iter, &iter);
        else
            error("Iterator is expected to point to an array or subobject");
    }
    else {
        bson* _b = _checkBSON(b);
        bson_iterator_init(&iter, _b);
    }
    return _mongo_bson_iterator_create(&iter);
}


int _mongo_bson_find(SEXP b, SEXP name, bson_iterator* iter) {
    bson* _b = _checkBSON(b);
    const char* _name = CHAR(STRING_ELT(name, 0));
    bson sub;
    const char* next = _name;
    do {
        if (bson_find(iter, _b, next) != BSON_EOO)
            return 1;
        char* p = strchr((char*)next, '.');
        if (!p)
            return 0;
        char prefix[2048];
        int len = p - next;
        strncpy(prefix, next, len);
        prefix[len] = '\0';
        int t;
        if ((t = bson_find(iter, _b, prefix)) == BSON_EOO)
            return 0;
        if (t == BSON_ARRAY || t == BSON_OBJECT) {
            bson_iterator_subobject(iter, &sub);
            _b = &sub;
            next = p + 1;
        }
        else
            return 0;
    }
    while (1);
    /* never gets here */
    return 0;
}


SEXP mongo_bson_find(SEXP b, SEXP name) {
    bson_iterator iter;
    if (_mongo_bson_find(b, name, &iter))
        return _mongo_bson_iterator_create(&iter);
    else
        return R_NilValue;
}


SEXP _mongo_timestamp_create(int t, int i) {
    SEXP ret, cls, inc;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = t;
    PROTECT(inc = allocVector(INTSXP, 1));
    INTEGER(inc)[0] = i;
    setAttrib(ret, sym_increment, inc);
    PROTECT(cls = allocVector(STRSXP, 3));
    SET_STRING_ELT(cls, 0, mkChar("mongo.timestamp"));
    SET_STRING_ELT(cls, 1, mkChar("POSIXct"));
    SET_STRING_ELT(cls, 2, mkChar("POSIXt"));
    classgets(ret, cls);
    return ret;
}


SEXP _getTime(SEXP value) {
    if (_objHasClass(value, "POSIXlt")) {
        SEXP s, t;
        PROTECT(t = s = allocList(2));
        SET_TYPEOF(s, LANGSXP);
        SETCAR(t, sym_as_POSIXct);
        t = CDR(t);
        SETCAR(t,  value);
        value = eval(s, R_GlobalEnv);
        UNPROTECT(1);
    }
    return value;
}


SEXP mongo_timestamp_create(SEXP t, SEXP i) {
    SEXP ret = _mongo_timestamp_create(asInteger(_getTime(t)), asInteger(i));
    UNPROTECT(3);
    return ret;
}


int _iterator_getComplex(bson_iterator* iter, Rcomplex* z) {
    if (bson_iterator_type(iter) != BSON_OBJECT)
        return 0;
    bson_iterator sub;
    bson_iterator_subiterator(iter, &sub);
    if (bson_iterator_next(&sub) != BSON_DOUBLE || strcmp(bson_iterator_key(&sub), "r") != 0)
        return 0;
    z->r = bson_iterator_double(&sub);
    if (bson_iterator_next(&sub) != BSON_DOUBLE || strcmp(bson_iterator_key(&sub), "i") != 0)
        return 0;
    z->i = bson_iterator_double(&sub);
    if (bson_iterator_next(&sub) != BSON_EOO)
        return 0;
    return 1;
}


SEXP _array_to_object(bson_iterator* iter) {
    bson_type sub_type;
    bson_type common_type;
    Rcomplex z;
    bson_iterator sub[MAXDIM+1];
    int dim[MAXDIM+1];
    memset(dim, 0, sizeof(dim));
    int bin_type = 0;

    sub[0] = *iter;
    int dims = 0;
    do {
        bson_iterator_subiterator(&sub[dims], &sub[dims+1]);
        if (++dims > MAXDIM)
            error("Max dimensions (%d) exceeded. Use an iterator\n");
        sub_type = bson_iterator_next(&sub[dims]);
    }
    while (sub_type == BSON_ARRAY);

    /* get what should be the common type */
    if (sub_type == BSON_LONG)
        sub_type = BSON_DOUBLE;
    switch (common_type = sub_type) {
    case BSON_INT: ;
    case BSON_DOUBLE: ;
    case BSON_STRING: ;
    case BSON_BOOL: ;
    case BSON_DATE:
        break;
    case BSON_BINDATA:
        if (bson_iterator_bin_len(&sub[dims]) == 1) {
            bin_type = bson_iterator_bin_type(&sub[dims]);
            break;
        }
        return R_NilValue;
    case BSON_OBJECT:
        if (_iterator_getComplex(&sub[dims], &z))
            break;
        /* fall thru to default */
    default:
        /* including empty array */
        return R_NilValue;
    }
    /* initial lowest level count */
    int count[MAXDIM+1];
    int i;
    for (i = 0; i <= dims; i++)
        count[i] = 1;
    while ((sub_type = bson_iterator_next(&sub[dims])) != BSON_EOO) {
        if (sub_type == BSON_LONG)
            sub_type = BSON_DOUBLE;
        if (sub_type != common_type)
            return R_NilValue;
        if (sub_type == BSON_OBJECT && !_iterator_getComplex(&sub[dims], &z))
            return R_NilValue;
        if (sub_type == BSON_BINDATA &&
                (bson_iterator_bin_len(&sub[dims]) != 1 ||
                 bson_iterator_bin_type(&sub[dims]) != bin_type))
            return R_NilValue;
        ++count[dims];
    }

    /* step through rest of array -- checking common type and dimensions */
    int depth = dims;
    while (depth >= 1) {
        sub_type = bson_iterator_next(&sub[depth]);
        if (sub_type == BSON_LONG)
            sub_type = BSON_DOUBLE;
        switch (sub_type) {
        case BSON_EOO:
            if (dim[depth] == 0)
                dim[depth] = count[depth];
            else if (dim[depth] != count[depth])
                return R_NilValue;
            depth--;
            break;
        case BSON_ARRAY:
            count[depth]++;
            bson_iterator_subiterator(&sub[depth], &sub[depth+1]);
            if (++depth > dims)
                return R_NilValue;
            count[depth] = 0;
            break;
        case BSON_INT: ;
        case BSON_DOUBLE: ;
        case BSON_STRING: ;
        case BSON_BOOL: ;
        case BSON_DATE: ;
GotEl:  {
                if (depth != dims || sub_type != common_type)
                    return R_NilValue;
                count[depth]++;
                break;
            }
        case BSON_BINDATA:
            if (bson_iterator_bin_len(&sub[depth]) == 1 &&
                    bson_iterator_bin_type(&sub[depth]) == bin_type)
                goto GotEl;
            return R_NilValue;
        case BSON_OBJECT:
            if (_iterator_getComplex(&sub[depth], &z))
                goto GotEl;
            /* fall thru to default */
        default:
            return R_NilValue;
        }
    }

    int len = 1;
    for (depth = 1; depth <= dims; depth++)
        len *= dim[depth];

    SEXP ret;
    switch (common_type) {
    case BSON_INT:     ret = allocVector(INTSXP,  len); break;
    case BSON_DATE: ;
    case BSON_DOUBLE:  ret = allocVector(REALSXP, len); break;
    case BSON_STRING:  ret = allocVector(STRSXP,  len); break;
    case BSON_BOOL:    ret = allocVector(LGLSXP,  len); break;
    case BSON_BINDATA: ret = allocVector(RAWSXP,  len); break;
    case BSON_OBJECT:  ret = allocVector(CPLXSXP, len); break;
    default:
        /* never reaches here */
        ret = R_NilValue;
    }
    PROTECT(ret);

    /* step through array(s) again, pulling out values */
    bson_iterator_subiterator(&sub[0], &sub[1]);
    depth = 1;
    i = 0;
    while (depth >= 1) {
        sub_type = bson_iterator_next(&sub[depth]);
        switch (sub_type) {
        case BSON_EOO:
            depth--;
            break;
        case BSON_ARRAY:
            bson_iterator_subiterator(&sub[depth], &sub[depth+1]);
            ++depth;
            break;
        case BSON_INT:
            INTEGER(ret)[i++] = bson_iterator_int(&sub[depth]);
            break;
        case BSON_DATE:
            REAL(ret)[i++] = (double)bson_iterator_date(&sub[depth]) / 1000;
            break;
        case BSON_DOUBLE:
            REAL(ret)[i++] = bson_iterator_double(&sub[depth]);
            break;
        case BSON_LONG:
            REAL(ret)[i++] = bson_iterator_long(&sub[depth]);
            break;
        case BSON_STRING:
            SET_STRING_ELT(ret, i++, mkChar(bson_iterator_string(&sub[depth])));
            break;
        case BSON_BOOL: ;
            LOGICAL(ret)[i++] = bson_iterator_bool(&sub[depth]);
            break;
        case BSON_BINDATA:
            RAW(ret)[i++] = *bson_iterator_bin_data(&sub[depth]);
            break;
        case BSON_OBJECT:
            _iterator_getComplex(&sub[depth], &COMPLEX(ret)[i++]);
            break;
        default: ;
            /* never reaches here */
        }
    }
    if (common_type == BSON_DATE) {
        SEXP cls;
        PROTECT(cls = allocVector(STRSXP, 2));
        SET_STRING_ELT(cls, 0, mkChar("POSIXct"));
        SET_STRING_ELT(cls, 1, mkChar("POSIXt"));
        classgets(ret, cls);
        UNPROTECT(1);
    }
    SEXP rdims;
    PROTECT(rdims = allocVector(INTSXP, dims));
    memcpy(&INTEGER(rdims)[0], &dim[1], sizeof(int)*dims);
    setAttrib(ret, R_DimSymbol, rdims);
    if (common_type == BSON_BINDATA && bin_type != 0) {
        SEXP _subtype;
        PROTECT(_subtype = allocVector(INTSXP, 1));
        INTEGER(_subtype)[0] = bin_type;
        setAttrib(ret, sym_subtype, _subtype);
        UNPROTECT(1);
    }
    UNPROTECT(2);
    return ret;
}


SEXP _mongo_bson_to_list(bson* b);

SEXP _mongo_bson_value(bson_iterator* _iter) {
    SEXP ret;
    Rcomplex z;
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

    case BSON_CODE:
        return _mongo_code_create(bson_iterator_string(_iter));

    case BSON_CODEWSCOPE: {
        const char* code = bson_iterator_code(_iter);
        bson b;
        bson_iterator_code_scope(_iter, &b);
        return _mongo_code_w_scope_create(code, &b);
    }

    case BSON_SYMBOL:
        return _mongo_symbol_create(bson_iterator_string(_iter));

    case BSON_UNDEFINED:
        return mongo_undefined_create();

    case BSON_REGEX:
        return _mongo_regex_create(bson_iterator_regex(_iter), bson_iterator_regex_opts(_iter));

    case BSON_BINDATA:
        return _raw_create(bson_iterator_bin_type(_iter),
                           bson_iterator_bin_data(_iter),
                           bson_iterator_bin_len(_iter));

    case BSON_NULL:
        return R_NilValue;

    case BSON_OID: {
        bson_oid_t* oid = Calloc(1, bson_oid_t);
        memcpy(oid, bson_iterator_oid(_iter), sizeof(bson_oid_t));
        ret = _mongo_oid_create(oid);
        UNPROTECT(3);
        return ret;
    }

    case BSON_DATE:
        ret = _createPOSIXct((double)bson_iterator_date(_iter) / 1000);
        UNPROTECT(2);
        return ret;

    case BSON_TIMESTAMP: {
        bson_timestamp_t ts = bson_iterator_timestamp(_iter);
        ret = _mongo_timestamp_create(ts.t, ts.i);
        UNPROTECT(3);
        return ret;
    }

    case BSON_ARRAY: {
        ret = _array_to_object(_iter);
        if (ret == R_NilValue)
            goto returnSubObject;
        return ret;
    }

    case BSON_OBJECT:
        if (_iterator_getComplex(_iter, &z)) {
            PROTECT(ret = allocVector(CPLXSXP, 1));
            COMPLEX(ret)[0] = z;
            break;
        }
        /* fall thru to returnSubObject */
returnSubObject: {
            bson b;
            bson_iterator_subobject(_iter, &b);
            return _mongo_bson_to_list(&b);
        }

    case 0:
        PROTECT(ret = allocVector(INTSXP, 1));
        INTEGER(ret)[0] = 0;
        break;

    default:
        error("Unhandled BSON type %d\n", t);
        ret = R_NilValue;  /* uninitialized ret avoid warning */
    }
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_iterator_value(SEXP iter) {
    bson_iterator* _iter = _checkIterator(iter);
    return _mongo_bson_value(_iter);
}


SEXP mongo_bson_value(SEXP b, SEXP name) {
    bson_iterator iter;
    if (!_mongo_bson_find(b, name, &iter))
        return R_NilValue;
    return _mongo_bson_value(&iter);
}


SEXP installAttrib(SEXP vec, SEXP name, SEXP val) {
    SEXP s, t;
    PROTECT(vec);
    PROTECT(name);
    PROTECT(val);
    for (s = ATTRIB(vec); s != R_NilValue; s = CDR(s)) {
        if (TAG(s) == name) {
            SETCAR(s, val);
            UNPROTECT(3);
            return val;
        }
    }
    s = allocList(1);
    SETCAR(s, val);
    SET_TAG(s, name);
    if (ATTRIB(vec) == R_NilValue)
        SET_ATTRIB(vec, s);
    else {
        t = nthcdr(ATTRIB(vec), length(ATTRIB(vec)) - 1);
        SETCDR(t, s);
    }
    if (name == R_ClassSymbol)
        SET_OBJECT(vec, 1);

    UNPROTECT(3);
    return val;
}


SEXP _get_R_object(bson* b) {
    bson_iterator iter;
    bson_iterator_init(&iter, b);
    if (bson_iterator_next(&iter) != BSON_BOOL ||
            strcmp(bson_iterator_key(&iter), "R_OBJ") != 0 ||
            !bson_iterator_bool(&iter))
        return R_NilValue;
    if (bson_iterator_next(&iter) == BSON_EOO ||
            strcmp(bson_iterator_key(&iter), "value") != 0)
        return R_NilValue;
    SEXP ret;
    PROTECT(ret = _mongo_bson_value(&iter));
    if (bson_iterator_next(&iter) == BSON_OBJECT &&
            strcmp(bson_iterator_key(&iter), "attr") == 0) {
        bson_iterator sub;
        bson_iterator_subiterator(&iter, &sub);
        while (bson_iterator_next(&sub) != BSON_EOO) {
            SEXP attr;
            PROTECT(attr = _mongo_bson_value(&sub));
            SEXP name = install(bson_iterator_key(&sub));
            if (name == R_DimNamesSymbol)
                setAttrib(attr, R_NamesSymbol, R_NilValue);
            installAttrib(ret, name, attr);
            UNPROTECT(1);
        }
    }
    UNPROTECT(1);
    return ret;
}


SEXP _mongo_bson_to_list(bson* b) {
    SEXP names, ret;
    ret = _get_R_object(b);
    if (ret != R_NilValue)
        return ret;
    int count = 0;
    bson_iterator iter;
    bson_iterator_init(&iter, b);

    int common_type = BSON_EOO;
    bson_type sub_type;
    Rcomplex z;
    while ((sub_type = bson_iterator_next(&iter))) {
        count++;
        if (sub_type == BSON_LONG)
            sub_type = BSON_DOUBLE;
        if (common_type == BSON_EOO) {
            switch ((common_type = sub_type)) {
            case BSON_INT: ;
            case BSON_DOUBLE: ;
            case BSON_STRING: ;
            case BSON_BOOL: ;
            case BSON_DATE:
                continue;
            case BSON_OBJECT:
                if (_iterator_getComplex(&iter, &z))
                    continue;
                /* fall thru to default */
            default:
                common_type = -1;
            }
        }
        else if (sub_type != common_type)
            common_type = -1;
    }

    bson_iterator_init(&iter, b);
    PROTECT(names = allocVector(STRSXP, count));
    int i = 0;
    if (common_type != -1) {
        switch (common_type) {
        case BSON_EOO:
        case BSON_INT:
            PROTECT(ret = allocVector(INTSXP, count));
            while (bson_iterator_next(&iter)) {
                SET_STRING_ELT(names, i, mkChar(bson_iterator_key(&iter)));
                INTEGER(ret)[i++] = bson_iterator_int(&iter);
            }
            break;
        case BSON_DATE:
            PROTECT(ret = allocVector(REALSXP, count));
            while (bson_iterator_next(&iter)) {
                SET_STRING_ELT(names, i, mkChar(bson_iterator_key(&iter)));
                REAL(ret)[i++] = (double)bson_iterator_date(&iter) / 1000;
            }
            SEXP cls;
            PROTECT(cls = allocVector(STRSXP, 2));
            SET_STRING_ELT(cls, 0, mkChar("POSIXct"));
            SET_STRING_ELT(cls, 1, mkChar("POSIXt"));
            classgets(ret, cls);
            UNPROTECT(1);
            break;
        case BSON_DOUBLE:
            PROTECT(ret = allocVector(REALSXP, count));
            while ((sub_type = bson_iterator_next(&iter))) {
                SET_STRING_ELT(names, i, mkChar(bson_iterator_key(&iter)));
                REAL(ret)[i++] = (sub_type == BSON_LONG ?
                                  bson_iterator_long(&iter) :
                                  bson_iterator_double(&iter));
            }
            break;
        case BSON_STRING:
            PROTECT(ret = allocVector(STRSXP, count));
            while (bson_iterator_next(&iter)) {
                SET_STRING_ELT(names, i, mkChar(bson_iterator_key(&iter)));
                SET_STRING_ELT(ret, i++, mkChar(bson_iterator_string(&iter)));
            }
            break;
        case BSON_BOOL:
            PROTECT(ret = allocVector(LGLSXP, count));
            while (bson_iterator_next(&iter)) {
                SET_STRING_ELT(names, i, mkChar(bson_iterator_key(&iter)));
                LOGICAL(ret)[i++] = bson_iterator_int(&iter);
            }
            break;
        case BSON_OBJECT: /* complex */
            PROTECT(ret = allocVector(CPLXSXP, count));
            while (bson_iterator_next(&iter)) {
                SET_STRING_ELT(names, i, mkChar(bson_iterator_key(&iter)));
                _iterator_getComplex(&iter, &COMPLEX(ret)[i++]);
            }
            break;
        default: /* never reaches here - avoid compiler warning */
            ret = R_NilValue;
            break;
        }
        setAttrib(ret, R_NamesSymbol, names);
        UNPROTECT(2);
        return ret;
    }

    SEXP el;
    PROTECT(ret = allocVector(VECSXP, count));
    for (; (sub_type = bson_iterator_next(&iter)); i++) {
        SET_STRING_ELT(names, i, mkChar(bson_iterator_key(&iter)));
        el = _mongo_bson_value(&iter);
        SET_VECTOR_ELT(ret, i, el);
    }
    setAttrib(ret, R_NamesSymbol, names);
    UNPROTECT(2);
    return ret;
}


SEXP mongo_bson_to_list(SEXP b) {
    if (b == R_NilValue)
        return R_NilValue;
    bson* _b = _checkBSON(b);
    return _mongo_bson_to_list(_b);
}


SEXP mongo_bson_iterator_next(SEXP iter) {
    bson_iterator* _iter = _checkIterator(iter);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = bson_iterator_next(_iter);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_iterator_key(SEXP iter) {
    bson_iterator* _iter = _checkIterator(iter);
    SEXP ret;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar(bson_iterator_key(_iter)));
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_iterator_type(SEXP iter) {
    bson_iterator* _iter = _checkIterator(iter);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = bson_iterator_type(_iter);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_oid_time(SEXP oid) {
    _checkOID(oid);
    bson_oid_t* _oid = (bson_oid_t*)R_ExternalPtrAddr(getAttrib(oid, sym_mongo_oid));
    SEXP ret = _createPOSIXct(bson_oid_generated_time(_oid));
    UNPROTECT(2);
    return ret;
}


SEXP mongo_oid_from_string(SEXP hexstr) {
    const char* _hexstr = CHAR(STRING_ELT(hexstr, 0));
    if (strlen(_hexstr) != 24)
        error("OID string length must be 24");
    bson_oid_t* oid = Calloc(1, bson_oid_t);
    bson_oid_from_string(oid, _hexstr);
    SEXP ret = _mongo_oid_create(oid);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_oid_to_string(SEXP oid) {
    _checkOID(oid);
    SEXP ret;
    PROTECT(ret = allocVector(STRSXP, 1));
    bson_oid_t* _oid = (bson_oid_t*)R_ExternalPtrAddr(getAttrib(oid, sym_mongo_oid));
    char s[25];
    bson_oid_to_string(_oid, s);
    SET_STRING_ELT(ret, 0, mkChar(s));
    UNPROTECT(1);
    return ret;
}


SEXP mongo_oid_print(SEXP oid) {
    _checkOID(oid);
    bson_oid_t* _oid = (bson_oid_t*)R_ExternalPtrAddr(getAttrib(oid, sym_mongo_oid));
    char s[25];
    bson_oid_to_string(_oid, s);
    Rprintf("{ $oid : \"%s\" }\n", s);
    return oid;
}


SEXP mongo_bson_buffer_append_int(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    const char* _name = CHAR(STRING_ELT(name, 0));
    int success = 1;
    int len = LENGTH(value);
    SEXP dim = getAttrib(value, R_DimSymbol);
    int dims;
    if (dim != R_NilValue && (dims = LENGTH(dim)) > 1) {
        if (dims > MAXDIM)
            error("only %d dimensions supported", MAXDIM);
        int ijk[MAXDIM];
        memset(ijk, 0, dims * sizeof(int));
        int depth = 0;
        int i = 0;
        success = (bson_append_start_array(_buf, _name) == BSON_OK);
        while (success && depth >= 0) {
            if (ijk[depth] < INTEGER(dim)[depth]) {
                _name = numstr(ijk[depth]++);
                if (depth < dims - 1) {
                    depth++;
                    success = (bson_append_start_array(_buf, _name) == BSON_OK);
                }
                else
                    success = (bson_append_int(_buf, _name, INTEGER(value)[i++]) == BSON_OK);
            }
            else {
                ijk[depth] = 0;
                success = (bson_append_finish_object(_buf) == BSON_OK);
                depth--;
            }
        }
    }
    else {
        SEXP names = getAttrib(value, R_NamesSymbol);
        if (names == R_NilValue)
            if (len == 1)
                LOGICAL(ret)[0] = (bson_append_int(_buf, _name, asInteger(value)) == BSON_OK);
            else {
                success = (bson_append_start_array(_buf, _name) == BSON_OK);
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (bson_append_int(_buf, numstr(i), INTEGER(value)[i]) == BSON_OK);
                success &= (bson_append_finish_object(_buf) == BSON_OK);
            }
        else {
            int success = (bson_append_start_object(_buf, _name) == BSON_OK);
            if (len == 1)
                success &= (bson_append_int(_buf, _name, asInteger(value)) == BSON_OK);
            else {
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (bson_append_int(_buf, CHAR(STRING_ELT(names, i)), INTEGER(value)[i]) == BSON_OK);
            }
            success &= (bson_append_finish_object(_buf) == BSON_OK);
        }
    }
    LOGICAL(ret)[0] = success;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_bool(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    const char* _name = CHAR(STRING_ELT(name, 0));
    int success = 1;
    int len = LENGTH(value);
    SEXP dim = getAttrib(value, R_DimSymbol);
    int dims;
    if (dim != R_NilValue && (dims = LENGTH(dim)) > 1) {
        if (dims > MAXDIM)
            error("only %d dimensions supported", MAXDIM);
        int ijk[MAXDIM];
        memset(ijk, 0, dims * sizeof(int));
        int depth = 0;
        int i = 0;
        success = (bson_append_start_array(_buf, _name) == BSON_OK);
        while (success && depth >= 0) {
            if (ijk[depth] < INTEGER(dim)[depth]) {
                _name = numstr(ijk[depth]++);
                if (depth < dims - 1) {
                    depth++;
                    success = (bson_append_start_array(_buf, _name) == BSON_OK);
                }
                else
                    success = (bson_append_bool(_buf, _name, LOGICAL(value)[i++]) == BSON_OK);
            }
            else {
                ijk[depth] = 0;
                success = (bson_append_finish_object(_buf) == BSON_OK);
                depth--;
            }
        }
    }
    else {
        SEXP names = getAttrib(value, R_NamesSymbol);
        if (names == R_NilValue)
            if (len == 1)
                success = (bson_append_bool(_buf, _name, asLogical(value)) == BSON_OK);
            else {
                success = (bson_append_start_array(_buf, _name) == BSON_OK);
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (bson_append_bool(_buf, numstr(i), LOGICAL(value)[i]) == BSON_OK);
                success &= (bson_append_finish_object(_buf) == BSON_OK);
            }
        else {
            success = (bson_append_start_object(_buf, _name) == BSON_OK);
            if (len == 1)
                success &= (bson_append_bool(_buf, _name, asLogical(value)) == BSON_OK);
            else {
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (bson_append_bool(_buf, CHAR(STRING_ELT(names, i)), LOGICAL(value)[i]) == BSON_OK);
            }
            success &= (bson_append_finish_object(_buf) == BSON_OK);
        }
    }
    LOGICAL(ret)[0] = success;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_double(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    const char* _name = CHAR(STRING_ELT(name, 0));
    int len = LENGTH(value);
    int success = 1;
    SEXP dim = getAttrib(value, R_DimSymbol);
    int dims;
    if (dim != R_NilValue && (dims = LENGTH(dim)) > 1) {
        if (dims > MAXDIM)
            error("only %d dimensions supported", MAXDIM);
        int ijk[MAXDIM];
        memset(ijk, 0, dims * sizeof(int));
        int depth = 0;
        int i = 0;
        success = (bson_append_start_array(_buf, _name) == BSON_OK);
        while (success && depth >= 0) {
            if (ijk[depth] < INTEGER(dim)[depth]) {
                _name = numstr(ijk[depth]++);
                if (depth < dims - 1) {
                    depth++;
                    success = (bson_append_start_array(_buf, _name) == BSON_OK);
                }
                else
                    success = (bson_append_double(_buf, _name, REAL(value)[i++]) == BSON_OK);
            }
            else {
                ijk[depth] = 0;
                success = (bson_append_finish_object(_buf) == BSON_OK);
                depth--;
            }
        }
    }
    else {
        SEXP names = getAttrib(value, R_NamesSymbol);
        if (names == R_NilValue)
            if (len == 1)
                success = (bson_append_double(_buf, _name, asReal(value)) == BSON_OK);
            else {
                success = (bson_append_start_array(_buf, _name) == BSON_OK);
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (bson_append_double(_buf, numstr(i), REAL(value)[i]) == BSON_OK);
                success &= (bson_append_finish_object(_buf) == BSON_OK);
            }
        else {
            success = (bson_append_start_object(_buf, _name) == BSON_OK);
            if (len == 1)
                success &= (bson_append_double(_buf, _name, asReal(value)) == BSON_OK);
            else {
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (bson_append_double(_buf, CHAR(STRING_ELT(names, i)), REAL(value)[i]) == BSON_OK);
                success &= (bson_append_finish_object(_buf) == BSON_OK);
            }
        }
    }
    LOGICAL(ret)[0] = success;
    UNPROTECT(1);
    return ret;
}


int _bson_append_complex(bson_buffer* buf, const char* name, Rcomplex* z) {
    return (bson_append_start_object(buf, name) == BSON_OK &&
            bson_append_double(buf, "r", z->r) == BSON_OK &&
            bson_append_double(buf, "i", z->i) == BSON_OK &&
            bson_append_finish_object(buf) == BSON_OK) ? BSON_OK : BSON_ERROR;
}


SEXP mongo_bson_buffer_append_complex(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    const char* _name = CHAR(STRING_ELT(name, 0));
    int success = 1;
    int len = LENGTH(value);
    SEXP dim = getAttrib(value, R_DimSymbol);
    int dims;
    if (dim != R_NilValue && (dims = LENGTH(dim)) > 1) {
        if (dims > MAXDIM)
            error("only %d dimensions supported", MAXDIM);
        int ijk[MAXDIM];
        memset(ijk, 0, dims * sizeof(int));
        int depth = 0;
        int i = 0;
        success = (bson_append_start_array(_buf, _name) == BSON_OK);
        while (success && depth >= 0) {
            if (ijk[depth] < INTEGER(dim)[depth]) {
                _name = numstr(ijk[depth]++);
                if (depth < dims - 1) {
                    depth++;
                    success = (bson_append_start_array(_buf, _name) == BSON_OK);
                }
                else
                    success = (_bson_append_complex(_buf, _name, &COMPLEX(value)[i++]) == BSON_OK);
            }
            else {
                ijk[depth] = 0;
                success = (bson_append_finish_object(_buf) == BSON_OK);
                depth--;
            }
        }
    }
    else {
        SEXP names = getAttrib(value, R_NamesSymbol);
        if (names == R_NilValue)
            if (len == 1)
                success = (_bson_append_complex(_buf, _name, &COMPLEX(value)[0]) == BSON_OK);
            else {
                success = (bson_append_start_array(_buf, _name) == BSON_OK);
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (_bson_append_complex(_buf, numstr(i), &COMPLEX(value)[i]) == BSON_OK);
                success &= (bson_append_finish_object(_buf) == BSON_OK);
            }
        else {
            success = (bson_append_start_object(_buf, _name) == BSON_OK);
            int i;
            for (i = 0; i < len && success; i++)
                success &= (_bson_append_complex(_buf, CHAR(STRING_ELT(names, i)), &COMPLEX(value)[i]) == BSON_OK);
            success &= (bson_append_finish_object(_buf) == BSON_OK);
        }
    }
    LOGICAL(ret)[0] = success;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_string(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    int success = 1;
    int len = LENGTH(value);
    SEXP dim = getAttrib(value, R_DimSymbol);
    int dims;
    if (dim != R_NilValue && (dims = LENGTH(dim)) > 1) {
        if (dims > MAXDIM)
            error("only %d dimensions supported", MAXDIM);
        int ijk[MAXDIM];
        memset(ijk, 0, dims * sizeof(int));
        int depth = 0;
        int i = 0;
        success = (bson_append_start_array(_buf, _name) == BSON_OK);
        while (success && depth >= 0) {
            if (ijk[depth] < INTEGER(dim)[depth]) {
                _name = numstr(ijk[depth]++);
                if (depth < dims - 1) {
                    depth++;
                    success = (bson_append_start_array(_buf, _name) == BSON_OK);
                }
                else
                    success = (bson_append_string(_buf, _name, CHAR(STRING_ELT(value, i++))) == BSON_OK);
            }
            else {
                ijk[depth] = 0;
                success = (bson_append_finish_object(_buf) == BSON_OK);
                depth--;
            }
        }
    }
    else {
        SEXP names = getAttrib(value, R_NamesSymbol);
        if (names == R_NilValue)
            if (len == 1)
                success = (bson_append_string(_buf, _name, CHAR(STRING_ELT(value, 0))) == BSON_OK);
            else {
                success = (bson_append_start_array(_buf, _name) == BSON_OK);
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (bson_append_string(_buf, numstr(i), CHAR(STRING_ELT(value, i))) == BSON_OK);
                success &= (bson_append_finish_object(_buf) == BSON_OK);
            }
        else {
            success = (bson_append_start_object(_buf, _name) == BSON_OK);
            int i;
            for (i = 0; i < len && success; i++)
                success &= (bson_append_string(_buf, CHAR(STRING_ELT(names, i)), CHAR(STRING_ELT(value,i))) == BSON_OK);
            success &= (bson_append_finish_object(_buf) == BSON_OK);
        }
    }
    LOGICAL(ret)[0] = success;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_raw(SEXP buf, SEXP name, SEXP value, SEXP subtype) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    int len = LENGTH(value);
    int _subtype;
    if (subtype == R_NilValue) {
        SEXP attrSubtype = getAttrib(value, sym_subtype);
        if (attrSubtype == R_NilValue)
            _subtype = BSON_BIN_BINARY;
        else
            _subtype = asInteger(attrSubtype);
    }
    else
        _subtype = INTEGER(subtype)[0];
    char* data = (char*)RAW(value);
    int success = 1;
    SEXP dim = getAttrib(value, R_DimSymbol);
    int dims;
    if (dim != R_NilValue && (dims = LENGTH(dim)) > 1) {
        if (dims > MAXDIM)
            error("only %d dimensions supported", MAXDIM);
        int ijk[MAXDIM];
        memset(ijk, 0, dims * sizeof(int));
        int depth = 0;
        int i = 0;
        success = (bson_append_start_array(_buf, _name) == BSON_OK);
        while (success && depth >= 0) {
            if (ijk[depth] < INTEGER(dim)[depth]) {
                _name = numstr(ijk[depth]++);
                if (depth < dims - 1) {
                    depth++;
                    success = (bson_append_start_array(_buf, _name) == BSON_OK);
                }
                else
                    success = (bson_append_binary(_buf, _name, _subtype, (char*)(RAW(value) + i++), 1) == BSON_OK);
            }
            else {
                ijk[depth] = 0;
                success = (bson_append_finish_object(_buf) == BSON_OK);
                depth--;
            }
        }
    }
    else
        success = (bson_append_binary(_buf, _name, _subtype, data, len) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_long(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    const char* _name = CHAR(STRING_ELT(name, 0));
    int len = LENGTH(value);
    int success = 1;
    SEXP dim = getAttrib(value, R_DimSymbol);
    int dims;
    if (dim != R_NilValue && (dims = LENGTH(dim)) > 1) {
        if (dims > MAXDIM)
            error("only %d dimensions supported", MAXDIM);
        int ijk[MAXDIM];
        memset(ijk, 0, dims * sizeof(int));
        int depth = 0;
        int i = 0;
        success = (bson_append_start_array(_buf, _name) == BSON_OK);
        while (success && depth >= 0) {
            if (ijk[depth] < INTEGER(dim)[depth]) {
                _name = numstr(ijk[depth]++);
                if (depth < dims - 1) {
                    depth++;
                    success = (bson_append_start_array(_buf, _name) == BSON_OK);
                }
                else
                    success = (bson_append_long(_buf, _name, REAL(value)[i++]) == BSON_OK);
            }
            else {
                ijk[depth] = 0;
                success = (bson_append_finish_object(_buf) == BSON_OK);
                depth--;
            }
        }
    }
    else {
        SEXP names = getAttrib(value, R_NamesSymbol);
        if (names == R_NilValue)
            if (len == 1)
                success = (bson_append_long(_buf, _name, asReal(value)) == BSON_OK);
            else {
                success = (bson_append_start_array(_buf, _name) == BSON_OK);
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (bson_append_long(_buf, numstr(i), REAL(value)[i]) == BSON_OK);
                success &= (bson_append_finish_object(_buf) == BSON_OK);
            }
        else {
            success = (bson_append_start_object(_buf, _name) == BSON_OK);
            if (len == 1)
                success &= (bson_append_long(_buf, _name, asReal(value)) == BSON_OK);
            else {
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (bson_append_long(_buf, CHAR(STRING_ELT(names, i)), REAL(value)[i]) == BSON_OK);
                success &= (bson_append_finish_object(_buf) == BSON_OK);
            }
        }
    }
    LOGICAL(ret)[0] = success;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_null(SEXP buf, SEXP name) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    const char* _name = CHAR(STRING_ELT(name, 0));
    LOGICAL(ret)[0] = (bson_append_null(_buf, _name) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_undefined(SEXP buf, SEXP name) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    const char* _name = CHAR(STRING_ELT(name, 0));
    LOGICAL(ret)[0] = (bson_append_undefined(_buf, _name) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_oid(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    _checkOID(value);
    const char* _name = CHAR(STRING_ELT(name, 0));
    bson_oid_t* _value = (bson_oid_t*)R_ExternalPtrAddr(getAttrib(value, sym_mongo_oid));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (bson_append_oid(_buf, _name, _value) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_bson(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    bson* _value = _checkBSON(value);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (bson_append_bson(_buf, _name, _value) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_element(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name;
    if (isNull(name))
        _name = NULL;
    else
        _name = CHAR(STRING_ELT(name, 0));
    bson_iterator* _value = _checkIterator(value);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (bson_append_element(_buf, _name, _value) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_time(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    int success;
    value = _getTime(value);
    SEXP names = getAttrib(value, R_NamesSymbol);
    int len = LENGTH(value);
    SEXP dim = getAttrib(value, R_DimSymbol);
    int dims;
    int t = TYPEOF(value);
    if (dim != R_NilValue && (dims = LENGTH(dim)) > 1) {
        if (dims > MAXDIM)
            error("only %d dimensions supported", MAXDIM);
        int ijk[MAXDIM];
        memset(ijk, 0, dims * sizeof(int));
        int depth = 0;
        int i = 0;
        success = (bson_append_start_array(_buf, _name) == BSON_OK);
        while (success && depth >= 0) {
            if (ijk[depth] < INTEGER(dim)[depth]) {
                _name = numstr(ijk[depth]++);
                if (depth < dims - 1) {
                    depth++;
                    success = (bson_append_start_array(_buf, _name) == BSON_OK);
                }
                else {
                    if (t == INTSXP)
                        success = (bson_append_date(_buf, _name, (int64_t)(INTEGER(value)[i++]) * 1000) == BSON_OK);
                    else
                        success = (bson_append_date(_buf, _name, REAL(value)[i++] * 1000) == BSON_OK);
                }
            }
            else {
                ijk[depth] = 0;
                success = (bson_append_finish_object(_buf) == BSON_OK);
                depth--;
            }
        }
    }
    else {
        if (t == INTSXP) {
            if (names == R_NilValue) {
                if (len == 1)
                    success = (bson_append_date(_buf, _name, (int64_t)(asInteger(value)) * 1000) == BSON_OK);
                else {
                    success = (bson_append_start_array(_buf, _name) == BSON_OK);
                    int i;
                    for (i = 0; i < len && success; i++)
                        success &= (bson_append_date(_buf, numstr(i), (int64_t)(INTEGER(value)[i]) * 1000) == BSON_OK);
                    success &= (bson_append_finish_object(_buf) == BSON_OK);
                }
            }
            else {
                success = (bson_append_start_object(_buf, _name) == BSON_OK);
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (bson_append_date(_buf, CHAR(STRING_ELT(names, i)), (int64_t)(INTEGER(value)[i]) * 1000) == BSON_OK);
                success &= (bson_append_finish_object(_buf) == BSON_OK);
            }
        }
        else {
            if (names == R_NilValue) {
                if (len == 1)
                    success = (bson_append_date(_buf, _name, REAL(value)[0] * 1000) == BSON_OK);
                else {
                    success = (bson_append_start_array(_buf, _name) == BSON_OK);
                    int i;
                    for (i = 0; i < len && success; i++)
                        success &= (bson_append_date(_buf, numstr(i), REAL(value)[i] * 1000) == BSON_OK);
                    success &= (bson_append_finish_object(_buf) == BSON_OK);
                }
            }
            else {
                success = (bson_append_start_object(_buf, _name) == BSON_OK);
                int i;
                for (i = 0; i < len && success; i++)
                    success &= (bson_append_date(_buf, CHAR(STRING_ELT(names, i)), REAL(value)[i] * 1000) == BSON_OK);
                success &= (bson_append_finish_object(_buf) == BSON_OK);
            }
        }
    }
    LOGICAL(ret)[0] = success;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_timestamp(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    _checkClass(value, "mongo.timestamp");
    bson_timestamp_t ts;
    ts.t = asInteger(value);
    ts.i = asInteger(getAttrib(value, sym_increment));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = bson_append_timestamp(_buf, _name, &ts) == BSON_OK;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_code(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (bson_append_code(_buf, _name, CHAR(STRING_ELT(value, 0))) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_code_w_scope(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    _checkClass(value, "mongo.code.w.scope");
    const char* code = CHAR(STRING_ELT(value, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    SEXP b = getAttrib(value, sym_scope);
    bson* scope = _checkBSON(b);
    LOGICAL(ret)[0] = (bson_append_code_w_scope(_buf, _name, code, scope) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_regex(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    const char* pattern = CHAR(STRING_ELT(value, 0));
    const char* options = "";
    SEXP opts = getAttrib(value, sym_options);
    if (opts != R_NilValue)
        options = CHAR(STRING_ELT(opts, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (bson_append_regex(_buf, _name, pattern, options) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_symbol(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (bson_append_symbol(_buf, _name, CHAR(STRING_ELT(value, 0))) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_object(SEXP buf, SEXP name, SEXP value) {
    if (LENGTH(value) == 0)
        error("object's length must be > 0");
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    int success = (bson_append_start_object(_buf, _name) == BSON_OK);
    if (success)
        success = (bson_append_bool(_buf, "R_OBJ", 1) == BSON_OK);
    if (success) {
        SEXP R_value;
        PROTECT(R_value = allocVector(STRSXP, 1));
        SET_STRING_ELT(R_value, 0, mkChar("value"));
        success = LOGICAL(mongo_bson_buffer_append(buf, R_value, value))[0];
        UNPROTECT(1);
        SEXP s = ATTRIB(value);
        if (s != R_NilValue) {
            if (success)
                success = (bson_append_start_object(_buf, "attr") == BSON_OK);
            for (; success && s != R_NilValue; s = CDR(s)) {
                SEXP t = TAG(s);
                if (t != R_NamesSymbol) {
                    SEXP name;
                    PROTECT(name = allocVector(STRSXP, 1));
                    SET_STRING_ELT(name, 0, PRINTNAME(t));
                    success = LOGICAL(mongo_bson_buffer_append(buf, name, CAR(s)))[0];
                    UNPROTECT(1);
                }
            }
            if (success)
                success = (bson_append_finish_object(_buf) == BSON_OK);
        }
    }
    if (success)
        success = (bson_append_finish_object(_buf) == BSON_OK);
    LOGICAL(ret)[0] = success;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append(SEXP buf, SEXP name, SEXP value) {
    if (isNull(value))
        return mongo_bson_buffer_append_null(buf, name);
    SEXP cls = getAttrib(value, R_ClassSymbol);
    if (cls != R_NilValue) {
        if (_hasClass(cls, "mongo.oid"))
            return mongo_bson_buffer_append_oid(buf, name, value);
        if (_hasClass(cls, "mongo.bson"))
            return mongo_bson_buffer_append_bson(buf, name, value);
        if (_hasClass(cls, "mongo.bson.iterator"))
            return mongo_bson_buffer_append_element(buf, name, value);
        if (_hasClass(cls, "mongo.timestamp")) /* extends POSIXct */
            return mongo_bson_buffer_append_timestamp(buf, name, value);
        if (_hasClass(cls, "POSIXct")) /* must follow timestamp */
            return mongo_bson_buffer_append_time(buf, name, value);
        if (_hasClass(cls, "POSIXlt"))
            return mongo_bson_buffer_append_time(buf, name, value);
        if (_hasClass(cls, "mongo.code.w.scope")) /* should be before code */
            return mongo_bson_buffer_append_code_w_scope(buf, name, value);
        if (_hasClass(cls, "mongo.code"))
            return mongo_bson_buffer_append_code(buf, name, value);
        if (_hasClass(cls, "mongo.symbol"))
            return mongo_bson_buffer_append_symbol(buf, name, value);
        if (_hasClass(cls, "mongo.undefined"))
            return mongo_bson_buffer_append_undefined(buf, name);
        if (_hasClass(cls, "mongo.regex"))
            return mongo_bson_buffer_append_regex(buf, name, value);
    }
    int t = TYPEOF(value);
    switch (t) {
    case LGLSXP:  return mongo_bson_buffer_append_bool(buf, name, value);
    case INTSXP:  return mongo_bson_buffer_append_int(buf, name, value);
    case STRSXP:  return mongo_bson_buffer_append_string(buf, name, value);
    case REALSXP: return mongo_bson_buffer_append_double(buf, name, value);
    case CPLXSXP: return mongo_bson_buffer_append_complex(buf, name, value);
    case VECSXP:  return mongo_bson_buffer_append_list(buf, name, value);
    case RAWSXP:  return mongo_bson_buffer_append_raw(buf, name, value, R_NilValue);
    default:
        error("Unhandled R type (%d) in mongo.bson.buffer.append\n", t);
        return R_NilValue; /* never reached */
    }
}


SEXP mongo_bson_buffer_append_list(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    int success = (bson_append_start_object(_buf, _name) == BSON_OK);
    int len = LENGTH(value);
    int i;
    SEXP names = getAttrib(value, R_NamesSymbol);
    SEXP fname;
    if (names != R_NilValue)
        for (i = 0; i < len && success; i++) {
            PROTECT(fname = allocVector(STRSXP, 1));
            SET_STRING_ELT(fname, 0, STRING_ELT(names, i));
            success &= LOGICAL(mongo_bson_buffer_append(buf, fname, VECTOR_ELT(value, i)))[0];
            UNPROTECT(1);
        }
    else
        for (i = 0; i < len && success; i++) {
            PROTECT(fname = allocVector(STRSXP, 1));
            SET_STRING_ELT(fname, 0, mkChar(numstr(i+1)));
            success &= LOGICAL(mongo_bson_buffer_append(buf, fname, VECTOR_ELT(value, i)))[0];
            UNPROTECT(1);
        }
    success &= (bson_append_finish_object(_buf) == BSON_OK);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = success;
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_from_list(SEXP lst) {
    int len = LENGTH(lst);
    if (len == 0)
        return R_NilValue;
    SEXP names = getAttrib(lst, R_NamesSymbol);
    if (TYPEOF(lst) != VECSXP)
        error("object is not a list");
    SEXP buf = _mongo_bson_buffer_create();
    int success = 1;
    int i;
    SEXP fname;
    if (names != R_NilValue)
        for (i = 0; i < len && success; i++) {
            PROTECT(fname = allocVector(STRSXP, 1));
            SET_STRING_ELT(fname, 0, STRING_ELT(names, i));
            success &= LOGICAL(mongo_bson_buffer_append(buf, fname, VECTOR_ELT(lst, i)))[0];
            UNPROTECT(1);
        }
    else
        for (i = 0; i < len && success; i++) {
            PROTECT(fname = allocVector(STRSXP, 1));
            SET_STRING_ELT(fname, 0, mkChar(numstr(i+1)));
            success &= LOGICAL(mongo_bson_buffer_append(buf, fname, VECTOR_ELT(lst, i)))[0];
            UNPROTECT(1);
        }
    if (!success) {
        UNPROTECT(3);
        return R_NilValue;
    }
    SEXP ret;
    ret = mongo_bson_from_buffer(buf);
    UNPROTECT(3);
    return ret;
}



SEXP mongo_bson_buffer_start_array(SEXP buf, SEXP name) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (bson_append_start_array(_buf, _name) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_start_object(SEXP buf, SEXP name) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (bson_append_start_object(_buf, _name) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_finish_object(SEXP buf) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (bson_append_finish_object(_buf) == BSON_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_size(SEXP buf) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = _buf->cur - _buf->data + 1;
    UNPROTECT(1);
    return ret;
}

/*
SEXP mongo_sys_time() {
    time_t t;
    time(&t);
    SEXP ret = _createPOSIXct(t);
    UNPROTECT(2);
    return ret;
}
*/