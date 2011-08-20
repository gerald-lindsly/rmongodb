% File rmongodb/man/mongo.bson.size.Rd
\name{mongo.bson.size}
\alias{mongo.bson.size}
\title{Get the size of a mongo.bson object}
\description{
Get the number of bytes taken up by the BSON data attached to the mongo.bson object
}
\usage{
mongo.bson.size(b)
}
\arguments{
\item{b}{(\link{mongo.bson}) the mongo.bson object to examine.}
}
\value{
(integer) the number of bytes taken up by the BSON data attached to the mongo.bson object.
}
\examples{
# should report 5
print(mongo.bson.size(mongo.bson.empty()))

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Fred")
mongo.bson.buffer.append(buf, "city", "Dayton")
y <- mongo.bson.from.buffer(buf)
# should report 37
print(mongo.bson.size(y))
}
\seealso{
\link{mongo.bson}
}
