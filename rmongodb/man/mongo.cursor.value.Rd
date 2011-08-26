% File rmongodb/man/mongo.cursor.value.Rd
\name{mongo.cursor.value}
\alias{mongo.cursor.value}
\title{Fetch the current value of a cursor}
\description{
\code{\link{mongo.cursor.value}(cursor)} is used to fetch the current record belonging to a\cr
\code{\link{mongo.find}()} query.
}
\usage{
mongo.cursor.value(cursor)
}
\arguments{
\item{cursor}{(\link{mongo.cursor}) A mongo.cursor object returned from \code{\link{mongo.find}()}.}
}
\value{
(\link{mongo.bson}) The current record of the result set.
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
\code{\link{mongo.cursor}},\cr
\code{\link{mongo.cursor.next}},\cr
\code{\link{mongo.cursor.value}},\cr
\code{\link{mongo.cursor.destroy}},\cr
\link{mongo.bson}.
}
