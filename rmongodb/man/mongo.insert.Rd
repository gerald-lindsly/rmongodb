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
\code{\link{mongo.update}},
\code{\link{mongo.find}},
\code{\link{mongo.find.one}},
\code{\link{mongo.remove}},
\link{mongo.bson},
\link{mongo}
}
