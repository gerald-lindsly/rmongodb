% File rmongodb/man/mongo.rename.Rd
\name{mongo.rename}
\alias{mongo.rename}
\title{Rename a collection on a MongoDB server}
\description{
Rename a collection on a MongoDB server.

Note that this may also be used to move a collection from one database to another.
}
\usage{
mongo.rename(mongo, from_ns, to_ns)
}
\arguments{
\item{mongo}{(\link{mongo}) A mongo connection object.}
\item{from_ns}{(string) The namespace of the collection to rename.}
\item{to_ns}{(string) The new namespace of the collection.}
}
\value{
NULL if unsuccessful; otherwise,

(\link{mongo.bson}) Server response.
}
\seealso{
\code{\link{mongo.drop.database}},
\code{\link{mongo.drop}},
\code{\link{mongo.command}},
\code{\link{mongo.count}},
\link{mongo},
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    print(mongo.rename(mongo, "test.people")

    mongo.destroy(mongo)
}
}
