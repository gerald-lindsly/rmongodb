% File rmongodb/man/mongo.create.Rd
\name{mongo.create}
\alias{mongo.create}
\title{Create an object of class "mongo"}
\description{
Connect to a MongoDB server or replset and return an object of class "mongo" used for further communication
over the connection.

All parameters are stored as attributes of the returned mongo object.
Note that these attributes only reflect the initial parameters.
Only the external data pointed to by the "mongo" attribute actually changes if, for example,
mongo.timeout is called after the initial call to \code{mongo.create}.
}
\usage{
mongo.create(host="127.0.0.1:27017", name="", username="", password="", db_name="admin", timeout=0L)
}
\arguments{
\item{host}{(string vector) A list of hosts/ports to which to connect.
    If a port is not given, 27017 is used.
}
\item{name}{(string) The name of the replset to which to connect. if name == "" (the default),
    the hosts are tried one by one until a connection is made.  Othersize, name must be the name of the replset 
    and the given hosts are assumed to be seeds of the replset.
    Each of these os connected to and queried in turn until one reports that it is a master.
    This master is then queried for a list of hosts and these are in turn connected to and verified as belonging to the given replset name.
    When one of these reports that it is a master, that connection is used to form the actual connection as returned.}
\item{username}{(string) The username to be used for authentication purposes.
    The default username of "" indicates that no user authentication is to be performed by the initial connect.}
\item{password}{(string) The password corresponding to the given username.}
\item{db_name}{(string) The database upon which to authenticate the given username and password.
    If authentication fails, the connection is disconnected, but mongo.get.err() will indicate not indicate an error. }
\item{timeout}{(as.integer) The number of milliseconds to wait before timing out of a network operation.
    The default (0L) indicates no timeout.}
}
\value{
    If successful, a mongo object for use in subsequent database operations; 
    otherwise, mongo.get.err() may be called on the returned mongo object to see why it failed.
}
\seealso{
\link{mongo},
\code{\link{mongo.is.connected}},
\code{\link{mongo.disconnect}},
\code{\link{mongo.reconnect}},
\code{\link{mongo.get.err}},
\code{\link{mongo.get.primary}},
\code{\link{mongo.get.hosts}},
\code{\link{mongo.get.socket}},
\code{\link{mongo.set.timeout}},
\code{\link{mongo.get.timeout}}
}
\examples{
mongo <- mongo.create()
mongo <- mongo.create("192.168.0.3")
}
