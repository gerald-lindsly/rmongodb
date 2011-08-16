% File rmongodb/man/mongo.bson.iterator.type.Rd
\name{mongo.bson.iterator.type}
\alias{mongo.bson.iterator.type}
\title{Get the type of data pointed to by an iterator}
\description{
Return the type of the field currently pointed to by a \link{mongo.bson.iterator}.
}
\usage{
mongo.bson.iterator.type(iter)
}
\arguments{
\item{iter}{A \link{mongo.bson.iterator}.}
}
\value{
(integer) The type of the field pointed to by the iterator as indicated by the following constants:
\itemize{
\item{\link{mongo.bson.eoo}} -- End of Object (0L)
\item{\link{mongo.bson.double}}
\item{\link{mongo.bson.string}}
\item{\link{mongo.bson.object}}
\item{\link{mongo.bson.array}}
\item{\link{mongo.bson.binary}}
\item{\link{mongo.bson.undefined}}
\item{\link{mongo.bson.oid}}
\item{\link{mongo.bson.bool}}
\item{\link{mongo.bson.date}}
\item{\link{mongo.bson.null}}
\item{\link{mongo.bson.regex}}
\item{\link{mongo.bson.dbref}} -- deprecated (follow link for more info)
\item{\link{mongo.bson.code}}
\item{\link{mongo.bson.symbol}}
\item{\link{mongo.bson.code.w.scope}}
\item{\link{mongo.bson.int}}
\item{\link{mongo.bson.timestamp}}
\item{\link{mongo.bson.long}}
}
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Joe") #  Append a string
mongo.bson.buffer.append(buf, "created", Sys.time()) #  Append a date/time
mongo.bson.buffer.append(buf, "cars", NULL) #  Append a NULL
b <- mongo.bson.from.buffer(buf)

iter <- mongo.bson.iterator.create(b)
while (mongo.bson.iterator.next(iter))
    if (mongo.bson.iterator.type(iter) == mongo.bson.date) {
        print(mongo.bson.iterator.value(iter))
        break
    }

# The above is given for illustrative purposes, but may be performed 
# much easier by the following:
iter <- mongo.bson.find(b, "created")
print(mongo.bson.iterator.value(iter))
}
\seealso{
\link{mongo.bson.iterator},
\code{\link{mongo.bson.iterator.create}},
\code{\link{mongo.bson.find}},
\code{\link{mongo.bson.iterator.next}},
\code{\link{mongo.bson.iterator.key}},
\code{\link{mongo.bson.iterator.value}},
\link{mongo.bson}
}
