% File rmongodb/man/mongo.bson.buffer.append.int.Rd
\name{mongo.bson.buffer.append.int}
\alias{mongo.bson.buffer.append.int}
\title{Append an integer field onto a mongo.bson.buffer}
\description{
Append an integer or vector of integers onto a \link{mongo.bson.buffer}.
}
\usage{
mongo.bson.buffer.append.int(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer. }
\item{value}{(integer vector) The integer(s) to append to the buffer.

If value has a \code{dims} attribute of length > 1, any \code{names} or \code{dimnames} attribute
is ignored and a nested array is appended.\cr
(Use \code{\link{mongo.bson.buffer.append.object}()} if you want to preserve \code{dimnames}).

If value has a names attribute, a subobject is appended and the subfields are given the indicated names.

Otherwise, if more than one element is present in value it must be a vector of integers and
the integers are appended as a subarray.

In the last case, the single value must be coerible to an integer.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.int(buf, "age", 23L)
b <- mongo.bson.from.buffer(buf)

# the above produces a BSON object of the form { "age" : 21 }

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.int(buf, "ages", c(21L, 19L, 13L))
b <- mongo.bson.from.buffer(buf)

# the above produces a BSON object of the form { "ages" : [21, 19, 13] }

buf <- mongo.bson.buffer.create()
dim <- c(2L, 4L, 8L)
names(dim) <- c("width", "height", "length")
mongo.bson.buffer.append.int(buf, "board", dim)
b <- mongo.bson.from.buffer(buf)

# theabove produces a BSON object of the form:
# { "board" : { "width" : 2, "height" : 4, "length" : 8 } }
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.buffer.append}}.
}
