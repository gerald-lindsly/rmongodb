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
#include <Rinternals.h>

#include "gridfs.h"

SEXP mongo_gridfs_create(SEXP mongo_conn, SEXP db, SEXP prefix);
SEXP mongo_gridfs_destroy(SEXP gfs);
SEXP mongo_gridfs_store_file(SEXP gfs, SEXP filename, SEXP remotename, SEXP contenttype);
SEXP mongo_gridfs_store(SEXP gfs, SEXP raw, SEXP remotename, SEXP contenttype);
SEXP mongo_gridfs_remove_file(SEXP gfs, SEXP filename);
SEXP mongo_gridfile_writer_create(SEXP gfs, SEXP remotename, SEXP contenttype);
SEXP mongo_gridfile_writer_write(SEXP gfw, SEXP raw);
SEXP mongo_gridfile_writer_finish(SEXP gfw);
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
SEXP mongo_gridfile_get_chunks(SEXP gfile, SEXP start, SEXP count);
SEXP mongo_gridfile_read(SEXP gfile, SEXP size);
SEXP mongo_gridfile_seek(SEXP gfile, SEXP offset);
