% File rmongodb/man/mongo.bson.buffer.append.code.w.scope.Rd
\name{mongo.bson.buffer.append.code.w.scope}
\alias{mongo.bson.buffer.append.code.w.scope}
\title{Append a code field with a scope onto a mongo.bson.buffer}
\description{
Append a javascript code value with a scope object onto a mongo.bson.buffer.

BSON has a special field type to indicate javascript code with a scope.
This function appends such an indicator as the type of a field with its value.
}
\usage{
mongo.bson.buffer.append.code.w.scope(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The mongo.bson.buffer object to which to append.}
\item{name}{(string) the name (key) of the field appended to the buffer.}
\item{value}{\link{mongo.code.w.scope} the scoped javascript code.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "scopevar", "scopevalue")
scope <- mongo.bson.from.buffer()
codeWscope <- mongo.code.w.scope.create("y = x", scope)
mongo.bson.buffer.append.code.w.scope(buf, "CodeWscope", codeWscope)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "CodeWscope" : (CODEWSCOPE) "y = x" (SCOPE) { "scopevar" : "scopevalue" } }

# mongo.bson.buffer.append() will give the same result as it can detect the mongo.code.w.scope object

#...
mongo.bson.buffer.append(buf, "CodeWscope", codeWscope)
}
\seealso{
\link{mongo.code.w.scope}
\code{\link{mongo.code.w.scope.create}}
\code{\link{mongo.bson.buffer.append}}
\link{mongo.bson}
\link{mongo.bson.buffer}
}
