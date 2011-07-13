mongo.bson.empty <- function()
	.Call(".mongo.bson.empty")

mongo.bson.clear <- function(b)
	.Call(".mongo.bson.clear")

mongo.bson.copy <- function(b)
	.Call(".mongo.bson.copy", b)

mongo.bson.size <- function(b)
	.Call(".mongo.bson.size", b)


mongo.bson.buffer.create <- function()
	.Call(".mongo.bson.buffer.create")

mongo.bson.from.buffer <- function(buf)
	.Call(".mongo.bson.from.buffer", buf)

mongo.bson.buffer.append.int <- function(buf, name, value)
	.Call(".mongo.bson.buffer.append.int", buf, name, value)

mongo.bson.buffer.append.string <- function(buf, name, value)
	.Call(".mongo.bson.buffer.append.string", buf, name, value)

