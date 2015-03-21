# Code Book for data set `tidy_data_set.txt`  

## Variables

* `subject`: identifier of the subject who carried out the experiment, ranging from 1 to 30. 
* `activity`: descriptive name of the measured activity performed by the subject. Possible values are (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
* `feature`: name of the measured feature. Only the mean() and std() features were filtered for this data set. 
* `average`: numeric average of each feature for each activity and each subject.


## Data

This data set contains the average of each variable from the meain data set (only features for mean() and std()) for each activity and each subject.

## Transformations

### Merge the training and the test sets to create one data set
The original data is split into train and test forders. This part of the code concatenates the measurements, activity id, and subject lists from train and test folders. 
dx, dy, and s end up with the total list of, respectively, measurements, activity id, and subject identifier
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

### Extract only the measurements on the mean and standard deviation for each measurement. 
File features.txt contains feature number (matching the column sequence from X_train.txt and X_test.txt) and name. So we use it to filter columns matching the exact strings "mean()" or "std()" for mean and standard deviation for each measurement.
```r
# Extract only the measurements on the mean and standard deviation for each measurement. 
cols <- read.table("features.txt",col.names=c("cnum","cname"),stringsAsFactors=FALSE)
cols <- filter(cols, str_detect(cname, fixed("mean()")) | str_detect(cname, fixed("std()")))
dx <- select(dx, cols[,"cnum"]) 
```

### Appropriately label the data set with descriptive variable names. 
Using the same structure used to select the columns to keep (cols), now we assign descriptive column names to dx.
```r
# Appropriately label the data set with descriptive variable names. 
colnames(dx) <- cols[,"cname"]
```

### Use descriptive activity names to name the activities in the data set
activity_labels.txt is a "lookup table" for activities. So it's used on a join with the list of all measurements' activities ids (dy). The select removes the column containing the activity_id for convenience for the cbind on the following step.
Finally, the list of subjects, measurements' descriptive names, and measurements is put together with cbind(s, dy, dx).
```r
# Use descriptive activity names to name the activities in the data set
act_names <- read.table("activity_labels.txt", col.names=c("activity_id", "activity"))
dy <- dy %>% join(act_names, "activity_id") %>% select(-activity_id)
df <- cbind(s,dy,dx)  
```

### Create a second, independent tidy data set with the average of each variable for each activity and each subject.
First, the data set is molten by subject and activity, making all column names into values for new column "feature", and its measurement into the new column value. Then the molten data is grouped by subject, activity, and feature, and column "average" is assigned the mean of value. Finally, the data is written to file "tidy_data_set.txt".
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

