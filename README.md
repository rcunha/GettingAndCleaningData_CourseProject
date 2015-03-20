#Getting And Cleaning Data 
##[Course Project][[https://class.coursera.org/getdata-012/human_grading/view/courses/973499/assessments/3/submissions]]
*Roger Cunha*  
*2015-03-20* 

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

###This project includes the following files: 

- `README.md`
 
- `run_analysis.R`: R script that does the following: 
 0. Downloads and unzips raw data files into directory `UCI HAR Dataset/`, if needed. 
 1. Merges the training and the test sets to create one data set. 
 2. Extracts only the measurements on the mean and standard deviation for each measurement.  
 3. Uses descriptive activity names to name the activities in the data set 
 4. Appropriately labels the data set with descriptive variable names.  
 5. From the data set in the previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

- `CodeBook.md`: describes the variables, the data, and transformations performed to clean up the data written to `tidy_data_set.txt`. 
 
- `tidy_data_set.txt`: tidy data set, created by script `run_analysis.R`. 
 
- `UCI HAR Dataset/`: directory containing the raw data. 
