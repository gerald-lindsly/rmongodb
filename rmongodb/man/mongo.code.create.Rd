% File rmongodb/man/mongo.code.create.Rd
\name{mongo.code.create}
\alias{mongo.code.create}
\title{Create a mongo.code object}
\description{
Create a mongo.code object for appending to a buffer with \code{\link{mongo.bson.buffer.append}()} or
for embedding in a list such that\cr
\code{\link{mongo.bson.buffer.append.list}()} will properly insert a code
value into the mongo.bson.buffer object.
}
\usage{
mongo.code.create(code)
}
\arguments{
\item{code}{(string) javascript code}
}
\value{
A \link{mongo.code} object
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
\link{mongo.code},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
