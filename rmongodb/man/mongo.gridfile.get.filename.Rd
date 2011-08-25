% File rmongodb/man/mongo.gridfile.get.filename.Rd
\name{mongo.gridfile.get.filename}
\alias{mongo.gridfile.get.filename}
\title{Get the filename of a mongo.gridfile}
\description{
Get the filename of a \link{mongo.gridfile}.
This is the 'remote name' that is used identify the file on the server.
}
\usage{
mongo.gridfile.get.filename(gridfile)
}
\arguments{
\item{gridfile}{A (\link{mongo.gridfile}) object.}
}
\value{
(string) The filename (remote name) of \emph{gridfile}
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo)) {
    gridfs <- mongo.gridfs.create(mongo, "grid")

    # find a GridFS file uploaded midnight July 4, 2008
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "uploadDate", strptime("07-04-2008", "\%m-\%d-\%Y"))
    query <- mongo.bson.from.buffer(buf)

    gf <- mongo.gridfs.find(gridfs, query)
    if (!is.null(gf)) {
        print(mongo.gridfile.get.filename(gf))

        mongo.gridfile.destroy(gf)
    }
    mongo.gridfs.destroy(gridfs)
}
}
\seealso{
\code{\link{mongo.gridfs}},
\code{\link{mongo.gridfs.find}},
\link{mongo.gridfile},
\code{\link{mongo.gridfile.get.descriptor}},
\code{\link{mongo.gridfile.get.length}},
\code{\link{mongo.gridfile.get.chunk.size}},
\code{\link{mongo.gridfile.get.chunk.count}},
\code{\link{mongo.gridfile.get.content.type}},
\code{\link{mongo.gridfile.get.upload.date}},
\code{\link{mongo.gridfile.get.md5}},
\code{\link{mongo.gridfile.get.metadata}},
\code{\link{mongo.gridfile.get.chunk}},
\code{\link{mongo.gridfile.get.chunks}},
\code{\link{mongo.gridfile.read}},
\code{\link{mongo.gridfile.seek}},
\code{\link{mongo.gridfile.pipe}}
}
