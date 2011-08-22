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


SEXP mongo_gridfile_create(SEXP gfs, SEXP meta) {
    gridfs* _gfs = _checkGridfs(gfs);
    bson* _meta = _checkBSON(meta);
    gridfile* gfile = Calloc(1, gridfile);
    gridfile_init(_gfs, _meta, gfile);
    return _mongo_gridfile_create(gfs, gfile);
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
    if (TYPEOF(query) == STRSXP)
        result = gridfs_find_filename(_gfs, CHAR(STRING_ELT(query, 0)), gfile);
    else {
        bson* _query = _checkBSON(query);
        result = gridfs_find_query(_gfs, _query, gfile);
    }
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
    SEXP ret = _createPOSIXct(gridfile_get_uploaddate(_gfile));
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
    bson meta = gridfile_get_metadata(_gfile);
    if (bson_size(&meta) <= 5)
        return R_NilValue;
    SEXP ret = _mongo_bson_create(&meta);
    UNPROTECT(3);
    return ret;
}


SEXP mongo_gridfile_get_chunk(SEXP gfile, SEXP i) {
    gridfile* _gfile = _checkGridfile(gfile);
    int _i = asInteger(i);
    bson meta = gridfile_get_chunk(_gfile, _i);
    if (bson_size(&meta) <= 5)
        return R_NilValue;
    SEXP ret = _mongo_bson_create(&meta);
    UNPROTECT(3);
    return ret;
}


