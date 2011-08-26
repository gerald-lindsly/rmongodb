% File rmongodb/man/mongo.gridfile.writer.Rd
\name{mongo.gridfile.writer}
\docType{class}
\alias{mongo.gridfile.writer}
\title{The mongo.gridfile.writer class}
\description{
Objects of class "mongo.gridfile.writer" are used to buffer multiple writes to a single GridFS file.

Use \code{\link{mongo.gridfile.writer.create}} to create an object of this class,\cr
\code{\link{mongo.gridfile.writer.write}} to write data to it, and\cr
\code{\link{mongo.gridfile.writer.finish}} when done writing.

mongo.gridfile.writer objects have "mongo.gridfile.writer" as their class and
contain an externally managed pointer to the actual data used to manage operations on the GridFS.
This pointer is stored in the "mongo.gridfile" attribute of the object.
The object also has a "mongo.gridfs" attribute
holding a pointer to the mongo.gridfs object used in creation to prevent garbage collection on the mongo.gridfs
object while the mongo.gridfile.writer is still active.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gfw <- mongo.gridfile.writer.create(gridfs, "test.dat")

    # store 4 bytes
    mongo.gridfile.writer.write(gfw, charToRaw("test"))

    # store string & LF plus 0-byte terminator
    buf <- writeBin("Test\\n", as.raw(1))
    mongo.gridfile.writer.write(gfw, buf)

    # store PI as a float
    buf <- writeBin(3.1415926, as.raw(1), size=4, endian="little")
    mongo.gridfile.writer.write(gfw, buf)

    mongo.gridfile.writer.finish(gfw)
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\link{mongo.gridfs},\cr
\code{\link{mongo.gridfile.writer.create}},\cr
\code{\link{mongo.gridfile.writer.write}},\cr
\code{\link{mongo.gridfile.writer.finish}}.
}
