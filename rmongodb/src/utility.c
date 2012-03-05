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
#include <Rinternals.h>
#include "utility.h"
#include "symbols.h"
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
    if (b == R_NilValue)
        return 0;
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


mongo* _checkMongo(SEXP mongo_conn) {
    _checkClass(mongo_conn, "mongo");
    SEXP ptr = getAttrib(mongo_conn, sym_mongo);
    if (ptr == R_NilValue)
        error("Attribute \"mongo\" is missing from mongo class object\n");
    mongo* conn = (mongo*)R_ExternalPtrAddr(ptr);
    if (!conn)
        error("mongo connection object appears to have been destroyed.\n");
    return conn;
}


SEXP _createPOSIXct(double t) {
    SEXP ret, cls;
    PROTECT(ret = allocVector(REALSXP, 1));
    REAL(ret)[0] = t;
    PROTECT(cls = allocVector(STRSXP, 2));
    SET_STRING_ELT(cls, 0, mkChar("POSIXct"));
    SET_STRING_ELT(cls, 1, mkChar("POSIXt"));
    classgets(ret, cls);
    return ret;
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


static void mongoCursorFinalizer(SEXP ptr) {
    if (!R_ExternalPtrAddr(ptr)) return;
    mongo_cursor* cursor = (mongo_cursor*)R_ExternalPtrAddr(ptr);
    mongo_cursor_destroy(cursor);
    R_ClearExternalPtr(ptr); /* not really needed */
}


SEXP _mongo_cursor_create(mongo_cursor* cursor) {
    SEXP ret, ptr, cls;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
    ptr = R_MakeExternalPtr(cursor, sym_mongo_cursor, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, mongoCursorFinalizer, TRUE);
    setAttrib(ret, sym_mongo_cursor, ptr);
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.cursor"));
    classgets(ret, cls);
    UNPROTECT(3);
    return ret;
}


