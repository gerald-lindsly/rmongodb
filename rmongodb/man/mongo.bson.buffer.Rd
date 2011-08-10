% File rmongodb/man/mongo.bson.buffer.Rd
\name{mongo.bson.buffer}
\docType{class}
\alias{mongo.bson.buffer}
\title{The mongo.bson.buffer class}
\description{
Objects of class "mongo.bson.buffer" are used to build BSON documents (\\link{mongo.bson} objects).

There are many functions for appending data onto a mongo.bson.buffer object.

After building, \code{\link{mongo.bson.from.buffer}()} may be used to turn the buffer into a mongo.bson objevt.

mongo.bson.buffer objects have "mongo.bson.buffer" as their class and
contain an externally managed pointer to the actual document data buffer.
This pointer is stored in the "mongo.bson.buffer" attribute of the object.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "make", "Ford")
mongo.bson.buffer.append(buf, "model", "Mustang")
mongo.bson.buffer.append.int(buf, "year", 1968)
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.bson},
\code{\link{mongo.bson.buffer.size}},
\code{\link{mongo.bson.from.buffer}},
\code{\link{mongo.bson.buffer.append}},
\code{\link{mongo.bson.buffer.append.list}},
\code{\link{mongo.bson.buffer.append.int}},
\code{\link{mongo.bson.buffer.append.string}},
\code{\link{mongo.bson.buffer.append.bool}},
\code{\link{mongo.bson.buffer.append.long}},
\code{\link{mongo.bson.buffer.append.double}},
\code{\link{mongo.bson.buffer.append.complex}},
\code{\link{mongo.bson.buffer.append.null}},
\code{\link{mongo.bson.buffer.append.undefined}},
\code{\link{mongo.bson.buffer.append.symbol}},
\code{\link{mongo.bson.buffer.append.code}},
\code{\link{mongo.bson.buffer.append.code.w.scope}},
\code{\link{mongo.bson.buffer.append.binary}},
\code{\link{mongo.bson.buffer.append.time}},
\code{\link{mongo.bson.buffer.append.timestamp}},
\code{\link{mongo.bson.buffer.append.regex}},
\code{\link{mongo.bson.buffer.append.oid}},
\code{\link{mongo.bson.buffer.append.bson}},
\code{\link{mongo.bson.buffer.append.element}},
\code{\link{mongo.bson.buffer.start.object}},
\code{\link{mongo.bson.buffer.start.array}},
\code{\link{mongo.bson.buffer.finish.object}},
}
