% File rmongodb/man/mongo.bson.iterator.create.Rd
\name{mongo.bson.iterator.create}
\alias{mongo.bson.iterator.create}
\title{Create a mongo.bson.iterator object}
\description{
Create a \link{mongo.bson.iterator} object used to step 
through a given \link{mongo.bson} object one field at a time.
}
\usage{
mongo.bson.iterator.create(b)
}
\arguments{
\item{b}{(\link{mongo.bson}) The mongo.bson object through which to iterate.

\code{b} may also be a mongo.bson.iterator and is expected to point to a subobject or array.
The iterator returned may be used to step through the subobject or array.}
}
\value{
(\link{mongo.bson.iterator}) An iterator initialized to 'before' the start of the given mongo.bson object.
\code{\link{mongo.bson.iterator.next}()} should be used on the iterator first to step to the first field.
}
\examples{
buf <- mongo.bson.buffer.create()
# Append a string
mongo.bson.buffer.append(buf, "name", "Joe")
# Append a date/time
mongo.bson.buffer.append(buf, "created", Sys.time())
# Append a NULL
mongo.bson.buffer.append(buf, "cars", NULL)
b <- mongo.bson.from.buffer(buf)

iter <- mongo.bson.iterator.create(b)
while (mongo.bson.iterator.next(iter))
    if (mongo.bson.iterator.key(iter) == "created") {
        print(mongo.bson.iterator.value(iter))
        break
    }

# The above is given for illustrative purposes, but may be performed 
# much easier (and faster) by the following:
iter <- mongo.bson.find(b, "created")
print(mongo.bson.iterator.value(iter))
}
\seealso{
\link{mongo.bson.iterator},\cr
\code{\link{mongo.bson.find}},\cr
\code{\link{mongo.bson.iterator.next}},\cr
\code{\link{mongo.bson.iterator.key}},\cr
\code{\link{mongo.bson.iterator.type}},\cr
\code{\link{mongo.bson.iterator.value}},\cr
\link{mongo.bson}.
}
