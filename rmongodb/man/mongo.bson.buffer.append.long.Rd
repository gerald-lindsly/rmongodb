% File rmongodb/man/mongo.bson.buffer.append.long.Rd
\name{mongo.bson.buffer.append.long}
\alias{mongo.bson.buffer.append.long}
\title{Append a long valued field onto a mongo.bson.buffer}
\description{
Append a long value or vector of longs onto a \link{mongo.bson.buffer}.

Note that since R has no long (64-bit integer) type, doubles are used in R, but are converted to 64-bit values
when stored in the buffer; some loss of precision may occur.

This is the only case in which \code{\link{mongo.bson.buffer.append}()} cannot
make the proper guess about what type to encode into the buffer.
You must call \code{mongo.bson.buffer.append.long()} explicitly; otherwise, doubles are appended.
}
\usage{
mongo.bson.buffer.append.long(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer. }
\item{value}{(double vector) The values(s) to append to the buffer.

If value has a names attribute, a subobject is appended and the subfields are given the indicated names.

Othersize, if more than one element is present in value, the values are appended as a subarray.

In the last case, a single long is appended as the value of the field.}
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
mongo.bson.buffer.append.long(buf, "YearSeconds", 365.24219 * 24 * 60 * 60)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "YearSeconds" : 31556925 }

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.long(buf, "longs", c(1, 9087654321, 1234567809))
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "longs" : [1, 9087654321, 1234567809] }

buf <- mongo.bson.buffer.create()
distances <- c(473, 133871000, 188178313)
names(distances) <- c("Sol", "Proxima Centari", "Bernard's Star")
mongo.bson.buffer.append.long(buf, "Stars", distances)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "Stars" : { "Sol" : 474, "Proxima Centari" : 133871000, "Bernard's Star" : 188178313 } }

}
