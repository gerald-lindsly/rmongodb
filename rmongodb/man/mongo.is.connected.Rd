% File rmongodb/man/mongo.is.connected.Rd
\name{mongo.is.connected}
\alias{mongo.is.connected}
\title{Determine if a mongo object is connected to a MongoDB server}
\description{
Returns TRUE if the parameter mongo object is connected to a MongoDB server;
otherwise, FALSE.
}
\usage{
mongo.is.connected(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
Logical TRUE if the mongo connection object is currently connected to a server; otherwise, FALSE.
}
\seealso{
\code{\link{mongo.create}},
\link{mongo},
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    print(mongo.count(mongo, "test.people"))
}
}
