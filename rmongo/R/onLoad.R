.onLoad <- function(libname, pkgname) {
	print("rmongo package (mongo-r-driver) loaded")
	.C("mongo.sock_init")

	buf <- mongo.bson.buffer.create()
	mongo.bson.buffer.append.string(buf, "name", "Gerald")
	mongo.bson.buffer.append.int(buf, "age", 48L)
	mongo.bson.buffer.append.bool(buf, "True", TRUE)
	mongo.bson.buffer.append.double(buf, "ThreePointFive", 3.5)
	mongo.bson.buffer.append.long(buf, "YearSeconds", 365 * 24 * 60 * 60)
	oid <- mongo.oid.from.string("1234567890AB1234567890AB")
	mongo.bson.buffer.append.oid(buf, "_id", oid)
	mongo.bson.buffer.append.null(buf, "Null")
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
	connection <- mongo.Connection()
	if (mongo.Connection.isConnected(connection))
		print(mongo.insert(connection, "test.test", b))

}
