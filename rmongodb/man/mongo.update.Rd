% File rmongodb/man/mongo.update.Rd
\name{mongo.update}
\alias{mongo.update}
\title{Perform an update on a collection}
\description{
Perform an update on a collection.

See \url{http://www.mongodb.org/display/DOCS/Updating}.
}
\usage{
mongo.update(mongo, ns, criteria, objNew, flags=0L)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
\item{ns}{(string) namespace of the collection to which to update.}
\item{criteria}{(\link{mongo.bson}) The criteria with which to match records that are to be updated.}
\item{objNew}{(\link{mongo.bson}) The replacement object.}
\item{flags}{(integer vector) A list of optional flags governing the operation:

mongo.update.upsert: insert ObjNew into the database if no record matching criteria is found.

mongo.update.multi: update multiple records rather than just the first one matched by criteria.}
}
\seealso{
\link{mongo},
\link{mongo.bson},
\code{\link{mongo.insert}},
\code{\link{mongo.find}},
\code{\link{mongo.find.one}},
\code{\link{mongo.remove}}
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Joe")
    criteria <- mongo.bson.from.buffer(buf)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.start.object(buf, "$inc")
    mongo.bson.buffer.append(buf, "age", 1L)
    mongo.bson.buffer.finish.object(buf)
    objNew <- mongo.bson.from.buffer(buf)

    # increment the age field of the first record matching name "Joe"
    mongo.update(mongo, "test.people", criteria, objNew)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Jeff")
    criteria <- mongo.bson.from.buffer(buf)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Jeff")
    mongo.bson.buffer.append(buf, "age", 27L)
    objNew <- mongo.bson.from.buffer(buf)

    # update the entire record to { name: "Jeff", age: 27 } where name equals "Jeff"
    # if such a record exists; otherwise, insert this as a new reord
    mongo.update(mongo, "test.people", criteria, objNew, mongo.update.upsert)
}
}
