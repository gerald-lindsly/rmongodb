.onLoad <- function(libname, pkgname) {
	print("rmongo package (mongo-r-driver) loaded")
	.C("mongo.sock_init")
	x <- mongo.Connection()
	print(x)
	buf <- mongo.bson.buffer.create()
	print(5)
	mongo.bson.buffer.append.string(buf, "name", "Gerald")
	print("A")
	mongo.bson.buffer.append.int(buf, "age", 48L)
	print("B")
	b <- mongo.bson.from.buffer(buf)
	print(mongo.insert(x, "test", b))
}