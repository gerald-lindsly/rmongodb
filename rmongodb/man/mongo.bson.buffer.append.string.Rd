% File rmongodb/man/mongo.bson.buffer.append.string.Rd
\name{mongo.bson.buffer.append.string}
\alias{mongo.bson.buffer.append.string}
\title{Append a string field onto a mongo.bson.buffer}
\description{
Append an string or vector of strings onto a \link{mongo.bson.buffer}.
}
\usage{
mongo.bson.buffer.append.string(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer. }
\item{value}{(string vector) The strings(s) to append to the buffer.

If value has a \code{dims} attribute of length > 1, any \code{names} or \code{dimnames} attribute
is ignored and a nested array is appended.\cr
(Use \code{\link{mongo.bson.buffer.append.object}()} if you want to preserve \code{dimnames}).

If value has a names attribute, a subobject is appended and the subfields are given the indicated names.

Otherwise, if more than one element is present in value, the strings are appended as a subarray.

In the last case, a single string is appended as the value of the field.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.string(buf, "name", "Joe")
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "name" : "Joe" }

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.string(buf, "names", c("Fred", "Jeff", "John"))
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form:
# { "names" : ["Fred", "Jeff", "John"] }

buf <- mongo.bson.buffer.create()
staff <- c("Mark", "Jennifer", "Robert")
names(staff) <- c("Chairman", "President", "Secretary")
mongo.bson.buffer.append.string(buf, "board", staff)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form:
# { "board" : { "Chairman"  : "Mark",
#               "President" : "Jennifer",
#               "Secretary" : "Robert" } }
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.buffer.append}}.
}
