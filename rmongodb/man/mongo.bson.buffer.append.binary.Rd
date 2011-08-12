% File rmongodb/man/mongo.bson.buffer.append.binary.Rd
\name{mongo.bson.buffer.append.binary}
\alias{mongo.bson.buffer.append.binary}
\title{Append a code field onto a mongo.bson.buffer}
\description{
Append binary data onto a mongo.bson.buffer.

BSON has a special field type to indicate binary data.
This function appends such an indicator as the type of a field with its value.
}
\usage{
mongo.bson.buffer.append.binary(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson}) The mongo.bson.buffer object to which to append.}
\item{name}{(string) the name (key) of the field appended to the buffer.}
\item{value}{\link{mongo.binary} the binary data.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
bin <- mongo.binary.create(type=1, length=3)
for (i in 0:2)
    mongo.binary.set(bin, i, i * 3)
mongo.bson.buffer.append.binary(buf, "bin1", bin)

# note that \code{\link{mongo.bson.buffer.append}()} will detect whether the value parameter 
# is a mongo.binary object and append the appropriate type and value.
mongo.bson.buffer.append(buf, "bin2", bin)  # gives same result
}
\seealso{
\link{mongo.binary},
\code{\link{mongo.binary.create}},
\code{\link{mongo.binary.set}},
\code{\link{mongo.binary.get}},
\code{\link{mongo.bson.buffer.append}},
\link{mongo.bson},
\link{mongo.bson.buffer}
}
