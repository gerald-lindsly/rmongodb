% File rmongodb/man/mongo.oid.to.string.Rd
\name{mongo.oid.to.string}
\alias{mongo.oid.to.string}
\title{Convert a mongo.oid object to a string}
\description{
Convert a \link{mongo.oid} object to a string of 24 hex digits.
This performs the inverse operation of \code{\link{mongo.oid.from.string}()}.

This function is an alias of \code{\link{as.character.mongo.oid}()} which you may perfer
to use since the class mechanism of R allows that to be called simply by \code{as.character(oid)}.

See \url{http://www.mongodb.org/display/DOCS/Object+IDs}
}
\usage{
mongo.oid.to.string(oid)
}
\arguments{
\item{oid}{(\link{mongo.oid}) The OID to be converted.}
}
\value{
(string) A string of 24 hex digits representing the bits of \code{oid}.
}
\examples{
oid <- mongo.oid.create()
print(mongo.oid.to.string(oid))
print(as.character(oid))  # print same thing as above line
}
\seealso{
\link{mongo.oid},\cr
\code{\link{mongo.oid.create}},\cr
\code{\link{as.character.mongo.oid}},\cr
\code{\link{mongo.oid.from.string}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.oid}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
