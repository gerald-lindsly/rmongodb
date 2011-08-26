% File rmongodb/man/mongo.cursor.destroy.Rd
\name{mongo.cursor.destroy}
\alias{mongo.cursor.destroy}
\title{Release resources attached to a cursor}
\description{
\code{mongo.cursor.destroy(cursor)} is used to release resources attached to a cursor on both the client and server.

Note that \code{mongo.cursor.destroy(cursor)} may be called before all records of a result set 
are iterated through (for example, if a desired record is located in the result set).

Although the 'destroy' functions in this package are called automatically by garbage collection, 
this one in particular should be called as soon as feasible when finished with the cursor so
that server resources are freed.
}
\usage{
mongo.cursor.destroy(cursor)
}
\arguments{
\item{cursor}{(\link{mongo.cursor}) A mongo.cursor object returned from \code{\link{mongo.find}()}.}
}
\value{
TRUE if successful; otherwise, FALSE (when an error occurs during sending the Kill Cursor operation to the server).
in either case, the cursor should not be used for further operations.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "city", "St. Louis")
    query <- mongo.bson.from.buffer(buf)

    # Find the first 1000 records in collection people
    # of database test where city == "St. Louis"
    cursor <- mongo.find(mongo, "test.people", query, limit=1000L)
    # Step though the matching records and display them
    while (mongo.cursor.next(cursor))
        print(mongo.cursor.destroy(cursor))
    mongo.cursor.destroy(cursor)
}
}
\seealso{
\code{\link{mongo.find}},\cr
\link{mongo.cursor},\cr
\code{\link{mongo.cursor.next}},\cr
\code{\link{mongo.cursor.value}}.
}
