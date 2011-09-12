% File rmongodb/man/mongo.shorthand.Rd
\name{mongo.shorthand}
\alias{mongo.shorthand}
\title{Define shorthand names for bson and gridfs functions}
\description{
Define shorthand names for bson and gridfs functions and constants.

All symbols dealing with BSON and GridFS are defined by this function excluding the "mongo." prefix.  
They will still be available by the orginal names also.  For clarity, the symbols in the mongo module
(for communication with the server) are not shortened.

}
\usage{
mongo.shorthand()
}
\value{
    TRUE
}
\examples{
mongo.shorthand()
buf <- bson.buffer.create()
bson.buffer.append(buf, "name", "Alice")
b <- bson.from.buffer(buf)
}
\seealso{
\link{mongo},\cr
\code{\link{mongo.bson.buffer.create}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.from.buffer}}.
}
