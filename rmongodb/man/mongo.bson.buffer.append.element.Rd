% File rmongodb/man/mongo.bson.buffer.append.element.Rd
\name{mongo.bson.buffer.append.element}
\alias{mongo.bson.buffer.append.element}
\title{Append a mongo.bson.iterator's element into a mongo.bson.buffer}
\description{
Append a \link{mongo.bson.iterator}'s element into a \link{mongo.bson.buffer}.

\code{\link{mongo.bson.buffer.append}()} will detect if its value parameter
is a mongo.bson.iterator object and perform the same action as this function.
}
\usage{
mongo.bson.buffer.append.element(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the subobject field appended to the buffer.

If NULL, the name appended will come from the element pointed to by the iterator.}
\item{value}{A (\link{mongo.bson.iterator}) object.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
name <- mongo.bson.from.list(list(first="Joe", last="Smith"))
iter <- mongo.bson.find(name, "last")
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.element(buf, "last", iter)
b <- mongo.bson.from.buffer(buf)

# the above will create a mongo.bson object (b) of the following form:
# { "last" : "Smith" }
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.find}},\cr
\code{\link{mongo.bson.from.list}},\cr
\code{\link{mongo.bson.buffer.append}}.
}
