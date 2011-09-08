% File rmongodb/man/mongo.bson.buffer.append.double.Rd
\name{mongo.bson.buffer.append.double}
\alias{mongo.bson.buffer.append.double}
\title{Append a double field onto a mongo.bson.buffer}
\description{
Append a double or vector of doubles onto a \link{mongo.bson.buffer}.
}
\usage{
mongo.bson.buffer.append.double(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer. }
\item{value}{(double vector) The values(s) to append to the buffer.

If value has a \code{dims} attribute of length > 1, any \code{names} or \code{dimnames} attribute
is ignored and a nested array is appended.\cr
(Use \code{\link{mongo.bson.buffer.append.object}()} if you want to preserve \code{dimnames}).

If value has a names attribute, a subobject is appended and the subfields are given the indicated names.

Otherwise, if more than one element is present in value, the values are appended as a subarray.

In the last case, a single as.double is appended as the value of the field.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.double(buf, "YearSeconds",
     365.24219 * 24 * 60 * 60)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form:
# { "YearSeconds" : 31556925.2 }

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.double(buf, "dbls", 
    c(1.7, 87654321.123, 12345678.321))
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form:
# { "dbls" : [1.7, 87654321.123, 12345678.321] }

buf <- mongo.bson.buffer.create()
fractions <- c(0.5, 0.25, 0.333333)
names(fractions) <- c("Half", "Quarter", "Third")
mongo.bson.buffer.append.double(buf, "Fractions", fractions)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form:
# { "Fractions" : { "Half"    : 0.5,
#                   "Quarter" : 0.25,
#                   "Third"   : 0.333333 } }
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.buffer.append}}.
}
