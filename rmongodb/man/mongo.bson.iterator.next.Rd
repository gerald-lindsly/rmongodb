% File rmongodb/man/mongo.bson.iterator.next.Rd
\name{mongo.bson.iterator.next}
\alias{mongo.bson.iterator.next}
\title{Advance an iterator to the first or next field}
\description{
Advance a \link{mongo.bson.iterator} to the first or next field.
}
\usage{
mongo.bson.iterator.next(iter)
}
\arguments{
\item{iter}{A \link{mongo.bson.iterator}.}
}
\value{
(integer) The type of the next of the field pointed to by the iterator as indicated by the folllowing constants:
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
# Append a string
mongo.bson.buffer.append(buf, "name", "Joe")
# Append a date/time
mongo.bson.buffer.append(buf, "created", Sys.time())
# Append a NULL
mongo.bson.buffer.append(buf, "cars", NULL)
b <- mongo.bson.from.buffer(buf)

iter <- mongo.bson.iterator.create(b)
# Advance to the "cars" field
while (mongo.bson.iterator.next(iter) != mongo.bson.null)
{ 
    # NOP
}
print(mongo.bson.iterator.value(iter))

# The above is given for illustrative purposes, but may be performed 
# much easier by the following:
iter <- mongo.bson.find(b, "cars")
print(mongo.bson.iterator.value(iter))

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
\code{\link{mongo.bson.iterator.key}},\cr
\code{\link{mongo.bson.iterator.type}},\cr
\code{\link{mongo.bson.iterator.value}},\cr
\link{mongo.bson}.
}
