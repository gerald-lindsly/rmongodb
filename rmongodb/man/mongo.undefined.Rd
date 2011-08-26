% File rmongodb/man/mongo.undefined.Rd
\name{mongo.undefined}
\docType{class}
\alias{mongo.undefined}
\title{The mongo.undefined class}
\description{
Objects of class "mongo.undefined" are used to represent undefined values in BSON documents.

mongo.undefined objects are strings (a character vector) with a single value of "UNDEFINED"

mongo.undefined objects have "mongo.undefined" as their class so that\cr
\code{\link{mongo.bson.buffer.append}()} 
may detect them and append the appropriate BSON undefined value to a buffer.

These mongo.undefined values may also be present in a list and will be handled properly
by \code{\link{mongo.bson.buffer.append.list}()} and \code{\link{mongo.bson.from.list}()}.
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
\code{\link{mongo.undefined.create}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
