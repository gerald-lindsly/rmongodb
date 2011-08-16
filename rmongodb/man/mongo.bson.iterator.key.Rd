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
(string) The key (name) of the field pointed to by \emph{iter}
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Joe") #  Append a string
mongo.bson.buffer.append(buf, "created", Sys.time()) #  Append a date/time
mongo.bson.buffer.append(buf, "cars", NULL) #  Append a NULL
b <- mongo.bson.from.buffer(buf)

# iterate through all values and print them with their keys (names)
iter <- mongo.bson.iterator.create(b)
while (mongo.bson.iterator.next(iter)) { # eoo at end stops loop
    print(mongo.bson.iterator.key(iter))
    print(mongo.bson.iterator.value(iter))
}
}
\seealso{
\link{mongo.bson.iterator},
\code{\link{mongo.bson.iterator.create}},
\code{\link{mongo.bson.find}},
\code{\link{mongo.bson.iterator.next}},
\code{\link{mongo.bson.iterator.type}},
\code{\link{mongo.bson.iterator.value}},
\link{mongo.bson}
}
