% File rmongodb/man/mongo.cursor.next.Rd
\name{mongo.cursor.next}
\alias{mongo.cursor.next}
\title{Advance a cursor to the next record}
\description{
\code{\link{mongo.cursor.next}(cursor)} is used to step to the first or next record.

\code{\link{mongo.cursor.value}(cursor)} may then be used to examine it.
}
\usage{
mongo.cursor.next(cursor)
}
\arguments{
\item{cursor}{(\link{mongo.cursor}) A mongo.cursor object returned from \code{\link{mongo.find}()}.}
}
\value{
TRUE if there is a next record; otherwise, FALSE.
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
        print(mongo.cursor.value(cursor))
    mongo.cursor.destroy(cursor)
}
}
\seealso{
\code{\link{mongo.find}},\cr
\link{mongo.cursor},\cr
\code{\link{mongo.cursor.value}},\cr
\code{\link{mongo.cursor.destroy}}.
}
