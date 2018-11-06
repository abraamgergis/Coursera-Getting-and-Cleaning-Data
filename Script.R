
##Load needed library
library(dplyr)



##load datasets
#Testing tables:
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

#Training tables:
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")

features <- read.table("./features.txt")
activity_labels <- read.table("./activity_labels.txt")



##Prep the data:
colnames(x_train) <- features[,2]
colnames(x_test) <- features[,2]
colnames(y_train) <- "activityId"
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(subject_train) <- "subjectId"



##Merge training and testing dataset:
test <- cbind(y_test, subject_test, x_test)
train <- cbind(y_train, subject_train, x_train)
data <- rbind(train, test)



##Extract only measurements on the mean and standard deviation for each measurement:
requiredFeatures <- features[grep('-(mean|std)\\(\\)', features[, 2 ]), 2]
clean_data <- data[, c(1,2,3, requiredFeatures)]



##Use descriptive activity names for data:
colnames(activity_labels) <- c("activityId", "V2")
desc_data <- merge(clean_data, activity_labels, by = "activityId")



##Create a different tidy dataset with the average of each variable for each activity and subject:
tidy_data <- summarise_at(group_by(desc_data, activityId, subjectId), 3:69, mean, na.rm = TRUE)



##Create a tidy dataset:
write.table(tidy_data, "FinalData.txt", row.names = FALSE)
