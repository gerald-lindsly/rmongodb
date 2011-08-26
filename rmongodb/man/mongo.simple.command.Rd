% File rmongodb/man/mongo.simple.command.Rd
\name{mongo.simple.command}
\alias{mongo.simple.command}
\title{Issue a simple.command to a database on MongoDB server}
\description{
Issue a simple command to a MongoDB server and return the response from the server.

This function supports many of the MongoDB database commands by allowing you to specify a simple command object 
which is entirely specified by the command name and an integer or string argument.

See \url{http://www.mongodb.org/display/DOCS/List+of+Database+Commands}.
}
\usage{
mongo.simple.command(mongo, db, cmdstr, arg)
}
\arguments{
\item{mongo}{(\link{mongo}) A mongo connection object.}
\item{db}{(string) The name of the database upon which to perform the command.}
\item{cmdstr}{(string) The name of the command.}
\item{arg}{An argument to the command, may be a string or numeric (as.integer).}
}
\value{
NULL if the command failed.  Use \code{\link{mongo.get.last.err}()} to determine the cause.

(\link{mongo.bson}) The server's response if successful.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    print(mongo.simple.command(mongo, "admin", "buildInfo", 1))

    mongo.destroy(mongo)
}
}
\seealso{
\code{\link{mongo.command}},\cr
\code{\link{mongo.rename}},\cr
\code{\link{mongo.count}},\cr
\code{\link{mongo.drop.database}},\cr
\code{\link{mongo.drop}},\cr
\link{mongo},\cr
\link{mongo.bson}.
}
