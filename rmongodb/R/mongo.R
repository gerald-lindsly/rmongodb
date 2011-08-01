mongo.connect <- function(mongo)
    .Call(".mongo.connect", mongo)

mongo.is.connected <- function(mongo)
    .Call(".mongo.is.connected", mongo)

mongo.get.socket <- function(mongo)
    .Call(".mongo.get.socket", mongo)

mongo.get.err <- function(mongo)
    .Call(".mongo.get.err", mongo)

mongo.get.server.err <- function(mongo)
    .Call(".mongo.get.server.err", mongo)

mongo.get.server.err.string <- function(mongo)
    .Call(".mongo.get.server.err.string", mongo)

mongo.insert <- function(mongo, ns, b)
    .Call(".mongo.insert", mongo, ns, b)

mongo.update.upsert <- 1L
mongo.update.multi  <- 2L

mongo.update <- function(mongo, ns, criteria, objNew, flags=0L)
    .Call(".mongo.update", mongo, ns, criteria, objNew, flags)

mongo.remove <- function(mongo, ns, criteria)
    .Call(".mongo.remove", mongo, ns, criteria)


mongo.find.one <- function(mongo, ns, query=mongo.bson.empty(), fields=mongo.bson.empty())
    .Call(".mongo.find.one", mongo, ns, query, fields)


mongo.find.cursor.tailable   <- 2L
mongo.find.slave.ok          <- 4L
mongo.find.oplog.replay      <- 8L
mongo.find.no.cursor.timeout <- 16L
mongo.find.await.data        <- 32L
mongo.find.exhaust           <- 64L
mongo.find.partial.results   <- 128L

mongo.find <- function(mongo, ns, query=mongo.bson.empty(), fields=mongo.bson.empty(), limit=1L, skip=0L, options=0L)
    .Call(".mongo.find", mongo, ns, query, fields, limit, skip, options)

mongo.cursor.next <- function(cursor)
    .Call(".mongo.cursor.next", cursor)

mongo.cursor.value <- function(cursor)
    .Call(".mongo.cursor.value", cursor)

mongo.cursor.destroy <- function(cursor)
    .Call(".mongo.cursor.destroy", cursor)


mongo.index.unique     <- 1L
mongo.index.drop.dups  <- 4L
mongo.index.background <- 8L
mongo.index.sparse     <- 16L

mongo.index.create <- function(mongo, ns, key, options=0L)
    .Call(".mongo.index.create", mongo, ns, key, options)


mongo.count <- function(mongo, ns, query=mongo.bson.empty())
    .Call(".mongo.count", mongo, ns, query)

mongo.command <- function(mongo, db, command)
    .Call(".mongo.command", mongo, db, command)

mongo.simple.command <- function(mongo, db, cmdstr, arg)
    .Call(".mongo.simple.command", mongo, db, cmdstr, arg)

mongo.drop.database <- function(mongo, db)
    .Call(".mongo.drop.database", mongo, db)

mongo.drop.collection <- function(mongo, ns)
    .Call(".mongo.drop.collection", mongo, ns)


mongo.reset.error <- function(mongo, db)
    .Call(".mongo.reset.error", mongo, db)

mongo.get.last.error <- function(mongo, db)
    .Call(".mongo.get.last.error", mongo, db)

mongo.get.prev.error <- function(mongo, db)
    .Call(".mongo.get.prev.error", mongo, db)

mongo.is.master <- function(mongo, db)
    .Call(".mongo.is.master", mongo, db)

mongo.add.user <- function(mongo, db, user, pass)
    .Call(".mongo.add.user", mongo, db, user, pass)


mongo.database_names <- function(mongo) {

}


mongo.get_database <- function(mongo, dbname) {

}


mongo.get_master <- function(mongo) {

}


mongo.Connection.authenticate <- function(mongo, dbname, username, password, is_digest=FALSE) {

}

mongo.send <- function(mongo, str) {

}


mongo.recv <- function(mongo, info) {

}


mongo.create <- function(host="127.0.0.1", port=27017L, username="", password="", db_name="admin", w=1, wtimeout=1000, auto_reconnect=TRUE, timeout=1000, .query_timeout=30000, find_master=FALSE, auto_connect=TRUE) {
    mongo <- .Call(".mongo.create")
    attr(mongo, "host") <- host
    attr(mongo, "port") <- port
    if (auto_connect) mongo.connect(mongo)
    mongo
}