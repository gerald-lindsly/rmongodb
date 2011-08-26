% File rmongodb/man/mongo.symbol.Rd
\name{mongo.symbol}
\docType{class}
\alias{mongo.symbol}
\title{The mongo.symbol class}
\description{
Objects of class "mongo.symbol" are used to represent symbol values in BSON documents.

mongo.symbol objects' value is a string representing the value of the symbol.

mongo.symbol objects have "mongo.symbol" as their class so that\cr
\code{\link{mongo.bson.buffer.append}()} 
may detect them and append the appropriate BSON symbol-typed value to a buffer.

These mongo.symbol values may also be present in a list and will be handled properly\cr
by \code{\link{mongo.bson.buffer.append.list}()} and \code{\link{mongo.bson.from.list}()}.
}
\examples{
buf <- mongo.bson.buffer.create()
sym <- mongo.symbol.create("Beta")
mongo.bson.buffer.append(buf, "B", sym)
l <- list(s1 = sym, Two = 2)
mongo.bson.buffer.append.list(buf, "listWsym", l)
b <- mongo.bson.from.buffer(buf)

# the above will create a mongo.bson object of the following form:
# { "B": (SYMBOL) "Beta", 
#   "listWsym" : { "s1" : (SYMBOL) "Beta",
#                  "Two" : 2 } }
}
\seealso{
\code{\link{mongo.symbol.create}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
