% File rmongodb/man/mongo.gridfile.seek.Rd
\name{mongo.gridfile.seek}
\alias{mongo.gridfile.seek}
\title{Seek to a position in a mongo.gridfile}
\description{
Seek to a position in a \link{mongo.gridfile}.\cr
This sets the position at which the next \code{\link{mongo.gridfile.read}()} will start.
}
\usage{
mongo.gridfile.seek(gridfile, offset)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
\item{offset}{(as.double) The position to which to seek.}
}
\value{
(double) The position set.  This may be at the length of the GridFS file if \code{offset} was greater than that.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "rmongodb.pdf")
    mongo.gridfile.seek(gf, 256*256*5)
    data <- mongo.gridfile.read(gf, 16384)

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
\code{\link{mongo.gridfile.get.chunks}},\cr
\code{\link{mongo.gridfile.read}},\cr
\code{\link{mongo.gridfile.pipe}}.
}
