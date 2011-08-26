% File rmongodb/man/mongo.gridfs.remove.file.Rd
\name{mongo.gridfs.remove.file}
\alias{mongo.gridfs.remove.file}
\title{Remove a file from a GridFS on a MongoDB server}
\description{
Remove a file from a GridFS on a MongoDB server.
}
\usage{
mongo.gridfs.remove.file(gridfs, remotename)
}
\arguments{
\item{gridfs}{A (\link{mongo.gridfs}) object.}
\item{remotename}{(string) The name of the file to be removed (as known within the GridFS).}
}
\value{
NULL
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")
    \dontrun{mongo.gridfs.remove.file(gridfs, "test.R")}
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\link{mongo.gridfs},\cr
\code{\link{mongo.gridfs.store.file}}\cr
\code{\link{mongo.gridfs.store}}.
}
