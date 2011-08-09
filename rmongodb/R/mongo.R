mongo.create <- function(host="127.0.0.1", name="", username="", password="", db="admin", timeout=0L) {
    mongo <- .Call(".mongo.create")
    attr(mongo, "host") <- host
    attr(mongo, "name") <- name
    attr(mongo, "username") <- username
    attr(mongo, "password") <- password
    attr(mongo, "db") <- db
    attr(mongo, "timeout") <- timeout
    .Call(".mongo.connect", mongo)
}


mongo.get.err <- function(mongo)
    .Call(".mongo.get.err", mongo)

mongo.clear.err <- function(mongo)
    .Call(".mongo.clear.err", mongo)

mongo.disconnect <- function(mongo)
    .Call(".mongo.disconnect", mongo)

mongo.reconnect <- function(mongo)
    .Call(".mongo.reconnect", mongo)

mongo.destroy <- function(mongo)
    .Call(".mongo.destroy", mongo)

mongo.is.connected <- function(mongo)
    .Call(".mongo.is.connected", mongo)

mongo.get.socket <- function(mongo)
    .Call(".mongo.get.socket", mongo)

mongo.get.primary <- function(mongo)
    .Call(".mongo.get.primary", mongo)

mongo.get.hosts <- function(mongo)
    .Call(".mongo.get.hosts", mongo)

mongo.set.timeout <- function(mongo, timeout)
    .Call(".mongo.set.timeout", mongo, timeout)

mongo.get.timeout <- function(mongo)
    .Call(".mongo.get.timeout", mongo)

mongo.is.master <- function(mongo)
    .Call(".mongo.is.master", mongo)

mongo.authenticate <- function(mongo, username, password, db="admin")
    .Call(".mongo.authenticate", mongo, username, password, db)

mongo.add.user <- function(mongo, username, password, db="admin")
    .Call(".mongo.add.user", mongo, username, password, db)

mongo.get.last.error <- function(mongo, db)
    .Call(".mongo.get.last.error", mongo, db)

mongo.get.prev.error <- function(mongo, db)
    .Call(".mongo.get.prev.error", mongo, db)

mongo.reset.error <- function(mongo, db)
    .Call(".mongo.reset.error", mongo, db)

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

mongo.remove <- function(mongo, ns, criteria=mongo.bson.empty())
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
    .Call(".mongo.drop", mongo, ns)

mongo.rename <- function(mongo, from.ns, to.ns)
    .Call(".mongo.rename", mongo, ns)

mongo.get.databases <- function(mongo)
    .Call(".mongo.get.databases", mongo)

