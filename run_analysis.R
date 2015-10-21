
# You should create one R script called run_analysis.R that does the following. 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Please upload the tidy data set created in step 5 of the instructions.
# Please upload your data set as a txt file created with write.table() using row.name=FALSE
# (do not cut and paste a dataset directly into the text box, as this may cause errors saving your submission).

library(dplyr)

# first read all the files
test1 <- read.table("UCI HAR Dataset/test/subject_test.txt")
test2 <- read.table("UCI HAR Dataset/test/X_test.txt")
test3 <- read.table("UCI HAR Dataset/test/y_test.txt")
train1 <- read.table("UCI HAR Dataset/train/subject_train.txt")
train2 <- read.table("UCI HAR Dataset/train/X_train.txt")
train3 <- read.table("UCI HAR Dataset/train/y_train.txt")


# select only measurements of mean and standard deviation
test2 <- select(test2, 1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 240:241, 253:254,
                 266:271, 345:350, 424:429, 503:504, 516:517, 529:530, 542:543)
train2 <- select(train2, 1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 240:241, 253:254,
                266:271, 345:350, 424:429, 503:504, 516:517, 529:530, 542:543)

# read features file (with columnnames)
namesaid <- read.table("UCI HAR Dataset/features.txt")
# select only columns of mean and standard deviation
namesaid2 <- namesaid[c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 240:241, 253:254,
                        266:271, 345:350, 424:429, 503:504, 516:517, 529:530, 542:543),]
labels <- as.character(namesaid2$V2)
# add labels
names(test2) <- c(labels)
names(train2) <- c(labels)
names(test1) <- c("personID")
names(train1) <- c("personID")
names(test3) <- c("activity")
names(train3) <- c("activity")

# combine them to one dataset
test <- cbind(test1, test3, test2)
train <- cbind(train1, train3, train2)
data <- rbind(test, train)

# make the personID and activity variable a factor and add levels
data$personID <- factor(data$personID, levels = c(1:30))
data$activity <- factor(data$activity, levels = c(1,2,3,4,5,6), 
                         labels = c("WALKING", "WALKING_UPSTAIRS","WALKING_DOWNSTAIRS", 
                                    "SITTING", "STANDING", "LAYING"))

# make the tidy dataset
library(reshape2)
datamelt <- melt(data, id = c("personID", "activity"))
tidydata <- dcast(datamelt, personID + activity ~ variable, mean)

write.table(tidydata, "tidydata.txt", row.names = FALSE, quote = FALSE)


