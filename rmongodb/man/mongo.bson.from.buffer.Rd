% File rmongodb/man/mongo.bson.from.buffer.Rd
\name{mongo.bson.from.buffer}
\alias{mongo.bson.from.buffer}
\title{Convert a mongo.bson.buffer object to a mongo.bson object}
\description{
Convert a \link{mongo.bson.buffer} object to a \link{mongo.bson} object.

Use this after appending data to a buffer to turn it into a mongo.bson object for network transport.

No futher data may be appended to the buffer after calling this function.
}
\usage{
mongo.bson.from.buffer(buf)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer to convert. }
}
\value{
A \link{mongo.bson} object as converted from the buffer parameter.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Fred")
mongo.bson.buffer.append(buf, "city", "Dayton")
b <- mongo.bson.from.buffer(buf)
print(b)
mongo.bson.destroy(b)
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.destroy}}.
}
