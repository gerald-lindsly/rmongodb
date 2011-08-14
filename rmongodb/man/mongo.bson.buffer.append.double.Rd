% File rmongodb/man/mongo.bson.buffer.append.double.Rd
\name{mongo.bson.buffer.append.double}
\alias{mongo.bson.buffer.append.double}
\title{Append a double field onto a mongo.bson.buffer}
\description{
Append a double or vector of doubles onto a mongo.bson.buffer.
}
\usage{
mongo.bson.buffer.append.double(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The mongo.bson.buffer object to which to append. }
\item{name}{(string) the name (key) of the field appended to the buffer. }
\item{value}{(double vector) the values(s) to append to the buffer.

If value has a names attribute, a subobject is appended and the subfields are given the indicated names.

Othersize, if more than one element is present in value, the values are appended as a subarray.

In the last case, a single double is appended as the value of the field.}
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
mongo.bson.buffer.append.double(buf, "YearSeconds", 365.24219 * 24 * 60 * 60)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "YearSeconds" : 31556925.2 }

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.double(buf, "dbls", c(1.7, 87654321.123, 12345678.321))
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "longs" : [1.7, 87654321.123, 12345678.321] }

buf <- mongo.bson.buffer.create()
factions <- c(0.5, 0.25, 0.333333)
names(factions) <- c("Half", "Quarter", "Third")
mongo.bson.buffer.append.double(buf, "Fractions", distances)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "Fractions" : { "Half" : 0.5, "Quarter" : 0.25, "Thrid" : 0.333333 } }

}
