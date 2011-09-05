% File rmongodb/man/mongo.add.user.Rd
\name{mongo.add.user}
\alias{mongo.add.user}
\title{Add a user and password}
\description{
Add a user and password to the given database on a MongoDB server for authentication purposes.

See \url{http://www.mongodb.org/display/DOCS/Security+and+Authentication}.

}
\usage{
mongo.add.user(mongo, username, password, db="admin")
}
\arguments{
\item{mongo}{(\link{mongo}) a mongo connection object.}
\item{username}{(string) username to add.}
\item{password}{(string) password corresponding to username.}
\item{db}{(string) The database on the server to which to add the username and password.}
}
\examples{
mongo <- mongo.create()
if (mongo.is.connected(mongo))
    mongo.add.user(mongo, "Jeff", "H87b5dog")
}
\seealso{
\code{\link{mongo.authenticate}},\cr
\link{mongo},\cr
\code{\link{mongo.create}}.
}
