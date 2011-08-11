% File rmongodb/man/mongo.bson.buffer.append.list.Rd
\name{mongo.bson.buffer.append.list}
\alias{mongo.bson.buffer.append.list}
\title{Append a list onto a mongo.bson.buffer}
\description{
Append a list onto a mongo.bson.buffer.

Note that the value parameter must be a true list, not an vector of a single atomic type.

Also note that this function is recursive and will append items that are lists themselves as subobjects.
}
\usage{
mongo.bson.buffer.append.list(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson}) The mongo.bson.buffer object to which to append. }
\item{name}{(string) the name (key) of the field appended to the buffer. }
\item{value}{(list) the list to append to the buffer as a subobject. }
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\seealso{
\link{mongo.bson}
\link{mongo.bson.buffer}
\code{\link{mongo.bson.buffer.append}}
}
\examples{
buf <- mongo.bson.buffer.create()
l <- list(fruit = "apple", hasSeeds = TRUE)
mongo.bson.buffer.append.list(buf, "item", l)
b <- mongo.bson.from.buffer(buf)

# this produces a BSON object of the form { "item" : { "fruit" : "apple", "hasSeeds" : true } }
}
