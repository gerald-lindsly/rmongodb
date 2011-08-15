% File rmongodb/man/mongo.bson.buffer.append.oid.Rd
\name{mongo.bson.buffer.append.oid}
\alias{mongo.bson.buffer.append.oid}
\title{Append a OID into a mongo.bson.buffer}
\description{
Append a OID (Object ID) value into a \link{mongo.bson.buffer}.
}
\usage{
mongo.bson.buffer.append.oid(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer.}
\item{value}{(\link{mongo.oid}) An OID value.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.oid(buf, "Now", Sys.oid())
b <- mongo.bson.from.buffer(buf)
}
\seealso{
\link{mongo.bson},
\link{mongo.bson.buffer},
\link{mongo.oid.create},
\code{\link{mongo.bson.buffer.append}}
}
