% File rmongodb/man/mongo.bson.buffer.append.null.Rd
\name{mongo.bson.buffer.append.null}
\alias{mongo.bson.buffer.append.null}
\title{Append a double field onto a mongo.bson.buffer}
\description{
Append a NULL value onto a \link{mongo.bson.buffer}.

}
\usage{
mongo.bson.buffer.append.null(buf, name)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer.}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.null(buf, "Nil")
b <- mongo.bson.from.buffer(buf)

# The above produces a BSON object of the form { "Nil" : NULL }
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.buffer.append}}.
}
