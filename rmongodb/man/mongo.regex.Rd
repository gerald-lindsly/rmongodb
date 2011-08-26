% File rmongodb/man/mongo.regex.Rd
\name{mongo.regex}
\docType{class}
\alias{mongo.regex}
\title{The mongo.regex class}
\description{
Objects of class "mongo.regex" represent regular expressions and are strings 
with the options value stored in the "options" attribute.

See \url{http://www.mongodb.org/display/DOCS/Advanced+Queries#AdvancedQueries-RegularExpressions}

mongo.regex objects have "mongo.regex" as their class so that\cr
\code{\link{mongo.bson.buffer.append}()} 
may detect them and append the appropriate BSON regex-typed value to a buffer.

These mongo.regex values may also be present in a list and will be handled properly\cr
by \code{\link{mongo.bson.buffer.append.list}()} and \code{\link{mongo.bson.from.list}()}.

}
\examples{
buf <- mongo.bson.buffer.create()
regex <- mongo.regex.create("acme.*corp", options="i")
mongo.bson.buffer.append.regex(buf, "MatchAcme", regex)
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\code{\link{mongo.regex.create}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
