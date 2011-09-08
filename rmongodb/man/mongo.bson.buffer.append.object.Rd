% File rmongodb/man/mongo.bson.buffer.append.object.Rd
\name{mongo.bson.buffer.append.object}
\alias{mongo.bson.buffer.append.object}
\title{Append an R object onto a mongo.bson.buffer}
\description{
Append an R object onto a \link{mongo.bson.buffer}.

This function allows you to store higher level R objects in the database without
losing their attribute information.  It will correctly handle data frames, matrices and arrays
for instance; although, empty objects, such as a data frame with no rows, are not permitted.

Note that the names attribute will not be preserved if the object is multidimensional (although
dimnames will be).

The object's value will look like this in the buffer:
\preformatted{
    {
       ...
       name : {
                R_OBJ : true,
                value : xxx,
                attr  : {
                           attr1 : yyy,
                           attr2 : zzz
                        }
              }
        ...
    }
}

\code{name} will be substituted with the value of the \code{name} parameter.\cr
\code{xxx} will be substituted with the low level value of the object (as would be appended by
\code{\link{mongo.bson.buffer.append}()}).\cr
\code{attr1} and \code{attr2} will be substituted with the names of attributes.\cr
\code{yyy} and \code{zzz} will be substituted with the values of those attributes.\cr

Note that it is inadvised to construct this wrapper manually as \code{\link{mongo.bson.value}()} and
\code{\link{mongo.bson.iterator.value}()} bypass the special checking and handling that is done by R code that
set attributes.
}
\usage{
mongo.bson.buffer.append.object(buf, name, value)
}
\arguments{
\item{buf}{(\link{mongo.bson.buffer}) The buffer object to which to append.}
\item{name}{(string) The name (key) of the field appended to the buffer. }
\item{value}{(object) The object to append to the buffer as a subobject. }
}
\value{
TRUE if successful; otherwise, FALSE if an error occured appending the data.
}
\examples{
age <- c(5, 8)
height <- c(35, 47)
d <- data.frame(age=age, height=height)
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append.object(buf, "table", d)
b <- mongo.bson.from.buffer(buf)

# this produces a BSON object of the form:
# { "table" : { "R_OBJ" : true,
#               "value" : {
#                    "age"    : [ 5, 8 ],
#                    "height" : [35, 47 ]
#               },
#               "attr" : {
#                  "row.names" : [ -2147483648, -2 ],
#                  "class" : "data.frame"
#               }
#             }
# }
# row.names is stored in the compact form used for integer row names.
}
\seealso{
\link{mongo.bson},\cr
\link{mongo.bson.buffer},\cr
\code{\link{mongo.bson.buffer.append}},\cr
\code{\link{mongo.bson.value}},\cr
\code{\link{mongo.bson.iterator.value}}
}
