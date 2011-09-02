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

In addition, \code{b} may be a list which will be converted to a mongo.bson object 
by \code{\link{mongo.bson.from.list}()}.}
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

    # do the same thing in shorthand:
    mongo.insert(mongo, ns, list(name="Joe", age=22L))
}
}
\seealso{
\code{\link{mongo.insert.batch}},\cr
\code{\link{mongo.update}},\cr
\code{\link{mongo.find}},\cr
\code{\link{mongo.find.one}},\cr
\code{\link{mongo.remove}},\cr
\link{mongo.bson},\cr
\link{mongo}.
}
