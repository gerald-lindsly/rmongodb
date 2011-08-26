% File rmongodb/man/mongo.undefined.create.Rd
\name{mongo.undefined.create}
\alias{mongo.undefined.create}
\title{Create a mongo.undefined object}
\description{
Create a mongo.undefined object for appending to a buffer with\cr
\code{\link{mongo.bson.buffer.append}()} or
for embedding in a list such that \code{\link{mongo.bson.buffer.append.list}()} will properly insert an undefined
value into the mongo.bson.buffer object.
}
\usage{
mongo.undefined.create()
}
\value{
a \link{mongo.undefined} object
}
\examples{
buf <- mongo.bson.buffer.create()
undef <- mongo.undefined.create()
mongo.bson.buffer.append(buf, "Undef", undef)
l <- list(u1 = undef, One = 1)
mongo.bson.buffer.append.list(buf, "listWundef", l)
b <- mongo.bson.from.buffer(buf)

# the above will create a mongo.bson object of the following form:
# { "Undef": UNDEFINED, "listWundef" : { "u1" : UNDEFINED, "One" : 1 } }
}
\seealso{
\link{mongo.undefined},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
