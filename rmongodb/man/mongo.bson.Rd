% File rmongodb/man/mongo.bson.Rd
\name{mongo.bson}
\docType{class}
\alias{mongo.bson}
\title{The mongo.bson class}
\description{
Objects of class "mongo.bson" are used to store BSON documents.
BSON is the form that MongoDB uses to store documents in its database.
MongoDB network traffic also uses BSON in messages.

See \url{http://www.mongodb.org/display/DOCS/BSON}.

mongo.bson objects have "mongo.bson" as their class and
contain an externally managed pointer to the actual document data.
This pointer is stored in the "mongo.bson" attribute of the object.

Objects of class "\link{mongo.bson.iterator}" are used to iterate over a
mongo.bson object to enumerate its keys and values.

Objects of class "\link{mongo.bson.buffer}" are used to build BSON documents.
}
\examples{
b <- mongo.bson.from.list(list(name="Fred", age=29, city="Boston"))
iter <- mongo.bson.iterator.create(b)  # b is of class "mongo.bson"
while (mongo.bson.iterator.next(iter))
    print(mongo.bson.iterator.value(iter))
}
\seealso{
\code{\link{mongo.bson.from.list}},\cr
\code{\link{mongo.bson.to.list}},\cr
\link{mongo.bson.iterator},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.from.buffer}},\cr
\code{\link{mongo.bson.empty}},\cr
\code{\link{mongo.find.one}},\cr
\code{\link{mongo.bson.destroy}},
\code{link{mongo.shorthand}}.
}
