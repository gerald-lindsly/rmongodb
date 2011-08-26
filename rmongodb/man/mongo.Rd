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

Note that the members of the mongo object only reflect\cr
the initial parameters of \code{\link{mongo.create}()}.
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
\code{\link{mongo.create}},\cr
\code{\link{mongo.is.connected}},\cr
\code{\link{mongo.get.databases}},\cr
\code{\link{mongo.get.database.collections}},\cr
\code{\link{mongo.insert}},\cr
\code{\link{mongo.find.one}},\cr
\code{\link{mongo.find}},\cr
\code{\link{mongo.update}},\cr
\code{\link{mongo.remove}},\cr
\code{\link{mongo.drop}},\cr
\code{\link{mongo.drop.database}}\cr
\link{mongo.gridfs}.
}
