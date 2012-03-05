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
#include "api_gridfs.h"
#include "symbols.h"
#include "utility.h"

gridfs* _checkGridfs(SEXP gfs) {
    _checkClass(gfs, "mongo.gridfs");
    SEXP ptr = getAttrib(gfs, sym_mongo_gridfs);
    if (ptr == R_NilValue)
        error("Attribute \"mongo.gridfs\" is missing from mongo.gridfs class object\n");
    gridfs* _gfs = (gridfs*)R_ExternalPtrAddr(ptr);
    if (!_gfs)
        error("mongo.gridfs object appears to have been destroyed.\n");
    return _gfs;
}


gridfile* _checkGridfile(SEXP gfile) {
    _checkClass(gfile, "mongo.gridfile");
    SEXP ptr = getAttrib(gfile, sym_mongo_gridfile);
    if (ptr == R_NilValue)
        error("Attribute \"mongo.gridfile\" is missing from mongo.gridfile class object\n");
    gridfile* _gfile = (gridfile*)R_ExternalPtrAddr(ptr);
    if (!_gfile)
        error("mongo.gridfile object appears to have been destroyed.\n");
    return _gfile;
}


static void mongoGridfsFinalizer(SEXP ptr) {
    if (!R_ExternalPtrAddr(ptr)) return;
    gridfs_destroy((gridfs*)R_ExternalPtrAddr(ptr));
    R_ClearExternalPtr(ptr);
}


SEXP mongo_gridfs_create(SEXP mongo_conn, SEXP db, SEXP prefix) {
    mongo* conn = _checkMongo(mongo_conn);
    const char* _db = CHAR(STRING_ELT(db, 0));
    const char* _prefix = CHAR(STRING_ELT(prefix, 0));
    gridfs* gfs = Calloc(1, gridfs);
    if (gridfs_init(conn, _db, _prefix, gfs) != MONGO_OK) {
        Free(gfs);
        return R_NilValue;
    }
    SEXP ret, ptr, cls;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
    /* prevent GC on connection object while gfs alive */
    setAttrib(ret, sym_mongo, mongo_conn);
    ptr = R_MakeExternalPtr(gfs, sym_mongo_gridfs, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, mongoGridfsFinalizer, TRUE);
    setAttrib(ret, sym_mongo_gridfs, ptr);
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.gridfs"));
    classgets(ret, cls);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_gridfs_destroy(SEXP gfs) {
    gridfs* _gfs = _checkGridfs(gfs);
    gridfs_destroy(_gfs);
    R_ClearExternalPtr(getAttrib(gfs, sym_mongo_gridfs));
    return R_NilValue;
}


SEXP mongo_gridfs_store_file(SEXP gfs, SEXP filename, SEXP remotename, SEXP contenttype) {
    gridfs* _gfs = _checkGridfs(gfs);
    const char* _filename = CHAR(STRING_ELT(filename, 0));
    const char* _remotename = CHAR(STRING_ELT(remotename, 0));
    const char* _contenttype = CHAR(STRING_ELT(contenttype, 0));
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (gridfs_store_file(_gfs, _filename, _remotename, _contenttype) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_gridfs_remove_file(SEXP gfs, SEXP filename) {
    gridfs* _gfs = _checkGridfs(gfs);
    const char* _filename = CHAR(STRING_ELT(filename, 0));
    gridfs_remove_filename(_gfs, _filename);
    return R_NilValue;
}


static void mongoGridfileFinalizer(SEXP ptr) {
    if (!R_ExternalPtrAddr(ptr)) return;
    gridfile_destroy((gridfile*)R_ExternalPtrAddr(ptr));
    R_ClearExternalPtr(ptr);
}


SEXP _mongo_gridfile_create(SEXP gfs, gridfile* gfile) {
    SEXP ret, ptr, cls;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
    /* prevent GC on gridfs object while gridfile alive */
    setAttrib(ret, sym_mongo_gridfs, gfs);
    ptr = R_MakeExternalPtr(gfile, sym_mongo_gridfile, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, mongoGridfileFinalizer, TRUE);
    setAttrib(ret, sym_mongo_gridfile, ptr);
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.gridfile"));
    classgets(ret, cls);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_gridfile_writer_create(SEXP gfs, SEXP remotename, SEXP contenttype) {
    gridfs* _gfs = _checkGridfs(gfs);
    const char* _remotename = CHAR(STRING_ELT(remotename, 0));
    const char* _contenttype = CHAR(STRING_ELT(contenttype, 0));
    gridfile* gfile = Calloc(1, gridfile);

    SEXP ret, ptr, cls;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = 0;
    /* prevent GC on gridfs object while gridfile alive */
    setAttrib(ret, sym_mongo_gridfs, gfs);
    ptr = R_MakeExternalPtr(gfile, sym_mongo_gridfile, R_NilValue);
    PROTECT(ptr);
    R_RegisterCFinalizerEx(ptr, mongoGridfileFinalizer, TRUE);
    setAttrib(ret, sym_mongo_gridfile, ptr);
    PROTECT(cls = allocVector(STRSXP, 1));
    SET_STRING_ELT(cls, 0, mkChar("mongo.gridfile.writer"));
    classgets(ret, cls);
    gridfile_writer_init(gfile, _gfs, _remotename, _contenttype);
    UNPROTECT(3);
    return ret;
}

gridfile* _checkGridfileWriter(SEXP gfw) {
    _checkClass(gfw, "mongo.gridfile.writer");
    SEXP ptr = getAttrib(gfw, sym_mongo_gridfile);
    if (ptr == R_NilValue)
        error("Expected a \"mongo.gridfile\" attribute in object\n");
    gridfile* _gfile = (gridfile*)R_ExternalPtrAddr(ptr);
    if (!_gfile)
        error("mongo.grdfile.writer object appears to have been finished.\n");
    return _gfile;
}


SEXP mongo_gridfile_writer_write(SEXP gfw, SEXP raw) {
    gridfile* gfile = _checkGridfileWriter(gfw);
    int len = LENGTH(raw);
    if (len) gridfile_write_buffer(gfile, (char*)RAW(raw), len);
    return R_NilValue;
}


SEXP mongo_gridfile_writer_finish(SEXP gfw) {
    gridfile* gfile = _checkGridfileWriter(gfw);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (gridfile_writer_done(gfile) == MONGO_OK);
    Free(gfile);
    R_ClearExternalPtr(getAttrib(gfw, sym_mongo_gridfile));
    UNPROTECT(1);
    return ret;
}


SEXP mongo_gridfs_store(SEXP gfs, SEXP raw, SEXP remotename, SEXP contenttype) {
    gridfs* _gfs = _checkGridfs(gfs);
    const char* _remotename = CHAR(STRING_ELT(remotename, 0));
    const char* _contenttype = CHAR(STRING_ELT(contenttype, 0));
    int len = LENGTH(raw);
    SEXP ret;
    PROTECT(ret = allocVector(LGLSXP, 1));
    LOGICAL(ret)[0] = (gridfs_store_buffer(_gfs, (char*)RAW(raw), len, _remotename, _contenttype) == MONGO_OK);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_gridfile_destroy(SEXP gfile) {
    gridfile* _gfile = _checkGridfile(gfile);
    gridfile_destroy(_gfile);
    R_ClearExternalPtr(getAttrib(gfile, sym_mongo_gridfile));
    return R_NilValue;
}


SEXP mongo_gridfs_find(SEXP gfs, SEXP query) {
    gridfs* _gfs = _checkGridfs(gfs);
    gridfile* gfile = Calloc(1, gridfile);
    int result;
    if (_isBSON(query)) {
        bson* _query = _checkBSON(query);
        result = gridfs_find_query(_gfs, _query, gfile);
    }
    else
        result = gridfs_find_filename(_gfs, CHAR(STRING_ELT(query, 0)), gfile);
    if (result != MONGO_OK)
        return R_NilValue;
    return _mongo_gridfile_create(gfs, gfile);
}


SEXP mongo_gridfile_get_filename(SEXP gfile) {
    gridfile* _gfile = _checkGridfile(gfile);
    SEXP ret;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar(gridfile_get_filename(_gfile)));
    UNPROTECT(1);
    return ret;
}


SEXP mongo_gridfile_get_length(SEXP gfile) {
    gridfile* _gfile = _checkGridfile(gfile);
    SEXP ret;
    PROTECT(ret = allocVector(REALSXP, 1));
    REAL(ret)[0] = gridfile_get_contentlength(_gfile);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_gridfile_get_chunk_size(SEXP gfile) {
    gridfile* _gfile = _checkGridfile(gfile);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = gridfile_get_chunksize(_gfile);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_gridfile_get_chunk_count(SEXP gfile) {
    gridfile* _gfile = _checkGridfile(gfile);
    SEXP ret;
    PROTECT(ret = allocVector(INTSXP, 1));
    INTEGER(ret)[0] = gridfile_get_numchunks(_gfile);
    UNPROTECT(1);
    return ret;
}


SEXP mongo_gridfile_get_content_type(SEXP gfile) {
    gridfile* _gfile = _checkGridfile(gfile);
    SEXP ret;
    PROTECT(ret = allocVector(STRSXP, 1));
    const char* type = gridfile_get_contenttype(_gfile);
    static const char empty[] = "";
    if (type == NULL)
        type = empty;
    SET_STRING_ELT(ret, 0, mkChar(type));
    UNPROTECT(1);
    return ret;
}


SEXP mongo_gridfile_get_upload_date(SEXP gfile) {
    gridfile* _gfile = _checkGridfile(gfile);
    SEXP ret = _createPOSIXct((double)gridfile_get_uploaddate(_gfile) / 1000);
    UNPROTECT(2);
    return ret;
}


SEXP mongo_gridfile_get_md5(SEXP gfile) {
    gridfile* _gfile = _checkGridfile(gfile);
    SEXP ret;
    PROTECT(ret = allocVector(STRSXP, 1));
    SET_STRING_ELT(ret, 0, mkChar(gridfile_get_md5(_gfile)));
    UNPROTECT(1);
    return ret;
}


SEXP mongo_gridfile_get_descriptor(SEXP gfile) {
    gridfile* _gfile = _checkGridfile(gfile);
    if (bson_size(_gfile->meta) <= 5)
        return R_NilValue;
    SEXP ret = _mongo_bson_create(_gfile->meta);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_gridfile_get_metadata(SEXP gfile) {
    gridfile* _gfile = _checkGridfile(gfile);
    bson meta;
    gridfile_get_metadata(_gfile, &meta);
    if (bson_size(&meta) <= 5)
        return R_NilValue;
    SEXP ret = _mongo_bson_create(&meta);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_gridfile_get_chunk(SEXP gfile, SEXP i) {
    gridfile* _gfile = _checkGridfile(gfile);
    int _i = asInteger(i);
    bson chunk;
    gridfile_get_chunk(_gfile, _i, &chunk);
    if (bson_size(&chunk) <= 5)
        return R_NilValue;
    SEXP ret = _mongo_bson_create(&chunk);
    bson_destroy(&chunk);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_gridfile_get_chunks(SEXP gfile, SEXP start, SEXP count) {
    gridfile* _gfile = _checkGridfile(gfile);
    int _start = asInteger(start);
    int _count = asInteger(count);
    mongo_cursor* cursor = gridfile_get_chunks(_gfile, _start, _count);
    return _mongo_cursor_create(cursor);
}


SEXP mongo_gridfile_read(SEXP gfile, SEXP size) {
    gridfile* _gfile = _checkGridfile(gfile);
    gridfs_offset _size = asReal(size);
    gridfs_offset remaining = gridfile_get_contentlength(_gfile) - _gfile->pos;
    if (_size > remaining) _size = remaining;
    SEXP ret;
    PROTECT(ret = allocVector(RAWSXP, _size));
    if (_size) gridfile_read(_gfile, _size, (char*)RAW(ret));
    UNPROTECT(1);
    return ret;
}


SEXP mongo_gridfile_seek(SEXP gfile, SEXP offset) {
    gridfile* _gfile = _checkGridfile(gfile);
    gridfs_offset _offset = asReal(offset);
    SEXP ret;
    PROTECT(ret = allocVector(REALSXP, 1));
    REAL(ret)[0] = gridfile_seek(_gfile, _offset);
    return ret;
}
