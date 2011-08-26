% File rmongodb/man/mongo.get.socket.Rd
\name{mongo.get.socket}
\alias{mongo.get.socket}
\title{Get the socket assigned to a mongo object by mongo.create().}
\description{
Get the the low-level socket number assigned to the given mongo object by mongo.create().
}
\usage{
mongo.get.socket(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
Integer socket number
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo))
    print(mongo.get.socket(mongo))
}
\seealso{
\code{\link{mongo.create}},\cr
\link{mongo}.
}
