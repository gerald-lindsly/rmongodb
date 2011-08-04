% File rmongodb/man/mongo.add.user.Rd
\name{mongo.add.user}
\alias{mongo.add.user}
\title{Add a user and password}
\description{
Add a user and password against to the given database on a MongoDB server for authentication purposes.
See \url{http://www.mongodb.org/display/DOCS/Security+and+Authentication}.
}
\usage{
mongo.add.user(mongo, username, password, db="admin")
}
\arguments{
\item{mongo}{(mongo) a mongo connection object.}
\item{username}{(string) username to add.}
\item{password}{(string) password corresponding to username.}
\item{db}{(string) The database on the server to which to add the username and password.}
}
\seealso{
\code{\link{mongo.authenticate}}
}
\examples{
mongo.add.user(mongo, "Jeff", "H87b5dog")
}
