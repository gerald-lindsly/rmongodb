% File rmongodb/man/mongo.bson.to.list.Rd
\name{mongo.bson.to.list}
\alias{mongo.bson.to.list}
\title{Convert a mongo.bson object to an R object.}
\description{
Convert a \link{mongo.bson} object to an R object.

Note that this function and \code{\link{mongo.bson.from.list}()} do not always perform inverse 
conversions since \code{mongo.bson.to.list}() will convert objects and subobjects to atomic vectors if possible.

This function is somewhat schizophrenic depending on the types of the fields in the mongo.bson object.
If all fields in an object (or subobject/array) can be converted to the same atomic R type
(for example they are all strings or all integer,
you'll actually get out a vector of the atomic type with the names attribute set.

For example, if you construct a mongo.bson object like such:

\preformatted{buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "First", "Joe")
mongo.bson.buffer.append(buf, "Last", "Smith")
b <- mongo.bson.from.buffer(buf)
l <- mongo.bson.to.list(b)}

You'll get a vector of strings out of it which may be indexed by number, like so:

\code{print(l[1])  # display "Joe"}

or by name, like so:

\code{print(l[["Last"]]) # display "Smith"}


If, however, the mongo.bson object is made up of disparate types like such:

\preformatted{buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "Name", "Joe Smith")
mongo.bson.buffer.append(buf, "age", 21.5)
b <- mongo.bson.from.buffer(buf)
l <- mongo.bson.to.list(b)}

You'll get a true list (with the names attribute set) which may be indexed by number also:

\code{print(l[1])  # display "Joe Smith"}

or by name, in the same fashion as above, like so

\code{print(l[["Name"]]) # display "Joe Smith"}

\strong{but} also with the $ operator, like so:

\code{print(l$age)  # display 21.5}


Note that \code{mongo.bson.to.list()} operates recursively on subobjects and arrays and 
you'll get lists whose members are lists or vectors themselves.  See \code{\link{mongo.bson.value}()} 
for more information on the conversion of component types.

This function also detects the special wrapper as output by \code{\link{mongo.bson.buffer.append.object}()} and
will return an appropriately attributed object.

Perhaps the best way to see what you are going to get for your particular application is to test it.
}
\usage{
mongo.bson.to.list(b)
}
\arguments{
\item{b}{(\link{mongo.bson}) The mongo.bson object to convert.}
}
\value{
Best guess at an appropriate R object representing the mongo.bson object.
}
\examples{
buf <- mongo.bson.buffer.create()
mongo.bson.buffer.append(buf, "name", "Fred")
mongo.bson.buffer.append(buf, "city", "Dayton")
b <- mongo.bson.from.buffer(buf)

l <- mongo.bson.to.list(b)
print(l)
}
\seealso{
\code{\link{mongo.bson.from.list}},\cr
\link{mongo.bson}.
}
