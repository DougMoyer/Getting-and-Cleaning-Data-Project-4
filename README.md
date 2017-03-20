###run_analysis.R
performs the following actions: 
1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard 
  deviation for each measurement. 
3.Uses descriptive activity names to name the activities in the
  data set
4.Appropriately labels the data set with descriptive variable 
  names. 
5.From the data set in step 4, creates a second, independent tidy
  data set with the average of each variable for each activity      
  and each subject.

To run this, ensure your working directory is set to the location 
of this file and the data folders are in the current directory.

###Inputs
The following files are used by this script:
./UCI HAR Dataset/activity_labels.txt
./UCI HAR Dataset/features.txt
./UCI HAR Dataset/test/x_test.txt
./UCI HAR Dataset/train/x_train.txt
./UCI HAR Dataset/test/subject_test.txt
./UCI HAR Dataset/train/subject_train.txt
./UCI HAR Dataset/test/y_test.txt
./UCI HAR Dataset/train/y_train.txt

###Outputs
The following file is created:
./Week4_Project_Results.txt

###Results
The output file contains the mean of each variable grouped by
Subject and Action.
