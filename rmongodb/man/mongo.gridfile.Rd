% File rmongodb/man/mongo.gridfile.Rd
\name{mongo.gridfile}
\docType{class}
\alias{mongo.gridfile}
\title{The mongo.gridfile class}
\description{
Objects of class "mongo.gridfile" are used to access gridfiles on a 
MongoDB server.  They are created by \code{\link{mongo.gridfs.find}()}.

mongo.gridfile objects have "mongo.gridfile" as their class and
contain an externally managed pointer to the actual data used to manage operations on the gridfile.
This pointer is stored in the "mongo.gridfile" attribute of the object.  The object also has a "mongo.gridfs" attribute
holding a pointer to the mongo.gridfs object used in creation to prevent garbage collection on the mongo.gridfs
object while the mongo.gridfile is still active.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "test.R")
    test.R <- file("test2.R")
    mongo.gridfile.pipe(gf, test.R)

    mongo.gridfile.destroy(gf)
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\code{\link{mongo.gridfs}},\cr
\code{\link{mongo.gridfs.find}},\cr
\code{\link{mongo.gridfile.get.filename}},\cr
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
\code{\link{mongo.gridfile.seek}},\cr
\code{\link{mongo.gridfile.pipe}}.
}
