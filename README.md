This is an R extension supporting access to MongoDB.

After cloning the repo, 
drop [mongo-c-driver](http://github.com/mongodb/mongo-c-driver)'s src directory 
into rmongodb/rmongodb/src.  Alternately, unpack mongo-c-driver-src.zip into rmongodb/rmongodb/src.

The driver is installed into R with:

`R CMD INSTALL rmongodb`

If you have compile problems, this may be due to interface changes to mongo-c-driver.  
In rmongodb/ is an archived copy of mongo-c-driver (mongo-c-driver-src.zip)
that you can unpack to .../src .  Since this is the version of the mongo-c-driver
used in the development of rmongodb, you may have better results.

Once you have installed the package, it may be loaded from within R like any other:

`>library("rmongodb") # for instance`

To run the unit tests:

`R --no-save < test.R`


