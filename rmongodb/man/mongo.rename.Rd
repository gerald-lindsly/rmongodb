% File rmongodb/man/mongo.rename.Rd
\name{mongo.rename}
\alias{mongo.rename}
\title{Rename a collection on a MongoDB server}
\description{
Rename a collection on a MongoDB server.

Note that this may also be used to move a collection from one database to another.
}
\usage{
mongo.rename(mongo, from.ns, to.ns)
}
\arguments{
\item{mongo}{(\link{mongo}) A mongo connection object.}
\item{from.ns}{(string) The namespace of the collection to rename.}
\item{to.ns}{(string) The new namespace of the collection.}
}
\value{
TRUE if successful; otherwise, FALSE.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    print(mongo.rename(mongo, "test.people", "test.humans"))

    mongo.destroy(mongo)
}
}
\seealso{
\code{\link{mongo.drop.database}},\cr
\code{\link{mongo.drop}},\cr
\code{\link{mongo.command}},\cr
\code{\link{mongo.count}},\cr
\link{mongo}.
}
