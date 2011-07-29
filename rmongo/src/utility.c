#include "utility.h"

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


void _checkBSON(SEXP b) {
    _checkClass(b, "mongo.bson");
}


int _isBSON(SEXP b) {
    return _objHasClass(b, "mongo.bson");
}

