% File rmongodb/man/mongo.bson.buffer.append.symbol.Rd
\name{mongo.bson.buffer.append.symbol}
\alias{mongo.bson.buffer.append.symbol}
\title{Append a symbol field onto a mongo.bson.buffer}
\description{
Append a symbol value onto a \link{mongo.bson.buffer}.

BSON has a special field type to indicate a symbol.
This function appends such an indicator as the type of a field with its value.
}
\usage{
mongo.bson.buffer.append.symbol(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer.}
\item{value}{(string) The value of the symbol.

Note that the value may simply be a string representing the symbol's value
and not necessarily a \link{mongo.symbol} object.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.symbol(buf, "A", "Alpha")
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "A" : (SYMBOL) "Alpha" }

# The same result can be produced by the following code:
buf <- mongo.bson.buffer.create()
sym <- mongo.symbol.create("Alpha")
mongo.bson.buffer.append(buf, "A", sym)
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.symbol},\cr
\code{\link{mongo.symbol.create}},\cr
\code{\link{mongo.bson.buffer.append}}.
}
