% File rmongodb/man/mongo.get.last.err.Rd
\name{mongo.get.last.err}
\alias{mongo.get.last.err}
\title{Retrieve an server error code from a mongo connection object}
\description{
Retrieve an server error record from a the MongoDB server.  While this function retrieves an error record
in the form of a mongo.bson record, it also sets the values returned by
\code{\link{mongo.get.server.err}()} and \code{\link{mongo.get.server.err.string}()}.
You may find it more convenient using those after calling \code{mongo.get.last.err()} rather than
unpacking the returned mongo.bson object.
}
\usage{
mongo.get.last.err(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
NULL if no error was reported; otherwise,

(\link{mongo.bson}) This BSON object has the form { err : "\emph{error message string}", code : \emph{error code integer} }
}
\seealso{
\code{\link{mongo.get.server.err}},
\code{\link{mongo.get.server.err.string}},
\code{\link{mongo.get.last.err}}
\link{mongo}
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    # construct a command with an invalid operator:
    # { "count" : "people", "query" : { "age" : { "$bad" : 1 } } }
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append("count", "people")
    mongo.bson.buffer.start.object(buf, "query")
    mongo.bson.buffer.start.object(buf, "age")
    mongo.bson.buffer.append(buf, "$bad", 1L)
    mongo.bson.buffer.finish.object(buf)
    mongo.bson.buffer.finish.object(buf)
    command <- mongo.bson.from.buffer(buf)

    result <- mongo.command(mongo, "test", command)
    if (is.null(result)) {
        err <- mongo.get.last.err(mongo)
        print(mongo.get.server.err(mongo))
        print(mongo.get.server.err.string(mongo))

        iter <- mongo.bson.find(err, "err")
        print(mongo.bson.iterator.value(iter)
    }
}
}
