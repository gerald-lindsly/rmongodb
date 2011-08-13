% File rmongodb/man/mongo.bson.buffer.append.time.Rd
\name{mongo.bson.buffer.append.time}
\alias{mongo.bson.buffer.append.time}
\title{Append a time value into a mongo.bson.buffer}
\description{
Append a time value into a mongo.bson.buffer.

BSON has a special field type to indicate a date/time; these are 64-bit values.

However, R has a 'standard' object of class "POSIXct" used to represent date/time values,
such as that returned by Sys.time().
Internally these are a 32-bit integer number of milliseconds since midnight January 1, 1970.
On January 19, 2038, 32-bit versions of the the Unix time stamp will cease to work, as it will
overflow the largest value that can be held in a signed 32-bit number. At such time, many applications, 
including R and this driver, will need to address that issue.
}
\usage{
mongo.bson.buffer.append.time(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson}) The mongo.bson.buffer object to which to append.}
\item{name}{(string) the name (key) of the field appended to the buffer.}
\item{value}{(integer) time value.  This may be an object of class "POSIXct", "POSIXlt" or "mongo.timestamp" also.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\seealso{
\link{mongo.timestamp},
\code{\link{mongo.timestamp.create}},
\code{\link{mongo.bson.buffer.append}},
\link{mongo.bson.buffer},
\link{mongo.bson}
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.time(buf, "Now", Sys.time())
b <- mongo.bson.from.buffer(buf)

}
