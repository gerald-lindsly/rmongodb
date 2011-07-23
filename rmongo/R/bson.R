mongo.bson.empty <- function()
	.Call(".mongo.bson.empty")

mongo.bson.clear <- function(b)
	.Call(".mongo.bson.clear")

mongo.bson.copy <- function(b)
	.Call(".mongo.bson.copy", b)

mongo.bson.size <- function(b)
	.Call(".mongo.bson.size", b)

mongo.bson.print <- function(b)
	.Call(".mongo.bson.print", b)

print.mongo.bson <- function(b)
	.Call(".mongo.bson.print", b)

mongo.bson.iterator.create <- function(b)
	.Call(".mongo.bson.iterator.create", b)

mongo.bson.find <- function(b, name, iter)
	.Call(".mongo.bson.find", b, name, iter)


mongo.bson.iterator.more <- function(iter)
	.Call(".mongo.bson.iterator.more", iter)

mongo.bson.iterator.next <- function(iter)
	.Call(".mongo.bson.iterator.next", iter)

mongo.bson.iterator.key <- function(iter)
	.Call(".mongo.bson.iterator.key", iter)

mongo.bson.iterator.type <- function(iter)
	.Call(".mongo.bson.iterator.type", iter)

mongo.oid.from.string <- function(str)
	.Call(".mongo.oid.from.string", str)

mongo.string.from.oid <- function(oid)
	.Call(".mongo.string.from.oid", oid)

mongo.oid.print <- function(oid)
	.Call(".mongo.oid.print", oid)

print.mongo.oid <- function(oid)
	.Call(".mongo.oid.print", oid)


mongo.bson.iterator.type <- function(iter)
	.Call(".mongo.bson.iterator.type", iter)

mongo.bson.iterator.value <- function(iter)
	.Call(".mongo.bson.iterator.value", iter)

mongo.timestamp.create <- function(t, i)
	.Call(".mongo.timestamp.create", t, i)



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

mongo.bson.buffer.append.string <- function(buf, name, value)
	.Call(".mongo.bson.buffer.append.string", buf, name, value)

mongo.bson.buffer.append.time <- function(buf, name, value)
	.Call(".mongo.bson.buffer.append.time", buf, name, value)

mongo.bson.buffer.append.timestamp <- function(buf, name, value)
	.Call(".mongo.bson.buffer.append.timestamp", buf, name, value)

mongo.bson.buffer.append.string <- function(buf, name, value)
	.Call(".mongo.bson.buffer.append.string", buf, name, value)

mongo.bson.buffer.append.oid <- function(buf, name, value)
	.Call(".mongo.bson.buffer.append.oid", buf, name, value)

mongo.bson.buffer.append.bson <- function(buf, name, value)
	.Call(".mongo.bson.buffer.append.bson", buf, name, value)

mongo.bson.buffer.append.element <- function(buf, name, value)
	.Call(".mongo.bson.buffer.append.element", buf, name, value)

mongo.bson.buffer.append <- function(buf, name, value)
	.Call(".mongo.bson.buffer.append", buf, name, value)

mongo.sys.time <- function()
	.Call(".mongo.sys.time")