% File rmongodb/man/mongo.gridfile.pipe.Rd
\name{mongo.gridfile.pipe}
\alias{mongo.gridfile.pipe}
\title{Pipe a mongo.gridfile to an R connection}
\description{
Pipe a mongo.gridfile to an R connection.  This outputs the entire GridFS file to a connection.
If the connection is open, it must be in binary output mode; 
otherwise, the connection is opened in binary output mode and closed afterwards.
}
\usage{
mongo.gridfile.pipe(gridfile, con)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
\item{con}{(connection) An R connection object.}
}
\value{
NULL
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "rmongodb.pdf")
    if (!is.null(gf)) {
        f <- file("mongodb_copy.pdf")
        mongo.gridfile.pipe(gf, f)
    }

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
\code{\link{mongo.gridfile.seek}}
}
