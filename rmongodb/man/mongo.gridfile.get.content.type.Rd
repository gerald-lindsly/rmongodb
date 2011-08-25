% File rmongodb/man/mongo.gridfile.get.content.type.Rd
\name{mongo.gridfile.get.content.type}
\alias{mongo.gridfile.get.content.type}
\title{Get the content type of a mongo.gridfile}
\description{
Get the MIME content type of a \link{mongo.gridfile}.
}
\usage{
mongo.gridfile.get.content.type(gridfile)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
}
\value{
(string) The content.type (remote name) of \emph{gridfile}.
This may be an empty string if no content type is associated with the gridfile.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "test.R")
    print(mongo.gridfile.get.content.type(gf))

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
\code{\link{mongo.gridfile.get.upload.date}},
\code{\link{mongo.gridfile.get.md5}},
\code{\link{mongo.gridfile.get.metadata}},
\code{\link{mongo.gridfile.get.chunk}},
\code{\link{mongo.gridfile.get.chunks}},
\code{\link{mongo.gridfile.read}},
\code{\link{mongo.gridfile.seek}},
\code{\link{mongo.gridfile.pipe}}
}
