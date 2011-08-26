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
(integer) error code as follows:
\item{0}{No Error}


mongo.create() errors:

\item{1}{No socket - Could not create socket.}
\item{2}{Fail - An error occurred attempting to connect to socket}
\item{3}{Address fail - An error occured calling getaddrinfo().}
\item{4}{Not Master - Warning: connected to a non-master node (read-only).}
\item{5}{Bad set name - given name doesn't match the replica set.}
\item{6}{No Primary - Cannot find primary in replica set - connection closed.}


Other errors:

\item{7}{I/O error - An error occured reading or writing on the socket.}
\item{8}{Read size error - The response is not the expected length.}
\item{9}{Command failed - The command returned with 'ok' value of 0.}
\item{10}{BSON invalid - Not valid for the specified operation.}
\item{11}{BSON not finished - should not occur with R driver. }
}
\examples{
mongo <- mongo.create()
if (!mongo.is.connected(mongo)) {
    print("Unable to connect.  Error code:")
    print(mongo.get.err(mongo))
}
}
\seealso{
\code{\link{mongo.create}},\cr
\link{mongo}
}
