% File rmongodb/man/mongo.bson.buffer.append.null.Rd
\name{mongo.bson.buffer.append.null}
\alias{mongo.bson.buffer.append.null}
\title{Append a undefined field onto a mongo.bson.buffer}
\description{
Append a undefined value onto a mongo.bson.buffer.

BSON has a special field type to indicate an undefined value.
This function appends such an indicator as the value of a field.
}
\usage{
mongo.bson.buffer.append.undefined(buf, name)
}
\arguments{
\item{buf}{(\link{mongo.bson}) The mongo.bson.buffer object to which to append.}
\item{name}{(string) the name (key) of the field appended to the buffer.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\seealso{
\link{mongo.bson}
\link{mongo.bson.buffer}
\link{mongo.undefined}
\code{\link{mongo.undefined.create}}
\code{\link{mongo.bson.buffer.append}}
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.Undefined(buf, "Undef")
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "Undef" : UNDEFINED }

# The same result can be produced by the following code:
buf <- mongo.bson.buffer.create()
Undef <- mongo.undefined.create()
mongo.bson.buffer.append(buf, "Undef", Undef)
b <- mongo.bson.from.buffer(buf)

}
