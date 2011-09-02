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
\item{criteria}{(\link{mongo.bson}) The criteria with which to match records that are to be updated.

Alternately, \code{criteria} may be a list which will be converted to a mongo.bson object
by \code{\link{mongo.bson.from.list}()}.}
\item{objNew}{(\link{mongo.bson}) The replacement object.

Alternately, \code{objNew} may be a list which will be converted to a mongo.bson object
by \code{\link{mongo.bson.from.list}()}.}
\item{flags}{(integer vector) A list of optional flags governing the operation:
    \itemize{
        \item{\code{\link{mongo.update.upsert}}: insert ObjNew into the database if no record matching criteria is found.}
        \item{\code{\link{mongo.update.multi}}: update multiple records rather than just the first one matched by criteria.}
        \item{\code{\link{mongo.update.basic}}: Perform a basic update.}
    }
}
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    ns <- "test.people"

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Joe")
    criteria <- mongo.bson.from.buffer(buf)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.start.object(buf, "$inc")
    mongo.bson.buffer.append(buf, "age", 1L)
    mongo.bson.buffer.finish.object(buf)
    objNew <- mongo.bson.from.buffer(buf)

    # increment the age field of the first record matching name "Joe"
    mongo.update(mongo, ns, criteria, objNew)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Jeff")
    criteria <- mongo.bson.from.buffer(buf)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Jeff")
    mongo.bson.buffer.append(buf, "age", 27L)
    objNew <- mongo.bson.from.buffer(buf)

    # update the entire record to { name: "Jeff", age: 27 }
    # where name equals "Jeff"
    # if such a record exists; otherwise, insert this as a new reord
    mongo.update(mongo, ns, criteria, objNew,
        mongo.update.upsert)

    # do a shorthand update:
    mongo.update(mongo, ns, list(name="John"), list(name="John", age=25))
}
}
\seealso{
\link{mongo},\cr
\link{mongo.bson},\cr
\code{\link{mongo.insert}},\cr
\code{\link{mongo.find}},\cr
\code{\link{mongo.find.one}},\cr
\code{\link{mongo.remove}}.
}
