% File rmongodb/man/mongo.count.Rd
\name{mongo.count}
\alias{mongo.count}
\title{Count records in a collection}
\description{
Count the number of records in a collection that match a query
See \url{http://www.mongodb.org/display/DOCS/Indexes}.
}
\usage{
mongo.count(mongo, ns, query=mongo.bson.empty())
}
\arguments{
\item{mongo}{(\link{mongo}) A mongo connection object.}
\item{ns}{(string) The namespace of the collection in which to add count records.}
\item{query}{\link{mongo.bson} The criteria with which to match records that are to be counted.
    The default of mongo.bson.empty() matches all records in the collection.
    
Alternately, \code{query} may be
a list which will be converted to a mongo.bson object by \code{\link{mongo.bson.from.list}()}.}
}
\value{
(double) The number of matching records.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    # Count the number of records in collection people of database test
    people.count <- mongo.count(mongo, "test.people")
    print("total people")
    print(people.count)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "age", 21L)
    query <- mongo.bson.from.buffer(buf)

    # Count the number of records in collection people of database test
    # where age == 21
    just.legal.count <- mongo.count(mongo, "test.people", query)
    print("people of age 21")
    print(just.legal.count)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.start.object(buf, "age")
    mongo.bson.buffer.append(buf, "$gte", 21L)
    mongo.bson.buffer.finish.object(buf)
    query <- mongo.bson.from.buffer(buf)

    # Count the number of records in collection people of database test
    # where age >= 21
    total.legal.count <- mongo.count(mongo, "test.people", query)
    print("people of age 21 or greater")
    print(total.legal.count)

    # shorthand using a list:
    ford.count <- mongo.count(mongo, "test.cars", list(make="Ford"))
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
