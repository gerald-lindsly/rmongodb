% File rmongodb/man/mongo.get.server.err.string.Rd
\name{mongo.get.server.err.string}
\alias{mongo.get.server.err.string}
\title{Retrieve an server error code from a mongo connection object}
\description{
Retrieve an server error string from a mongo connection object.

The following functions set this error string if the server reports an error during their operation: \code{\link{mongo.find}()}, \code{\link{mongo.find.one}().}

\code{\link{mongo.index.create}()} sets or clears this error string depending on whether it is successful or not.

\code{\link{mongo.get.last.error}()} and \code{\link{mongo.get.prev.error}()} both set or clear this error string according to what the server reports.
}
\usage{
mongo.get.server.err.string(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
(integer) server error string
}
\seealso{
\code{\link{mongo.get.server.err}},
\code{\link{mongo.get.last.err}},
\code{\link{mongo.get.prev.err}},
\code{\link{mongo.find}},
\code{\link{mongo.find.one}},
\code{\link{mongo.index.create}},
\link{mongo}
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

    result <- mongo.find.one(mongo, ns, query)
    if (is.null(result)) {
        print(mongo.get.server.err.(mongo))
        print(mongo.get.server.err.string(mongo))
    }
}
}
