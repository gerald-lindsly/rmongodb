#include <Rinternals.h>
#include "bson.h"
#include "mongo.h"

int    _hasClass(SEXP cls, const char* name);
int    _objHasClass(SEXP b, const char* name);
void   _checkClass(SEXP b, const char* name);
int    _isBSON(SEXP b);
bson*  _checkBSON(SEXP b);
mongo* _checkMongo(SEXP mongo_conn);
SEXP   _mongo_bson_create(bson* b);
SEXP   _createPOSIXct(int t);
SEXP   _mongo_cursor_create(mongo_cursor* cursor);
