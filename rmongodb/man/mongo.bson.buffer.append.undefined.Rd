% File rmongodb/man/mongo.bson.buffer.append.undefined.Rd
\name{mongo.bson.buffer.append.undefined}
\alias{mongo.bson.buffer.append.undefined}
\title{Append a undefined field onto a mongo.bson.buffer}
\description{
Append a undefined value onto a \link{mongo.bson.buffer}.

BSON has a special field type to indicate an undefined value.
This function appends such an indicator as the value of a field.
}
\usage{
mongo.bson.buffer.append.undefined(buf, name)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.undefined(buf, "Undef")
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "Undef" : UNDEFINED }

# The same result can be produced by the following code:
buf <- mongo.bson.buffer.create()
undef <- mongo.undefined.create()
mongo.bson.buffer.append(buf, "Undef", undef)
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.undefined},\cr
\code{\link{mongo.undefined.create}},\cr
\code{\link{mongo.bson.buffer.append}}.
}
