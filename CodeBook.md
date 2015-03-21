# Code Book for data set `tidy_data_set.txt`  

## Variables

* `subject`: identifier of the subject who carried out the experiment, ranging from 1 to 30. 
* `activity`: descriptive name of the measured activity performed by the subject. Possible values are (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
* `feature`: name of the measured feature. Only the mean() and std() features were filtered for this data set. 
* `average`: numeric average of each feature for each activity and each subject.


## Data

This data set contains the average of each variable from the meain data set matching mean() and std() for each activity and each subject.

## Transformations

```r
# Merge the training and the test sets to create one data set
dx_train<- read.table("train/X_train.txt")
dx_test <- read.table("test/X_test.txt")
dx <- rbind(dx_train, dx_test) # list of all measurements
dy_train<- read.table("train/y_train.txt", col.names=c("activity_id"))
dy_test <- read.table("test/y_test.txt", col.names=c("activity_id"))
dy <- rbind(dy_train, dy_test) # list of all measurements' activities ids
s_train <- read.table("train/subject_train.txt", col.names=c("subject"))
s_test <- read.table("test/subject_test.txt", col.names=c("subject"))
s <- rbind(s_train, s_test) # list of all measurements' subjects 
```

```r
# Extract only the measurements on the mean and standard deviation for each measurement. 
cols <- read.table("features.txt",col.names=c("cnum","cname"),stringsAsFactors=FALSE)
cols <- filter(cols, str_detect(cname, fixed("mean()")) | str_detect(cname, fixed("std()")))
dx <- select(dx, cols[,"cnum"]) 
```

```r
# Appropriately label the data set with descriptive variable names. 
colnames(dx) <- cols[,"cname"]
```

```r
# Use descriptive activity names to name the activities in the data set
act_names <- read.table("activity_labels.txt", col.names=c("activity_id", "activity"))
dy <- dy %>% join(act_names, "activity_id") %>% select(-activity_id)
df <- cbind(s,dy,dx)  
```

```r
# Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject.
tidydf <- df %>% 
          gather(feature, value, -c(subject,activity)) %>% 
          group_by(subject, activity, feature) %>%
          summarise(average=mean(value))
setwd("..")
write.table(tidydf, "tidy_data_set.txt", row.name=FALSE)
```
