% File rmongodb/man/mongo.get.prev.err.Rd
\name{mongo.get.prev.err}
\alias{mongo.get.prev.err}
\title{Retrieve an server error code from a mongo connection object}
\description{
Retrieve the previous server error record from a the MongoDB server.  While this function retrieves an error record
in the form of a mongo.bson record, it also sets the values returned by
\code{\link{mongo.get.server.err}()} and \code{\link{mongo.get.server.err.string}()}.
You may find it more convenient using those after calling \code{mongo.get.prev.err()} rather than
unpacking the returned mongo.bson object.
}
\usage{
mongo.get.prev.err(mongo, db)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
\item{db}{(string) The name of the database for which to get the error status. }
}
\value{
NULL if no error was reported; otherwise,

(\link{mongo.bson}) This BSON object has the form \{ err : "\emph{error message string}", code : \emph{error code integer} \}
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

    # try insert again
    mongo.insert(mongo, ns, b);

    err <- mongo.get.prev.err(mongo, db)
    print(mongo.get.server.err(mongo))
    print(mongo.get.server.err.string(mongo))
}
}
\seealso{
\code{\link{mongo.get.server.err}},\cr
\code{\link{mongo.get.server.err.string}},\cr
\code{\link{mongo.get.last.err}}\cr
\link{mongo}.
}
