% File rmongodb/man/mongo.is.master.Rd
\name{mongo.is.master}
\alias{mongo.is.master}
\title{Determine if a mongo connection object is connected to a master}
\description{
Determine if a mongo connection object is connected to a master.  Normally, this is only used
with replsets to see if we are currently connected to the master of the replset.
However, when connected to a singleton, this function reports TRUE also.
}
\usage{
mongo.is.master(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
(logical) TRUE if the server reports that it is a master; otherwise, FALSE.
}
\examples{
\dontrun{
mongo <- mongo.create(c("127.0.0.1", "192.168.0.3"), name="Accounts")
if (mongo.is.connected(mongo)) {
    print("isMaster")
    print(if (mongo.is.master(mongo)) "Yes" else "No")
}
}
}
\seealso{
\code{\link{mongo.create}},\cr
\link{mongo}.
}
