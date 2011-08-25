% File rmongodb/man/mongo.gridfile.get.chunk.count.Rd
\name{mongo.gridfile.get.chunk.count}
\alias{mongo.gridfile.get.chunk.count}
\title{Get the chunk count of a mongo.gridfile}
\description{
Get the chunk count of a \link{mongo.gridfile}.
This is the number of chunks into which the gridfile is broken up on the server.
}
\usage{
mongo.gridfile.get.chunk.count(gridfile)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
}
\value{
(integer) The chunk count of \emph{gridfile}
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "test.R")
    print(mongo.gridfile.get.chunk.count(gf))

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
\code{\link{mongo.gridfile.get.content.type}},
\code{\link{mongo.gridfile.get.upload.date}},
\code{\link{mongo.gridfile.get.md5}},
\code{\link{mongo.gridfile.get.metadata}},
\code{\link{mongo.gridfile.get.chunk}},
\code{\link{mongo.gridfile.get.chunks}},
\code{\link{mongo.gridfile.read}},
\code{\link{mongo.gridfile.seek}},
\code{\link{mongo.gridfile.pipe}}
}
