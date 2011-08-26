% File rmongodb/man/mongo.gridfs.destroy.Rd
\name{mongo.gridfile.destroy}
\alias{mongo.gridfile.destroy}
\title{Destroy a mongo.gridfile object}
\description{
Releases the resources associated with a \link{mongo.gridfile} object.\cr
These are created by \code{\link{mongo.gridfs.find}()}.

It is not absolutely necessary to call this function since R's garbage collection will eventually
get around to doing it for you.
}
\usage{
mongo.gridfile.destroy(gridfile)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
}
\value{
NULL
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")
    gf <- mongo.gridfs.find(gridfs, "test.R")
    print(mongo.gridfile.get.upload.date(gf))
    mongo.gridfile.destroy(gf)
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\code{\link{mongo.gridfs.find}},\cr
\link{mongo.gridfile},\cr
\link{mongo.gridfs}.
}
