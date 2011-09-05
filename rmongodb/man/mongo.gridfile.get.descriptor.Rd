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
(\link{mongo.bson}) The descriptor of \code{gridfile}.
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
\code{\link{mongo.gridfs}},\cr
\code{\link{mongo.gridfs.find}},\cr
\link{mongo.gridfile},\cr
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
\code{\link{mongo.gridfile.seek}},\cr
\code{\link{mongo.gridfile.pipe}}.
}
