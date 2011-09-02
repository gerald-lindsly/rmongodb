% File rmongodb/man/mongo.insert.batch.Rd
\name{mongo.insert.batch}
\alias{mongo.insert.batch}
\title{Add multiple records to a collection}
\description{
Add multiple records to a collection.  This function eliminates some network traffic and server overhead 
by sending all the records in a single message.

See \url{http://www.mongodb.org/display/DOCS/Inserting}.
}
\usage{
mongo.insert.batch(mongo, ns, lst)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
\item{ns}{(string) namespace of the collection to which to add the record.}
\item{lst}{A list of (\link{mongo.bson}) records to add.}
}
\value{
TRUE if the command was successfully sent to the server; otherwise, FALSE.

\code{\link{mongo.get.last.err}()} may be examined to verify that the insert was successful on the server if necessary.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    ns <- "test.people"

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Dave")
    mongo.bson.buffer.append(buf, "age", 27L)
    x <- mongo.bson.from.buffer(buf)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Fred")
    mongo.bson.buffer.append(buf, "age", 31L)
    y <- mongo.bson.from.buffer(buf)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Silvia")
    mongo.bson.buffer.append(buf, "city", 24L)
    z <- mongo.bson.from.buffer(buf)
    mongo.insert.batch(mongo, ns, list(x, y, z))
}
}
\seealso{
\code{\link{mongo.insert}},\cr
\code{\link{mongo.update}},\cr
\code{\link{mongo.find}},\cr
\code{\link{mongo.find.one}},\cr
\code{\link{mongo.remove}},\cr
\link{mongo.bson},\cr
\link{mongo}.
}
