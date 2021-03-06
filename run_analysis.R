# The purpose of this project is to demonstrate the ability to collect, work with, and 
# clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

library(dplyr)
library(tidyr)
library(stringr)

# Set working directory. Download and unzip files if needed.
folderDataset <- "./UCI HAR Dataset"
if (!file.exists(folderDataset)){
  zipFile <- "dataset.zip"
  if (!file.exists(zipFile)){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, zipFile, method="curl")
  }
  unzip("dataset.zip")
}
setwd(folderDataset)

# Merge the training and the test sets to create one data set.
dx_train<- read.table("train/X_train.txt")
dx_test <- read.table("test/X_test.txt")
dx <- rbind(dx_train, dx_test) # list of all measurements
dy_train<- read.table("train/y_train.txt", col.names=c("activity_id"))
dy_test <- read.table("test/y_test.txt", col.names=c("activity_id"))
dy <- rbind(dy_train, dy_test) # list of all measurements' activities ids
s_train <- read.table("train/subject_train.txt", col.names=c("subject"))
s_test <- read.table("test/subject_test.txt", col.names=c("subject"))
s <- rbind(s_train, s_test) # list of all measurements' subjects 

# Extract only the measurements on the mean and standard deviation for each measurement. 
cols <- read.table("features.txt",col.names=c("cnum","cname"),stringsAsFactors=FALSE)
cols <- filter(cols, str_detect(cname, fixed("mean()")) | str_detect(cname, fixed("std()")))
dx <- select(dx, cols[,"cnum"]) 

# Appropriately label the data set with descriptive variable names. 
colnames(dx) <- cols[,"cname"]

# Use descriptive activity names to name the activities in the data set
act_names <- read.table("activity_labels.txt", col.names=c("activity_id", "activity"))
dy <- dy %>% join(act_names, "activity_id") %>% select(-activity_id)
df <- cbind(s,dy,dx)  

# Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject.
tidydf <- df %>% 
          gather(feature, value, -c(subject,activity)) %>% 
          group_by(subject, activity, feature) %>%
          summarise(average=mean(value))
setwd("..")
write.table(tidydf, "tidy_data_set.txt", row.name=FALSE)

