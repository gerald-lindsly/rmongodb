% File rmongodb/man/mongo.bson.buffer.append.code.w.scope.Rd
\name{mongo.bson.buffer.append.code.w.scope}
\alias{mongo.bson.buffer.append.code.w.scope}
\title{Append a code field with a scope onto a mongo.bson.buffer}
\description{
Append a javascript code value with a scope object onto a \link{mongo.bson.buffer}.

BSON has a special field type to indicate javascript code with a scope.
This function appends such an indicator as the type of a field with its value.
}
\usage{
mongo.bson.buffer.append.code.w.scope(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer.}
\item{value}{\link{mongo.code.w.scope} The scoped javascript code.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
scope <- mongo.bson.from.list(list(scopevar="scopevalue"))
buf <- mongo.bson.buffer.create()
codeWscope <- mongo.code.w.scope.create("y = x", scope)
mongo.bson.buffer.append.code.w.scope(buf, "CodeWscope1",
     codeWscope)

# mongo.bson.buffer.append() will give the same result
# as it can detect the mongo.code.w.scope object
mongo.bson.buffer.append(buf, "CodeWscope2", codeWscope)

b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form:
# { "CodeWscope1" : (CODEWSCOPE) "y = x"
#        (SCOPE) { "scopevar" : "scopevalue" },
#   "CodeWscope2" : (CODEWSCOPE) "y = x"
#        (SCOPE) { "scopevar" : "scopevalue" } }

}
\seealso{
\link{mongo.code.w.scope},\cr
\code{\link{mongo.code.w.scope.create}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.from.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
