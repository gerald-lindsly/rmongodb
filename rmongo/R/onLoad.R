.onLoad <- function(libname, pkgname) {
	print("rmongo package (mongo-r-driver) loaded")
	x <- mongo.Connection()
}