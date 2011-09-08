% File rmongodb/man/mongo.bson.buffer.append.complex.Rd
\name{mongo.bson.buffer.append.complex}
\alias{mongo.bson.buffer.append.complex}
\title{Append a double field onto a mongo.bson.buffer}
\description{
Append a double or vector of doubles onto a \link{mongo.bson.buffer}.

Note that since BSON has no built-in complex type, R's complex values are appended as subobjects with two fields:
"r" : the real part and "i" : the imaginary part.
}
\usage{
mongo.bson.buffer.append.complex(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer. }
\item{value}{(complex vector) The values(s) to append to the buffer.

If value has a \code{dims} attribute of length > 1, any \code{names} or \code{dimnames} attribute
is ignored and a nested array is appended.\cr
(Use \code{\link{mongo.bson.buffer.append.object}()} if you want to preserve \code{dimnames}).

If value has a names attribute, a subobject is appended and the subfields are given the indicated names.

Otherwise, if more than one element is present in value, the values are appended as a subarray.

In the last case, a single complex is appended as the value of the field.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.complex(buf, "Alpha", 3.14159 + 2i)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form:
# { "Alpha" : { "r" : 3.14159, "i" : 2 } }

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.complex(buf, "complexi", c(1.7 + 2.1i, 97.2))
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form:
# { "complexi" : [ { "r": 1.7, i : 2.1}, { "r": 97.2, "i" : 0} ] }

buf <- mongo.bson.buffer.create()
values <- c(0.5 + 0.1i, 0.25)
names(values) <- c("Theta", "Epsilon")
mongo.bson.buffer.append.complex(buf, "Values", values)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form:
# { "Values" : { "Theta"   : { "r" : 0.5, "i" : 0.1 },
#                "Epsilon" : { " r" : 0.25, "i" : 0 } } }
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.buffer.append}}.
}
