% File rmongodb/man/mongo.gridfile.seek.Rd
\name{mongo.gridfile.seek}
\alias{mongo.gridfile.seek}
\title{Seek to a position in a mongo.gridfile}
\description{
Seek to a position in a \link{mongo.gridfile}.  
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
(double) The position set.  This may be at the length of the GridFS file if \emph{offset} was greater than that.
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
\code{\link{mongo.gridfs}},
\code{\link{mongo.gridfs.find}},
\link{mongo.gridfile},
\code{\link{mongo.gridfile.get.descriptor}},
\code{\link{mongo.gridfile.get.filename}},
\code{\link{mongo.gridfile.get.length}},
\code{\link{mongo.gridfile.get.chunk.size}},
\code{\link{mongo.gridfile.get.chunk.count}},
\code{\link{mongo.gridfile.get.content.type}},
\code{\link{mongo.gridfile.get.upload.date}},
\code{\link{mongo.gridfile.get.md5}},
\code{\link{mongo.gridfile.get.metadata}},
\code{\link{mongo.gridfile.get.chunk}},
\code{\link{mongo.gridfile.get.chunks}},
\code{\link{mongo.gridfile.read}},
\code{\link{mongo.gridfile.pipe}}
}
