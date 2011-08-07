% File rmongodb/man/mongo.get.err.Rd
\name{mongo.get.err}
\alias{mongo.get.err}
\title{Retrieve an connection error code from a mongo object}
\description{
Retrieve an connection error code from a mongo object indicating the failure code if mongo.create() failed.}
\usage{
mongo.get.err(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
(integer) error code as follows: 0 - Success, 1 - Bad argument, 2 - No socket,
    3 - Fail, 4 - Not Master, 5 - Bad replica set name, 6 - Cannot find primary
}
\seealso{
\code{\link{mongo.create}},
\link{mongo}
}
\examples{
mongo <- mongo.create()
if (!mongo.is.connected(mongo)) {
    print("Unable to connect.  Error code:")
    print(mongo.get.err(mongo))
}
}
