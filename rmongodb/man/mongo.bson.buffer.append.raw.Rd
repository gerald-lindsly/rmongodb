% File rmongodb/man/mongo.bson.buffer.append.raw.Rd
\name{mongo.bson.buffer.append.raw}
\alias{mongo.bson.buffer.append.raw}
\title{Append a raw (binary) field onto a mongo.bson.buffer}
\description{
Append raw (binary) data onto a \link{mongo.bson.buffer}.

BSON has a special field type to indicate binary data.
This function appends such an indicator as the type of a field with its value.

If value has a \code{dims} attribute of length > 1, any \code{names} or \code{dimnames} attribute
is ignored and a nested array is appended.\cr
(Use \code{\link{mongo.bson.buffer.append.object}()} if you want to preserve \code{dimnames}).
}
\usage{
mongo.bson.buffer.append.raw(buf, name, value, subtype=NULL)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer.}
\item{value}{(raw) the binary data.}
\item{subtype}{(as.integer) The binary data subtype.  If subtype == NULL, 
    the "subtype" attribute of the raw is used.  If this is not present,
    mongo.binary.binary is used.  The following constants are defined:
    \itemize{
        \item{\code{\link{mongo.binary.binary}} (0L) }
        \item{\code{\link{mongo.binary.function}} (1L) }
        \item{\code{\link{mongo.binary.old}} (2L) }
        \item{\code{\link{mongo.binary.uuid}} (3L) }
        \item{\code{\link{mongo.binary.md5}} (5L) }
        \item{\code{\link{mongo.binary.user}} (128L) }
    }}
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
buf <- mongo.bson.buffer.create()
bin <- raw(3)
for (i in 0:2)
    bin[i] <- as.raw(i * 3)
mongo.bson.buffer.append.raw(buf, "bin1", bin)

# Note that mongo.bson.buffer.append()
# will detect whether the value parameter 
# is a raw object and append the appropriate value.

mongo.bson.buffer.append(buf, "bin2", bin)  # gives same result
}
\seealso{
\code{\link{mongo.bson.buffer.append}},\cr
\link{mongo.bson},\cr
\link{mongo.bson.buffer}.
}
