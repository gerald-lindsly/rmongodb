% File rmongodb/man/mongo.bson.value.Rd
\name{mongo.bson.value}
\alias{mongo.bson.value}
\title{Return the value of a mongo.bson field}
\description{
Search a \link{mongo.bson} object for a field by name and retrieve its value.
}
\usage{
mongo.bson.value(b, name)
}
\arguments{
\item{b}{A \link{mongo.bson} object.}
\item{name}{(string) The name of a field within \code{b}}
}
\value{
NULL if name is not found;\cr
otherwise, the value of the found field.

This function returns an appropriate R object depending on the type of the field found.
This mapping to values is as follows:
\tabular{ll}{
\code{\link{mongo.bson.double}} \tab A double \cr
\code{\link{mongo.bson.string}} \tab A string \cr
\code{\link{mongo.bson.object}} \tab If the object is recognized as a complex value
(of the form \{ "r" : double, "i" : double \}),
 a complex value is returned.  If the special wrapper as output by \code{\link{mongo.bson.buffer.append.object}()}
 is detected, an appropriately attributed R object is returned; otherwise,
a list is returned containing the subfields.\cr
\code{\link{mongo.bson.array}} \tab If all fields of the array are of the same atomic type,
a vector of that type is returned.
Arrays of complex values are also detected as above.
Otherwise, a list is returned containing the subfields.\cr
\code{\link{mongo.bson.binary}} \tab A raw object.
If non-zero, the subtype of the binary data is stored in the attribute "subtype".
See \code{\link{mongo.bson.buffer.append.raw}()}.\cr
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

# Display the date appended above
print(mongo.bson.value(b, "created"))
}
\seealso{
\link{mongo.bson.iterator.value},\cr
\link{mongo.bson}.
}
