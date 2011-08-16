#include <R.h>
#include "api_bson.h"
#include "symbols.h"
#include "utility.h"


#include <stdlib.h>

typedef bson bson_buffer;

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


void _checkBinary(SEXP bin) {
    _checkClass(bin, "mongo.binary");
}


static void bsonFinalizer(SEXP ptr) {
    if (!R_ExternalPtrAddr(ptr)) return;
    bson* b = (bson*)R_ExternalPtrAddr(ptr);
    bson_destroy(b);
    Free(b);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP _mongo_bson_create(bson* b) {
    SEXP ret, ptr, cls;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
    bson* obj = Calloc(1, bson);
    bson_copy(obj, b);
    ptr = R_MakeExternalPtr(obj, sym_mongo_bson, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, bsonFinalizer, TRUE);
    setAttrib(ret, sym_mongo_bson, ptr);
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.bson"));
    classgets(ret, cls);
    return ret;
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

SEXP _mongo_code_create(const char* code)
{
    SEXP ret, cls;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar(code));
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.code"));
    classgets(ret, cls);
    UNPROTECT(2);
    return ret;
}


SEXP mongo_code_create(SEXP code)
{
    const char* _code = CHAR(STRING_ELT(code, 0));
    return _mongo_code_create(_code);
}


SEXP _mongo_code_w_scope_create(const char* code, bson* b)
{
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


SEXP mongo_code_w_scope_create(SEXP code, SEXP b)
{
    bson* _b = _checkBSON(b);
    return _mongo_code_w_scope_create(CHAR(STRING_ELT(code, 0)), _b);
}


SEXP _mongo_regex_create(const char* pattern, const char* options)
{
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


SEXP mongo_regex_create(SEXP pattern, SEXP options)
{
    return _mongo_regex_create(CHAR(STRING_ELT(pattern, 0)), CHAR(STRING_ELT(options, 0)));
}


static void binaryFinalizer(SEXP ptr) {
    if (!R_ExternalPtrAddr(ptr)) return;
    void* b = (void*)R_ExternalPtrAddr(ptr);
    Free(b);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP _mongo_binary_create(char type, const char* data, int len)
{
    SEXP ret, cls, ptr;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = type;
    void* d = (void*)Calloc(len, char);
    if (data) memcpy(d, data, len);
    ptr = R_MakeExternalPtr(d, sym_mongo_binary, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, binaryFinalizer, TRUE);
    setAttrib(ret, sym_mongo_binary, ptr);
    SEXP rlen;
    PROTECT(rlen = allocVector(INTSXP, 1));
    INTEGER(rlen)[0] = len;
    setAttrib(ret, sym_length, rlen);
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.binary"));
    classgets(ret, cls);
    UNPROTECT(4);
    return ret;
}


SEXP mongo_binary_create(SEXP type, SEXP len) {
    return _mongo_binary_create(asInteger(type), NULL, asInteger(len));
}


SEXP mongo_binary_set(SEXP bin, SEXP index, SEXP value) {
    _checkBinary(bin);
    int i = asInteger(index);
    int len = INTEGER(getAttrib(bin, sym_length))[0];
    if (i >= len)
        error("index (%d) must be less than the length (%d) of the binary object", i, len);
    char* data = (char*)R_ExternalPtrAddr(getAttrib(bin, sym_mongo_binary));
    data[i] = (char)asInteger(value);
    return R_NilValue;
}


SEXP mongo_binary_get(SEXP bin, SEXP index) {
    _checkBinary(bin);
    int i = asInteger(index);
    int len = INTEGER(getAttrib(bin, sym_length))[0];
    if (i >= len)
        error("index (%d) must be less than the length (%d) of the binary object", i, len);
    char* data = (char*)R_ExternalPtrAddr(getAttrib(bin, sym_mongo_binary));
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = (int)data[i];
    UNPROTECT(1);
    return ret;
}


SEXP _mongo_symbol_create(const char* symbol)
{
    SEXP ret, cls;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar(symbol));
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.symbol"));
    classgets(ret, cls);
    UNPROTECT(2);
    return ret;
}


SEXP mongo_symbol_create(SEXP symbol)
{
    const char* _symbol = CHAR(STRING_ELT(symbol, 0));
    return _mongo_symbol_create(_symbol);
}


SEXP mongo_undefined_create()
{
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
            error("Iterator expected to point to an array or subobject");
    } else {
        bson* _b = _checkBSON(b);
        bson_iterator_init(&iter, _b);
    }
    return _mongo_bson_iterator_create(&iter);
}


SEXP mongo_bson_find(SEXP b, SEXP name) {
    bson* _b = _checkBSON(b);
    const char* _name = CHAR(STRING_ELT(name, 0));
    bson_iterator iter;
    if (bson_find(&iter, _b, _name) == BSON_EOO)
        return R_NilValue;
    return _mongo_bson_iterator_create(&iter);
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


SEXP _createPOSIXct(int t) {
    SEXP ret, cls;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = t;
    PROTECT(cls = allocVector(STRSXP, 2));
    SET_STRING_ELT(cls, 0, mkChar("POSIXct"));
    SET_STRING_ELT(cls, 1, mkChar("POSIXt"));
    classgets(ret, cls);
    return ret;
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


SEXP mongo_timestamp_create(SEXP t, SEXP i) {
    SEXP ret = _mongo_timestamp_create(asInteger(t), asInteger(i));
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


SEXP _array_to_object(bson_iterator* _iter) {
    SEXP ret;
    Rcomplex z;
    bson_iterator sub;
    bson_iterator_subiterator(_iter, &sub);
    bson_type common_type = BSON_EOO;
    bson_type sub_type;
    int count = 0;
    while ((sub_type = bson_iterator_next(&sub))) {
        count++;
        if (sub_type == BSON_LONG)
            sub_type = BSON_DOUBLE;
        if (common_type == BSON_EOO) {
            switch (common_type = sub_type) {
            case BSON_INT: ;
            case BSON_DOUBLE: ;
            case BSON_STRING: ;
            case BSON_BOOL: ;
                continue;
            case BSON_OBJECT:
                if (_iterator_getComplex(&sub, &z))
                    continue;
                // fall thru to default
            default:
                return R_NilValue;
            }
        }
        else if (sub_type != common_type)
            return R_NilValue;
    }
    bson_iterator_subiterator(_iter, &sub);
    int i = 0;
    switch (common_type) {
    case BSON_INT:
        PROTECT(ret = allocVector(INTSXP, count));
        while (bson_iterator_next(&sub))
            INTEGER(ret)[i++] = bson_iterator_int(&sub);
        break;
    case BSON_DOUBLE:
        PROTECT(ret = allocVector(REALSXP, count));
        while ((sub_type = bson_iterator_next(&sub)))
            REAL(ret)[i++] = (sub_type == BSON_LONG ?
                                bson_iterator_long(&sub) :
                                bson_iterator_double(&sub));
        break;
    case BSON_STRING:
        PROTECT(ret = allocVector(STRSXP, count));
        while (bson_iterator_next(&sub))
            SET_STRING_ELT(ret, i++, mkChar(bson_iterator_string(_iter)));
        break;
    case BSON_BOOL:
        PROTECT(ret = allocVector(LGLSXP, count));
        while (bson_iterator_next(&sub))
            LOGICAL(ret)[i++] = bson_iterator_int(&sub);
        break;
    case BSON_OBJECT: // complex
        PROTECT(ret = allocVector(CPLXSXP, count));
        while (bson_iterator_next(&sub))
            _iterator_getComplex(&sub, &COMPLEX(ret)[i++]);

    default: // never reaches here - avoid compiler warning
        ret = R_NilValue;
    }
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_iterator_value(SEXP iter) {
    bson_iterator* _iter = _checkIterator(iter);
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

    case BSON_SYMBOL:
        return _mongo_symbol_create(bson_iterator_string(_iter));

    case BSON_UNDEFINED:
        return mongo_undefined_create();

    case BSON_REGEX:
        return _mongo_regex_create(bson_iterator_regex(_iter), bson_iterator_regex_opts(_iter));

    case BSON_BINDATA:
        return _mongo_binary_create(bson_iterator_bin_type(_iter), 
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
        ret = _createPOSIXct(bson_iterator_date(_iter));
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
        // fall thru to returnSubObject
returnSubObject: {
            bson b;
            bson_iterator_subobject(_iter, &b);
            ret = _mongo_bson_create(&b);
            UNPROTECT(3);
            return ret;
        }

    case BSON_CODEWSCOPE: {
        const char* code = bson_iterator_code(_iter);
        bson b;
        bson_iterator_code_scope(_iter, &b);
        return _mongo_code_w_scope_create(code, &b);
    }

    case 0:
        PROTECT(ret = allocVector(INTSXP, 1));
        INTEGER(ret)[0] = 0;
        break;

    default:
        error("Unhandled BSON type %d\n", t);
        ret = R_NilValue;  // uninitialized ret avoid warning
    }
    UNPROTECT(1);
    return ret;
}

// passed an iterator to start of a bson object
SEXP _mongo_bson_to_list(bson_iterator* _iter)
{
    SEXP names, ret;
    int count = 0;
    bson_iterator iter;
    memcpy(&iter, _iter, sizeof(bson_iterator));
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
                continue;
            case BSON_OBJECT:
                if (_iterator_getComplex(&iter, &z))
                    continue;
                // fall thru to default
            default:
                common_type = -1;
            }
        }
        else if (sub_type != common_type)
            common_type = -1;
    }

    memcpy(&iter, _iter, sizeof(bson_iterator));
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
        case BSON_OBJECT: // complex
            PROTECT(ret = allocVector(CPLXSXP, count));
            while (bson_iterator_next(&iter)) {
                SET_STRING_ELT(names, i, mkChar(bson_iterator_key(&iter)));
                _iterator_getComplex(&iter, &COMPLEX(ret)[i++]);
            }
            break;
        default: // never reaches here - avoid compiler warning
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
        switch (sub_type) {
        case BSON_INT:
            el = allocVector(INTSXP, 1);
            INTEGER(el)[0] = bson_iterator_int(&iter);
            break;

        case BSON_DOUBLE:
            el = allocVector(REALSXP, 1);
            REAL(el)[0] = bson_iterator_double(&iter);
            break;

        case BSON_LONG:
            el = allocVector(REALSXP, 1);
            REAL(el)[0] = bson_iterator_long(&iter);
            break;

        case BSON_BOOL:
            el = allocVector(LGLSXP, 1);
            LOGICAL(el)[0] = bson_iterator_bool(&iter);
            break;

        case BSON_STRING:
            el = allocVector(STRSXP, 1);
            SET_STRING_ELT(el, 0, mkChar(bson_iterator_string(&iter)));
            break;

        case BSON_NULL:
            el =  R_NilValue;
            break;

        case BSON_OID: {
            bson_oid_t* oid = Calloc(1, bson_oid_t);
            memcpy(oid, bson_iterator_oid(&iter), sizeof(bson_oid_t));
            el = _mongo_oid_create(oid);
            UNPROTECT(3);
            break;
        }

        case BSON_DATE:
            el = _createPOSIXct(bson_iterator_date(&iter));
            UNPROTECT(2);
            break;

        case BSON_TIMESTAMP: {
            bson_timestamp_t ts = bson_iterator_timestamp(&iter);
            el = _mongo_timestamp_create(ts.t, ts.i);
            UNPROTECT(3);
            break;
        }

        case BSON_CODE:
            el = _mongo_code_create(bson_iterator_string(&iter));
            break;

        case BSON_SYMBOL:
            el = _mongo_symbol_create(bson_iterator_string(&iter));
            break;

        case BSON_UNDEFINED:
            el = mongo_undefined_create();
            break;

        case BSON_REGEX:
            el = _mongo_regex_create(bson_iterator_regex(&iter), bson_iterator_regex_opts(&iter));
            break;

        case BSON_BINDATA:
            el = _mongo_binary_create(bson_iterator_bin_type(&iter), 
                                      bson_iterator_bin_data(&iter), 
                                      bson_iterator_bin_len(&iter));
            break;

        case BSON_ARRAY: {
            el = _array_to_object(&iter);
            if (el == R_NilValue)
                goto returnSubObject;
            break;
        }

        case BSON_OBJECT:
            if (_iterator_getComplex(&iter, &z)) {
                el = allocVector(CPLXSXP, 1);
                COMPLEX(el)[0] = z;
                break;
            }
            // fall thru to returnSubObject
returnSubObject: {
                bson_iterator sub;
                bson_iterator_subiterator(&iter, &sub);
                el = _mongo_bson_to_list(&sub);
                break;
            }

        case BSON_CODEWSCOPE: {
            const char* code = bson_iterator_code(&iter);
            bson b;
            bson_iterator_code_scope(&iter, &b);
            el =  _mongo_code_w_scope_create(code, &b);
            break;
        }

        case 0:
            el = allocVector(INTSXP, 1);
            INTEGER(el)[0] = 0;
            break;

        default:
            error("Unhandled BSON type %d\n", sub_type);
            el = R_NilValue;  // uninitialized el avoid warning
        }
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
    bson_iterator iter;
    bson_iterator_init(&iter, _b);
    return _mongo_bson_to_list(&iter);
}


SEXP mongo_bson_buffer_append_int(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    const char* _name = CHAR(STRING_ELT(name, 0));
    int len = LENGTH(value);
    SEXP names = getAttrib(value, R_NamesSymbol);
    if (names == R_NilValue)
        if (len == 1)
            LOGICAL(ret)[0] = (bson_append_int(_buf, _name, asInteger(value)) == BSON_OK);
        else {
            int success = (bson_append_start_array(_buf, _name) == BSON_OK);
            int i;
            for (i = 0; i < len && success; i++)
                success &= (bson_append_int(_buf, numstr(i), INTEGER(value)[i]) == BSON_OK);
            success &= (bson_append_finish_object(_buf) == BSON_OK);
            LOGICAL(ret)[0] = success;
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
        LOGICAL(ret)[0] = success;
    }
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_bool(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    const char* _name = CHAR(STRING_ELT(name, 0));
    int len = LENGTH(value);
    SEXP names = getAttrib(value, R_NamesSymbol);
    if (names == R_NilValue)
        if (len == 1)
            LOGICAL(ret)[0] = (bson_append_bool(_buf, _name, asLogical(value)) == BSON_OK);
        else {
            int success = (bson_append_start_array(_buf, _name) == BSON_OK);
            int i;
            for (i = 0; i < len && success; i++)
                success &= (bson_append_bool(_buf, numstr(i), LOGICAL(value)[i]) == BSON_OK);
            success &= (bson_append_finish_object(_buf) == BSON_OK);
            LOGICAL(ret)[0] = success;
        }
    else {
        int success = (bson_append_start_object(_buf, _name) == BSON_OK);
        if (len == 1)
            success &= (bson_append_bool(_buf, _name, asLogical(value)) == BSON_OK);
        else {
            int i;
            for (i = 0; i < len && success; i++)
                success &= (bson_append_bool(_buf, CHAR(STRING_ELT(names, i)), LOGICAL(value)[i]) == BSON_OK);
        }
        success &= (bson_append_finish_object(_buf) == BSON_OK);
        LOGICAL(ret)[0] = success;
    }
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_double(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    const char* _name = CHAR(STRING_ELT(name, 0));
    int len = LENGTH(value);
    SEXP names = getAttrib(value, R_NamesSymbol);
    if (names == R_NilValue)
        if (len == 1)
            LOGICAL(ret)[0] = (bson_append_double(_buf, _name, asReal(value)) == BSON_OK);
        else {
            int success = (bson_append_start_array(_buf, _name) == BSON_OK);
            int i;
            for (i = 0; i < len && success; i++)
                success &= (bson_append_double(_buf, numstr(i), REAL(value)[i]) == BSON_OK);
            success &= (bson_append_finish_object(_buf) == BSON_OK);
            LOGICAL(ret)[0] = success;
        }
    else {
        int success = (bson_append_start_object(_buf, _name) == BSON_OK);
        if (len == 1)
            success &= (bson_append_double(_buf, _name, asReal(value)) == BSON_OK);
        else {
            int i;
            for (i = 0; i < len && success; i++)
                success &= (bson_append_double(_buf, CHAR(STRING_ELT(names, i)), REAL(value)[i]) == BSON_OK);
            success &= (bson_append_finish_object(_buf) == BSON_OK);
        }
        LOGICAL(ret)[0] = success;
    }
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
    int len = LENGTH(value);
    SEXP names = getAttrib(value, R_NamesSymbol);
    if (names == R_NilValue)
        if (len == 1)
            LOGICAL(ret)[0] = (_bson_append_complex(_buf, _name, &COMPLEX(value)[0]) == BSON_OK);
        else {
            int success = (bson_append_start_array(_buf, _name) == BSON_OK);
            int i;
            for (i = 0; i < len && success; i++)
                success &= (_bson_append_complex(_buf, numstr(i), &COMPLEX(value)[i]) == BSON_OK);
            success &= (bson_append_finish_object(_buf) == BSON_OK);
            LOGICAL(ret)[0] = success;
        }
    else {
        int success = (bson_append_start_object(_buf, _name) == BSON_OK);
        int i;
        for (i = 0; i < len && success; i++)
            success &= (_bson_append_complex(_buf, CHAR(STRING_ELT(names, i)), &COMPLEX(value)[i]) == BSON_OK);
        success &= (bson_append_finish_object(_buf) == BSON_OK);
        LOGICAL(ret)[0] = success;
    }
    UNPROTECT(1);
    return ret;
}


SEXP mongo_bson_buffer_append_long(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    const char* _name = CHAR(STRING_ELT(name, 0));
    int len = LENGTH(value);
    SEXP names = getAttrib(value, R_NamesSymbol);
    if (names == R_NilValue)
        if (len == 1)
            LOGICAL(ret)[0] = (bson_append_long(_buf, _name, asReal(value)) == BSON_OK);
        else {
            int success = (bson_append_start_array(_buf, _name) == BSON_OK);
            int i;
            for (i = 0; i < len && success; i++)
                success &= (bson_append_long(_buf, numstr(i), REAL(value)[i]) == BSON_OK);
            success &= (bson_append_finish_object(_buf) == BSON_OK);
            LOGICAL(ret)[0] = success;
        }
    else {
        int success = (bson_append_start_object(_buf, _name) == BSON_OK);
        if (len == 1)
            success &= (bson_append_long(_buf, _name, asReal(value)) == BSON_OK);
        else {
            int i;
            for (i = 0; i < len && success; i++)
                success &= (bson_append_long(_buf, CHAR(STRING_ELT(names, i)), REAL(value)[i]) == BSON_OK);
            success &= (bson_append_finish_object(_buf) == BSON_OK);
        }
        LOGICAL(ret)[0] = success;
    }
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
    time_t _value = asInteger(value);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (bson_append_date(_buf, _name, _value) == BSON_OK);
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


SEXP mongo_bson_buffer_append_string(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    int len = LENGTH(value);
    SEXP names = getAttrib(value, R_NamesSymbol);
    if (names == R_NilValue)
        if (len == 1)
            LOGICAL(ret)[0] = (bson_append_string(_buf, _name, CHAR(STRING_ELT(value, 0))) == BSON_OK);
        else {
            int success = (bson_append_start_array(_buf, _name) == BSON_OK);
            int i;
            for (i = 0; i < len && success; i++)
                success &= (bson_append_string(_buf, numstr(i), CHAR(STRING_ELT(value, i))) == BSON_OK);
            success &= (bson_append_finish_object(_buf) == BSON_OK);
            LOGICAL(ret)[0] = success;
        }
    else {
        int success = (bson_append_start_object(_buf, _name) == BSON_OK);
        int i;
        for (i = 0; i < len && success; i++)
            success &= (bson_append_string(_buf, CHAR(STRING_ELT(names, i)), CHAR(STRING_ELT(value,i))) == BSON_OK);
        success &= (bson_append_finish_object(_buf) == BSON_OK);
        LOGICAL(ret)[0] = success;
    }

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


SEXP mongo_bson_buffer_append_code_w_scope(SEXP buf, SEXP name, SEXP value)
{
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


SEXP mongo_bson_buffer_append_regex(SEXP buf, SEXP name, SEXP value)
{
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


SEXP mongo_bson_buffer_append_binary(SEXP buf, SEXP name, SEXP value) {
    bson_buffer* _buf = _checkBuffer(buf);
    const char* _name = CHAR(STRING_ELT(name, 0));
    _checkBinary(value);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    int len = INTEGER(getAttrib(value, sym_length))[0];
    char* data = (char*)R_ExternalPtrAddr(getAttrib(value, sym_mongo_binary));
    LOGICAL(ret)[0] = (bson_append_binary(_buf, _name, INTEGER(value)[0], data, len) == BSON_OK);
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
        if (_hasClass(cls, "mongo.code.w.scope"))
            return mongo_bson_buffer_append_code_w_scope(buf, name, value);
        if (_hasClass(cls, "mongo.code"))
            return mongo_bson_buffer_append_code(buf, name, value);
        if (_hasClass(cls, "mongo.symbol"))
            return mongo_bson_buffer_append_symbol(buf, name, value);
        if (_hasClass(cls, "mongo.undefined"))
            return mongo_bson_buffer_append_undefined(buf, name);
        if (_hasClass(cls, "mongo.regex"))
            return mongo_bson_buffer_append_regex(buf, name, value);
        if (_hasClass(cls, "mongo.binary"))
            return mongo_bson_buffer_append_binary(buf, name, value);
    }
    int t = TYPEOF(value);
    switch (t) {
    case LGLSXP:  return mongo_bson_buffer_append_bool(buf, name, value);
    case INTSXP:  return mongo_bson_buffer_append_int(buf, name, value);
    case STRSXP:  return mongo_bson_buffer_append_string(buf, name, value);
    case REALSXP: return mongo_bson_buffer_append_double(buf, name, value);
    case CPLXSXP: return mongo_bson_buffer_append_complex(buf, name, value);
    case VECSXP:  return mongo_bson_buffer_append_list(buf, name, value);
    default:
        error("Unhandled R type (%d) in mongo.bson.buffer.append\n", t);
        return R_NilValue; // never reached
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

SEXP mongo_sys_time() {
    time_t t;
    time(&t);
    SEXP ret = _createPOSIXct(t);
    UNPROTECT(2);
    return ret;
}
