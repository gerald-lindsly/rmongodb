% File rmongodb/man/mongo.gridfile.read.Rd
\name{mongo.gridfile.read}
\alias{mongo.gridfile.read}
\title{Read raw data from a mongo.gridfile}
\description{
Read raw data from a \link{mongo.gridfile}.  The data read may span multiple chunks.

A mongo.gridfile file maintains a current read position which is advanced by the size of each read.  
This position is initially at offset 0.

Since this function returns raw data, you may want to use R's \code{readBin()} to unpack it.
}
\usage{
mongo.gridfile.read(gridfile, size)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
\item{size}{(as.double) The number of bytes to read.}
}
\value{
(raw) The data read from emph{gridfile}.
The length of this vector may be less than the requested size
if there was not enough data remaining to be read.
This length could also be 0 if an error occured during the operation.
Check \code{\link{mongo.get.err}()} of the associated mongo connection object in this case.
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
\code{\link{mongo.gridfile.seek}},
\code{\link{mongo.gridfile.pipe}}
}
