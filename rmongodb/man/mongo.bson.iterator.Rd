% File rmongodb/man/mongo.bson.iterator.Rd
\name{mongo.bson.iterator}
\docType{class}
\alias{mongo.bson.iterator}
\title{The mongo.bson.iterator class}
\description{
Objects of class "mongo.bson.iterator" are used to iterate through BSON documents 
as stored in \link{mongo.bson} objects.

mongo.bson.iterator objects have "mongo.bson.iterator" as their class and
contain an externally managed pointer to the actual document data.
This pointer is stored in the "mongo.bson.iterator" attribute of the object.
}
\examples{
b <- mongo.bson.from.list(list(name="Joy", age=35, city="Ontario"))
iter <- mongo.bson.iterator.create(b)  # b is of class "mongo.bson"
while (mongo.bson.iterator.next(iter))
    print(mongo.bson.iterator.value(iter))
}
\seealso{
\code{\link{mongo.bson.iterator.create}},
\code{\link{mongo.bson.find}},
\code{\link{mongo.bson.iterator.next}},
\code{\link{mongo.bson.iterator.key}},
\code{\link{mongo.bson.iterator.value}},
\link{mongo.bson}
}
