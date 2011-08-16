% File rmongodb/man/mongo.remove.Rd
\name{mongo.remove}
\alias{mongo.remove}
\title{Remove records from a collection}
\description{
Remove all records from a collection that match a given criteria.

See \url{http://www.mongodb.org/display/DOCS/Removing}.
}
\usage{
mongo.remove(mongo, ns, criteria=mongo.bson.empty())
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
\item{ns}{(string) namespace of the collection from which to remove records.}
\item{criteria}{(\link{mongo.bson}) The criteria with which to match records that are to be removed.
The default of mongo.bson.empty() will cause \emph{all} records in the given collection to be removed.}
}
\seealso{
\link{mongo},
\link{mongo.bson},
\code{\link{mongo.insert}},
\code{\link{mongo.update}},
\code{\link{mongo.find}},
\code{\link{mongo.find.one}}
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Jeff")
    criteria <- mongo.bson.from.buffer(buf)

    # remove all records where name is "Jeff" from collection people in database test
    mongo.remove(mongo, "test.people", criteria)

    # remove all records from collection cars in database test
    mongo.remove(mongo, "test.cars")
}
}
