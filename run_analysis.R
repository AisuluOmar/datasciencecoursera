library(reshape2)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:

if (!file.exists(filename)){
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
unzip(filename) 
}

# Load activity labels + features
activityNames <- read.table("UCI HAR Dataset/activity_labels.txt")
activityNames[,2] <- as.character(activityNames[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
featuresNeeded <- grep(".*mean.*|.*std.*", features[,2])
featuresNeeded.names <- features[featuresWanted,2]
featuresNeeded.names = gsub('-mean', 'Mean', featuresNeeded.names)
featuresNeeded.names = gsub('-std', 'Std', featuresNeeded.names)
featuresNeeded.names <- gsub('[-()]', '', featuresNeeded.names)

# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainSkills <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSkills <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainSkills, train)
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresNeeded]
testSkills <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testSkills, test)

# merge datasets and add labels
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresNeeded.names)

# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityNames[,1], labels = activityNames[,2])
allData$subject <- as.factor(allData$subject)
allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
