#   Copyright (C) 2008-2011 10gen Inc.
# 
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

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

mongo.get.last.err <- function(mongo, db)
    .Call(".mongo.get.last.err", mongo, db)

mongo.get.prev.err <- function(mongo, db)
    .Call(".mongo.get.prev.err", mongo, db)

mongo.reset.err <- function(mongo, db)
    .Call(".mongo.reset.err", mongo, db)

mongo.get.server.err <- function(mongo)
    .Call(".mongo.get.server.err", mongo)

mongo.get.server.err.string <- function(mongo)
    .Call(".mongo.get.server.err.string", mongo)

mongo.insert <- function(mongo, ns, b) {
    if (typeof(b) == "list")
        b <- mongo.bson.from.list(b)
    .Call(".mongo.insert", mongo, ns, b)
}

mongo.insert.batch <- function(mongo, ns, lst)
    .Call(".mongo.insert.batch", mongo, ns, lst)


mongo.update.upsert <- 1L
mongo.update.multi  <- 2L
mongo.update.basic  <- 4L

mongo.update <- function(mongo, ns, criteria, objNew, flags=0L) {
    if (typeof(criteria) == "list")
        criteria <- mongo.bson.from.list(criteria)
    if (typeof(objNew) == "list")
        objNew <- mongo.bson.from.list(objNew)
    .Call(".mongo.update", mongo, ns, criteria, objNew, flags)
}

mongo.remove <- function(mongo, ns, criteria=mongo.bson.empty()) {
    if (typeof(criteria) == "list")
        criteria <- mongo.bson.from.list(criteria)
    .Call(".mongo.remove", mongo, ns, criteria)
}

mongo.find.one <- function(mongo, ns, query=mongo.bson.empty(), fields=mongo.bson.empty()) {
    if (typeof(query) == "list")
        query <- mongo.bson.from.list(query)
    if (typeof(fields) == "list")
        fields <- mongo.bson.from.list(fields)
    .Call(".mongo.find.one", mongo, ns, query, fields)
}

mongo.find.cursor.tailable   <- 2L
mongo.find.slave.ok          <- 4L
mongo.find.oplog.replay      <- 8L
mongo.find.no.cursor.timeout <- 16L
mongo.find.await.data        <- 32L
mongo.find.exhaust           <- 64L
mongo.find.partial.results   <- 128L

mongo.find <- function(mongo, ns, query=mongo.bson.empty(), sort=mongo.bson.empty(), fields=mongo.bson.empty(), limit=0L, skip=0L, options=0L) {
    if (typeof(query) == "list")
        query <- mongo.bson.from.list(query)
    if (typeof(sort) == "list")
        sort <- mongo.bson.from.list(sort)
    if (typeof(fields) == "list")
        fields <- mongo.bson.from.list(fields)
    .Call(".mongo.find", mongo, ns, query, sort, fields, limit, skip, options)
}

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

mongo.index.create <- function(mongo, ns, key, options=0L) {
    if (typeof(key) == "list")
        key <- mongo.bson.from.list(key)
    .Call(".mongo.index.create", mongo, ns, key, options)
}

mongo.count <- function(mongo, ns, query=mongo.bson.empty()) {
    if (typeof(query) == "list")
        query <- mongo.bson.from.list(query)
    .Call(".mongo.count", mongo, ns, query)
}

mongo.command <- function(mongo, db, command) {
   if (typeof(command) == "list")
        command <- mongo.bson.from.list(command)
    .Call(".mongo.command", mongo, db, command)
}

mongo.simple.command <- function(mongo, db, cmdstr, arg)
    .Call(".mongo.simple.command", mongo, db, cmdstr, arg)

mongo.drop.database <- function(mongo, db)
    .Call(".mongo.drop.database", mongo, db)

mongo.drop <- function(mongo, ns)
    .Call(".mongo.drop", mongo, ns)

mongo.rename <- function(mongo, from.ns, to.ns)
    .Call(".mongo.rename", mongo, from.ns, to.ns)

mongo.get.databases <- function(mongo)
    .Call(".mongo.get.databases", mongo)

mongo.get.database.collections <- function(mongo, db)
    .Call(".mongo.get.database.collections", mongo, db)

mongo.distinct <- function(mongo, ns, key, query=mongo.bson.empty()) {
    pos <- regexpr('\\.', ns)
    if (pos == 0) {
        print("mongo.distinct: No '.' in namespace")
        return(NULL)
    }
    db <- substr(ns, 1, pos-1)
    collection <- substr(ns, pos+1, nchar(ns))
    b <- mongo.command(mongo, db, list(distinct=collection, key=key, query=query))
    if (!is.null(b))
        b <- mongo.bson.value(b, "values")
    b
}
