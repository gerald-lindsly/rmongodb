% File rmongodb/man/mongo.bson.destroy.Rd
\name{mongo.bson.destroy}
\alias{mongo.bson.destroy}
\title{Destroy a mongo.bson object}
\description{
Releases the resources associated with a \link{mongo.bson} object.
It is not absolutely necessary to call this function since R's garbage collection will eventually
get around to doing it for you.
}
\usage{
mongo.bson.destroy(b)
}
\arguments{
\item{b}{A (\link{mongo.bson}) object.}
}
\value{
NULL
}
\examples{
b <- mongo.bson.from.list(list(name="Cheryl", age=29))
print(b)
mongo.bson.destroy(b)
}
\seealso{
\link{mongo.bson},\cr
\code{\link{mongo.bson.from.list}},\cr
\code{\link{mongo.bson.from.buffer}}.
}
