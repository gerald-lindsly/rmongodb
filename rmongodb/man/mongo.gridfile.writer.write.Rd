% File rmongodb/man/mongo.gridfile.writer.write.Rd
\name{mongo.gridfile.writer.write}
\alias{mongo.gridfile.writer.write}
\title{Write raw data to a buffered GridFS file}
\description{
Write raw data to a buffered GridFS file.
The data is buffered and sent to the server in 256k chunks as it accumulates.

This function only handles the RAW type.
Use \code{writeBin()} as necessary to pack your data appropriately for storage.  
See the examples and R's documentation on \code{writeBin()}.

Use \code{\link{mongo.gridfs.store}()} when you only need to write one data packet as a complete GridFS file.
}
\usage{
mongo.gridfile.writer.write(gfw, raw)
}
\arguments{
\item{gfw}{A (\link{mongo.gridfile.writer}) object.}
\item{raw}{(raw) The data to write to the GridFS file.}
}
\value{
NULL
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
\code{\link{mongo.gridfile.writer.finish}}.

}
