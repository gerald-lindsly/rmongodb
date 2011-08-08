#include "utility.h"
#include "symbols.h"
#include <Rinternals.h>
#include <string.h>


int _hasClass(SEXP cls, const char* name) {
    int len = LENGTH(cls);
    int i;
    for (i = 0; i < len; i++)
        if (strcmp(CHAR(STRING_ELT(cls, i)), name) == 0)
            return 1;
    return 0;
}


int _objHasClass(SEXP b, const char* name) {
    SEXP cls = getAttrib(b, R_ClassSymbol);
    return cls != R_NilValue && _hasClass(cls, name);
}


void _checkClass(SEXP b, const char* name) {
    if (!_objHasClass(b, name))
        error("Expected an object with class '%s'\n", name);
}


bson* _checkBSON(SEXP b) {
    _checkClass(b, "mongo.bson");
    SEXP ptr = getAttrib(b, sym_mongo_bson);
    if (ptr == R_NilValue)
        error("Expected a \"mongo.bson\" attribute in object\n");
    bson* _b = (bson*)R_ExternalPtrAddr(ptr);
    if (!_b)
        error("mongo.bson object appears to have been destroyed.\n");
    return _b;
}


int _isBSON(SEXP b) {
    return _objHasClass(b, "mongo.bson");
}

