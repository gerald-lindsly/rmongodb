% File rmongodb/man/mongo.bson.buffer.append.bson.Rd
\name{mongo.bson.buffer.append.bson}
\alias{mongo.bson.buffer.append.bson}
\title{Append a mongo.bson object into a mongo.bson.buffer}
\description{
Append a \link{mongo.bson} object into a \link{mongo.bson.buffer} as a subobject.

Note that \code{\link{mongo.bson.buffer.append}()} will detect if its value parameter is a mongo.bson object and
perform the same action as this function.
}
\usage{
mongo.bson.buffer.append.bson(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the subobject field appended to the buffer.}
\item{value}{(\link{mongo.bson}) a mongo.bson object.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
name <- mongo.bson.from.list(list(first="Joe", last="Smith"))
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.bson(buf, "name", name)
mongo.bson.buffer.append.string(buf, "city", "New York")
b <- mongo.bson.from.buffer(buf)

# the above will create a mongo.bson object of the following form:
# { "name" : { "first" : "Joe", "last" : "Smith" }, "city" : "New York" }
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.from.list}},\cr
\code{\link{mongo.bson.buffer.append}}.
}
