% File rmongodb/man/mongo.distinct.Rd
\name{mongo.distinct}
\alias{mongo.distinct}
\title{Get a vector of distinct keys in a collection}
\description{
Get a vector of distinct keys in a collection.

See \url{http://www.mongodb.org/display/DOCS/Aggregation#Aggregation-Distinct}.
}
\usage{
mongo.distinct(mongo, ns, key, query=mongo.bson.empty())
}
\arguments{
\item{mongo}{(\link{mongo}) A mongo connection object.}
\item{ns}{(string) The namespace of the collection in which to find distinct keys.}
\item{key}{(string) The name of the key field for which to get distinct values.}
\item{query}{\link{mongo.bson} An optional query to restrict the returned values.}
}
\value{
NULL if the command failed.  \code{\link{mongo.get.err}()} may be MONGO_COMMAND_FAILED.

(vector) The result set of distinct keys.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    keys <- mongo.distinct(mongo, "test.people", "name")
    print(keys)
}
}
\seealso{
\code{\link{mongo.command}},\cr
\code{\link{mongo.simple.command}},\cr
\code{\link{mongo.find}},\cr
\link{mongo}.
}
