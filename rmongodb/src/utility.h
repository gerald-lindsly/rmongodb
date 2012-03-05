/* Copyright (C) 2008-2011 10gen Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
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
SEXP   _createPOSIXct(double t);
SEXP   _mongo_cursor_create(mongo_cursor* cursor);
