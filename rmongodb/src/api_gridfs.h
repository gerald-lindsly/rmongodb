#include <Rinternals.h>

#include "gridfs.h"

SEXP mongo_gridfs_create(SEXP mongo_conn, SEXP db, SEXP prefix);
SEXP mongo_gridfs_destroy(SEXP gfs);
SEXP mongo_gridfs_store_file(SEXP gfs, SEXP filename, SEXP remotename, SEXP contenttype);
SEXP mongo_gridfs_remove_file(SEXP gfs, SEXP filename);
SEXP mongo_gridfile_create(SEXP gfs, SEXP meta);
SEXP mongo_gridfile_destroy(SEXP gfile);
SEXP mongo_gridfs_find(SEXP gfs, SEXP query);
SEXP mongo_gridfile_get_descriptor(SEXP gfile);
SEXP mongo_gridfile_get_filename(SEXP gfile);
SEXP mongo_gridfile_get_chunk_size(SEXP gfile);
SEXP mongo_gridfile_get_chunk_count(SEXP gfile);
SEXP mongo_gridfile_get_length(SEXP gfile);
SEXP mongo_gridfile_get_content_type(SEXP gfile);
SEXP mongo_gridfile_get_upload_date(SEXP gfile);
SEXP mongo_gridfile_get_md5(SEXP gfile);
SEXP mongo_gridfile_get_metadata(SEXP gfile);
SEXP mongo_gridfile_get_chunk(SEXP gfile, SEXP i);
