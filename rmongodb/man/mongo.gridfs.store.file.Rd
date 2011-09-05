% File rmongodb/man/mongo.gridfs.store.file.Rd
\name{mongo.gridfs.store.file}
\alias{mongo.gridfs.store.file}
\title{Store a file into a GridFS on a MongoDB server}
\description{
Store a file into a GridFS on a MongoDB server.  This function stores the entire given file on the server, 
breaking it up into 256K chunks as necessary.
}
\usage{
mongo.gridfs.store.file(gridfs, filename, remotename="",
                        contenttype="")
}
\arguments{
\item{gridfs}{A (\link{mongo.gridfs}) object.}
\item{filename}{(string) The path/filename of the file to copy to the server.}
\item{remotename}{(string) The name the file will be known as within the GridFS.\cr
If remotename=="" (the default),
the remote file will be known by the given \code{filename}.}
\item{contenttype}{(string) Optional MIME content type.}
}
\value{
TRUE, if successful; FALSE, if an error occured during the operation.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")
    # Copy a local file to the server as a gridfs file
    mongo.gridfs.store.file(gridfs, "../test.R", "test.R")
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\link{mongo.gridfs},\cr
\code{\link{mongo.gridfs.create}},\cr
\code{\link{mongo.gridfs.remove.file}}.
}
