% File rmongodb/man/mongo..bson.buffer.size.Rd
\name{mongo.bson.buffer.size}
\alias{mongo.bson.buffer.size}
\title{Get the size of a mongo.bson.buffer object}
\description{
Get the number of bytes which would be taken up by the BSON data with the buffer is converted
to a mongo.bson object with \code{\link{mongo.bson.from.buffer}()}.
}
\usage{
mongo..bson.buffer.size(buf)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) the mongo.bson.buffer object to examine.}
}
\value{
(integer) the number of bytes which would be taken up by the BSON data with the buffer is converted
to a mongo.bson object with \code{\link{mongo.bson.from.buffer}()}.
}
\seealso{
\link{mongo.bson.buffer}
\link{mongo.bson}
}
\examples{
# should report 5
print(mongo..bson.buffer.size(mongo.bson.empty());

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Fred")
mongo.bson.buffer.append(buf, "city", "Dayton")
# both should report 37
print(mongo.bson.buffer.size(buf))
y <- mongo.bson.from.buffer(buf)
print(mongo..bson.buffer.size(y))

}
