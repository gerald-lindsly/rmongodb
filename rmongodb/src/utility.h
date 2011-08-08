#include <Rinternals.h>
#include "bson.h"

int _hasClass(SEXP cls, const char* name);
void _checkClass(SEXP b, const char* name);
int _isBSON(SEXP b);
bson* _checkBSON(SEXP b);
