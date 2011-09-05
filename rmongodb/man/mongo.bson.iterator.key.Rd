% File rmongodb/man/mongo.bson.iterator.key.Rd
\name{mongo.bson.iterator.key}
\alias{mongo.bson.iterator.key}
\title{Return the key (name) of the field pointed to by an iterator}
\description{
Return the key (name) of the field pointed to by a \link{mongo.bson.iterator}.
}
\usage{
mongo.bson.iterator.key(iter)
}
\arguments{
\item{iter}{A \link{mongo.bson.iterator}.}
}
\value{
(string) The key (name) of the field pointed to by \code{iter}
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

# iterate through all values and print them with their keys (names)
iter <- mongo.bson.iterator.create(b)
while (mongo.bson.iterator.next(iter)) { # eoo at end stops loop
    print(mongo.bson.iterator.key(iter))
    print(mongo.bson.iterator.value(iter))
}
}
\seealso{
\link{mongo.bson.iterator},\cr
\code{\link{mongo.bson.iterator.create}},\cr
\code{\link{mongo.bson.find}},\cr
\code{\link{mongo.bson.iterator.next}},\cr
\code{\link{mongo.bson.iterator.type}},\cr
\code{\link{mongo.bson.iterator.value}},\cr
\link{mongo.bson}.
}
