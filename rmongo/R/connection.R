mongo.Connection.connect <- function(connection) {
    .Call(".mongo.connection.connect", connection)
}


mongo.Connection.isConnected <- function(connection)
.Call(".mongo.connection.isConnected", connection)

mongo.Connection.getErr <- function(connection)
.Call(".mongo.connection.getErr", connection)

mongo.insert <- function(connection, ns, bson)
.Call(".mongo.insert", connection, ns, bson)


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


mongo.Connection <- function(host="127.0.0.1", port=27017L, username="", password="", db_name="admin", w=1, wtimeout=1000, auto_reconnect=TRUE, timeout=1000, .query_timeout=30000, find_master=FALSE, auto_connect=TRUE) {
    connection <- .Call(".mongo.connection.create")
    attr(connection, "host") <- host
    attr(connection, "port") <- port
    if (auto_connect) mongo.Connection.connect(connection)
        connection
    }