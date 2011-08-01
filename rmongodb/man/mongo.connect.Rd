% File rmongodb/man/mongo.connect.Rd
\name{mongo.connect}
\alias{mongo.connect}
\title{Connect to a MongoDB server}
\description{
Connect to a MongoDB server with parameters specified to \code{mongo.create}.
}
\usage{
mongo.connect(mongo)
}
\arguments{
\item{mongo}{a mongo connection object}
}
\seealso{
\code{\link{mongo.create}}.
}
\examples{
mongo <- mongo.create(auto_connect=FALSE)
mongo.connect(mongo)
}
