% File rmongodb/man/mongo.binary.set.Rd
\name{mongo.binary.set}
\alias{mongo.binary.set}
\title{Set a value in a mongo.binary object}
\description{
set a value in a \link{mongo.binary} object at a given index.
}
\usage{
mongo.binary.set(bin, index, value)
}
\arguments{
\item{bin}{(\link{mongo.binary}) a mongo.binary object}
\item{index}{(as.integer) index into the binary data, 0-based}
\item{value}{(integer) byte value of the binary data at the given index}
}
\value{
NULL
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
\code{\link{mongo.binary.get}},
\code{\link{mongo.bson.buffer.append}},
\code{\link{mongo.bson.buffer.append.list}},
\link{mongo.bson.buffer},
\link{mongo.bson}
}
