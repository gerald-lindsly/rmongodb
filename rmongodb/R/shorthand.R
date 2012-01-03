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

mongo.shorthand <- function() {
    evalq(
        {
            bson.empty <- mongo.bson.empty
            bson.size <- mongo.bson.size
            bson.print <- mongo.bson.print
            bson.to.list <- mongo.bson.to.list
            bson.from.list <- mongo.bson.from.list
            bson.destroy <- mongo.bson.destroy
            bson.find <- mongo.bson.find
            bson.value <- mongo.bson.value

            bson.iterator.create <- mongo.bson.iterator.create
            bson.iterator.next <- mongo.bson.iterator.next
            bson.iterator.key <- mongo.bson.iterator.key
            bson.iterator.value <- mongo.bson.iterator.value
            bson.iterator.type <- mongo.bson.iterator.type

            bson.eoo <- mongo.bson.eoo
            bson.double <- mongo.bson.double
            bson.string <- mongo.bson.string
            bson.object <- mongo.bson.object
            bson.array <- mongo.bson.array
            bson.binary <- mongo.bson.binary
            bson.undefined <- mongo.bson.undefined
            bson.oid <- mongo.bson.oid
            bson.bool <- mongo.bson.bool
            bson.date <- mongo.bson.date
            bson.null <- mongo.bson.null
            bson.regex <- mongo.bson.regex
            bson.dbref <- mongo.bson.dbref
            bson.code <- mongo.bson.code
            bson.symbol <- mongo.bson.symbol
            bson.code.w.scope <- mongo.bson.code.w.scope
            bson.int <- mongo.bson.int
            bson.timestamp <- mongo.bson.timestamp
            bson.long <- mongo.bson.long

            oid.create <- mongo.oid.create
            oid.time <- mongo.oid.time
            oid.from.string <- mongo.oid.from.string
            oid.to.string <- mongo.oid.to.string
            oid.print <- mongo.oid.print

            timestamp.create <- mongo.timestamp.create
            code.create <- mongo.code.create
            code.w.scope.create <- mongo.code.w.scope.create
            symbol.create <- mongo.symbol.create
            undefined.create <- mongo.undefined.create
            regex.create <- mongo.regex.create

            bson.buffer.create <- mongo.bson.buffer.create
            bson.from.buffer <- mongo.bson.from.buffer
            bson.buffer.append.int <- mongo.bson.buffer.append.int
            bson.buffer.append.string <- mongo.bson.buffer.append.string
            bson.buffer.append.bool <- mongo.bson.buffer.append.bool
            bson.buffer.append.long <- mongo.bson.buffer.append.long
            bson.buffer.append.double <- mongo.bson.buffer.append.double
            bson.buffer.append.complex <- mongo.bson.buffer.append.complex
            bson.buffer.append.null <- mongo.bson.buffer.append.null
            bson.buffer.append.undefined <- mongo.bson.buffer.append.undefined
            bson.buffer.append.symbol <- mongo.bson.buffer.append.symbol
            bson.buffer.append.code <- mongo.bson.buffer.append.code
            bson.buffer.append.code.w.scope <- mongo.bson.buffer.append.code.w.scope
            bson.buffer.append.raw <- mongo.bson.buffer.append.raw
            bson.buffer.append.time <- mongo.bson.buffer.append.time
            bson.buffer.append.timestamp <- mongo.bson.buffer.append.timestamp
            bson.buffer.append.regex <- mongo.bson.buffer.append.regex
            bson.buffer.append.oid <- mongo.bson.buffer.append.oid
            bson.buffer.append.bson <- mongo.bson.buffer.append.bson
            bson.buffer.append.element <- mongo.bson.buffer.append.element
            bson.buffer.append.list <- mongo.bson.buffer.append.list
            bson.buffer.append.object <- mongo.bson.buffer.append.object
            bson.buffer.append <- mongo.bson.buffer.append
            bson.buffer.start.object <- mongo.bson.buffer.start.object
            bson.buffer.start.array <- mongo.bson.buffer.start.array
            bson.buffer.finish.object <- mongo.bson.buffer.finish.object
            bson.buffer.size <- mongo.bson.buffer.size

            gridfs.create <- mongo.gridfs.create
            gridfs.destroy <- mongo.gridfs.destroy
            gridfs.store.file <- mongo.gridfs.store.file
            gridfs.store <- mongo.gridfs.store
            gridfs.remove.file <- mongo.gridfs.remove.file
            gridfs.find <- mongo.gridfs.find
            gridfile.destroy <- mongo.gridfile.destroy
            gridfile.get.descriptor <- mongo.gridfile.get.descriptor
            gridfile.get.filename <- mongo.gridfile.get.filename
            gridfile.get.length <- mongo.gridfile.get.length
            gridfile.get.chunk.size <- mongo.gridfile.get.chunk.size
            gridfile.get.chunk.count <- mongo.gridfile.get.chunk.count
            gridfile.get.content.type <- mongo.gridfile.get.content.type
            gridfile.get.upload.date <- mongo.gridfile.get.upload.date
            gridfile.get.md5 <- mongo.gridfile.get.md5
            gridfile.get.metadata <- mongo.gridfile.get.metadata
            gridfile.get.chunk <- mongo.gridfile.get.chunk
            gridfile.get.chunks <- mongo.gridfile.get.chunks
            gridfile.read <- mongo.gridfile.read
            gridfile.seek <- mongo.gridfile.seek
            gridfile.pipe <- mongo.gridfile.pipe
            gridfile.writer.create <- mongo.gridfile.writer.create
            gridfile.writer.write <- mongo.gridfile.writer.write
            gridfile.writer.finish <- mongo.gridfile.writer.finish
        },
        envir=parent.frame()
    )
    TRUE
}