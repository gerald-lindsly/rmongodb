% File rmongodb/man/mongo.destroy.Rd
\name{mongo.destroy}
\alias{mongo.destroy}
\title{Destroy a MongoDB connection}
\description{
Destroy a \link{mongo} connection.  The connection is disconnected first if it is still connected.
No further communication is possible on the connection.  Releases resources attached to the
connection on both client and server.
}
\usage{
mongo.destroy(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
NULL
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    n_people <- mongo.count(mongo, "test.people")
    mongo.destroy(mongo)
    print(n_people)
}
}
\seealso{
\link{mongo},
\code{\link{mongo.disconnect}},
\code{\link{mongo.is.connected}}
\code{\link{mongo.reconnect}},
}
