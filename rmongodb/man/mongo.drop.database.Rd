% File rmongodb/man/mongo.drop.database.Rd
\name{mongo.drop.database}
\alias{mongo.drop.database}
\title{Drop a database from a MongoDB server}
\description{
Drop a database from MongoDB server.  Removes the entire database and all collections in it.

Obviously, care should be taken when using this command.
}
\usage{
mongo.drop.database(mongo, db)
}
\arguments{
\item{mongo}{(\link{mongo}) A mongo connection object.}
\item{db}{(string) The name of the database to drop.}
}
\value{
(Logical) TRUE if successful; otherwise, FALSE
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    print(mongo.drop.database(mongo, "test"))

    mongo.destroy(mongo)
}
}
\seealso{
\code{\link{mongo.drop}},\cr
\code{\link{mongo.command}},\cr
\code{\link{mongo.rename}},\cr
\code{\link{mongo.count}},\cr
\link{mongo}.
}
