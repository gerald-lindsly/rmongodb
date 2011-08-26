% File rmongodb/man/mongo.bson.buffer.start.array.Rd
\name{mongo.bson.buffer.start.array}
\alias{mongo.bson.buffer.start.array}
\title{Start an array within a mongo.bson.buffer}
\description{
Call this function to start an array within a \link{mongo.bson.buffer}.\cr
\code{\link{mongo.bson.buffer.finish.object}()} must be called
when finished appending the elements of the array.

(\code{mongo.bson.buffer.start.object()}, \code{mongo.bson.buffer.start.array()}) and\cr
\code{mongo.bson.buffer.finsih.object()} may be called in a stackwise (LIFO) order to 
further nest arrays and documents.

The names of the elements appended should properly be given sequentially numbered strings.

Note that arrays will be automatically appended by the 'append' functions when appending vectors 
(containing more than one element) of atomic types.
}
\usage{
mongo.bson.buffer.start.array(buf, name)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the array to be appended to the buffer. }
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.start.array(buf, "Fibonacci")
x <- 0
mongo.bson.buffer.append.int(buf, "0", x)
y <- 1
mongo.bson.buffer.append.int(buf, "1", y)
for (i in 2:8) {
    z <- x + y
    mongo.bson.buffer.append.int(buf, as.character(i), z)
    x <- y
    y <- z
}
mongo.bson.buffer.finish.object(buf)
b <- mongo.bson.from.buffer(buf)

# the above produces a BSON object of the form:
# { "Fibonacci" : [ 0, 1, 1, 2, 3, 5, 8, 13, 21 ] }
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.buffer.finish.object}},\cr
\code{\link{mongo.bson.buffer.start.array}},\cr
\code{\link{mongo.bson.buffer.append}}.
}
