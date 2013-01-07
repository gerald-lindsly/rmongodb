% File rmongodb/man/mongo.get.primary.Rd
\name{mongo.get.primary}
\alias{mongo.get.primary}
\title{Get the host & port of the server to which a mongo object is connected.}
\description{
Get the host & port of the server to which a mongo object is connected.
}
\usage{
mongo.get.primary(mongo)
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
}
\value{
String host & port in the format "\%s:\%d".
}
\examples{
\dontrun{
mongo <- mongo.create(c("127.0.0.1", "192.168.0.3"))
if (mongo.is.connected(mongo)) {
    print(mongo.get.primary(mongo))
}
}
}
\seealso{
\code{\link{mongo.create}},\cr
\link{mongo}.
}
