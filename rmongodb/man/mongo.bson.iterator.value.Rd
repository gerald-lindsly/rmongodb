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
The value of the field pointed to by \code{iter}.

This function returns an appropriate R object depending on the type of the field pointed to by the iterator.
This mapping to values is as follows:
\tabular{ll}{
\code{\link{mongo.bson.eoo}} \tab 0L \cr
\code{\link{mongo.bson.double}} \tab A double \cr
\code{\link{mongo.bson.string}} \tab A string \cr
\code{\link{mongo.bson.object}} \tab (See below).\cr
\code{\link{mongo.bson.array}} \tab (See below).\cr
\code{\link{mongo.bson.binary}} \tab A raw vector.  (See below).\cr
\code{\link{mongo.bson.undefined}} \tab A \link{mongo.undefined} object \cr
\code{\link{mongo.bson.oid}} \tab A \link{mongo.oid} object \cr
\code{\link{mongo.bson.bool}} \tab A logical \cr
\code{\link{mongo.bson.date}} \tab A "POSIXct" class object \cr
\code{\link{mongo.bson.null}} \tab NULL \cr
\code{\link{mongo.bson.regex}} \tab A \link{mongo.regex} object \cr
\code{\link{mongo.bson.dbref}} \tab Error! (deprecated -- see link) \cr
\code{\link{mongo.bson.code}} \tab A \link{mongo.code} object \cr
\code{\link{mongo.bson.symbol}} \tab A \link{mongo.symbol} object \cr
\code{\link{mongo.bson.code.w.scope}} \tab A \link{mongo.code.w.scope} object \cr
\code{\link{mongo.bson.int}} \tab An integer \cr
\code{\link{mongo.bson.timestamp}} \tab A \link{mongo.timestamp} object \cr
\code{\link{mongo.bson.long}} \tab A double \cr
}

Special handling:

\code{\link{mongo.bson.object}}: If the object is recognized as a complex value
(of the form \{ "r" : double, "i" : double \}), a complex value is returned.
If the special wrapper as output by\cr
\code{\link{mongo.bson.buffer.append.object}()} is detected, an appropriately attributed R object is returned;
otherwise, a list is returned containing the subfields.

\code{\link{mongo.bson.array}}: If all fields of the array are of the same atomic type,
a vector of that type is returned.  (Multidimensinal arrays are detected and the \code{dims} attribute 
will be set accordingly.  Arrays of complex values are also detected as above).
Otherwise, a list is returned containing the subfields.

\code{\link{mongo.bson.binary}}: If non-zero, the subtype of the binary data is stored in the attribute "subtype".
See \code{\link{mongo.bson.buffer.append.raw}()}.
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
\code{\link{mongo.bson.iterator.key}},\cr
\code{\link{mongo.bson.iterator.type}},\cr
\link{mongo.bson}.
}
