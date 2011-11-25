library("rmongodb")

cat("\nSimple Teacher's Aid - A Sample Program Using rmongodb\n")
cat("The grading functions will work only if a test has at least 2 students' scores entered.\n")

# test scores of 0 are thrown out when calculating the grade curve of a test
#   but are taken into consideration of a student's class grade
#   these 0's are 'absent' on mandatory tests
#   -1 scores (which are not stored in the database) do not effect the test curve
#   nor the student's class grade

#------------------------------------------------------------------------------
# The database looks like this:

# classes
#    _id  : (Object ID) class id
#    name : (string) name of the class
## one record exists in this collection for each class

# students
#    _id  : (Object ID) student id
#    name : (string) name of the student
## one record exists in this collection for each student

# class_students - many-to-many relationship
#    _id        : (Object ID) relationship id
#    class_id   : (Object ID) class id
#    student_id : (Object ID) student_id
## one record exists in this collection for each enrollment
##   of a student in a class

# tests
#    _id      : (Object ID) test id 
#    class_id : (Object ID) the class to which this test belongs
#    name     : (string) the name of the test (or 'gradable')
#    weight   : (double) relative weight of this test to other tests in the class
#    date     : (date)   date of the test
#    mean     : (double) average score on test - calculated by gradeTest()
#    sd       : (double) standard deviation of scores - calculated by gradeTest()
## one record exists in this collection for each test of a class

# test_scores
#    _id        : (Object ID) test-score id
#    test_id    : (Object ID) the test to which this score belongs
#    student_id : (Object ID) the student to which this score belongs
#    score      : (double) the student's raw score on the test
#    curved     : (integer) curved score index into rLETS or rPOINTS
#                             - calculated by gradeTest()
## one record exists in this collection for each score given to a student
##   on the indicated test

# admin
#    _id : (Object ID) arbitrary
#    indexed : (boolean) true
## one record exists in this collection if the indexes have been registered

#------------------------------------------------------------------------------

mongo <- mongo.create()
if (!mongo.is.connected(mongo))
    error("No connection to MongoDB")

# define the database name and the namespaces of the collections
db <- "rmongodb_sample"
classes        <- paste(db, "classes",        sep=".")
students       <- paste(db, "students",       sep=".")
class_students <- paste(db, "class_students", sep=".")
tests          <- paste(db, "tests",          sep=".")
test_scores    <- paste(db, "test_scores",    sep=".")
admin          <- paste(db, "admin",          sep=".")

# register indexes with MongoDB to speed up the queries we'll be pulling
indexed = list(indexed=TRUE)
b <- mongo.find.one(mongo, admin, indexed)
if (is.null(b)) {
    mongo.index.create(mongo, classes, "name")
    mongo.index.create(mongo, students, "name")
    mongo.index.create(mongo, class_students, "class_id")
    mongo.index.create(mongo, class_students, "student_id")
    mongo.index.create(mongo, tests, "class_id")
    mongo.index.create(mongo, tests, "name")
    mongo.index.create(mongo, test_scores, "test_id")
    mongo.index.create(mongo, test_scores, "student_id")
    mongo.insert(mongo, admin, indexed)
}

#define some constants
rINDEX <- 1:13
rLETS  <- c("F", "D-", "D", "D+", "C-", "C", "C+", "B-", "B", "B+", "A-", "A", "A+")
rPOINTS <- c(0,  0.33, 0.67, 1,   1.33, 1.67,2,    2.33, 2.67, 3,  3.33, 3.67, 4.0)
rSCRS <- seq(from=52, by=4, length=13)
name_sort <- mongo.bson.from.list(list(name=1L))

# get a single char from the console (reads a whole line)
#    used by YesNo() and for menu selections
getch <- function(emptyOk=FALSE) {
    repeat {
        cat("? ")
        choice <- toupper(substr(readLines(n=1), 1, 1))
        if (emptyOk)
            break
        if (choice != "")
            break
    }
    choice
}

# get a yes/no choice from the console as a boolean (TRUE for yes)
YesNo <- function(default="Y") {
    repeat {
        cat(if (default == "Y") " (Y/n)" else " (y/N)")
        choice <- getch(emptyOk=TRUE)
        if (choice == "")
            choice <- default;
        if (choice == "Y")
            break
        if (choice == "N")
            break
    }
    choice != "N"
}


# create a mongo.bson { _id : (Object ID) id }
#   for searching a collection to find the record with given the id
bson_id <- function(id) {
    buf <- mongo.bson.buffer.create()
    mongo.bson.buffer.append(buf, "_id", id)
    mongo.bson.from.buffer(buf)
}

# select a record from a collection by a prefix of its name field
select <- function(prompt, table) {
    repeat {
        cat(prompt, "Name (prefix)? ")
        name <- readLines(n=1)
        if (name == "") {
            match <- NULL
            break
        } else {
            buf <- mongo.bson.buffer.create()
            mongo.bson.buffer.start.object(buf, "name")
            mongo.bson.buffer.append(buf, "$regex", paste("^", name, sep=""))
            mongo.bson.buffer.append(buf, "$options", "i")
            mongo.bson.buffer.finish.object(buf)
            query <- mongo.bson.from.buffer(buf)
            match <- mongo.find.one(mongo, table, query)
            if (is.null(match))
                cat("No match\n")
            else {
                name <- mongo.bson.value(match, "name")
                cat("Matched: ", name, ". Select", sep="")
                if (YesNo())
                    break
            }
        }
    }
    match
}

# turn a vector of raw scores into a vector of curved indexes to rLETS or rPOINTS
grade <- function(scores) {
    # borrowed from ProfessR
    B <- boxplot(scores, plot=FALSE)
    divs <- c(min(scores), B$stats[1:4] + diff(B$stats)/2, max(scores))
    M <- length(divs)
    adiff <- diff(divs)
    J <- rep(0, 13)
    J[1] <- 0
    for (i in 2:(M-1)) {
        j <- 3 * (i - 1) - 1
        J[j]   <- divs[i] + 0 * adiff[i] / 3
        J[j+1] <- divs[i] + 1 * adiff[i] / 3
        J[j+2] <- divs[i] + 2 * adiff[i] / 3
    }
    Jinval <- findInterval(scores, J, all.inside=TRUE)
    index <- rINDEX[Jinval]
    scores <- rSCRS[Jinval]+ 4*(scores-J[Jinval])/(J[Jinval+1]-J[Jinval])
    scores[scores >= 100] <- 100
    index[scores >= 100] <- rINDEX[13]
    index
}

# grade a test given the mongo.bson record describing the test
#   stores results in test_scores and test records
gradeTest <- function(test) {
    test_id <- mongo.bson.value(test, "_id")
    score <- c()
    id <- list()
    i <- 1
    # find all test_scores belonging to this test
    cursor <- mongo.find(mongo, test_scores, list(test_id=test_id))
    while (mongo.cursor.next(cursor)) {
        test_score <- mongo.cursor.value(cursor)
        s = mongo.bson.value(test_score, "score")
        # don't allow 0 scores to throw the curve
        if (s != 0) {
            score <- append(score, s)
            id[[i]] <- mongo.bson.value(test_score, "_id")
            i <- i + 1
        }
    }
    count <- i - 1
    if (count > 1) {
        # grade curve the test
        g <- grade(score)
        # store the curved result in test_scores
        for (i in 1:count) {
            buf <- mongo.bson.buffer.create()
            mongo.bson.buffer.start.object(buf, "$set")
            mongo.bson.buffer.append(buf, "curved", g[i])
            mongo.bson.buffer.finish.object(buf)
            b <- mongo.bson.from.buffer(buf)
            mongo.update(mongo, test_scores, bson_id(id[[i]]), b)
        }
        # calculate mean & std. dev. while we here and store them in test
        buf <- mongo.bson.buffer.create()
        mongo.bson.buffer.start.object(buf, "$set")
        mongo.bson.buffer.append(buf, "mean", mean(score))
        mongo.bson.buffer.append(buf, "sd", sd(score))
        mongo.bson.buffer.finish.object(buf)
        b <- mongo.bson.from.buffer(buf)
        b_test_id <- bson_id(test_id)
        mongo.update(mongo, tests, b_test_id, b)
    }
}

# calculate a student's final grade in a class
#   assumes the tests have already been run through gradeTest()
gradeClassStudent <- function(class_student, display=FALSE) {
    class_id <- mongo.bson.value(class_student, "class_id")
    student_id <- mongo.bson.value(class_student, "student_id")
    total_weight <- 0
    i <- 1
    weight <- c()
    curved <- c()
    name <- c()
    cursor <- mongo.find(mongo, tests, list(class_id=class_id))
    while (mongo.cursor.next(cursor)) {
        test <- mongo.cursor.value(cursor)
        test_id <- mongo.bson.value(test, "_id")
        test_score <- mongo.find.one(mongo, test_scores, 
             list(test_id=test_id, student_id=student_id))
        if (!is.null(test_score)) {
            score <- mongo.bson.value(test_score, "score")
            if (score == 0)
                c <- 1
            else
                c <- mongo.bson.value(test_score, "curved")
            curved <- append(curved, c)
            name <- append(name, mongo.bson.value(test, "name"))
            weight <- append(weight, mongo.bson.value(test, "weight"))
            total_weight <- total_weight + weight[i]
            i <- i + 1
        }
    }
    count <- i - 1
    grade <- 0
    if (count > 0) {
        o <- order(name)
        for (i in 1:count) {
            j <- o[i]
            grade <- grade + curved[j] * (weight[j] / total_weight)
            if (display)
                cat(sprintf("%-20s %s\n", name[j], rLETS[curved[j]]))
        }
    }
    grade <- as.integer(grade + 0.5)
    if (grade > 13)
        grade <- 13
    if (display)
        cat(sprintf("%-20s %s\n", "Class Grade", rLETS[grade]))
    grade
}

# precalculate grades for all tests in a class
gradeClass <- function(cls) {
    class_id <- mongo.bson.value(cls, "_id")
    cursor <- mongo.find(mongo, tests, list(class_id=class_id))
    while (mongo.cursor.next(cursor))
        gradeTest(mongo.cursor.value(cursor))
}


studentMenu <- function(student) {
    student_id <- mongo.bson.value(student, "_id")
    student_name <- mongo.bson.value(student, "name")
    repeat {
        cat(student_name, ": Student Menu\n", sep="")
        cat("L) List classes\n")
        cat("G) List Grades\n")
        cat("D) Delete this student\n")
        cat("Q) Quit to Students Menu\n")
        choice <- getch()
        if (choice == "Q")
            break
        else if (choice == "L") {
            cursor <- mongo.find(mongo, class_students, list(student_id=student_id))
            while (mongo.cursor.next(cursor)) {
                class_student <- mongo.cursor.value(cursor)
                class_id <- mongo.bson.value(class_student, "class_id")
                cls <- mongo.find.one(mongo, classes, bson_id(class_id))
                cat(mongo.bson.value(cls, "name"), "\n")
            }
        }
        else if (choice == "D") {
            cat("Delete this student?  Are you sure")
            if (YesNo("N")) {
                mongo.remove(mongo, students, bson_id(student_id))
                query <- mongo.bson.from.list(list(student_id=student_id))
                mongo.remove(mongo, class_students, query)
                mongo.remove(mongo, test_scores, query)
                break
            }
        }
        else if (choice == "G") {
            cat("Include test results")
            display <- YesNo("N")
            cursor <- mongo.find(mongo, class_students, list(student_id=student_id))
            name <- c()
            class_student <- list()
            i <- 1
            while (mongo.cursor.next(cursor)) {
                class_student[[i]] <- mongo.cursor.value(cursor)
                class_id <- mongo.bson.value(class_student[[i]], "class_id")
                cls <- mongo.find.one(mongo, classes, bson_id(class_id))
                name <- append(name, mongo.bson.value(cls, "name"))
                gradeClass(cls)
                i <- i + 1
            }
            count <- i - 1
            if (count > 0) {
                o <- order(name)
                total <- 0
                for (i in 1:count) {
                    j <- o[i]
                    if (display)
                        cat(name, "\n")
                    g <- gradeClassStudent(class_student[[j]], display)
                    if (!display)
                        cat(sprintf("%-20s %s", name[j], rLETS[g]))
                    cat("\n")
                    total <- total + rPOINTS[g]
                }
                g <- total / count
                cat(sprintf("\nGPA = %1.2f\n", g))
            }
        }
    }
}


studentsMenu <- function(parent) {
    repeat {
        cat("\nStudents Menu\n")
        cat("L) List students\n")
        cat("A) Add a student\n")
        cat("S) Select a student\n")
        cat("Q) Quit to", parent, "\n")
        choice <- getch()
        if (choice == "Q")
            break
        else if (choice == "L") {
            cursor <- mongo.find(mongo, students, sort=name_sort)
            while (mongo.cursor.next(cursor)) {
                student <- mongo.cursor.value(cursor)
                cat(mongo.bson.value(student, "name"), "\n")
            }
        } else if (choice == "A") {
            cat("Name? ")
            name <- readLines(n=1)
            if (name != "") {
                b <- mongo.bson.from.list(list(name=name))
                if (!is.null(mongo.find.one(mongo, students, b)))
                    cat("A student already exists with that name.\n")
                else {
                    mongo.insert(mongo, students, b)
                    cat(name, "added.\n")
                }
            }
        } else if (choice == "S") {
            student <- select("Student", students)
            if (!is.null(student))
                studentMenu(student)
        }
    }
}


testMenu <- function(test) {
    test_id <- mongo.bson.value(test, "_id")
    class_id <- mongo.bson.value(test, "class_id")
    test_name <- mongo.bson.value(test, "name")
    test_date <- as.character(mongo.bson.value(test, "date"))
    repeat {
        cat("\n", test_name, " (", test_date, "): Test Menu\n", sep="")
        cat("L) List scores\n")
        cat("E) Enter scores\n")
        cat("D) Delete this test\n")
        cat("Q) Quit to Class Menu\n")
        choice <- getch()
        if (choice == "Q")
            break
        else if (choice == "D") {
            cat("Delete this test?  Are you sure")
            if (YesNo("N")) {
                mongo.remove(mongo, tests, bson_id(test_id))
                mongo.remove(mongo, test_scores, list(test_id=test_id))
                break
            }
        }
        else if (choice == "L") {
            query <- mongo.bson.from.list(list(test_id=test_id))
            count <- mongo.count(mongo, test_scores, query)
            if (count > 0) {
                name <- rep("X", count)
                score <- rep(1.0, count)
                i <- 1
                cursor <- mongo.find(mongo, test_scores, query)
                while (mongo.cursor.next(cursor)) {
                    test_score <- mongo.cursor.value(cursor)
                    student_id <- mongo.bson.value(test_score, "student_id")
                    student <- mongo.find.one(mongo, students, bson_id(student_id))
                    name[i] <- mongo.bson.value(student, "name")
                    score[i] <- mongo.bson.value(test_score, "score")
                    i <- i + 1
                }
                if (count == 1)
                    cat(sprintf("%-20s %5.2f\n", name[1], score[1]))
                else {
                    g <- grade(score)
                    o <- order(name)
                    for (i in 1:count) {
                        j <- o[i]
                        cat(sprintf("%-20s %5.2f %s\n", name[j], score[j], rLETS[g[j]]))
                    }
                    cat("Mean = ", mean(score), ", Standard Deviation = ", sd(score), "\n", sep="")
                }
            }       
        }
        else if (choice == "E") {
            query <- mongo.bson.from.list(list(class_id=class_id))
            count <- mongo.count(mongo, class_students, query)
            if (count > 0) {
                id <- list()
                name <- rep("X", count)
                cursor <- mongo.find(mongo, class_students, query)
                i <- 1
                while (mongo.cursor.next(cursor)) {
                    class_student <- mongo.cursor.value(cursor)
                    id[[i]] <- mongo.bson.value(class_student, "student_id")
                    student <- mongo.find.one(mongo, students, bson_id(id[[i]]))
                    name[i] <- mongo.bson.value(student, "name")
                    i <- i + 1
                }
                o <- order(name)
                for (i in 1:count) {
                    j <- o[i]
                    query <- mongo.bson.from.list(list(test_id=test_id, student_id=id[[j]]))
                    score <- -1
                    test_score <- mongo.find.one(mongo, test_scores, query)
                    if (!is.null(test_score))
                        score <- mongo.bson.value(test_score, "score")
                    newscore <- score
                    repeat {
                        cat(name[j], ": (", score, ") ")
                        s <- readLines(n=1)
                        if (s == "")
                            break;
                        inscore <- as.double(s)
                        if (!is.na(inscore)) {
                            newscore <- inscore
                            break
                        }
                    }
                    if (newscore != score) {
                        if (newscore == -1)
                            mongo.remove(mongo, test_scores, query)
                        else
                            mongo.update(mongo, test_scores, query, 
                                list(test_id=test_id, student_id=id[[j]], score=newscore), 
                                mongo.update.upsert)
                    }
                }
            }
        }
    }
}


classMenu <- function(cls) {
    class_id <- mongo.bson.value(cls, "_id")
    class_name <- mongo.bson.value(cls, "name")
    parent <- paste(class_name, ": Class Menu", sep="")
    repeat {
        cat("\n", parent, "\n", sep="")
        cat("L) List students\n")
        cat("G) Report current Grades\n")
        cat("E) Enroll a student in this class\n")
        cat("R) Remove a student\n")
        cat("S) Students menu\n")
        cat("1) List tests\n")
        cat("2) Add a test\n")
        cat("3) Select a test\n")
        cat("Q) Quit to Classes Menu\n")
        choice <- getch()
        if (choice == "Q")
            break
        else if (choice == "L") {
            query <- mongo.bson.from.list(list(class_id=class_id))
            count <- mongo.count(mongo, class_students, query)
            if (count > 0) {
                cursor <- mongo.find(mongo, class_students, query)
                name <- rep("X", count)
                i <- 1
                while (mongo.cursor.next(cursor)) {
                    class_student <- mongo.cursor.value(cursor)
                    student_id <- mongo.bson.value(class_student, "student_id")
                    student <- mongo.find.one(mongo, students, bson_id(student_id))
                    name[i] <- mongo.bson.value(student, "name")
                    i <- i + 1
                }
                o <- order(name)
                for (i in 1:count)
                    cat(name[o[i]], "\n")
            }
        }
        else if (choice == "G") {
            cat("Include test results")
            display <- YesNo("N")          
            query <- mongo.bson.from.list(list(class_id=class_id))
            count <- mongo.count(mongo, class_students, query)
            if (count > 0) {
                gradeClass(cls)
                cursor <- mongo.find(mongo, class_students, query)
                name <- rep("X", count)
                i <- 1
                class_student <- list()
                while (mongo.cursor.next(cursor)) {
                    class_student[[i]] <- mongo.cursor.value(cursor)
                    student_id <- mongo.bson.value(class_student[[i]], "student_id")
                    student <- mongo.find.one(mongo, students, bson_id(student_id))
                    name[i] <- mongo.bson.value(student, "name")
                    i <- i + 1
                }
                o <- order(name)
                for (i in 1:count) {
                    j <- o[i]
                    if (display)
                        cat(name[j], "\n")
                    g <- gradeClassStudent(class_student[[j]], display)
                    if (!display)
                        cat(sprintf("%-20s %s", name[j], rLETS[g]))
                    cat("\n")
                }
            }
        }
        else if (choice == "E") {
            student <- select("Student name", students)
            if (!is.null(student)) {
                student_id <- mongo.bson.value(student, "_id")
                class_student <- mongo.bson.from.list(list(class_id=class_id, student_id=student_id))
                if (!is.null(mongo.find.one(mongo, class_students, class_student)))
                    cat("That student is already in this class")
                else {
                    mongo.insert(mongo, class_students, class_student)
                    cat(mongo.bson.value(student, "name"), "enrolled.")
                }
            }
        }
        else if (choice == "S")
            studentsMenu(parent)
        else if (choice == "1") {
            query <- mongo.bson.from.list(list(class_id=class_id))
            count <- mongo.count(mongo, tests, query)
            if (count > 0) {
                cursor <- mongo.find(mongo, tests, query)
                name <- rep("X", count)
                weight <- rep(1.0, count)
                date <- rep(1.0, count)
                i <- 1
                while (mongo.cursor.next(cursor)) {
                    test <- mongo.cursor.value(cursor)
                    name[i] <- mongo.bson.value(test, "name")
                    weight[i] <- mongo.bson.value(test, "weight")
                    date[i] <- mongo.bson.value(test, "date")
                    i <- i + 1
                }
                class(date) <- c("POSIXct", "POSIXt")
                o <- order(name)
                for (i in 1:count)
                    cat(sprintf("%-20s %5.1f %s\n", name[o[i]], weight[o[i]], as.character(date[o[i]])))
            }
        }
        else if (choice == "2") {
            cat("Name? ")
            name <- readLines(n=1)
            if (name != "") {
                test <- mongo.find.one(mongo, tests, list(name=name, class_id=class_id))
                if (!is.null(test))
                    cat("A test by that name already exists\n")
                else {
                    repeat {
                        cat("Weight (1.0)? ")
                        weight <- readLines(n=1)
                        if (weight == "")
                            weight <- 1.0
                        else {
                            weight <- as.double(weight)
                            if (is.na(weight))
                                next
                        }
                        break
                    }
                    date <- as.POSIXlt(Sys.time())
                    date$sec <- 0
                    date$min <- 0
                    date$hour <- 0
                    repeat {
                        cat("Date YYYY-MM-DD (", as.character(date), ") ?", sep="")
                        sdate <- readLines(n=1)
                        if (sdate != "") {
                            d <- strptime(sdate, "%Y-%m-%d")
                            if (is.na(d))
                                next
                            date <- d
                        }
                        break
                    }
                    mongo.insert(mongo, tests, list(class_id=class_id, name=name, weight=weight, date=date))
                }
            }
        }
        else if (choice == "3") {
            test <- select("Test", tests)
            if (!is.null(test))
                testMenu(test)
        }
    }
}


classesMenu <- function()
    repeat {
        cat("\nClasses Menu\n")
        cat("L) List classes\n")
        cat("A) Add a class\n")
        cat("S) Select a class\n")
        cat("Q) Quit to Main Menu\n")
        choice <- getch()
        if (choice == "Q")
            break
        else if (choice == "L") {
            cursor <- mongo.find(mongo, classes, sort=name_sort)
            while (mongo.cursor.next(cursor)) {
                cls <- mongo.cursor.value(cursor)
                cat(mongo.bson.value(cls, "name"), "\n")
            }
        } else if (choice == "A") {
            cat("Name? ")
            name <- readLines(n=1)
            if (name != "") {
                mongo.insert(mongo, classes, list(name=name))
                cat(name, "added.\n")
            }
        } else if (choice == "S") {
            cls <- select("Class", classes)
            if (!is.null(cls))
                classMenu(cls)
        }
    }

repeat {
    cat("\nMain Menu\n")
    cat("C) Classes Menu\n")
    cat("S) Students Menu\n")
    cat("Q) Quit\n")
    choice <- getch()
    if (choice == "Q") {
        cat("Exiting...\n")
        break
    }
    if (choice == "C")
        classesMenu()
    else if (choice == "S")
        studentsMenu("Main Menu")
    else
        cat("Invalid choice")
}
