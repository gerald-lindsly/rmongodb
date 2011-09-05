% File rmongodb/man/mongo.bson.from.list.Rd
\name{mongo.bson.from.list}
\alias{mongo.bson.from.list}
\title{Convert a list to a mongo.bson object}
\description{
Convert a list to a \link{mongo.bson} object.

This function permits the simple and convenient creation of a mongo.bson object.  This bypasses the creation
of a \link{mongo.bson.buffer}, appending fields one by one, and then turning the buffer
into a mongo.bson object with \code{\link{mongo.bson.from.buffer}()}.

Note that this function and \code{\link{mongo.bson.to.list}()} do not always perform inverse 
conversions since mongo.bson.to.list() will convert objects and subobjects to atomic vectors if possible.
}
\usage{
mongo.bson.from.list(lst)
}
\arguments{
\item{lst}{(list) The list to convert. 

This \emph{must} be a list, \emph{not} a vector of atomic types; otherwise, an error is thrown;
use \code{as.list()} as necessary.}
}
\value{
(\link{mongo.bson}) A mongo.bson object serialized from \code{lst}.
}
\examples{
lst <- list(name="John", age=32)
b <- mongo.bson.from.list(lst)
# the above produces a BSON object of the form:
# { "name" : "John", "age" : 32.0 }

# Convert a vector of an atomic type to a list and
# then to a mongo.bson object
v <- c(president="Jefferson", vice="Burr")
b <- mongo.bson.from.list(as.list(v))
# the above produces a BSON object of the form:
# { "president" : "Jefferson", "vice" : "Burr" }
}
\seealso{
\code{\link{mongo.bson.to.list}},\cr
\link{mongo.bson},\cr
\code{\link{mongo.bson.destroy}}.
}
