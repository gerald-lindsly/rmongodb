% File rmongodb/man/mongo.reconnect.Rd
\name{mongo.reconnect}
\alias{mongo.reconnect}
\title{Reconnect to a MongoDB server}
\description{
Reconnect to a MongoDB server.
}
\usage{
mongo.reconnect(mongo)
}
\arguments{
\item{mongo}{a mongo connection object}
}
\seealso{
\code{\link{mongo.create}}.
\code{\link{mongo.disconnect}}.
}
\examples{
mongo <- mongo.create()
mongo.disconnect(mongo)
mongo.reconnect(mongo)
}
