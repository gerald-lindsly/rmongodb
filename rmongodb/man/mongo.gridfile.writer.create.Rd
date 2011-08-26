% File rmongodb/man/mongo.gridfile.writer.create.Rd
\name{mongo.gridfile.writer.create}
\alias{mongo.gridfile.writer.create}
\title{Create a mongo.gridfile.writer object}
\description{
Create a \link{mongo.gridfile.writer} object used to buffer many writes to a single GridFS file.
Once the mongo.gridfile.writer is created, use \code{\link{mongo.gridfile.writer.write}()} to write data to the
buffered GridFS file and \code{\link{mongo.gridfile.writer.finish}()} when done.
}
\usage{
mongo.gridfile.writer.create(gridfs, remotename, contenttype="")
}
\arguments{
\item{gridfs}{A (\link{mongo.gridfs}) object.}
\item{remotename}{(string) The name the file will be known as within the GridFS.}
\item{contenttype}{(string) Optional MIME content type.}
}
\value{
(\link{mongo.gridfile.writer}) The object to be used for writing to the GridFS file.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gfw <- mongo.gridfile.writer.create(gridfs, "test.dat")

    # store 4 bytes
    mongo.gridfile.writer.write(gfw, charToRaw("test"))

    # store string & LF plus 0-byte terminator
    buf <- writeBin("Test\n", as.raw(1))
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
\code{\link{mongo.gridfs.create}},\cr
\code{\link{mongo.gridfile.writer.write}},\cr
\code{\link{mongo.gridfile.writer.finish}}.
}
