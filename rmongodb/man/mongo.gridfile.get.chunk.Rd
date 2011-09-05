% File rmongodb/man/mongo.gridfile.get.chunk.Rd
\name{mongo.gridfile.get.chunk}
\alias{mongo.gridfile.get.chunk}
\title{Get a chunk of a mongo.gridfile}
\description{
Get a chunk of a \link{mongo.gridfile}.
}
\usage{
mongo.gridfile.get.chunk(gridfile, i)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
\item{i}{(integer) The index of the chunk to fetch. 
This should be in the range 0 to \code{\link{mongo.gridfile.get.chunk.count}(gridfile) - 1}.}
}
\value{
(\link{mongo.bson}) the \code{i}th chunk of \code{gridfile} if successful; otherwise, NULL.

The value returned is the \code{i}th document in the 'chunks' collection of the GridFS.  The 'data' field of this
document contains the actual data belonging to the chunk.\cr
See \url{http://www.mongodb.org/display/DOCS/GridFS+Specification}.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "test.R")
    chunk <- mongo.gridfile.get.chunk(gf, 0)
    iter <- mongo.bson.find(chunk, "data")

    f <- file("testChunk0.R", "wb")
    # write the binary (raw) data to a file
    writeBin(mongo.bson.iterator.value(iter), f)
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
\code{\link{mongo.gridfile.get.chunks}},\cr
\code{\link{mongo.gridfile.read}},\cr
\code{\link{mongo.gridfile.seek}},\cr
\code{\link{mongo.gridfile.pipe}}.
}
