mongo.bson.empty <- function()
    .Call(".mongo.bson.empty")

mongo.bson.size <- function(b)
    .Call(".mongo.bson.size", b)

mongo.bson.print <- function(b)
    .Call(".mongo.bson.print", b)

mongo.bson.to.list <- function(b)
    .Call(".mongo.bson.to.list", b)

print.mongo.bson <- function(b, digits)
    .Call(".mongo.bson.print", b)

mongo.bson.iterator.create <- function(b)
    .Call(".mongo.bson.iterator.create", b)

mongo.bson.find <- function(b, name)
    .Call(".mongo.bson.find", b, name)


mongo.bson.iterator.more <- function(iter)
    .Call(".mongo.bson.iterator.more", iter)

mongo.bson.iterator.next <- function(iter)
    .Call(".mongo.bson.iterator.next", iter)

mongo.bson.iterator.key <- function(iter)
    .Call(".mongo.bson.iterator.key", iter)

mongo.bson.iterator.type <- function(iter)
    .Call(".mongo.bson.iterator.type", iter)

mongo.bson.iterator.value <- function(iter)
    .Call(".mongo.bson.iterator.value", iter)

mongo.oid.from.string <- function(str)
    .Call(".mongo.oid.from.string", str)

mongo.string.from.oid <- function(oid)
    .Call(".mongo.string.from.oid", oid)

mongo.oid.create <- function()
    .Call(".mongo.oid.create")

mongo.oid.time <- function(oid)
    .Call(".mongo.oid.time", oid)

mongo.oid.print <- function(oid)
    .Call(".mongo.oid.print", oid)

print.mongo.oid <- function(oid)
    .Call(".mongo.oid.print", oid)


mongo.timestamp.create <- function(t, i)
    .Call(".mongo.timestamp.create", t, i)

mongo.code.create <- function(str)
    .Call(".mongo.code.create", str)

mongo.code.w.scope.create <- function(str, b)
    .Call(".mongo.code.w.scope.create", str, b)

mongo.symbol.create <- function(str)
    .Call(".mongo.symbol.create", str)

mongo.undefined.create <- function()
    .Call(".mongo.undefined.create")

mongo.regex.create <- function(pattern, options)
    .Call(".mongo.regex.create", pattern, options)

mongo.binary.create <- function(type, length)
    .Call(".mongo.binary.create", type, length)

mongo.binary.set <- function(bin, index, value)
    .Call(".mongo.binary.set", bin, index, value)

mongo.binary.get <- function(bin, index)
    .Call(".mongo.binary.get", bin, index)


mongo.bson.buffer.create <- function()
    .Call(".mongo.bson.buffer.create")

mongo.bson.from.buffer <- function(buf)
    .Call(".mongo.bson.from.buffer", buf)

mongo.bson.buffer.append.int <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.int", buf, name, value)

mongo.bson.buffer.append.bool <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.bool", buf, name, value)

mongo.bson.buffer.append.double <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.double", buf, name, value)

mongo.bson.buffer.append.complex <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.complex", buf, name, value)

mongo.bson.buffer.append.long <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.long", buf, name, value)

mongo.bson.buffer.append.null <- function(buf, name)
    .Call(".mongo.bson.buffer.append.null", buf, name)

mongo.bson.buffer.append.undefined <- function(buf, name)
    .Call(".mongo.bson.buffer.append.undefined", buf, name)

mongo.bson.buffer.append.string <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.string", buf, name, value)

mongo.bson.buffer.append.time <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.time", buf, name, value)

mongo.bson.buffer.append.timestamp <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.timestamp", buf, name, value)

mongo.bson.buffer.append.code <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.code", buf, name, value)

mongo.bson.buffer.append.code.w.scope <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.code.w.scope", buf, name, value)

mongo.bson.buffer.append.symbol <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.symbol", buf, name, value)

mongo.bson.buffer.append.regex <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.regex", buf, name, value)

mongo.bson.buffer.append.binary <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.binary", buf, name, value)

mongo.bson.buffer.append.oid <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.oid", buf, name, value)

mongo.bson.buffer.append.bson <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.bson", buf, name, value)

mongo.bson.buffer.append.element <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.element", buf, name, value)

mongo.bson.buffer.append <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append", buf, name, value)

mongo.bson.buffer.start.object <- function(buf, name)
    .Call(".mongo.bson.buffer.start.object", buf, name)

mongo.bson.buffer.start.array <- function(buf, name)
    .Call(".mongo.bson.buffer.start.array", buf, name)

mongo.bson.buffer.finish.object <- function(buf)
    .Call(".mongo.bson.buffer.finish.object", buf)



mongo.sys.time <- function()
    .Call(".mongo.sys.time")
