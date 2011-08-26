% File rmongodb/man/mongo.bson.buffer.append.regex.Rd
\name{mongo.bson.buffer.append.regex}
\alias{mongo.bson.buffer.append.regex}
\title{Append a timestamp value into a mongo.bson.buffer}
\description{
Append a regular expression value into a \link{mongo.bson.buffer}.
}
\usage{
mongo.bson.buffer.append.regex(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer.}
\item{value}{(\link{mongo.regex}) A regular expression as created\cr by \code{\link{mongo.regex.create}()}.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
regex <- mongo.regex.create("acme.*corp", options="i")
mongo.bson.buffer.append.regex(buf, "MatchAcme", regex)
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.regex.create},\cr
\code{\link{mongo.bson.buffer.append.regex}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\link{mongo.bson},\cr
\link{mongo.bson.buffer}.
}
