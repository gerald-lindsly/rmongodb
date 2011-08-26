% File rmongodb/man/mongo.timestamp.create.Rd
\name{mongo.timestamp.create}
\alias{mongo.timestamp.create}
\title{Create a mongo.timestamp object}
\description{
Create a \link{mongo.timestamp} object for appending to a buffer with\cr
\code{\link{mongo.bson.buffer.append.timestamp}()} or \code{\link{mongo.bson.buffer.append}()}, or
for embedding in a list such that \code{\link{mongo.bson.buffer.append.list}()} will properly insert a timestamp
value into the mongo.bson.buffer object.

See \url{http://www.mongodb.org/display/DOCS/Timestamp+Data+Type}
}
\usage{
mongo.timestamp.create(time, increment)
}
\arguments{
\item{time}{(integer) date/time value (milliseconds since UTC epoch).

This may also be a "POSIXct" or "POSIXlt" class object.}
\item{increment}{increment ordinal}
}
\value{
A \link{mongo.timestamp} object
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
\link{mongo.timestamp},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.buffer.append.time}},\cr
\code{\link{mongo.bson.buffer.append.list}},\cr
\link{mongo.bson.buffer},\cr
\link{mongo.bson}.
}
