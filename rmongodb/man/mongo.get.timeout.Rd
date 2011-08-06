% File rmongodb/man/mongo.get.timeout.Rd
\name{mongo.get.timeout}
\alias{mongo.get.timeout}
\title{Get the timeout value of a mongo connection}
\description{
get the timeout value for network operations on a mongo connection.  
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
\seealso{
\code{\link{mongo.set.timeout}}
}
\examples{
timeout <- mongo.get.timeout(mongo)
}
