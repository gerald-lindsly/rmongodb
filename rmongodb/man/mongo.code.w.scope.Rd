% File rmongodb/man/mongo.code.w.scope.Rd
\name{mongo.code.w.scope}
\docType{class}
\alias{mongo.code.w.scope}
\title{The mongo.code.w.scope class}
\description{
Objects of class "mongo.code.w.scope" are used to represent javascript code values with scopes in BSON documents.

mongo.code.w.scope objects' value is a string representing the value of the code.

The scope is a \link{mongo.bson} object and is stored in the "scope" attribute of the mongo.code.w.scope object.

mongo.code.w.scope objects have "mongo.code.w.scope" as their class so that\cr
\code{\link{mongo.bson.buffer.append}()} 
may detect them and append the appropriate BSON code-typed value and scope to a buffer.

These mongo.code.w.scope values may also be present in a list and will be handled properly
by \code{\link{mongo.bson.buffer.append.list}()} and \code{\link{mongo.bson.from.list}()}.

}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "sv", "sx")
scope <- mongo.bson.from.buffer(buf)
codeWscope <- mongo.code.w.scope.create("y = x", scope)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "CodeWscope", codeWscope)
lst <- list(c1 = codeWscope, One = 1)
mongo.bson.buffer.append.list(buf, "listWcodeWscope", lst)
b <- mongo.bson.from.buffer(buf)

# the above will create a mongo.bson object of the following form:
# { "CodeWscope" : (CODEWSCOPE) "y = x"
#                  (SCOPE) { "sv" : "sx"}, 
#   "listWcodeWscope" : { "c1" : (CODEWSCOPE) "y = x"
#                                (SCOPE) { "sv" : "sx"} } }
}
\seealso{
\code{\link{mongo.code.w.scope.create}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
