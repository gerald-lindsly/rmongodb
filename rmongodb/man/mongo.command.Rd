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
\item{db}{(string) The names of the database upon which to perform the command.}
\item{command}{\link{mongo.bson} An object describing the command.}
}
\value{
NULL if the command failed.  Use \code{\link{mongo.get.last.err}()} to determine the cause.

(\link{mongo.bson} The server's response if successful.
}
\seealso{
\code{\link{mongo.simple.command}},
\code{\link{mongo.rename}},
\code{\link{mongo.count}},
\code{\link{mongo.drop.database}},
\code{\link{mongo.drop.collection}},
\link{mongo},
\link{mongo.bson}
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {

    # alternate method of renaming a collection
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "renameCollection", ns)
    mongo.bson.buffer.append(buf, "to", "test.humans")
    command <- mongo.bson.from.buffer(buf)
    mongo.command(mongo, "admin", command)


    # Alternate method of counting people
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "count", "test")
    mongo.bson.buffer.append(buf, "query", mongo.bson.empty())
    command <- mongo.bson.from.buffer(buf)
    result = mongo.command(mongo, "test", command)
    if (!is.null(result)) {
        iter = mongo.bson.iterator.create(result)
        mongo.bson.find(result, "n", iter)
        print(mongo.bson.iterator.value(iter))
    }
}
}
