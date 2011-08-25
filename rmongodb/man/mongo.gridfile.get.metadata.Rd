% File rmongodb/man/mongo.gridfile.get.metadata.Rd
\name{mongo.gridfile.get.metadata}
\alias{mongo.gridfile.get.metadata}
\title{Get the metadata of a mongo.gridfile}
\description{
Get the metadata of a \link{mongo.gridfile}.  Some applications may store metadata pertaining to a GridFS file in the "metadata" field of the 
descriptor.  (See \code{\link{mongo.gridfile.get.descriptor}()}.  This function retrieves that field as a \link{mongo.bson} object.
}
\usage{
mongo.gridfile.get.metadata(gridfile)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
}
\value{
(\link{mongo.bson}) The metadata of \emph{gridfile} if present; otherwise, NULL.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "test.R")
    print(mongo.gridfile.get.metadata(gf))

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
\code{\link{mongo.gridfile.get.chunk}},
\code{\link{mongo.gridfile.get.chunks}},
\code{\link{mongo.gridfile.read}},
\code{\link{mongo.gridfile.seek}},
\code{\link{mongo.gridfile.pipe}}
}
