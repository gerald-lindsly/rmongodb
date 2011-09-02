% File rmongodb/man/mongo.command.Rd
\name{mongo.command}
\alias{mongo.command}
\title{Issue a command to a database on MongoDB server}
\description{
Issue a command to a MongoDB server and return the response from the server.

This function supports any of the MongoDB database commands by allowing you to specify the command object completely yourself.

See \url{http://www.mongodb.org/display/DOCS/List+of+Database+Commands}.
}
\usage{
mongo.command(mongo, db, command)
}
\arguments{
\item{mongo}{(\link{mongo}) A mongo connection object.}
\item{db}{(string) The name of the database upon which to perform the command.}
\item{command}{(\link{mongo.bson}) An object describing the command.

Alternately, \code{command} may be
a list which will be converted to a mongo.bson object by \code{\link{mongo.bson.from.list}()}.}
}
\value{
NULL if the command failed.  \code{\link{mongo.get.err}()} may be MONGO_COMMAND_FAILED.

(\link{mongo.bson}) The server's response if successful.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {

    # alternate method of renaming a collection
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "renameCollection", "test.people")
    mongo.bson.buffer.append(buf, "to", "test.humans")
    command <- mongo.bson.from.buffer(buf)
    mongo.command(mongo, "admin", command)

    # use list notation to rename the collection back
    mongo.command(mongo, "admin", 
        list(renameCollection="test.humans", to="test.people"))

    # Alternate method of counting people
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "count", "people")
    mongo.bson.buffer.append(buf, "query", mongo.bson.empty())
    command <- mongo.bson.from.buffer(buf)
    result = mongo.command(mongo, "test", command)
    if (!is.null(result)) {
        iter = mongo.bson.find(result, "n")
        print(mongo.bson.iterator.value(iter))
    }

}
}
\seealso{
\code{\link{mongo.get.err}},\cr
\code{\link{mongo.simple.command}},\cr
\code{\link{mongo.rename}},\cr
\code{\link{mongo.count}},\cr
\code{\link{mongo.drop.database}},\cr
\code{\link{mongo.drop}},\cr
\link{mongo},\cr
\link{mongo.bson}.
}
