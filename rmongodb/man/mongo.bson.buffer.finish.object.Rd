% File rmongodb/man/mongo.bson.buffer.finish.object.Rd
\name{mongo.bson.buffer.finish.object}
\alias{mongo.bson.buffer.finish.object}
\title{Finish a subobject or array within a mongo.bson.buffer}
\description{
BSON documents may themselves contain nested documents.  Call this function
to finish a subobject within a \link{mongo.bson.buffer}.

\code{\link{mongo.bson.buffer.start.object}()} and
\code{mongo.bson.buffer.finish.object()} may be called in a stackwise (LIFO) order to further nest documents.

This function must also be called to finish arrays.
}
\usage{
mongo.bson.buffer.finish.object(buf)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object on which to finish a subobject.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.start.object(buf, "name")
mongo.bson.buffer.append(buf, "first", "Jeff")
mongo.bson.buffer.append(buf, "last", "Davis")
mongo.bson.buffer.finish.object(buf)
mongo.bson.buffer.append(buf, "city", "Toronto")
b <- mongo.bson.from.buffer(buf)

# the above produces a BSON object of the form:
# { "name" : { "first" : "Jeff", "last" : "Davis" }, "city" : "Toronto" }
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.buffer.start.object}},\cr
\code{\link{mongo.bson.buffer.start.array}},\cr
\code{\link{mongo.bson.buffer.append}}.
}
