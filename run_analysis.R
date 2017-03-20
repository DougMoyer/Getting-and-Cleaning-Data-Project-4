# run_analysis.R
# accomplishes the following: 
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard 
#   deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the
#   data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.From the data set in step 4, creates a second, independent tidy
#   data set with the average of each variable for each activity and
#   each subject.

# To run this, ensure your working directory is set to the location of
# this file and the data folders are in the current directory.
#
# The following files are used by this script:
# ./UCI HAR Dataset/activity_labels.txt
# ./UCI HAR Dataset/features.txt
# ./UCI HAR Dataset/test/x_test.txt
# ./UCI HAR Dataset/train/x_train.txt
# ./UCI HAR Dataset/test/subject_test.txt
# ./UCI HAR Dataset/train/subject_train.txt
# ./UCI HAR Dataset/test/y_test.txt
# ./UCI HAR Dataset/train/y_train.txt
#
# The following file is created:
# ./Week4_Project_Results.txt
#
# The output file contains the mean of each variable grouped by
# Subject and Action.
#

# read the activities file
activities <- read.csv("./UCI HAR Dataset/activity_labels.txt", sep="",
				col.names = c("Value", "Factor"),
				header = FALSE, stringsAsFactors = FALSE)

# read the variables file
names <- read.table("./UCI HAR Dataset/features.txt", sep=" ",
				col.names = c("Index", "Name"),
				stringsAsFactors = FALSE)

# create a list of the indexes and column names
# that we are interested in keeping in our dataset
cols <- names[grepl("mean|std", names$Name),1]
colNames <- names[grepl("mean|std", names$Name),2]

# load the test motion data
test <- read.csv("./UCI HAR Dataset/test/x_test.txt", sep="",
				col.names = names$Name,  colClasses = "numeric",
				header = FALSE, stringsAsFactors = FALSE)
# keep just the columns we need and drop the rest
test <- test[cols]

# load the train motion data
train <- read.csv("./UCI HAR Dataset/train/x_train.txt", sep="",
				col.names = names$Name,  colClasses = "numeric",
				header = FALSE, stringsAsFactors = FALSE)
# keep just the columns we need and drop the rest
train <- train [cols]

# merge the test and train motion data
total <- rbind(test,train)

# load the test and train subject files
subjTest <- read.csv("./UCI HAR Dataset/test/subject_test.txt", sep="",
				colClasses = "integer",
				header = FALSE, stringsAsFactors = FALSE)
subjTrain <- read.csv("./UCI HAR Dataset/train/subject_train.txt", sep="",
				colClasses = "integer",
				header = FALSE, stringsAsFactors = FALSE)

# merge the test and train subject data and give it a descriptive name
subjTotal <- rbind(subjTest, subjTrain)
colnames(subjTotal) <- c("Subject")

# read the test and train action files
actTest <- read.csv("./UCI HAR Dataset/test/y_test.txt", sep="",
				colClasses = "integer",
				header = FALSE)
actTrain <- read.csv("./UCI HAR Dataset/train/y_train.txt", sep="",
				colClasses = "integer",
				header = FALSE)

# merge the test and train action data and give it a descriptive name
actTotal <- rbind(actTest, actTrain)
colnames(actTotal) <- c("Action")

# convert the actions to a factor so it is more readable
actTotal$Action <- factor(actTotal$Action, labels= activities$Factor)

# make the column names more readable
colNames <- gsub("tBodyAcc", "Time_Body_Acceleration",colNames)
colNames <- gsub("\\-mean\\(\\)\\-", "_Mean_",colNames)
colNames <- gsub("\\-std\\(\\)\\-", "_Standard_Deviation_",colNames)
colNames <- gsub("tGravityAcc", "Time_Gravity_Acceleration",colNames)
colNames <- gsub("Jerk", "_Jerk",colNames)
colNames <- gsub("tBodyGyro", "Time_Body_Gyroscope",colNames)
colNames <- gsub("\\-mean\\(\\)", "_Mean",colNames)
colNames <- gsub("\\-std\\(\\)", "_Standard_Deviation",colNames)
colNames <- gsub("Mag", "_Magnitude",colNames)
colNames <- gsub("fBodyAcc", "FFT_Body_Acceleration",colNames)
colNames <- gsub("fBodyGyro", "FFT_Body_Gyroscope",colNames)
colNames <- gsub("fBodyBodyAcc", "FFT_Body_Body_Acceleration",colNames)
colNames <- gsub("fBodyBodyGyro", "FFT_Body_Body_Gyroscope",colNames)
colNames <- gsub("\\-meanFreq\\(\\)\\-", "_Mean_Frequency_",colNames)
colNames <- gsub("\\-meanFreq\\(\\)", "_Mean_Frequency",colNames)

# change the names in the data file
colnames(total) <- colNames

# bind the 3 data tables together
ds <- cbind(subjTotal, actTotal, total)

# calculate the mean for each of the variables
# grouped by Subject and Action
res <- ds %>% group_by(Subject, Action) %>%
	summarize_each(funs(mean))

#write the results to a file
write.table(res, file = "./Week4_Project_Results.txt", row.name=FALSE)
