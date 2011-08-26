% File rmongodb/man/mongo.bson.buffer.append.code.Rd
\name{mongo.bson.buffer.append.code}
\alias{mongo.bson.buffer.append.code}
\title{Append a code field onto a mongo.bson.buffer}
\description{
Append a javascript code value onto a \link{mongo.bson.buffer}.

BSON has a special field type to indicate javascript code.
This function appends such an indicator as the type of a field with its value.
}
\usage{
mongo.bson.buffer.append.code(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer.}
\item{value}{string} The javascript code.

Note that the value may simply be a string of javascript and not necessarily a \link{mongo.code} object.
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.code(buf, "SetXtoY", "x = y")
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form:
# { "SetXtoY" : (CODE) "x = y" }

# The same result can be produced by the following code:
buf <- mongo.bson.buffer.create()
code <- mongo.code.create("x = y")
mongo.bson.buffer.append(buf, "SetXtoY", code)
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.code},\cr
\code{\link{mongo.code.create}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\link{mongo.bson},\cr
\link{mongo.bson.buffer}.
}
