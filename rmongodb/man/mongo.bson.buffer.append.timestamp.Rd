% File rmongodb/man/mongo.bson.buffer.append.timestamp.Rd
\name{mongo.bson.buffer.append.timestamp}
\alias{mongo.bson.buffer.append.timestamp}
\title{Append a timestamp value into a mongo.bson.buffer}
\description{
Append a timetamp value into a mongo.bson.buffer.

\link{mongo.timestamp} objects extend the "POSIXct" class to include an attrubute "increment".

See \code{\link{mongo.bson.buffer.append.time}()}.
}
\usage{
mongo.bson.buffer.append.timestamp(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson}) The mongo.bson.buffer object to which to append.}
\item{name}{(string) the name (key) of the field appended to the buffer.}
\item{value}{(\link{mongo.timestamp}) a timestamp value as created by \code{\link{mongo.timestamp.create}()}.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\seealso{
\link{mongo.bson},
\link{mongo.bson.buffer},
\link{mongo.timestamp.create},
\code{\link{mongo.bson.buffer.append.time}},
\code{\link{mongo.bson.buffer.append}}
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.timestamp(buf, "Now", Sys.timestamp())
b <- mongo.bson.from.buffer(buf)

}
