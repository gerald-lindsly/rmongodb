% File rmongodb/man/mongo.oid.from.string.Rd
\name{mongo.oid.from.string}
\alias{mongo.oid.from.string}
\title{Create a mongo.oid object ftom a string}
\description{
Create from a 24-character hex string a mongo.oid object representing a MongoDB Object ID.

See \url{http://www.mongodb.org/display/DOCS/Object+IDs}
}
\usage{
mongo.oid.from.string(hexstr)
}
\arguments{
\item{hexstr}{(string) 24 hex characters representing the OID.

Note that although an error is thrown if the length is not 24, no error is thrown if 
the characters are not hex digits; you'll get zero bits for the invalid digits.}
}
\value{
A \link{mongo.oid} object constructed from hexstr.
}
\examples{
buf <- mongo.bson.buffer.create()
oid <- mongo.oid.from.string("ABCD1234EFAB5678CDEF9012")
mongo.bson.buffer.append(buf, "_id", oid)
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.oid},
\code{\link{mongo.oid.create}}
\code{\link{as.character.mongo.oid}}
\code{\link{mongo.oid.to.string}}
\code{\link{mongo.bson.buffer.append}},
\code{\link{mongo.bson.buffer.append.oid}},
\code{\link{mongo.bson.buffer.append.list}},
\link{mongo.bson.buffer},
\link{mongo.bson}
}
