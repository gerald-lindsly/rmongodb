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
\code{\link{mongo.gridfile.seek}}.
}
