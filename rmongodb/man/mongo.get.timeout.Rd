% File rmongodb/man/mongo.get.timeout.Rd
\name{mongo.get.timeout}
\alias{mongo.get.timeout}
\title{Get the timeout value of a mongo connection}
\description{
Get the timeout value for network operations on a mongo connection.  
}
\usage{
mongo.get.timeout(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
(integer) timeout value in milliseconds.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    mongo.set.timeout(mongo, 2000L)
    timeout <- mongo.get.timeout(mongo)
    if (timeout != 2000L)
        error("expected timeout of 2000");
}
}
\seealso{
\code{\link{mongo.set.timeout}},\cr
\code{\link{mongo.create}},\cr
\link{mongo}.
}
