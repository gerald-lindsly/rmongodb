#   Copyright (C) 2008-2011 10gen Inc.
# 
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

mongo.bson.empty <- function()
    .Call(".mongo.bson.empty")

mongo.bson.size <- function(b)
    .Call(".mongo.bson.size", b)

mongo.bson.destroy <- function(b)
    .Call(".mongo.bson.destroy", b)

mongo.bson.print <- function(x, ...) {
    if (typeof(x) == "list")
        x <- mongo.bson.from.list(x)
    invisible(.Call(".mongo.bson.print", x))
}

print.mongo.bson <- function(x, ...)
    invisible(.Call(".mongo.bson.print", x))

mongo.bson.to.list <- function(b)
    .Call(".mongo.bson.to.list", b)

mongo.bson.from.list <- function(lst)
    .Call(".mongo.bson.from.list", lst)

mongo.bson.iterator.create <- function(b)
    .Call(".mongo.bson.iterator.create", b)

mongo.bson.find <- function(b, name)
    .Call(".mongo.bson.find", b, name)

mongo.bson.value <- function(b, name)
    .Call(".mongo.bson.value", b, name)


mongo.bson.iterator.next <- function(iter)
    .Call(".mongo.bson.iterator.next", iter)

mongo.bson.iterator.key <- function(iter)
    .Call(".mongo.bson.iterator.key", iter)

mongo.bson.iterator.type <- function(iter)
    .Call(".mongo.bson.iterator.type", iter)

mongo.bson.eoo       <- 0L # end of object
mongo.bson.double    <- 1L
mongo.bson.string    <- 2L
mongo.bson.object    <- 3L
mongo.bson.array     <- 4L
mongo.bson.binary    <- 5L
mongo.bson.undefined <- 6L
mongo.bson.oid       <- 7L
mongo.bson.bool      <- 8L
mongo.bson.date      <- 9L
mongo.bson.null      <- 10L
mongo.bson.regex     <- 11L
mongo.bson.dbref     <- 12L # deprecated
mongo.bson.code      <- 13L
mongo.bson.symbol    <- 14L
mongo.bson.code.w.scope <- 15L
mongo.bson.int       <- 16L
mongo.bson.timestamp <- 17L
mongo.bson.long      <- 18L

mongo.binary.binary  <- 0L 
mongo.binary.function <- 1L 
mongo.binary.old     <- 2L 
mongo.binary.uuid    <- 3L 
mongo.binary.md5     <- 5L
mongo.binary.user    <- 128L

mongo.bson.iterator.value <- function(iter)
    .Call(".mongo.bson.iterator.value", iter)

mongo.oid.from.string <- function(hexstr)
    .Call(".mongo.oid.from.string", hexstr)

mongo.oid.to.string <- function(oid)
    .Call(".mongo.oid.to.string", oid)

as.character.mongo.oid <- function(x, ...)
    .Call(".mongo.oid.to.string", x)

mongo.oid.create <- function()
    .Call(".mongo.oid.create")

mongo.oid.time <- function(oid)
    .Call(".mongo.oid.time", oid)

mongo.oid.print <- function(x)
    invisible(.Call(".mongo.oid.print", x))

print.mongo.oid <- function(x, ...)
    invisible(.Call(".mongo.oid.print", x))


mongo.timestamp.create <- function(time, increment)
    .Call(".mongo.timestamp.create", time, increment)

mongo.code.create <- function(code)
    .Call(".mongo.code.create", code)

mongo.code.w.scope.create <- function(code, scope)
    .Call(".mongo.code.w.scope.create", code, scope)

mongo.symbol.create <- function(value)
    .Call(".mongo.symbol.create", value)

mongo.undefined.create <- function()
    .Call(".mongo.undefined.create")

mongo.regex.create <- function(pattern, options="")
    .Call(".mongo.regex.create", pattern, options)


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

mongo.bson.buffer.append.time <- function(buf, name, time)
    .Call(".mongo.bson.buffer.append.time", buf, name, time)

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

mongo.bson.buffer.append.raw <- function(buf, name, value, subtype=NULL)
    .Call(".mongo.bson.buffer.append.raw", buf, name, value, subtype)

mongo.bson.buffer.append.oid <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.oid", buf, name, value)

mongo.bson.buffer.append.bson <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.bson", buf, name, value)

mongo.bson.buffer.append.element <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.element", buf, name, value)

mongo.bson.buffer.append <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append", buf, name, value)

mongo.bson.buffer.append.list <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.list", buf, name, value)

mongo.bson.buffer.append.object <- function(buf, name, value)
    .Call(".mongo.bson.buffer.append.object", buf, name, value)

mongo.bson.buffer.start.object <- function(buf, name)
    .Call(".mongo.bson.buffer.start.object", buf, name)

mongo.bson.buffer.start.array <- function(buf, name)
    .Call(".mongo.bson.buffer.start.array", buf, name)

mongo.bson.buffer.finish.object <- function(buf)
    .Call(".mongo.bson.buffer.finish.object", buf)

mongo.bson.buffer.size <- function(buf)
    .Call(".mongo.bson.buffer.size", buf)

