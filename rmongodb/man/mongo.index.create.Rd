% File rmongodb/man/mongo.index.create.Rd
\name{mongo.index.create}
\alias{mongo.index.create}
\title{Add an index to a collection}
\description{
Add an index to a collection.

See \url{http://www.mongodb.org/display/DOCS/Indexes}.
}
\usage{
mongo.index.create(mongo, ns, key, options=0L)
}
\arguments{
\item{mongo}{(\link{mongo}) A mongo connection object.}
\item{ns}{(string) The namespace of the collection to which to add an index.}
\item{key}{An object enumerating the fields in order which are to participate in the index.
This object may be a vector of strings listing the key fields or 
a \link{mongo.bson} object containing the key fields in the desired order.
    
Alternately, \code{key} may be a list which will be converted to a mongo.bson object
by \code{\link{mongo.bson.from.list}()}.}
\item{options}{(integer vector) Optional flags governing the operation:
    \itemize{
        \item{\code{\link{mongo.index.unique}}}
        \item{\code{\link{mongo.index.drop.dups}}}
        \item{\code{\link{mongo.index.background}}}
        \item{\code{\link{mongo.index.sparse}}}
    }
}
}
\value{
NULL if successful; otherwise, a \link{mongo.bson} object describing the error.\cr
\code{\link{mongo.get.server.err}()} or \code{\link{mongo.get.server.err.string}()} may alternately be called in this case instead of examining the returned object.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    # Add a city index to collection people in database test
    b <- mongo.index.create(mongo, "test.people", "city")
    if (!is.null(b)) {
        print(b)
        stop("Server error")
    }

    # Add an index to collection people in database test
    # which will speed up queries of age followed by name
    b <- mongo.index.create(mongo, "test.people", c("age", "name"))

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "age", 1L)
    mongo.bson.buffer.append(buf, "name", 1L)
    key <- mongo.bson.from.buffer(buf)

    # add an index using an alternate method of specifying the key fields
    b <- mongo.index.create(mongo, "test.people", key)

    # create an index using list of that enumerates the key fields
    b <- mongo.index.create(mongo, "test.cars", list(make=1L, model=1L))
}
}
\seealso{
\code{\link{mongo.find}},\cr
\code{\link{mongo.find.one}},\cr
\code{\link{mongo.insert}},\cr
\code{\link{mongo.update}},\cr
\code{\link{mongo.remove}},\cr
\link{mongo},\cr
\link{mongo.bson}.
}
