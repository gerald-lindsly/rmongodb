% File rmongodb/man/print.mongo.oid.Rd
\name{print.mongo.oid}
\alias{print.mongo.oid}
\title{Display a mongo.oid object}
\description{
Display formatted output of a \link{mongo.oid} object.

Output is tabbed (indented to show the nesting level of subobjects and arrays).

This version is an alias of \code{\link{mongo.oid.print}()} so that \code{print()} will properly handle the mongo.oid class.
}
\usage{
\method{print}{mongo.oid}(x, ...)
}
\arguments{
\item{x}{\link{mongo.oid} The object to display.}
\item{...}{Parameters passed from generic.}
}
\value{
The parameter is returned unchanged.
}
\examples{
oid <- mongo.oid.create()

# all display the same thing
print.mongo.oid(oid)
mongo.oid.print(oid)
print(oid)
}
\seealso{
\code{\link{mongo.oid.print}},\cr
\code{\link{mongo.oid.to.string}},\cr
\link{mongo.bson.oid},\cr
\link{mongo.bson}.
}
