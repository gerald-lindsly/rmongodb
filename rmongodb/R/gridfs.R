mongo.gridfs.create <- function(mongo, db, prefix="fs")
    .Call(".mongo.gridfs.create", mongo, db, prefix)

mongo.gridfs.destroy <- function(gfs)
    .Call(".mongo.gridfs.destroy", gfs)

mongo.gridfs.store.file <- function(gfs, filename, remotename="", contenttype="")
    .Call(".mongo.gridfs.store.file", gfs, filename, remotename, contenttype)

mongo.gridfs.remove.file <- function(gfs, filename)
    .Call(".mongo.gridfs.remove.file", gfs, filename)

mongo.gridfile.create <- function(gfs, meta)
    .Call(".mongo.gridfile.create", gfs, meta)

mongo.gridfile.destroy <- function(gridfile)
    .Call(".mongo.gridfile.destroy", gridfile)

mongo.gridfs.find <- function(gfs, query)
    .Call(".mongo.gridfs.find", gfs, query)

mongo.gridfile.get.descriptor <- function(gridfile)
    .Call(".mongo.gridfile.get.descriptor", gridfile)

mongo.gridfile.get.filename <- function(gridfile)
    .Call(".mongo.gridfile.get.filename", gridfile)

mongo.gridfile.get.length <- function(gridfile)
    .Call(".mongo.gridfile.get.length", gridfile)

mongo.gridfile.get.chunk.size <- function(gridfile)
    .Call(".mongo.gridfile.get.chunk.size", gridfile)

mongo.gridfile.get.chunk.count <- function(gridfile)
    .Call(".mongo.gridfile.get.chunk.count", gridfile)

mongo.gridfile.get.content.type <- function(gridfile)
    .Call(".mongo.gridfile.get.content.type", gridfile)

mongo.gridfile.get.upload.date <- function(gridfile)
    .Call(".mongo.gridfile.get.upload.date", gridfile)

mongo.gridfile.get.md5 <- function(gridfile)
    .Call(".mongo.gridfile.get.md5", gridfile)

mongo.gridfile.get.metadata <- function(gridfile)
    .Call(".mongo.gridfile.get.metadata", gridfile)

mongo.gridfile.get.chunk <- function(gridfile, i)
    .Call(".mongo.gridfile.get.chunk", gridfile, i)

