% File rmongodb/man/mongo.gridfs.find.Rd
\name{mongo.gridfs.find}
\alias{mongo.gridfs.find}
\title{Find a GridFS file}
\description{
Find a GridFS file and return a \link{mongo.gridfile} object used for further operations on it}
\usage{
mongo.gridfs.find(gridfs, query)
}
\arguments{
\item{gridfs}{A (\link{mongo.gridfs}) object.}
\item{query}{(string) The name of the GridFS file to locate.

This parameter may also be a \link{mongo.bson} query object and is used to search 
the GridFS "files" collection documents for matches.  Alternately, \code{query} may be
a list which will be converted to a mongo.bson object by \code{\link{mongo.bson.from.list}()}.}
}
\value{
NULL, if not found; otherwise, a \link{mongo.gridfile} object corresponding to the found GridFS file.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "test.dat")
    print(mongo.gridfile.get.length(gf))

    # find a GridFS file uploaded midnight July 4, 2008
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "uploadDate",
        strptime("07-04-2008", "\%m-\%d-\%Y"))
    query <- mongo.bson.from.buffer(buf)
    gf <- mongo.gridfs.find(gridfs, query)

    if (!is.null(gf))
        print(mongo.gridfile.get.filename(gf))

    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\link{mongo.gridfile},\cr
\code{\link{mongo.gridfile.get.filename}},\cr
\link{mongo.gridfs}.
}
