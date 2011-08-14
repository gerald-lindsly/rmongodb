% File rmongodb/man/mongo.oid.Rd
\name{mongo.oid}
\docType{class}
\alias{mongo.oid}
\title{The mongo.oid class}
\description{
Objects of class "mongo.oid" represent MongoDB Object IDs.

See \url{http://www.mongodb.org/display/DOCS/Object+IDs}

mongo.oid objects contain an externally managed pointer to the actual 12-byte object ID data.
This pointer is stored in the "mongo.oid" attribute of the object.

mongo.oid objects have "mongo.oid" as their class so that \code{\link{mongo.bson.buffer.append}()} 
may detect them and append the appropriate BSON OID-typed value to a buffer.

mongo.oid values may also be present in a list and will be handled properly
by \code{\link{mongo.bson.buffer.append.list}().}
}
\examples{
buf <- mongo.bson.buffer.create()
oid <- mongo.oid.create()
mongo.bson.buffer.append(buf, "_id", oid)
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.oid},
\code{\link{mongo.oid.from.string}}
\code{\link{as.character.mongo.oid}}
\code{\link{mongo.oid.to.string}}
\code{\link{mongo.oid.time}}
\code{\link{mongo.bson.buffer.append}},
\code{\link{mongo.bson.buffer.append.oid}},
\code{\link{mongo.bson.buffer.append.list}},
\link{mongo.bson.buffer},
\link{mongo.bson}
}
