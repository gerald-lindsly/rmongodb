% File rmongodb/man/mongo.get.reset.err.Rd
\name{mongo.reset.err}
\alias{mongo.reset.err}
\title{Retrieve an server error code from a mongo connection object}
\description{
Send a "reset error" command to the server, it also resets the values returned by\cr
\code{\link{mongo.get.server.err}()} and \code{\link{mongo.get.server.err.string}()}.
}
\usage{
mongo.reset.err(mongo, db)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
\item{db}{(string) The name of the database on which to reset the error status. }
}
\value{
NULL
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {

    # try adding a duplicate record when index doesn't allow this

    db <- "test"
    ns <- "test.people"
    mongo.index.create(mongo, ns, "name", mongo.index.unique)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "John")
    mongo.bson.buffer.append(buf, "age", 22L)
    b <- mongo.bson.from.buffer(buf)
    mongo.insert(mongo, ns, b);

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "John")
    mongo.bson.buffer.append(buf, "age", 27L)
    b <- mongo.bson.from.buffer(buf)
    mongo.insert(mongo, ns, b);

    err <- mongo.get.last.err(mongo, db)
    print(mongo.get.server.err(mongo))
    print(mongo.get.server.err.string(mongo))
    mongo.reset.err(mongo, db)
}
}
\seealso{
\code{\link{mongo.get.server.err}},\cr
\code{\link{mongo.get.server.err.string}},\cr
\code{\link{mongo.get.last.err}},\cr
\code{\link{mongo.get.prev.err}},\cr
\link{mongo}.
}
