% File rmongodb/man/mongo.binary.create.Rd
\name{mongo.binary.create}
\alias{mongo.binary.create}
\title{Create a mongo.binary object}
\description{
Create a mongo.binary object for appending to a buffer with \code{\link{mongo.bson.buffer.append}()} or
for embedding in a list such that \code{\link{mongo.bson.buffer.append.list}()} will properly insert a code
value into the mongo.bson.buffer object.
}
\usage{
mongo.binary.create(type, length)
}
\arguments{
\item{type}{(as.integer truncated to low byte) user-defined type of the binary data}
\item{length}{(as.integer) length in bytes of the binary data}
}
\value{
A \link{mongo.binary} object with the values initially being all zero.
}
\examples{
buf <- mongo.bson.buffer.create()
bin <- mongo.binary.create(type=3, length=4)
for (i in 0:4)
    mongo.binary.set(bin, i, i * 16 + 3)
mongo.bson.buffer.append(buf, "bin", bin)
}
\seealso{
\link{mongo.binary},
\code{\link{mongo.binary.set}},
\code{\link{mongo.binary.get}},
\code{\link{mongo.bson.buffer.append}},
\code{\link{mongo.bson.buffer.append.list}},
\link{mongo.bson.buffer},
\link{mongo.bson}
}
