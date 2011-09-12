% File rmongodb/man/mongo.gridfs.create.Rd
\name{mongo.gridfs.create}
\alias{mongo.gridfs.create}
\title{Create a mongo.gridfs object}
\description{
Create a \link{mongo.gridfs} object used to access and store "grid files" on the MongoDB server.
}
\usage{
mongo.gridfs.create(mongo, db, prefix="fs")
}
\arguments{
\item{mongo}{A (\link{mongo}) connection object.}
\item{db}{(string) The name of the database in which to access and/or store the gridfs-related collections. }
\item{prefix}{(string) The prefix to use constructing the gridfs-related collection names. 
There are two collections used for this purpose:\cr
\"\code{db}.\code{prefix}.files\" and  \"\code{db}.\code{prefix}.chunks\".}
}
\value{
(\link{mongo.gridfs}) An object to be used for subsequent operations on the grid file store.
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
\code{\link{mongo.gridfs.destroy}},\cr
\code{\link{mongo.gridfs.store.file}},\cr
\code{\link{mongo.gridfs.remove.file}},\cr
\code{\link{mongo.gridfs.store}},\cr
\code{\link{mongo.gridfile.writer.create}},\cr
\code{\link{mongo.gridfs.find}},
\code{link{mongo.shorthand}}.
}
