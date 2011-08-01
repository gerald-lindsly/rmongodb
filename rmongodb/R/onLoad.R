.onLoad <- function(libname, pkgname) {
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "x", 5L)
    scope <- mongo.bson.from.buffer(buf)
    codew <- mongo.code.w.scope.create("y = x", scope)

    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append.string(buf, "name", "Gerald")
    mongo.bson.buffer.append.int(buf, "age", 48L)
    mongo.bson.buffer.append.bool(buf, "True", TRUE)
    mongo.bson.buffer.append.double(buf, "ThreePointFive", 3.5)
    mongo.bson.buffer.append.long(buf, "YearSeconds", 365 * 24 * 60 * 60)
    oid <- mongo.oid.from.string("1234567890AB1234567890AB")
    mongo.bson.buffer.append.oid(buf, "_id", oid)
    id <- mongo.oid.create()
    print(mongo.oid.time(id))
    mongo.bson.buffer.append(buf, "ID", id)
    mongo.bson.buffer.append.null(buf, "Null")

    mongo.bson.buffer.start.object(buf, "One_Four")
    for (x in 1:4)
        mongo.bson.buffer.append.int(buf, as.character(x), x)
    mongo.bson.buffer.finish.object(buf)

    code <- mongo.code.create("CoDe")
    mongo.bson.buffer.append(buf, "code", code)

    mongo.bson.buffer.append(buf, "CodeW", codew)

    mongo.bson.buffer.append.symbol(buf, "symbol", "SyMbOl")

    mongo.bson.buffer.append.undefined(buf, "undefined1")
    undef <- mongo.undefined.create()
    mongo.bson.buffer.append(buf, "undefined2", undef)


    mongo.bson.buffer.append.time(buf, "Now", Sys.time())
    ts <- mongo.timestamp.create(Sys.time() + 60 * 60 * 1000, 25L)
    mongo.bson.buffer.append.timestamp(buf, "Later", ts)

    b <- mongo.bson.from.buffer(buf)
    print(b)

    iter <- mongo.bson.iterator.create(b)
    while (mongo.bson.iterator.next(iter)) {
        print(mongo.bson.iterator.key(iter))
        print(mongo.bson.iterator.value(iter))
    }
    print(attr(ts, "increment"))

    print(mongo.bson.to.list(b))
    mongo <- mongo.create()
    if (mongo.is.connected(mongo)) {
        db <- "test"
        ns <- paste(db, "test", sep=".")
        mongo.reset.error(mongo, db)
        print("drop collection x2")
        print(mongo.drop.collection(mongo, ns))
        print(mongo.drop.collection(mongo, "foo.bar"))
        print("drop database")
        print(mongo.drop.database(mongo, db))

        print("add user")
        print(mongo.add.user(mongo, db, "Gerald", "PaSsWoRd"))

        mongo.simple.command(mongo, db, "badcommand", 0L)
        print("last error")
        print(mongo.get.last.error(mongo, db))

        print("insert")
        print(mongo.insert(mongo, ns, b))

        buf <- mongo.bson.buffer.create()
        mongo.bson.buffer.append(buf, "name", "Dwight")
        mongo.bson.buffer.append(buf, "city", "NY")
        b <- mongo.bson.from.buffer(buf)
        mongo.insert(mongo, ns, b)

        buf <- mongo.bson.buffer.create()
        mongo.bson.buffer.append(buf, "name", "Dave")
        mongo.bson.buffer.append(buf, "city", "Cinci")
        b <- mongo.bson.from.buffer(buf)
        mongo.insert(mongo, ns, b)

        buf <- mongo.bson.buffer.create()
        mongo.bson.buffer.append(buf, "name", "Fred")
        mongo.bson.buffer.append(buf, "city", "Dayton")
        b <- mongo.bson.from.buffer(buf)
        mongo.insert(mongo, ns, b)

        print("index create x2")
        print(mongo.index.create(mongo, ns, "city"))

        print(mongo.index.create(mongo, ns, c("name", "city")))

        buf <- mongo.bson.buffer.create()
        mongo.bson.buffer.append(buf, "name", "Dave")
        query  <- mongo.bson.from.buffer(buf)
        result <- mongo.find.one(mongo, ns, query)

        if (mongo.bson.find(result, "city", iter)) {
            city <- mongo.bson.iterator.value(iter)
            buf <- mongo.bson.buffer.create()
            mongo.bson.buffer.append(buf, "city", city)
            query <- mongo.bson.from.buffer(buf)
            print(paste("find city: ", city, sep=""))
            print(mongo.find.one(mongo, ns, query))
        }

        buf <- mongo.bson.buffer.create()
        mongo.bson.buffer.append(buf, "_id", oid)
        query <- mongo.bson.from.buffer(buf)

        buf <- mongo.bson.buffer.create()
        mongo.bson.buffer.start.object(buf, "$inc")
        mongo.bson.buffer.append(buf, "age", 1L)
        mongo.bson.buffer.finish.object(buf)
        op  <- mongo.bson.from.buffer(buf)

        mongo.update(mongo, ns, query, op)

        cursor <- mongo.find(mongo, ns, limit=100L)
        while (mongo.cursor.next(cursor))
            print(mongo.cursor.value(cursor))
        mongo.cursor.destroy(cursor)

        buf <- mongo.bson.buffer.create()
        mongo.bson.buffer.append(buf, "name", "")
        mongo.bson.buffer.append(buf, "age", 1L)
        b <- mongo.bson.from.buffer(buf)
        print("index create")
        print(mongo.index.create(mongo, ns, b))

        print("count x2")
        print(mongo.count(mongo, ns))
        buf <- mongo.bson.buffer.create()
        mongo.bson.buffer.append(buf, "count", "test")
        mongo.bson.buffer.append(buf, "query", mongo.bson.empty())
        command <- mongo.bson.from.buffer(buf)
        print(mongo.command(mongo, "test", command))

    }

}
