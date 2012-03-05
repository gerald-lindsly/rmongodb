library("rmongodb")

r <- as.integer(c(1,2,3,4,5,6,7,8))
dim(r) <- c(2,2,2)
r
t <- Sys.time()
t <- c(t, t+10, t+60, t+120)
dim(t) <- c(2,2)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.int(buf, "test", r)
mongo.bson.buffer.append(buf, "times", t)
b <- mongo.bson.from.buffer(buf)
b

mongo.bson.value(b, "test")
mongo.bson.value(b, "times")

r <- as.raw(r)
dim(r) <- c(2,4)
r
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "test", r)
b <- mongo.bson.from.buffer(buf)
b

q <- mongo.bson.value(b, "test")
q
typeof(q)

r <- 1:24
dim(r) <- c(3,2,4)
r
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.int(buf, "test", r)
b <- mongo.bson.from.buffer(buf)
b

mongo.bson.value(b, "test")


age <- c(5, 8)
height <- c(35, 47)
d <- data.frame(age=age,height=height)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.object(buf, "table", d)
b <- mongo.bson.from.buffer(buf)
print(b)


age=18:29
height=c(76.1,77,78.1,78.2,78.8,79.7,79.9,81.1,81.2,81.8,82.8,83.5)
village=data.frame(age=age,height=height)
unclass(village)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.object(buf, "village", village)
b <- mongo.bson.from.buffer(buf)
print(b)

v <- mongo.bson.value(b, "village")
v
unclass(v)

m <- matrix(c(1,0,0, 0,1,0, 0,0,1), nrow=3, ncol=3, dimnames=list(c("X","Y","Z"),c("x","y","z")))
m
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.object(buf, "mat", m)
b <- mongo.bson.from.buffer(buf)
print(b)
v <- mongo.bson.value(b, "mat")
v
attributes(v)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "x", 5L)
scope <- mongo.bson.from.buffer(buf)
codew <- mongo.code.w.scope.create("y = x", scope)
print(codew)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.string(buf, "name", "Gerald")
mongo.bson.buffer.append.int(buf, "age", 48L)
mongo.bson.buffer.append.bool(buf, "True", TRUE)
mongo.bson.buffer.append.double(buf, "ThreePointFive", 3.5)
mongo.bson.buffer.append.long(buf, "YearSeconds", 365.24219 * 24 * 60 * 60)
mongo.bson.buffer.append.time(buf, "lt", strptime("05-12-2012", "%m-%d-%Y"))

oid <- mongo.oid.from.string("1234567890AB1234567890AB")
mongo.bson.buffer.append.oid(buf, "_id", oid)
id <- mongo.oid.create()
print(mongo.oid.time(id))
print(as.character(id))
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

mongo.bson.buffer.append(buf, "regex",
    mongo.regex.create("pattern", "options"))

bin <- raw(length=3)
for (i in 0:2)
    bin[i] = as.raw(i * 3)
mongo.bson.buffer.append(buf, "bin", bin)

mongo.bson.buffer.append.time(buf, "Now", Sys.time())
ts <- mongo.timestamp.create(Sys.time() + 24 * 60 * 60, 25L)
mongo.bson.buffer.append.timestamp(buf, "Later", ts)

mongo.bson.buffer.start.object(buf, "data")
mongo.bson.buffer.append(buf, "sub1", 1L)
mongo.bson.buffer.append(buf, "sub2", Sys.time())
mongo.bson.buffer.finish.object(buf)

b <- mongo.bson.from.buffer(buf)
print(b)

iter <- mongo.bson.iterator.create(b)
while (mongo.bson.iterator.next(iter)) {
    print(mongo.bson.iterator.key(iter))
    print(mongo.bson.iterator.value(iter))
}
print(attr(ts, "increment"))

iter <- mongo.bson.find(b, "code")
print(mongo.bson.iterator.value(iter))

sub2 <- mongo.bson.value(b, "data.sub2")
print(sub2)

print(mongo.bson.to.list(b))
mongo <- mongo.create()
if (!mongo.is.connected(mongo))
    stop("No connnection")

print(mongo.get.primary(mongo))
print(sprintf("IsMaster (%s)", if (mongo.is.master(mongo)) "Yes" else "No"))
mongo.set.timeout(mongo, 2000)
print(mongo.get.timeout(mongo))

print(mongo.simple.command(mongo, "admin", "buildInfo", 1))

print(mongo.get.databases(mongo))
#print(mongo.simple.command(mongo, "admin", "top", 1L))

db <- "test"
ns <- paste(db, "test", sep=".")
print("drop collection x2")
print(mongo.drop(mongo, ns))
print(mongo.drop(mongo, "foo.bar"))
print("drop database")
print(mongo.drop.database(mongo, db))

print("test add dup key")
ns <- paste(db, "people", sep=".")
mongo.index.create(mongo, ns, "name", mongo.index.unique)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "John")
mongo.bson.buffer.append(buf, "age", 22L)
x <- mongo.bson.from.buffer(buf)
mongo.insert(mongo, ns, x);

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "John")
mongo.bson.buffer.append(buf, "age", 27L)
x <- mongo.bson.from.buffer(buf)
mongo.insert(mongo, ns, x);

err <- mongo.get.last.err(mongo, db)
print(mongo.get.server.err(mongo))
iter = mongo.bson.find(err, "code")
print(mongo.bson.iterator.value(iter))
print(mongo.get.server.err.string(mongo))
iter = mongo.bson.find(err, "err")
print(mongo.bson.iterator.value(iter))

mongo.reset.err(mongo, db)

# test various other database ops

print("add user")
print(mongo.add.user(mongo, "Gerald", "PaSsWoRd"))

mongo.simple.command(mongo, db, "badcommand", 0L)
print(mongo.get.err(mongo))

print("insert")
#print(mongo.insert(mongo, ns, b))  #

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Dwight")
mongo.bson.buffer.append(buf, "city", "NY")
b <- mongo.bson.from.buffer(buf)
mongo.insert(mongo, ns, b)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Dave")
mongo.bson.buffer.append(buf, "city", "Cincinnati")
x <- mongo.bson.from.buffer(buf)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Fred")
mongo.bson.buffer.append(buf, "city", "Dayton")
mongo.bson.buffer.append(buf, "age", 21L)
print(mongo.bson.buffer.size(buf))

y <- mongo.bson.from.buffer(buf)
print(mongo.bson.size(y))

l <- mongo.bson.to.list(y)
print(l$name)
print(l$city)
l$city <- "Detroit"
print(l)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Silvia")
mongo.bson.buffer.append(buf, "city", "Cincinnati")
z <- mongo.bson.from.buffer(buf)
mongo.insert.batch(mongo, ns, list(x, y, z))

print("index create x2")
print(mongo.index.create(mongo, ns, "city"))

print(mongo.index.create(mongo, ns, c("name", "city")))

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.start.object(buf, "age")
mongo.bson.buffer.append(buf, "$bad", 1L)
mongo.bson.buffer.finish.object(buf)
query  <- mongo.bson.from.buffer(buf)
print("bad find.one")
result <- mongo.find.one(mongo, ns, query)
if (is.null(result)) {
    print(mongo.get.server.err(mongo))
    print(mongo.get.server.err.string(mongo))
} else
    print(result)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Dave")
query  <- mongo.bson.from.buffer(buf)
print("find.one")
result <- mongo.find.one(mongo, ns, query)

print("bson.find")
iter <- mongo.bson.find(result, "city")
if (!is.null(iter)) {
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

cursor <- mongo.find(mongo, ns, sort=mongo.bson.from.list(list(city=1L)), limit=100L)
print(mongo.cursor.value(cursor))
while (mongo.cursor.next(cursor))
    print(mongo.cursor.value(cursor))
mongo.cursor.destroy(cursor)

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "")
mongo.bson.buffer.append(buf, "age", 1L)
b <- mongo.bson.from.buffer(buf)
print("index create")
print(mongo.index.create(mongo, ns, b))
 
print("rename")
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "renameCollection", ns)
mongo.bson.buffer.append(buf, "to", "foo.humans")
command <- mongo.bson.from.buffer(buf)
print(mongo.command(mongo, "admin", command))
ns <- "foo.humans"

print("count x2")
print(mongo.count(mongo, ns))
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "count", "humans")
mongo.bson.buffer.append(buf, "query", mongo.bson.empty())
command <- mongo.bson.from.buffer(buf)
print(mongo.command(mongo, "foo", command))

buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Ford")
mongo.bson.buffer.append(buf, "engine", "Vv8")
z <- mongo.bson.from.buffer(buf)
mongo.insert(mongo, "foo.cars", z)

print(mongo.get.database.collections(mongo, "foo"))

buf <- mongo.bson.buffer.create()
l <- list(fruit = "apple", hasSeeds = TRUE)
mongo.bson.buffer.append.list(buf, "item", l)
b <- mongo.bson.from.buffer(buf)
print(b)


buf <- mongo.bson.buffer.create()
undef <- mongo.undefined.create()
mongo.bson.buffer.append(buf, "Undef", undef)
l <- list(u1 = undef, One = 1)
mongo.bson.buffer.append.list(buf, "listWundef", l)
b <- mongo.bson.from.buffer(buf)
print(b)
print(mongo.bson.to.list(b))

gfs <- mongo.gridfs.create(mongo, "grid")
if (!mongo.gridfs.store.file(gfs, "test.R"))
    stop("unable to store test.R")
if (!mongo.gridfs.store.file(gfs, "rmongodb.pdf"))
    stop("unable to store rmongodb.pdf")
if (!mongo.gridfs.store.file(gfs, "check.bat"))
    stop("unable to store check.bat")
if (!mongo.gridfs.store.file(gfs, "test.bat"))
    stop("unable to store test.bat")

mongo.gridfs.remove.file(gfs, "test.bat")
if (!is.null(mongo.gridfs.find(gfs, "test.bat")))
    stop("mongo.gridfs.remove.file didn't work.")

gridfile <- mongo.gridfs.find(gfs, "check.bat")
print(mongo.gridfile.get.descriptor(gridfile))
print(mongo.gridfile.get.filename(gridfile))
print(mongo.gridfile.get.length(gridfile))
print(mongo.gridfile.get.chunk.size(gridfile))
print(mongo.gridfile.get.chunk.count(gridfile))
print(mongo.gridfile.get.content.type(gridfile))
print(mongo.gridfile.get.upload.date(gridfile))
print(mongo.gridfile.get.md5(gridfile))
print(mongo.gridfile.get.metadata(gridfile))

b <- mongo.gridfile.get.chunk(gridfile, 0)
print(b)
iter <- mongo.bson.find(b, "data")
print(rawToChar(mongo.bson.iterator.value(iter)))

test.out <- file("test.out")
mongo.gridfile.pipe(gridfile, test.out)

    gfw <- mongo.gridfile.writer.create(gfs, "test.dat")

    # store 4 bytes
    mongo.gridfile.writer.write(gfw, charToRaw("test"))

    # store string & LF plus 0-byte terminator
    buf <- writeBin("Test\n", as.raw(1))
    mongo.gridfile.writer.write(gfw, buf)

    # store PI as a float
    buf <- writeBin(3.1415926, as.raw(1), size=4, endian="little")
    mongo.gridfile.writer.write(gfw, buf)

    mongo.gridfile.writer.finish(gfw)

mongo.gridfile.destroy(gridfile)

mongo.disconnect(mongo)
mongo.destroy(mongo)
