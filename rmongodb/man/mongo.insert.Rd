% File rmongodb/man/mongo.insert.Rd
\name{mongo.insert}
\alias{mongo.insert}
\title{Add record to a collection}
\description{
Add record to a collection.

See \url{http://www.mongodb.org/display/DOCS/Inserting}.
}
\usage{
mongo.insert(mongo, ns, b)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
\item{ns}{(string) namespace of the collection to which to add the record.}
\item{b}{(\link{mongo.bson}) The record to add.

Note that parameter b may also be a list of mongo.bson records to do a batch insert (See example).}
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
    mongo.bson.buffer.append(buf, "name", "Joe")
    mongo.bson.buffer.append(buf, "age", 22L)
    b <- mongo.bson.from.buffer(buf)

    mongo.insert(mongo, ns, b)

    # do a batch insert
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
    mongo.insert(mongo, ns, list(x, y, z))

}
}
\seealso{
\code{\link{mongo.update}},\cr
\code{\link{mongo.find}},\cr
\code{\link{mongo.find.one}},\cr
\code{\link{mongo.remove}},\cr
\link{mongo.bson},\cr
\link{mongo}.
}
