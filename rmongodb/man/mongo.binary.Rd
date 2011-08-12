% File rmongodb/man/mongo.binary.Rd
\name{mongo.binary}
\docType{class}
\alias{mongo.binary}
\title{The mongo.binary class}
\description{
Objects of class "mongo.binary" are used to represent arbitrary binary data values in BSON documents.

mongo.binary objects contain an externally managed pointer to the actual binary data.
This pointer is stored in the "mongo.bson" attribute of the object.

The length of the data is stored in the "length" attribute of the object.

mongo.binary objects have "mongo.binary" as their class so that \code{\link{mongo.bson.buffer.append}()} 
may detect them and append the appropriate BSON binary data to a buffer.

mongo.binary object may also be present in a list and will be handled properly
by \code{\link{mongo.bson.buffer.append.list}()}
}
\examples{
buf <- mongo.bson.buffer.create()
bin <- mongo.binary.create(type=1, length=5)
for (i in 0:4)
    mongo.binary.set(bin, i, i * 7)
mongo.bson.buffer.append(buf, "bin", bin)
}
\seealso{
\code{\link{mongo.binary.create}},
\code{\link{mongo.binary.set}},
\code{\link{mongo.binary.get}},
\code{\link{mongo.bson.buffer.append}},
\code{\link{mongo.bson.buffer.append.list}},
\link{mongo.bson.buffer},
\link{mongo.bson}
}
