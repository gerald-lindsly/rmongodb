% File rmongodb/man/mongo.create.Rd
\name{mongo.create}
\alias{mongo.create}
\title{Create an object of class "mongo"}
\description{
Connect to a MongoDB server or replset and return an object of class "mongo" used for further communication
over the connection.

WARNING: This function is currently undergoing refinement and it's interface may be expected to change and/or
not work entirely as advertised.

Note that the members of the mongo object only reflect the initial parameters.
Only the external data pointed to by the "mongo" attribute actually changes if, for example,
mongo.timeout is called after the initial call to \code{mongo.create}.
}
\usage{
mongo.create(host="127.0.0.1:27017", name="", username="", password="", db_name="admin", timeout=1000L)
}
\arguments{
\item{host}{A vector of character strings indicating the hosts/ports to which to connect.
If more than one host is specified, it is assumed that one is attempting to connect to a replset.
}
\item{name}{(string) The name of the replset to whcih to connect.}
\item{username}{(string) The username to be used for authentication purposes.
The default username of "" indicates that no user authentication is to be performed by the initial connect.}
\item{password}{(string) The password corresponding to the given username.}
\item{db_name}{string) The database upon which to authenticate the given username and password.}
\item{timeout}{(asInteger) The number of milliseconds to wait before timing out of a network operation.}
}
\seealso{
\code{\link{mongo}}.
}
\examples{
mongo <- mongo.create()
mongo <- mongo.create("192.168.0.3")
}
