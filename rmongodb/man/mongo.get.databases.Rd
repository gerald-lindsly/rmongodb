% File rmongodb/man/mongo.get.databases.Rd
\name{mongo.get.databases}
\alias{mongo.get.databases}
\title{Get a list of databases from a MongoDB server}
\description{
Get a list of databases from a MongoDB server.
}
\usage{
mongo.get.databases(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) A mongo connection object.}
}
\value{
(string vector) List of databases.  Note this will not include the system databases "admin" and "local".
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    print(mongo.get.databases(mongo))

    mongo.destroy(mongo)
}
}
\seealso{
\code{\link{mongo.get.database.collections}},\cr
\code{\link{mongo.drop.database}},\cr
\code{\link{mongo.command}},\cr
\code{\link{mongo.rename}},\cr
\link{mongo}.
}
