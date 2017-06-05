# Getting and leaning data
# Assingment
#Step-by-step procedure

library(reshape2) 
 
filename <- "getdata_dataset.zip" 
 
## Step 1: Download and unzip the dataset: 
if (!file.exists(filename)){ 
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip " 
  download.file(fileURL, filename, mode='wb') 
}   
if (!file.exists("UCI HAR Dataset")) {  
  unzip(filename)  
} 
 
# Step 2: Load activity labels and features 
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt") 
activityLabels[,2] <- as.character(activityLabels[,2]) 
features <- read.table("UCI HAR Dataset/features.txt") 
features[,2] <- as.character(features[,2]) 

# Step 3: Extract only the data on mean and standard deviation 
featuresWanted <- grep(".*mean.*|.*std.*", features[,2]) 
featuresWanted.names <- features[featuresWanted,2] 
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names) 
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names) 
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names) 

# Step 4: Load train dataset
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted] 
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt") 
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt") 
train <- cbind(trainSubjects, trainActivities, train) 

# Step 5: Load test dataset 
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted] 
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt") 
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt") 
test <- cbind(testSubjects, testActivities, test) 
  
# Step 6: merge datasets and add labels 
allData <- rbind(train, test) 
colnames(allData) <- c("subject", "activity", featuresWanted.names) 
 
# Step 7: turn activities & subjects into factors 
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2]) 
allData$subject <- as.factor(allData$subject) 

allData.melted <- melt(allData, id = c("subject", "activity")) 
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean) 
 
write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE) 

