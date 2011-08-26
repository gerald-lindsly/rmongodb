% File rmongodb/man/mongo.destroy.Rd
\name{mongo.destroy}
\alias{mongo.destroy}
\title{Destroy a MongoDB connection}
\description{
Destroy a \link{mongo} connection.  The connection is disconnected first if it is still connected.
No further communication is possible on the connection.  Releases resources attached to the
connection on both client and server.

Although the 'destroy' functions in this package are called automatically by garbage collection, 
this one in particular should be called as soon as feasible when finished with the connection so
that server resources are freed.
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
\link{mongo},\cr
\code{\link{mongo.disconnect}},\cr
\code{\link{mongo.is.connected}}\cr
\code{\link{mongo.reconnect}}.
}
