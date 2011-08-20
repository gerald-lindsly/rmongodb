% File rmongodb/man/mongo.get.database.collections.Rd
\name{mongo.get.database.collections}
\alias{mongo.get.database.collections}
\title{Get a list of collections in a database}
\description{
Get a list of collections in a database on a MongoDB server.
}
\usage{
mongo.get.database.collections(mongo, db)
}
\arguments{
\item{mongo}{(\link{mongo}) A mongo connection object.}
\item{db}{(string) Name of the database for which to get the list of collections.}
}
\value{
(string vector) List of collection namespaces in the given database.

 Note this will not include the system collection \emph{db}.system.indexes nor the indexes attached to the database.
Use mongo.find(mongo, '\emph{db}.system.indexes", limit=0L) for information on any indexes.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    print(mongo.get.database.collections(mongo, "test"))

    mongo.destroy(mongo)
}
}
\seealso{
\code{\link{mongo.get.databases}},
\code{\link{mongo.drop.database}},
\code{\link{mongo.drop}},
\code{\link{mongo.command}},
\code{\link{mongo.rename}},
\link{mongo}
}
