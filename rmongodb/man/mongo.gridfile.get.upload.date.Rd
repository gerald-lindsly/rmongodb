% File rmongodb/man/mongo.gridfile.get.upload.date.Rd
\name{mongo.gridfile.get.upload.date}
\alias{mongo.gridfile.get.upload.date}
\title{Get the upload date of a mongo.gridfile}
\description{
Get the upload date of a \link{mongo.gridfile}.
}
\usage{
mongo.gridfile.get.upload.date(gridfile)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
}
\value{
(POSIXct) The upload date/time of \emph{gridfile}.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "test.R")
    print(mongo.gridfile.get.upload.date(gf))

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
\code{\link{mongo.gridfile.get.md5}},
\code{\link{mongo.gridfile.get.metadata}},
\code{\link{mongo.gridfile.get.chunk}},
\code{\link{mongo.gridfile.get.chunks}},
\code{\link{mongo.gridfile.read}},
\code{\link{mongo.gridfile.seek}},
\code{\link{mongo.gridfile.pipe}}
}
