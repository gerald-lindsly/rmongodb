% File rmongodb/man/mongo.Rd
\name{mongo}
\docType{class}
\alias{mongo}
\title{The mongo (database connection) class}
\description{
Objects of class "mongo" are used to connect to a MongoDB server and
to perform database operations on that server.

mongo objects have "mongo" as their class and
contain an externally managed pointer to the connection data.
This pointer is stored in the "mongo" attribute of the object.

Note that the members of the mongo object only reflect the initial parameters of \code{\link{mongo.create}()}.
Only the external data actually changes if, for example,
mongo.timeout is called after the initial call to \code{mongo.create}.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Joe")
    mongo.bson.buffer.append(buf, "age", 22L)
    b <- mongo.bson.from.buffer(buf)
    mongo.insert(mongo, "test.people", b)
}
}
\seealso{
\code{\link{mongo.create}},
\code{\link{mongo.is.connected}},
\code{\link{mongo.get.databases}},
\code{\link{mongo.get.database.collections}},
\code{\link{mongo.insert}},
\code{\link{mongo.find.one}},
\code{\link{mongo.find}},
\code{\link{mongo.update}},
\code{\link{mongo.remove}},
\code{\link{mongo.drop}},
\code{\link{mongo.drop.database}},
}
