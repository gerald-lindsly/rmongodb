% File rmongodb/man/mongo.find.Rd
\name{mongo.find}
\alias{mongo.find}
\title{Find records in a collection}
\description{
Find records in a collection that match a given query.

See \url{http://www.mongodb.org/display/DOCS/Querying}.
}
\usage{
mongo.find(mongo, ns, query=mongo.bson.empty(), fields=mongo.bson.empty(), limit=1L, skip=0L, options=0L)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
\item{ns}{(string) namespace of the collection from which to find records.}
\item{query}{(\link{mongo.bson}) The criteria with which to match the records to be found.
    The default of mongo.bson.empty() will cause the the very first record in the collection to be returned. }
\item{fields}{(\link{mongo.bson}) The desired fields which are to be returned frtom the matching record.
    The default of mongo.bson.empty() will cause all fields of the matching record to be returned; 
    however, specific fields may be specified to cut down on network traffic and memory overhead.}
\item{limit}{(as.integer) The maximum number of records to be returned. A limit of 0L will return all matching records not skipped.}
\item{skip}{(as.integer) The number of matching records to skip before returning subsequent matching records.}
\item{options}{(integer vector) Flags governing the requested operation as follows: mongo.find.cursor.tailable, 
    mongo.find.slave.ok, mongo.find.oplog.replay, mongo.find.no.cursor.timeout, mongo.find.await.data, 
    mongo.find.exhaust, or mongo.find.partial.results.}
}
\value{
(\link{mongo.cursor}) An object of class "mongo.cursor" which is used to step through the matching records.
Note that an empty cursor will be returned if a database error occurred.  
\code{\link{mongo.get.server.err}()} and \code{\link{mongo.get.server.err.string}()} may be examined in that case.
}
\seealso{
\code{\link{mongo.cursor}},
\code{\link{mongo.cursor.next}},
\code{\link{mongo.cursor.value}},
\code{\link{mongo.find.one}},
\code{\link{mongo.insert}},
\code{\link{mongo.index.create}},
\code{\link{mongo.update}},
\code{\link{mongo.remove}},
\link{mongo},
\link{mongo.bson}
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "age", 18L)
    query <- mongo.bson.from.buffer(buf)

    # Find the first 100 records in collection people of database test where age == 18
    cursor <- mongo.find(mongo, "test.people", query, limit=100L)
    # Step though the matching records and display them
    while (mongo.cursor.next(cursor))
        print(mongo.cursor.value(cursor))
    mongo.cursor.destroy(cursor)
}
}
