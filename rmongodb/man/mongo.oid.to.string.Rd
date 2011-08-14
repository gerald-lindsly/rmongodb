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
(string) A string of 24 hex digits representing the bits of \emph{oid}.
}
\examples{
oid <- mongo.oid.create()
print(mongo.oid.to.string(oid))
print(as.character(oid))  # print same thing as above line
}
\seealso{
\link{mongo.oid},
\code{\link{mongo.oid.create}}
\code{\link{as.character.mongo.oid}}
\code{\link{mongo.oid.to.string}}
\code{\link{mongo.bson.buffer.append}},
\code{\link{mongo.bson.buffer.append.oid}},
\link{mongo.bson.buffer},
\link{mongo.bson}
}
