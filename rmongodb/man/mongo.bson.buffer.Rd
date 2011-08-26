% File rmongodb/man/mongo.bson.buffer.Rd
\name{mongo.bson.buffer}
\docType{class}
\alias{mongo.bson.buffer}
\title{The mongo.bson.buffer class}
\description{
Objects of class "mongo.bson.buffer" are used to build BSON documents (\link{mongo.bson} objects).

There are many functions for appending data into a mongo.bson.buffer object.\cr
See \code{\link{mongo.bson.buffer.append}()} for a list of those functions.

After constructing your object in the buffer,
\code{\link{mongo.bson.from.buffer}()} may be used to turn the buffer into a mongo.bson object.

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
\link{mongo.bson},\cr
\code{\link{mongo.bson.buffer.size}},\cr
\code{\link{mongo.bson.from.buffer}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.start.object}},\cr
\code{\link{mongo.bson.buffer.start.array}},\cr
\code{\link{mongo.bson.buffer.finish.object}}.
}
