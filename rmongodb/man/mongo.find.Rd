% File rmongodb/man/mongo.find.Rd
\name{mongo.find}
\alias{mongo.find}
\title{Find records in a collection}
\description{
Find records in a collection that match a given query.

See \url{http://www.mongodb.org/display/DOCS/Querying}.
}
\usage{
mongo.find(mongo, ns, query=mongo.bson.empty(),
           sort=mongo.bson.empty(), fields=mongo.bson.empty(),
           limit=0L, skip=0L, options=0L)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
\item{ns}{(string) namespace of the collection from which to find records.}
\item{query}{(\link{mongo.bson}) The criteria with which to match the records to be found.
    The default of mongo.bson.empty() will cause the the very first record in the collection to be returned.
    
Alternately, \code{query} may be a list which will be converted to a mongo.bson object
by \code{\link{mongo.bson.from.list}()}.}
\item{sort}{(\link{mongo.bson}) The desired fields by which to sort the returned records. The default of mongo.bson.empty()
    indicates that no special sorting is to be done; the records will come back in the order that indexes locate them.
    
Alternately, \code{sort} may be a list which will be converted to a mongo.bson object
by \code{\link{mongo.bson.from.list}()}.}
\item{fields}{(\link{mongo.bson}) The desired fields which are to be returned from the matching record.
    The default of mongo.bson.empty() will cause all fields of the matching record to be returned; 
    however, specific fields may be specified to cut down on network traffic and memory overhead.
    
Alternately, \code{fields} may be a list which will be converted to a mongo.bson object
by \code{\link{mongo.bson.from.list}()}.}
\item{limit}{(as.integer) The maximum number of records to be returned. A limit of 0L will return all matching records not skipped.}
\item{skip}{(as.integer) The number of matching records to skip before returning subsequent matching records.}
\item{options}{(integer vector) Flags governing the requested operation as follows:
    \itemize{
        \item{\link{mongo.find.cursor.tailable}}
        \item{\link{mongo.find.slave.ok}}
        \item{\link{mongo.find.oplog.replay}}
        \item{\link{mongo.find.no.cursor.timeout}}
        \item{\link{mongo.find.await.data}}
        \item{\link{mongo.find.exhaust}}
        \item{\link{mongo.find.partial.results}}
     }}
}
\value{
(\link{mongo.cursor}) An object of class "mongo.cursor" which is used to step through the matching records.

Note that an empty cursor will be returned if a database error occurred.\cr
\code{\link{mongo.get.server.err}()} and \code{\link{mongo.get.server.err.string}()} may be examined in that case.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "age", 18L)
    query <- mongo.bson.from.buffer(buf)

    # Find the first 100 records
    #    in collection people of database test where age == 18
    cursor <- mongo.find(mongo, "test.people", query, limit=100L)
    # Step though the matching records and display them
    while (mongo.cursor.next(cursor))
        print(mongo.cursor.value(cursor))
    mongo.cursor.destroy(cursor)


    # shorthand: find all records where age=32, sorted by name, 
    # and only return the name & address fields:
    cursor <- mongo.find(mongo, "test.people", list(age=32),
                         list(name=1L), list(name=1L, address=1L))
}
}
\seealso{
\code{\link{mongo.cursor}},\cr
\code{\link{mongo.cursor.next}},\cr
\code{\link{mongo.cursor.value}},\cr
\code{\link{mongo.find.one}},\cr
\code{\link{mongo.insert}},\cr
\code{\link{mongo.index.create}},\cr
\code{\link{mongo.update}},\cr
\code{\link{mongo.remove}},\cr
\link{mongo},\cr
\link{mongo.bson}.
}
