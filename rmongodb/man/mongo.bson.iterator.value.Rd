% File rmongodb/man/mongo.bson.iterator.value.Rd
\name{mongo.bson.iterator.value}
\alias{mongo.bson.iterator.value}
\title{Return the value of the field pointed to by an iterator}
\description{
Return the value of the field pointed to by a \link{mongo.bson.iterator}.
}
\usage{
mongo.bson.iterator.value(iter)
}
\arguments{
\item{iter}{A \link{mongo.bson.iterator}.}
}
\value{
The value of the field pointed to by \emph{iter}.

This function returns an appropriate R object depending on the type of the field pointed to by the iterator.
This mapping to values is as follows:
\tabular{ll}{
\code{\link{mongo.bson.eoo}} \tab 0L \cr
\code{\link{mongo.bson.double}} \tab double \cr
\code{\link{mongo.bson.string}} \tab string \cr
\code{\link{mongo.bson.object}} \tab a \link{mongo.bson} which may be further iterated through for the values of subfields \cr
\code{\link{mongo.bson.array}} \tab if all fields of the array are of the same atomic type, a vector of that type is returned; 
otherwise, a \link{mongo.bson} object is returned which may be examined similarly as for mongo.bson.object \cr
\code{\link{mongo.bson.binary}} \tab \link{mongo.binary} \cr
\code{\link{mongo.bson.undefined}} \tab \link{mongo.undefined} \cr
\code{\link{mongo.bson.oid}} \tab \link{mongo.oid} \cr
\code{\link{mongo.bson.bool}} \tab logical \cr
\code{\link{mongo.bson.date}} \tab a "POSIXct" class object \cr
\code{\link{mongo.bson.null}} \tab NULL \cr
\code{\link{mongo.bson.regex}} \tab \link{mongo.regex} \cr
\code{\link{mongo.bson.dbref}} \tab Error! (deprecated -- see link)\cr
\code{\link{mongo.bson.code}} \tab \link{mongo.code} \cr
\code{\link{mongo.bson.symbol}} \tab \link{mongo.symbol} \cr
\code{\link{mongo.bson.code.w.scope}} \tab \link{mongo.code.w.scope} \cr
\code{\link{mongo.bson.int}} \tab integer \cr
\code{\link{mongo.bson.timestamp}} \tab \link{mongo.timestamp} \cr
\code{\link{mongo.bson.long}} \tab double \cr
}
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
\code{\link{mongo.bson.iterator.more}},
\code{\link{mongo.bson.iterator.key}},
\code{\link{mongo.bson.iterator.type}},
\link{mongo.bson}
}
