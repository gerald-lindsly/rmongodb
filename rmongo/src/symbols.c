#include "symbols.h"

SEXP sym_mongo_connection;
SEXP sym_host;
SEXP sym_port;
SEXP sym_mongo_bson;
SEXP sym_mongo_bson_buffer;
SEXP sym_mongo_bson_iterator;
SEXP sym_mongo_oid;
SEXP sym_increment;

void install_mongo_symbols()
{
	sym_mongo_bson_iterator = install("mongo.bson.iterator");
	sym_mongo_connection = install("mongo.connection");
	sym_host = install("host");
	sym_port = install("port");
	sym_mongo_bson = install("mongo.bson");
	sym_mongo_bson_buffer = install("mongo.bson.buffer");
	sym_mongo_oid = install("mongo.oid");
	sym_increment = install("increment");
}