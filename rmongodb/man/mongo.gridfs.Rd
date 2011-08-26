% File rmongodb/man/mongo.gridfs.Rd
\name{mongo.gridfs}
\docType{class}
\alias{mongo.gridfs}
\title{The mongo.gridfs class}
\description{
Objects of class "mongo.gridfs" are used to store and/or access a "Grid File System" (GridFS) on a 
MongoDB server.  While primarily intended to store large documents that won't fit on the server as
a single BSON object, GridFS may also be used to store large numbers of smaller files.

See \url{http://www.mongodb.org/display/DOCS/GridFS} and\cr
\url{http://www.mongodb.org/display/DOCS/When+to+use+GridFS}.

mongo.gridfs objects have "mongo.gridfs" as their class and
contain an externally managed pointer to the actual data used to manage operations on the GridFS.\cr
This pointer is stored in the "mongo.gridfs" attribute of the object.  The object also has a "mongo" attribute
holding a pointer to the mongo connection object used in creation to prevent garbage collection on the mongo
object while the mongo.gridfile is still active.

Objects of class "\link{mongo.gridfile}" are used to access gridfiles and read from them.

Objects of class "\link{mongo.gridfile.writer}" are used to write data to the GridFS.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")
    # Copy a local file to the server as a GridFS file
    mongo.gridfs.store.file(gridfs, "../test.R", "test.R")

    # locate the file on the server
    gf <- mongo.gridfs.find(gridfs, "test.R")
    print(gf)
    # and pipe it to an R connection object
    test.R <- file("test2.R")
    mongo.gridfile.pipe(gf, test.R)

    mongo.gridfile.destroy(gf)
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\code{\link{mongo.gridfs.destroy}},\cr
\code{\link{mongo.gridfs.store.file}},\cr
\code{\link{mongo.gridfs.remove.file}},\cr
\code{\link{mongo.gridfs.store}},\cr
\code{\link{mongo.gridfile.writer.create}},\cr
\code{\link{mongo.gridfs.find}}.
}
