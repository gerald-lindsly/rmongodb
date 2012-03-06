% File rmongodb/man/as.character.mongo.oid.Rd
\name{as.character.mongo.oid}
\alias{as.character.mongo.oid}
\title{Convert a mongo.oid object to a string}
\description{
Convert a \link{mongo.oid} object to a string of 24 hex digits.
This performs the inverse operation of \code{\link{mongo.oid.from.string}()}.

This function is an alias of \code{\link{mongo.oid.to.string}()} so that the class mechanism of R
allows it to be called simply by \code{as.character(oid)}.

See \url{http://www.mongodb.org/display/DOCS/Object+IDs}
}
\usage{
\method{as.character}{mongo.oid}(x, ...)
}
\arguments{
\item{x}{(\link{mongo.oid}) The OID to be converted.}
\item{...}{Parameters passed from generic.}
}
\value{
(string) A string of 24 hex digits representing the bits of oid \code{x}.
}
\examples{
oid <- mongo.oid.create()
print(as.character.mongo.oid(oid))
print(as.character(oid))  # print same thing as above line
}
\seealso{
\link{mongo.oid},\cr
\code{\link{mongo.oid.create}},\cr
\code{\link{as.character.mongo.oid}},\cr
\code{\link{mongo.oid.to.string}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.oid}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
