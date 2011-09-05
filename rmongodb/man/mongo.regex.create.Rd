% File rmongodb/man/mongo.regex.create.Rd
\name{mongo.regex.create}
\alias{mongo.regex.create}
\title{Create a mongo.regex object}
\description{
Create a \link{mongo.regex} object for appending to a buffer with\cr
\code{\link{mongo.bson.buffer.append.regex}()} or \code{\link{mongo.bson.buffer.append}()}, or
for embedding in a list such that \code{\link{mongo.bson.buffer.append.list}()} will properly insert a regular expression
value into a mongo.bson.buffer object.

See \url{http://www.mongodb.org/display/DOCS/Advanced+Queries#AdvancedQueries-RegularExpressions}
}
\usage{
mongo.regex.create(pattern, options="")
}
\arguments{
\item{pattern}{(string) The regular expression.}
\item{options}{(string) Options governing the parsing done with the pattern.}
}
\value{
A \link{mongo.regex} object
}
\examples{
buf <- mongo.bson.buffer.create()
regex <- mongo.regex.create("acme.*corp", options="i")
mongo.bson.buffer.append.regex(buf, "MatchAcme", regex)
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.regex},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.regex}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
