mongo.Connection.connect <- function(Connection) {

	Connection$socket = .C("mongo.sock_connect",  port = Connection$port,
                   host = Connection$host)[1]$port
	print(Connection$socket)
}


mongo.Connection.database_names <- function(Connection) {

}


mongo.Connection.get_database <- function(Connection, dbname) {

}


mongo.Connection.get_master <- function(Connection) {

}


mongo.Connection.authenticate <- function(Connection, dbname, username, password, is_digest=FALSE) {

}

mongo.Connection.send <- function(Connection, str) {

}


mongo.Connection.recv <- function(Connection, info) {

}


mongo.Connection <- function(host="localhost", port=27017L, username="", password="", db_name="admin", w=1, wtimeout=1000, auto_reconnect=TRUE, timeout=1000, query_timeout=30000, find_master=FALSE, auto_connect=TRUE) {
    connection <- list(host=host, port=port, username=username, password=password, w=w, wtimeout=wtimeout, auto_reconnect=auto_reconnect, timeout=timeout, query_timeout=query_timeout, auto_connect=auto_connect, connected=FALSE)
	class(connection) <- "mongo.Connection"
	if (auto_connect) mongo.Connection.connect(connection)
	t
}