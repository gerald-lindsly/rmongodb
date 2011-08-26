% File rmongodb/man/mongo.cursor.Rd
\name{mongo.cursor}
\docType{class}
\alias{mongo.cursor}
\title{The mongo.cursor class}
\description{
Objects of class "mongo.cursor" are returned from \code{\link{mongo.find}()} and used to iterate over
the records matching the query.

\code{\link{mongo.cursor.next}(cursor)} is used to step to the first or next record.

\code{\link{mongo.cursor.value}(cursor)} returns a mongo.bson object representing the current record.

\code{\link{mongo.cursor.destroy}(cursor)} releases the resources attached to the cursor.

mongo.cursor objects have "mongo.cursor" as their class and
contain an externally managed pointer to the actual cursor data.
This pointer is stored in the "mongo.cursor" attribute of the object.
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
\code{\link{mongo.cursor.next}},\cr
\code{\link{mongo.cursor.value}},\cr
\code{\link{mongo.cursor.destroy}}.
}
