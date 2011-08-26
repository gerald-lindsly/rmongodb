% File rmongodb/man/mongo.gridfile.writer.finish.Rd
\name{mongo.gridfile.writer.finish}
\alias{mongo.gridfile.writer.finish}
\title{Finish writing to a buffered GridFS file}
\description{
Finish writing to a buffered GridFS file.
This function flushes any partial buffer and finalizes the operation.
}
\usage{
mongo.gridfile.writer.finish(gfw)
}
\arguments{
\item{gfw}{A (\link{mongo.gridfile.writer}) object.}
}
\value{
TRUE, if successfil; false, if an error occurred.
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
\link{mongo.gridfile.writer},\cr
\code{\link{mongo.gridfile.writer.write}}.
}
