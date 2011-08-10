% File rmongodb/man/print.mongo.bson.Rd
\name{print.mongo.bson}
\alias{print.mongo.bson}
\title{Display a mongo.bson object}
\description{
Display formatted output of a mongo.bson object.

Output is tabbed (indented to show the nesting level of subobjects and arrays).

This version is an alias of mongo.bson.print() so that print() will properly handle the mongo.bson class.
}
\usage{
print.mongo.bson(b)
}
\arguments{
\item{(\link{mongo.bson}}{ The mongo.bson object to display.}
}
\value{
The parameter is returned unchanged.
}
\seealso{
\code{\link{mongo.bson.print}},
\link{mongo.bson}
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Fred")
mongo.bson.buffer.append(buf, "city", "Dayton")
b <- mongo.bson.from.buffer(buf)

# all display the same thing
print.mongo.bson(b)
mongo.bson.print(b)
print(b)
}
