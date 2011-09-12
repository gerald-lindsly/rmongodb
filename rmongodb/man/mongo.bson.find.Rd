% File rmongodb/man/mongo.bson.find.Rd
\name{mongo.bson.find}
\alias{mongo.bson.find}
\title{Find a field within a mongo.bson object by name}
\description{
Find a field within a \link{mongo.bson} object by the name (key) of the field\cr
and return a \link{mongo.bson.iterator} pointing to that field.

The search parameter may also be a 'dotted' reference to a field in a subobject or array. See examples.
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
b <- mongo.bson.from.list(list(name="John", age=32L, 
     address=list(street="Vine", city="Denver", state="CO")))
iter <- mongo.bson.find(b, "age")
print(mongo.bson.iterator.value(iter)) # print 32

iter <- mongo.bson.find(b, "address.city")
print(mongo.bson.iterator.value(iter)) # print Denver

x <- c(1,1,2,3,5)
b <- mongo.bson.from.list(list(fib=x))
iter <- mongo.bson.find(b, "fib.3")  # BSON arrays are 0-based
print(mongo.bson.iterator.value(iter)) # print 3
}
\seealso{
\link{mongo.bson.iterator},\cr
\code{\link{mongo.bson.iterator.value}},\cr
\link{mongo.bson}.
}
