#include "symbols.h"

SEXP sym_mongo_connection;
SEXP sym_host;
SEXP sym_port;
SEXP sym_mongo_bson;
SEXP sym_mongo_bson_buffer;

void install_mongo_symbols()
{
	sym_mongo_connection = install("mongo.connection");
	sym_host = install("host");
	sym_port = install("port");
	sym_mongo_bson = install("mongo.bson");
	sym_mongo_bson_buffer = install("mongo.bson.buffer");
}