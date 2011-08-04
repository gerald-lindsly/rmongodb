% File rmongodb/man/mongo.authenticate.Rd
\name{mongo.authenticate}
\alias{mongo.authenticate}
\title{Autherticate a user and password}
\description{
Autherticate a user and password against a given database on a MongoDB server.
See \url{http://www.mongodb.org/display/DOCS/Security+and+Authentication}.
Note that mongo.create() can authenticate a username and password before returning a connected mongo object. }
\usage{
mongo.authenticate(mongo, username, password, db="admin")
}
\arguments{
\item{mongo}{(mongo) a mongo connection object.}
\item{username}{(string) username to authenticate.}
\item{password}{(string) password corresponding to username.}
\item{db}{(string) The database on the server against which to validate the username and password.}
}
\seealso{
\code{\link{mongo.create}}
\code{\link{mongo.add.user}}
}
\examples{
mongo.authenticate(mongo, "Joe", "ZxYaBc217")
}
