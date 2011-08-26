% File rmongodb/man/mongo.gridfile.get.chunks.Rd
\name{mongo.gridfile.get.chunks}
\alias{mongo.gridfile.get.chunks}
\title{Get a cursor for a range of chunks in a mongo.gridfile}
\description{
Get a \link{mongo.cursor} for a range of chunks in a \link{mongo.gridfile}.
}
\usage{
mongo.gridfile.get.chunks(gridfile, start, count)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
\item{start}{(integer) The index of the first chunk to fetch. 
This should be in the range 0 to \code{\link{mongo.gridfile.get.chunk.count}(gridfile) - 1}.}
\item{count}{(integer) The number of chunks to fetch.}
}
\value{
(\link{mongo.cursor}) A cursor to be used to step through the requested chunks.

The values returned by \code{\link{mongo.cursor.value}()} will be consecutive documents in the 'chunks' collection of the GridFS.  The 'data' field of these
documents contains the actual data belonging to the chunk.  See \url{http://www.mongodb.org/display/DOCS/GridFS+Specification}.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "rmongodb.pdf")
    cursor <- mongo.gridfile.get.chunks(gf, 1, 2)

    f <- file("rmongodb.pdf.chunks12", "wb")
    while (mongo.cursor.next(cursor)) {
        chunk <- mongo.cursor.value(cursor)
        iter <- mongo.bson.find(chunk, "data")

        # write the binary (raw) data to the file
        writeBin(mongo.bson.iterator.value(iter), f)
    }
    close(f)
    mongo.gridfile.destroy(gf)
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\code{\link{mongo.gridfs}},\cr
\code{\link{mongo.gridfs.find}},\cr
\link{mongo.gridfile},\cr
\code{\link{mongo.gridfile.get.descriptor}},\cr
\code{\link{mongo.gridfile.get.filename}},\cr
\code{\link{mongo.gridfile.get.length}},\cr
\code{\link{mongo.gridfile.get.chunk.size}},\cr
\code{\link{mongo.gridfile.get.chunk.count}},\cr
\code{\link{mongo.gridfile.get.content.type}},\cr
\code{\link{mongo.gridfile.get.upload.date}},\cr
\code{\link{mongo.gridfile.get.md5}},\cr
\code{\link{mongo.gridfile.get.metadata}},\cr
\code{\link{mongo.gridfile.get.chunk}},\cr
\code{\link{mongo.gridfile.read}},\cr
\code{\link{mongo.gridfile.seek}},\cr
\code{\link{mongo.gridfile.pipe}}.
}
