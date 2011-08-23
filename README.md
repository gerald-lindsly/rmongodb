This is an R extension supporting access to MongoDB.

After cloning the repo, drop [mongo-c-driver](http://github.com/mongodb/mongo-c-driver)'s src directory into rmongodb/rmongodb/src

The driver is installed into R with:

`R CMD INSTALL rmongodb`

Once this is done, the package may be loaded from within R like any other.

To run the unit tests:

`R --no-save < test.R`
