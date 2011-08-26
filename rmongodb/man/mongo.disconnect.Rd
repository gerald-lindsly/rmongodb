% File rmongodb/man/mongo.disconnect.Rd
\name{mongo.disconnect}
\alias{mongo.disconnect}
\title{Disconnect from a MongoDB server}
\description{
Disconnect from a MongoDB server.  No further communication is possible on the connection.
However, \code{\link{mongo.reconnect}()} may be called on the mongo object to restablish the connection.
}
\usage{
mongo.disconnect(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
The mongo object is returned.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    n_people <- mongo.count(mongo, "test.people")
    mongo.disconnect(mongo)
}
}
\seealso{
\link{mongo},\cr
\code{\link{mongo.create}},\cr
\code{\link{mongo.reconnect}},\cr
\code{\link{mongo.is.connected}}.
}
