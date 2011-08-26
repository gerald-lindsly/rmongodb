% File rmongodb/man/mongo.reconnect.Rd
\name{mongo.reconnect}
\alias{mongo.reconnect}
\title{Reconnect to a MongoDB server}
\description{
Reconnect to a MongoDB server. Calls mongo.disconnect and then attempts to re-establish the connection.
}
\usage{
mongo.reconnect(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo))
    mongo.reconnect(mongo)
}
\seealso{
\code{\link{mongo.create}},\cr
\code{\link{mongo.disconnect}},\cr
\link{mongo}.
}
