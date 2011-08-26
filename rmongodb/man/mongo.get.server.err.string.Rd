% File rmongodb/man/mongo.get.server.err.string.Rd
\name{mongo.get.server.err.string}
\alias{mongo.get.server.err.string}
\title{Retrieve an server error code from a mongo connection object}
\description{
Retrieve an server error string from a mongo connection object.

\code{\link{mongo.find}()}, \code{\link{mongo.find.one}()}, \code{\link{mongo.index.create}()}
 set or clear this error string depending on whether they are successful or not.

\code{\link{mongo.get.last.err}()} and \code{\link{mongo.get.prev.err}()}
both set or clear this error string according to what the server reports.
}
\usage{
mongo.get.server.err.string(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
(string) Server error string
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    # construct a query containing invalid operator
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.start.object(buf, "age")
    mongo.bson.buffer.append(buf, "$bad", 1L)
    mongo.bson.buffer.finish.object(buf)
    query <- mongo.bson.from.buffer(buf)

    result <- mongo.find.one(mongo, "test.people", query)
    if (is.null(result)) {
        print(mongo.get.server.err(mongo))
        print(mongo.get.server.err.string(mongo))
    }
}
}
\seealso{
\code{\link{mongo.get.server.err}},\cr
\code{\link{mongo.get.last.err}},\cr
\code{\link{mongo.get.prev.err}},\cr
\code{\link{mongo.find}},\cr
\code{\link{mongo.find.one}},\cr
\code{\link{mongo.index.create}},\cr
\link{mongo}.
}
