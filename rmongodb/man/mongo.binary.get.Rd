% File rmongodb/man/mongo.binary.get.Rd
\name{mongo.binary.get}
\alias{mongo.binary.get}
\title{Get a value from a mongo.binary object}
\description{
Get a value from a \link{mongo.binary} object at a given index.
}
\usage{
mongo.binary.get(bin, index)
}
\arguments{
\item{bin}{(\link{mongo.binary}) a mongo.binary object}
\item{index}{(as.integer) index into the binary data, 0-based}
}
\value{
(integer) The value of the byte at the given index.
}
\examples{
bin <- mongo.binary.create(type=0, length=5)
for (i in 0:4)
    mongo.binary.set(bin, i, i * 4 + 1)
for (i in 0:4)
    print(mongo.binary.get(bin, i))
}
\seealso{
\link{mongo.binary},
\code{\link{mongo.binary.create}},
\code{\link{mongo.binary.set}},
\code{\link{mongo.bson.buffer.append}},
\code{\link{mongo.bson.buffer.append.list}},
\link{mongo.bson.buffer},
\link{mongo.bson}
}
