% File rmongodb/man/mongo.find.one.Rd
\name{mongo.find.one}
\alias{mongo.find.one}
\title{Find one record in a collection}
\description{
Find the first record in a collection that matches a given query.

This is a simplified version of mongo.find() which eliminates the need 
to step through returned records with a cursor.

See \url{http://www.mongodb.org/display/DOCS/Querying}.
}
\usage{
mongo.find.one(mongo, ns, query=mongo.bson.empty(),
                          fields=mongo.bson.empty())
}
\arguments{
\item{mongo}{(\link{mongo}) A mongo connection object.}
\item{ns}{(string) The namespace of the collection from in which to find a record.}
\item{query}{(\link{mongo.bson}) The criteria with which to match the record that is to be found.
The default of mongo.bson.empty() will cause the the very first record in the collection to be returned.

Alternately, \code{query} may be a list which will be converted to a mongo.bson object 
by \code{\link{mongo.bson.from.list}()}.}
\item{fields}{(\link{mongo.bson}) The desired fields which are to be returned frtom the matching record.
    The default of mongo.bson.empty() will cause all fields of the matching record to be returned; 
    however, specific fields may be specified to cut down on network traffic and memory overhead.
    
Alternately, \code{fields} may be a list which will be converted to a mongo.bson object
by \code{\link{mongo.bson.from.list}()}.}
}
\value{
NULL if no record matching the criteria is found; otherwise,

(\link{mongo.bson}) The matching record/fields.

Note that NULL may also be returned if a database error occurred (when a badly formed query is used, for example).
\code{\link{mongo.get.server.err}} and \code{\link{mongo.get.server.err.string}} may be examined in that case.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "name", "Jeff")
    query <- mongo.bson.from.buffer(buf)

    # find the first record where name is "Jeff"\
    #    in collection people of database test
    b <- mongo.find.one(mongo, "test.people", query)
    if (!is.null(b))
        print(b)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "_id", 1L)
    mongo.bson.buffer.append(buf, "age", 1L)
    fields <- mongo.bson.from.buffer(buf)

    # find the first record where name is "Jeff"
    #    in collection people of database test
    # return only the _id and age fields of the matched record
    b <- mongo.find.one(mongo, "test.people", query, fields)
    if (!is.null(b))
        print(b)

    # find the first record in collection cars of database test
    have.car <- !is.null(mongo.find.one(mongo, "test.cars"))

    # shorthand using a list:
    b <- mongo.find.one(mongo, "test.people", list(name="Jose"))
}
}
\seealso{
\code{\link{mongo.find}},\cr
\code{\link{mongo.index.create}},\cr
\code{\link{mongo.insert}},\cr
\code{\link{mongo.update}},\cr
\code{\link{mongo.remove}},\cr
\link{mongo},\cr
\link{mongo.bson}.
}
