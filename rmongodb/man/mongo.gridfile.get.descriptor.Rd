% File rmongodb/man/mongo.gridfile.get.descriptor.Rd
\name{mongo.gridfile.get.descriptor}
\alias{mongo.gridfile.get.descriptor}
\title{Get the descriptor of a mongo.gridfile}
\description{
Get the descriptor of a \link{mongo.gridfile}.  This descriptor is the document describing the given gridfile as 
stored on the MongoDB server in the 'files' collection of the GridFS .

See \url{http://www.mongodb.org/display/DOCS/GridFS+Specification}.
}
\usage{
mongo.gridfile.get.descriptor(gridfile)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
}
\value{
(\link{mongo.bson}) The descriptor of \emph{gridfile}.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "test.R")
    print(mongo.gridfile.get.descriptor(gf))

    mongo.gridfile.destroy(gf)
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\code{\link{mongo.gridfs}},
\code{\link{mongo.gridfs.find}},
\link{mongo.gridfile},
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
\code{\link{mongo.gridfile.seek}},
\code{\link{mongo.gridfile.pipe}}
}
