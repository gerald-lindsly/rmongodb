% File rmongodb/man/mongo.bson.empty.Rd
\name{mongo.bson.empty}
\alias{mongo.bson.empty}
\title{Create an empty mongo.bson object}
\description{
Returns an empty mongo.bson object.
mongo.bson objects have "mongo.bson" as their class and
contain an externally managed pointer to the actual data.
This pointer is stored in the "mongo.bson" attribute of the object.
}
\usage{
mongo.bson.empty()
}
\value{
An empty mongo.bson object
}
\examples{
# Use an empty mongo.bson for the query object which matches everything.
# This happens to be the default value for the query
# parameter to mongo.count,  but we explicity use mongo.bson.empty()
# here for an example.
mongo <- mongo.create()
if (mongo.is.connected(mongo))
    print(mongo.count(mongo, "test.people", query=mongo.bson.empty()))
}
\seealso{
\link{mongo.bson}
}
