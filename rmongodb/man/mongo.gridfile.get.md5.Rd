% File rmongodb/man/mongo.gridfile.get.md5.Rd
\name{mongo.gridfile.get.md5}
\alias{mongo.gridfile.get.md5}
\title{Get the MD5 hash of a mongo.gridfile}
\description{
Get the MD5 hash of a \link{mongo.gridfile}.
}
\usage{
mongo.gridfile.get.md5(gridfile)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
}
\value{
(string) The MD5 hash (32 hex digits) of \code{gridfile}.
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    gf <- mongo.gridfs.find(gridfs, "test.R")
    print(mongo.gridfile.get.md5(gf))

    mongo.gridfile.destroy(gf)
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\code{\link{mongo.gridfs}},\cr
\code{\link{mongo.gridfs.find}},\cr
\link{mongo.gridfile},\cr
\code{\link{mongo.gridfile.get.descriptor}},\cr
\code{\link{mongo.gridfile.get.filename}},\cr
\code{\link{mongo.gridfile.get.length}},\cr
\code{\link{mongo.gridfile.get.chunk.size}},\cr
\code{\link{mongo.gridfile.get.chunk.count}},\cr
\code{\link{mongo.gridfile.get.content.type}},\cr
\code{\link{mongo.gridfile.get.upload.date}},\cr
\code{\link{mongo.gridfile.get.metadata}},\cr
\code{\link{mongo.gridfile.get.chunk}},\cr
\code{\link{mongo.gridfile.get.chunks}},\cr
\code{\link{mongo.gridfile.read}},\cr
\code{\link{mongo.gridfile.seek}},\cr
\code{\link{mongo.gridfile.pipe}}.
}
