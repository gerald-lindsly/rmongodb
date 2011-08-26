% File rmongodb/man/mongo.code.Rd
\name{mongo.code}
\docType{class}
\alias{mongo.code}
\title{The mongo.code class}
\description{
Objects of class "mongo.code" are used to represent javascript code values in BSON documents.

mongo.code objects' value is a string representing the value of the code.

mongo.code objects have "mongo.code" as their class so that\cr
\code{\link{mongo.bson.buffer.append}()} 
may detect them and append the appropriate BSON code-typed value to a buffer.

These mongo.code values may also be present in a list and\cr
will be handled properly by \code{\link{mongo.bson.buffer.append.list}()} and\cr
\code{\link{mongo.bson.from.list}()}.
}
\examples{
buf <- mongo.bson.buffer.create()
code <- mongo.code.create("y = x")
mongo.bson.buffer.append(buf, "Code", code)
lst <- list(c1 = code, One = 1)
mongo.bson.buffer.append.list(buf, "listWcode", lst)
mongo.bson.buffer.append.code(buf, "Code2", "a = 1")
b <- mongo.bson.from.buffer(buf)

# the above will create a mongo.bson object of the following form:
# { "Code": (CODE) "y = x", 
#   "listWcode" : { "c1"  : (CODE) "y = x",
#                   "One" : 1 },
#   "Code2" : (CODE) "a = 1" }
}
\seealso{
\code{\link{mongo.code.create}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
