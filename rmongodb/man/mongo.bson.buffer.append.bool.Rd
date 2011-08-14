% File rmongodb/man/mongo.bson.buffer.append.bool.Rd
\name{mongo.bson.buffer.append.bool}
\alias{mongo.bson.buffer.append.bool}
\title{Append a boolean field onto a mongo.bson.buffer}
\description{
Append an logical (boolean) or vector of logical values onto a mongo.bson.buffer.
}
\usage{
mongo.bson.buffer.append.bool(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The mongo.bson.buffer object to which to append. }
\item{name}{(string) the name (key) of the field appended to the buffer. }
\item{value}{(logical vector) the booleans(s) to append to the buffer.

If value has a names attribute, a subobject is appended and the subfields are given the indicated names.

Othersize, if more than one element is present in value, the booleans are appended as a subarray.

In the last case, a single boolean is appended as the value of the field.}
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
mongo.bson.buffer.append.bool(buf, "wise", TRUE)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "wise" : true }

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.bool(buf, "bools", c(TRUE, FALSE, FALSE))
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "bools" : [true, false, false] }

buf <- mongo.bson.buffer.create()
flags <- c(FALSE, FALSE, TRUE)
names(flags) <- c("Tall", "Fat", "Pretty")
mongo.bson.buffer.append.bool(buf, "Looks", flags)
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "Looks" : { "Tall" : false, "Fat" : false, "Pretty" : true } }

}
