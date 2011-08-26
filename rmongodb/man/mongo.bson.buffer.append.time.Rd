% File rmongodb/man/mongo.bson.buffer.append.time.Rd
\name{mongo.bson.buffer.append.time}
\alias{mongo.bson.buffer.append.time}
\title{Append a time value into a mongo.bson.buffer}
\description{
Append a date/time value into a \link{mongo.bson.buffer}.

BSON has a special field type to indicate a date/time; these are 64-bit values.

However, R has a 'standard' object of class "POSIXct" used to represent date/time values,
such as that returned by Sys.time().
Internally these are a 32-bit integer number of milliseconds since midnight January 1, 1970.
On January 19, 2038, 32-bit versions of the the Unix time stamp will cease to work, as it will
overflow the largest value that can be held in a signed 32-bit number. At such time, many applications, 
including R and this driver, will need to address that issue.
}
\usage{
mongo.bson.buffer.append.time(buf, name, time)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer.}
\item{time}{(integer) A time value.  This may also be an object of\cr class "POSIXct", "POSIXlt" or "mongo.timestamp".}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.time(buf, "Now", Sys.time())
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.timestamp},\cr
\code{\link{mongo.timestamp.create}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
