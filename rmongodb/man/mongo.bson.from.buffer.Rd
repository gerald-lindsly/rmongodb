% File rmongodb/man/mongo.bson.from.buffer.Rd
\name{mongo.bson.from.buffer}
\alias{mongo.bson.from.buffer}
\title{Convert a mongo.bson.buffer object to a mongo.bson object}
\description{
Convert a \link{mongo.bson.buffer} object to a \link{mongo.bson} object.

Use this after appending data to a buffer to turn it into a mongo.bson object for network transport.
}
\usage{
mongo.bson.from.buffer(buf)
}
\arguments{
\item{buf}{(\link{mongo.bson}) The mongo.bson.buffer object to convert. }
}
\value{
A \link{mongo.bson} A mongo.bson object as converted from the buffer parameter.
}
\seealso{
\link{mongo.bson}
\link{mongo.bson.buffer}
\code{\link{mongo.bson.buffer.append}}
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Fred")
mongo.bson.buffer.append(buf, "city", "Dayton")
b <- mongo.bson.from.buffer(buf)
print(b)
}
