% File rmongodb/man/mongo.bson.buffer.append.Rd
\name{mongo.bson.buffer.append}
\alias{mongo.bson.buffer.append}
\title{Append a name/value pair into a mongo.bson.buffer}
\description{
Append a name/value pair into a \link{mongo.bson.buffer}.

This function is a generic version of many 'append' functions.  It will detect the type of the \code{value} parameter
and perform the same action as the specific functions.  These functions are:
\itemize{
\item \code{\link{mongo.bson.buffer.append.int}()}
\item \code{\link{mongo.bson.buffer.append.string}()}
\item \code{\link{mongo.bson.buffer.append.bool}()}
\item \code{\link{mongo.bson.buffer.append.double}()}
\item \code{\link{mongo.bson.buffer.append.complex}()}
\item \code{\link{mongo.bson.buffer.append.null}()}
\item \code{\link{mongo.bson.buffer.append.undefined}()}
\item \code{\link{mongo.bson.buffer.append.symbol}()}
\item \code{\link{mongo.bson.buffer.append.code}()}
\item \code{\link{mongo.bson.buffer.append.code.w.scope}()}
\item \code{\link{mongo.bson.buffer.append.raw}()}
\item \code{\link{mongo.bson.buffer.append.time}()}
\item \code{\link{mongo.bson.buffer.append.timestamp}()}
\item \code{\link{mongo.bson.buffer.append.regex}()}
\item \code{\link{mongo.bson.buffer.append.oid}()}
\item \code{\link{mongo.bson.buffer.append.bson}()}
\item \code{\link{mongo.bson.buffer.append.element}()}
\item \code{\link{mongo.bson.buffer.append.list}()}
}

\code{\link{mongo.bson.buffer.append.long}()} is missing from the above list since R has 
no 64-bit long integer type.  If you wish a value to be stored in the BSON data as a long
you must explicity call that function.

All of the above functions will lose the attributes of the object other than "names".
When vectors of length > 1 are appended, "names" are preserved.\cr
\code{\link{mongo.bson.buffer.append.object}()} gets around this shortcoming and allows
most R objects to be stored in a database without loss of attributes.
}
\usage{
mongo.bson.buffer.append(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer.}
\item{value}{The value of the field.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
# Append a string
mongo.bson.buffer.append(buf, "name", "Joe")
# Append a date/time
mongo.bson.buffer.append(buf, "created", Sys.time())
# Append a NULL
mongo.bson.buffer.append(buf, "cars", NULL)
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer}.
}
