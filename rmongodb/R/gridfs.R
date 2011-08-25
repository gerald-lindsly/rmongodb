mongo.gridfs.create <- function(mongo, db, prefix="fs")
    .Call(".mongo.gridfs.create", mongo, db, prefix)

mongo.gridfs.destroy <- function(gridfs)
    .Call(".mongo.gridfs.destroy", gridfs)

mongo.gridfs.store.file <- function(gridfs, filename, remotename="", contenttype="")
    .Call(".mongo.gridfs.store.file", gridfs, filename, remotename, contenttype)

mongo.gridfs.remove.file <- function(gridfs, remotename)
    .Call(".mongo.gridfs.remove.file", gridfs, remotename)

mongo.gridfs.store <- function(gridfs, raw, remotename, contenttype="")
    .Call(".mongo.gridfs.store", gridfs, raw, remotename, contenttype)

mongo.gridfile.writer.create <- function(gridfs, remotename, contenttype="")
    .Call(".mongo.gridfile.writer.create", gridfs, remotename, contenttype)

mongo.gridfile.writer.write <- function(gfw, raw)
    .Call(".mongo.gridfile.writer.write", gfw, raw)

mongo.gridfile.writer.finish <- function(gfw)
    .Call(".mongo.gridfile.writer.finish", gfw)

mongo.gridfs.find <- function(gridfs, query)
    .Call(".mongo.gridfs.find", gridfs, query)

mongo.gridfile.destroy <- function(gridfile)
    .Call(".mongo.gridfile.destroy", gridfile)

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

mongo.gridfile.get.chunks <- function(gridfile, start, count)
    .Call(".mongo.gridfile.get.chunks", gridfile, start, count)

mongo.gridfile.read <- function(gridfile, size)
    .Call(".mongo.gridfile.read", gridfile, size)

mongo.gridfile.seek <- function(gridfile, offset)
    .Call(".mongo.gridfile.get.chunk", gridfile, offset)

mongo.gridfile.pipe <- function(gridfile, con) {
    wasOpen <- isOpen(con)
    if (!wasOpen)
        open(con, "wb")
    count <- mongo.gridfile.get.chunk.count(gridfile)
    cursor <- mongo.gridfile.get.chunks(gridfile, 0, count)
    while (mongo.cursor.next(cursor)) {
        b <- mongo.cursor.value(cursor);
        iter <- mongo.bson.find(b, "data")
        data <- mongo.bson.iterator.value(iter)
        writeBin(as.vector(data), con)
        mongo.bson.destroy(b)
    }
    if (!wasOpen)
        close(con)
    mongo.cursor.destroy(cursor)
    NULL
}

