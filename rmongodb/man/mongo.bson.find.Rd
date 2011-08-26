% File rmongodb/man/mongo.bson.find.Rd
\name{mongo.bson.find}
\alias{mongo.bson.find}
\title{Find a field within a mongo.bson object by name}
\description{
Find a field within a \link{mongo.bson} object by the name (key) of the field\cr
and return a \link{mongo.bson.iterator} pointing to that field.
}
\usage{
mongo.bson.find(b, name)
}
\arguments{
\item{b}{(\link{mongo.bson}) The object in which to find the field. }
\item{name}{(string) The name of the field to find.}
}
\value{
(\link{mongo.bson.iterator}) An iterator pointing to the field found if name was found
among the names of the fields; otherwise, NULL.
}
\examples{
b <- mongo.bson.from.list(list(name="John", age=32))
iter <- mongo.bson.find(b, "age")
print(mongo.bson.iterator.value(iter)) # print 32
}
\seealso{
\link{mongo.bson.iterator},\cr
\code{\link{mongo.bson.iterator.value}},\cr
\link{mongo.bson}.
}
