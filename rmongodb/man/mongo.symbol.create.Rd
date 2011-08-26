% File rmongodb/man/mongo.symbol.create.Rd
\name{mongo.symbol.create}
\alias{mongo.symbol.create}
\title{Create a mongo.symbol object}
\description{
Create a mongo.symbol object for appending to a buffer with\cr \code{\link{mongo.bson.buffer.append}()} or
for embedding in a list such that \code{\link{mongo.bson.buffer.append.list}()} will properly insert a symbol
value into the mongo.bson.buffer object.
}
\usage{
mongo.symbol.create(value)
}
\arguments{
\item{value}{(string) The value of the symbol}
}
\value{
a \link{mongo.symbol} object
}
\examples{
buf <- mongo.bson.buffer.create()
sym <- mongo.symbol.create("Alpha")
mongo.bson.buffer.append(buf, "A", sym)
lst <- list(s1 = sym, One = 1)
mongo.bson.buffer.append.list(buf, "listWsym", lst)
mongo.bson.buffer.append.symbol(buf, "D", "Delta")
b <- mongo.bson.from.buffer(buf)

# the above will create a mongo.bson object of the following form:
# { "A": (SYMBOL) "Alpha",
#   "listWsym" : { "a1"  : (SYMBOL) "Aplha",
#                  "One" : 1 }, 
#   "D" : (SYMBOL) "Delta" }
}
\seealso{
\link{mongo.symbol},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
