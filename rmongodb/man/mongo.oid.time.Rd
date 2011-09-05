% File rmongodb/man/mongo.oid.time.Rd
\name{mongo.oid.time}
\alias{mongo.oid.time}
\title{Get an Object ID's time}
\description{
Get the 32-bit UTC time portion of an OID (Object ID).

See \url{http://www.mongodb.org/display/DOCS/Object+IDs}
}
\usage{
mongo.oid.time(oid)
}
\arguments{
\item{oid}{(\link{mongo.oid}) The OID to be examined.}
}
\value{
(integer) ("POSIXct") The time portion of the given \code{oid}.
}
\examples{
oid <- mongo.oid.create()
print(mongo.oid.time(oid))
}
\seealso{
\link{mongo.oid},\cr
\code{\link{mongo.oid.create}},\cr
\code{\link{as.character.mongo.oid}},\cr
\code{\link{mongo.oid.to.string}},\cr
\code{\link{mongo.oid.from.string}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.oid}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
