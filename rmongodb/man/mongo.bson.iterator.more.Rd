% File rmongodb/man/mongo.bson.iterator.more.Rd
\name{mongo.bson.iterator.more}
\alias{mongo.bson.iterator.more}
\title{Return TRUE if there are more fields to processs with an iterator}
\description{
Return TRUE if more fields to processs with an iterator; otherwise, FALSE.

** Possibly to be dropped from the driver. **
}
\usage{
mongo.bson.iterator.more(iter)
}
\arguments{
\item{iter}{A \link{mongo.bson.iterator}.}
}
\value{
(logical) FALSE if the iterator at the end of the object; otherwise, TRUE.
}
\seealso{
\link{mongo.bson.iterator},
\code{\link{mongo.bson.iterator.create}},
\code{\link{mongo.bson.find}},
\code{\link{mongo.bson.iterator.next}},
\code{\link{mongo.bson.iterator.key}},
\code{\link{mongo.bson.iterator.type}},
\code{\link{mongo.bson.iterator.value}},
\link{mongo.bson}
}
