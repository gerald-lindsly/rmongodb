% File rmongodb/man/mongo.get.hosts.Rd
\name{mongo.get.hosts}
\alias{mongo.get.hosts}
\title{Get a lists of hosts & ports as reported by a replica set master upon connection creation.}
\description{
Get a lists of hosts & ports as reported by a replica set master upon connection creation.
}
\usage{
mongo.get.hosts(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
NULL if a replica set was not connected to; otherwise, a
list of host & port strings in the format "%s:%d".
}
\examples{
\dontrun{
mongo <- mongo.create(c("127.0.0.1", "192.168.0.3"), name="Inventory")
if (mongo.is.connected(mongo))
    print(mongo.get.hosts(mongo))
}
}

\seealso{
\code{\link{mongo.create}},\cr
\link{mongo}
}
