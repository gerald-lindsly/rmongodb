% File rmongodb/man/mongo.oid.create.Rd
\name{mongo.oid.create}
\alias{mongo.oid.create}
\title{Create a mongo.oid object}
\description{
Create a \link{mongo.oid} object for appending to a buffer with\cr
\code{\link{mongo.bson.buffer.append.oid}()} or \code{\link{mongo.bson.buffer.append}()}, or
for embedding in a list such that \code{\link{mongo.bson.buffer.append.list}()}
will properly insert an Object ID value into a mongo.bson.buffer object.

See \url{http://www.mongodb.org/display/DOCS/Object+IDs}
}
\usage{
mongo.oid.create()
}
\value{
A \link{mongo.oid} object that is reasonably assured of being unique.
}
\examples{
buf <- mongo.bson.buffer.create()
oid <- mongo.oid.create()
mongo.bson.buffer.append(buf, "_id", oid)
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.oid},\cr
\code{\link{mongo.oid.from.string}},\cr
\code{\link{as.character.mongo.oid}},\cr
\code{\link{mongo.oid.to.string}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.oid}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
