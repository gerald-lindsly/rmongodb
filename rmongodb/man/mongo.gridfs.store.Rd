% File rmongodb/man/mongo.gridfs.store.Rd
\name{mongo.gridfs.store}
\alias{mongo.gridfs.store}
\title{Store raw data as a file in a GridFS}
\description{
Store raw data as a file to a GridFS on a MongoDB server.
This function stores the entire piece of data file on the server, 
breaking it up into 256K chunks as necessary.

This function only handles the RAW type.
Use \code{writeBin()} as necessary to pack your data appropriately for storage.  
See the examples and R's documentation on \code{writeBin()}.

Use \link{mongo.gridfile.writer} when you need to buffer many writes to a GridFS file.
}
\usage{
mongo.gridfs.store(gridfs, raw, remotename, contenttype="")
}
\arguments{
\item{gridfs}{A (\link{mongo.gridfs}) object.}
\item{raw}{(raw) The data to store on the server.}
\item{remotename}{(string) The name the file will be known as within the GridFS.}
\item{contenttype}{(string) Optional MIME content type.}
}
\value{
TRUE, if successful; FALSE, if an error occured during the operation.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")
    # store 4 bytes
    mongo.gridfs.store(gridfs, charToRaw("test"), "test4.dat")

    # store string & LF plus 0-byte terminator
    buf <- writeBin("Test\n", as.raw(1))
    mongo.gridfs.store(gridfs, buf, "test6.dat")

    # store PI as a float
    buf <- writeBin(3.1415926, as.raw(1), size=4, endian="little")
    mongo.gridfs.store(gridfs, buf, "PI.dat")

    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\link{mongo.gridfs},\cr
\code{\link{mongo.gridfs.create}},\cr
\code{\link{mongo.gridfs.remove.file}}.
}
