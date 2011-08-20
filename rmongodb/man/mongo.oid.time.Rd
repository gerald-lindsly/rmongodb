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
(integer) ("POSIXct") The time portion of the given \emph{oid}.
}
\examples{
oid <- mongo.oid.create()
print(mongo.oid.time(oid))
}
\seealso{
\link{mongo.oid},
\code{\link{mongo.oid.create}}
\code{\link{as.character.mongo.oid}}
\code{\link{mongo.oid.to.string}}
\code{\link{mongo.oid.from.string}}
\code{\link{mongo.bson.buffer.append}},
\code{\link{mongo.bson.buffer.append.oid}},
\link{mongo.bson.buffer},
\link{mongo.bson}
}
