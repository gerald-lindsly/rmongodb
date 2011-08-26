% File rmongodb/man/mongo.timestamp.Rd
\name{mongo.timestamp}
\docType{class}
\alias{mongo.timestamp}
\title{The mongo.timestamp class}
\description{
Objects of class "mongo.timestamp" are an extension of the POSIXct class.
They have their increment value stored in the "increment" attribute of the object.

See \url{http://www.mongodb.org/display/DOCS/Timestamp+Data+Type}

mongo.timestamp objects have "mongo.timestamp", "POSIXct" & "POSIXt" as their class
so that \code{\link{mongo.bson.buffer.append}()} 
may detect them and append the appropriate BSON code-typed value to a buffer.

These mongo.timestamp values may also be present in a list and will be handled properly
by \code{\link{mongo.bson.buffer.append.list}()} and \code{\link{mongo.bson.from.list}()}.

}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    buf <- mongo.bson.buffer.create()
    # special Null timestamp -- automatically filled in 
    # if one of first two fields in a record
    ts <- mongo.timestamp.create(0,0)
    mongo.bson.buffer.append(buf, "InsertTime", ts)
    mongo.bson.buffer.append(buf, "name", "Joe")
    b <- mongo.bson.from.buffer(buf)
    mongo.insert(mongo, "test.people", b)

    # create using a POSIXlt
    ts <- mongo.timestamp.create(strptime("05-12-2012",
        "\%m-\%d-\%Y"), increment=1)
}
}
\seealso{
\code{\link{mongo.timestamp.create}},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
