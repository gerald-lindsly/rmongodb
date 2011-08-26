% File rmongodb/man/mongo.bson.buffer.append.timestamp.Rd
\name{mongo.bson.buffer.append.timestamp}
\alias{mongo.bson.buffer.append.timestamp}
\title{Append a timestamp value into a mongo.bson.buffer}
\description{
Append a timestamp value into a \link{mongo.bson.buffer}.

\link{mongo.timestamp} objects extend the "POSIXct" class to include an attrubute "increment".

See \code{\link{mongo.bson.buffer.append.time}()}.
}
\usage{
mongo.bson.buffer.append.timestamp(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer.}
\item{value}{A (\link{mongo.timestamp}) value as created by \code{\link{mongo.timestamp.create}()}.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.timestamp(buf, "Now-27",
    mongo.timestamp.create(Sys.time(), 27))
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.timestamp.create},\cr
\code{\link{mongo.bson.buffer.append.time}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\link{mongo.bson},\cr
\link{mongo.bson.buffer}.
}
