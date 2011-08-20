% File rmongodb/man/mongo.bson.buffer.start.object.Rd
\name{mongo.bson.buffer.start.object}
\alias{mongo.bson.buffer.start.object}
\title{Start a subobject within a mongo.bson.buffer}
\description{
BSON documents may themselves contain nested documents.  Call this function
to start a subobject within a \link{mongo.bson.buffer}. 

\code{\link{mongo.bson.buffer.finish.object}()} must be called
when finsihed appending subfields.  (\code{mongo.bson.buffer.start.object()}, \code{mongo.bson.buffer.start.array()})
and 
\code{mongo.bson.buffer.finish.object()} may be called in a stackwise (LIFO) order to further nest documents and arrays.
}
\usage{
mongo.bson.buffer.start.object(buf, name)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the subobject to be appended to the buffer. }
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
\link{mongo.bson}
\link{mongo.bson.buffer}
\code{\link{mongo.bson.buffer.finish.object}},
\code{\link{mongo.bson.buffer.start.array}},
\code{\link{mongo.bson.buffer.append}}
}
