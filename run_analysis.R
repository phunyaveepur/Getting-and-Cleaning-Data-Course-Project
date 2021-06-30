library(dplyr)

#Download and unzip file
filename <- "UCI HAR Dataset.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename, method="curl")
unzip(filename) 

#Define source file locations
src_feature <-  "UCI HAR Dataset/features.txt"
src_activity <- "UCI HAR Dataset/activity_labels.txt"
src_test_subject <-  "UCI HAR Dataset/test/subject_test.txt"
src_test_X <-  "UCI HAR Dataset/test/X_test.txt"
src_test_Y <-  "UCI HAR Dataset/test/Y_test.txt"
src_train_subject <-  "UCI HAR Dataset/train/subject_train.txt"
src_train_X <-  "UCI HAR Dataset/train/X_train.txt"
src_train_Y <-  "UCI HAR Dataset/train/Y_train.txt"

#Read files into Data Frame with column names defined
feature <- read.table(src_feature, col.names = c("id","features"))
activity <- read.table(src_activity, col.names = c("activityID","activity"))

test_subject <- read.table(src_test_subject, col.names = c("subject"))
test_x <- read.table(src_test_X, col.names = feature$features)
test_y <- read.table(src_test_Y, col.names = c("activityID"))

train_subject <- read.table(src_train_subject, col.names = c("subject"))
train_x <- read.table(src_train_X, col.names = feature$features)
train_y <- read.table(src_train_Y, col.names = c("activityID"))

#Select column ID for columns which contain MEAN or STD
sel_features <- feature[grepl("[Mm]ean|[Ss]td",feature$features),1] 

#Merge activity description column
activity_test <- left_join(test_y, activity, by.x = "activityID", by.y = "activityID")
activity_train <- left_join(train_y, activity, by.x = "activityID", by.y = "activityID")

#Merge all for each set and then combine them altogether
#Select only columns which present MEAN or STD from full_data using sel_features
test_data <- cbind(test_subject, activity_test, test_x[, sel_features])
train_data <- cbind(train_subject, activity_train,train_x[, sel_features])
tidy_data <- rbind(test_data, train_data)
tidy_data <- select(tidy_data, !activityID)

#Check if tidy_data is complete
dim(test_data)
dim(train_data)
dim(tidy_data)
nrow(tidy_data) == nrow(test_data)+nrow(train_data) #should provide result as TRUE

#Revise column names 
names(tidy_data) <- names(tidy_data) %>% 
        lapply(function(x) {x <- gsub("\\.+", "_", x)}) %>% 
        lapply(function(x) {x <- gsub("_$", "", x)}) %>% 
        lapply(function(x) {x <- gsub("^t", "Time", x)}) %>% 
        lapply(function(x) {x <- gsub("^f", "Frequency", x)}) %>% 
        lapply(function(x) {x <- gsub("Acc", "Accelerometer", x)}) %>% 
        lapply(function(x) {x <- gsub("Gyro", "Gyroscope", x)}) %>% 
        lapply(function(x) {x <- gsub("Mag", "Magnitude", x)}) %>% 
        lapply(function(x) {x <- gsub("BodyBody", "Body", x)}) %>% 
        lapply(function(x) {x <- gsub("tBody", "TimeBody", x)}) %>% 
        lapply(function(x) {x <- gsub("Freq", "Frequency", x)}) %>% 
        lapply(function(x) {x <- gsub("mean", "Mean", x)}) %>% 
        lapply(function(x) {x <- gsub("[Ss][Tt][Dd]", "STD", x)}) 

#Average each variable for each activity and each subject
Average_All <- tidy_data %>% 
        group_by(subject, activity) %>% 
        summarise_all(funs(mean))
write.table(Average_All, "Average_All.txt", row.name=FALSE) 
