% File rmongodb/man/mongo.gridfs.destroy.Rd
\name{mongo.gridfs.destroy}
\alias{mongo.gridfs.destroy}
\title{Destroy a mongo.gridfs object}
\description{
Releases the resources associated with a \link{mongo.gridfs} object.

It is not absolutely necessary to call this function since R's garbage collection will eventually
get around to doing it for you.
}
\usage{
mongo.gridfs.destroy(gridfs)
}
\arguments{
\item{gridfs}{A (\link{mongo.gridfs}) object.}
}
\value{
NULL
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
\code{\link{mongo.gridfs.store.file}}.
}
