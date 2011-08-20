% File rmongodb/man/mongo.code.w.scope.create.Rd
\name{mongo.code.w.scope.create}
\alias{mongo.code.w.scope.create}
\title{Create a mongo.code.w.scope object}
\description{
Create a mongo.code.w.scope object for appending to a buffer with \code{\link{mongo.bson.buffer.append}()} or
for embedding in a list such that \code{\link{mongo.bson.buffer.append.list}()} will properly insert a code
value into the mongo.bson.buffer object.
}
\usage{
mongo.code.w.scope.create(code, scope)
}
\arguments{
\item{code}{(string) javascript code}
\item{scope}{(\link{mongo.bson}) the scope object}
}
\value{
A \link{mongo.code.w.scope} object
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "scopevar", "scopevalue")
scope <- mongo.bson.from.buffer(buf)
codeWscope <- mongo.code.w.scope.create("y = x", scope)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "CodeWscope", codeWscope)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "CodeWscope" : (CODEWSCOPE) "y = x" (SCOPE) { "scopevar" : "scopevalue" } }
}
\seealso{
\link{mongo.code.w.scope},
\code{\link{mongo.bson.buffer.append}},
\code{\link{mongo.bson.buffer.append.list}},
\link{mongo.bson.buffer},
\link{mongo.bson}
}
