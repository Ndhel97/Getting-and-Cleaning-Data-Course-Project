#Add Library
library(reshape2)
#------------------------------------------------

#Extract dataset
rawDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
  download.file(url = rawDataUrl)
} else {
  unzip(zipfile = "getdata_projectfiles_UCI HAR Dataset.zip")
}
#------------------------------------------------

#Merge the train and test dataset
#train data
x_train <- read.table(paste(sep = "", "./UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(paste(sep = "", "./UCI HAR Dataset/train/Y_train.txt"))
s_train <- read.table(paste(sep = "", "./UCI HAR Dataset/train/subject_train.txt"))

# test data
x_test <- read.table(paste(sep = "", "./UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(paste(sep = "", "./UCI HAR Dataset/test/Y_test.txt"))
s_test <- read.table(paste(sep = "", "./UCI HAR Dataset/test/subject_test.txt"))

# merge {train, test} data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)
#------------------------------------------------

#Read features info and activity labels
#Features info
features <- read.table(paste(sep = "", "./UCI HAR Dataset/features.txt"))

#Activity labels
a_label <- read.table(paste(sep = "", "./UCI HAR Dataset/activity_labels.txt"))
a_label[,2] <- as.character(a_label[,2])
#------------------------------------------------

#Extract features cols & names named 'mean, std'
selectedCols <- grep("-(mean|std).*", as.character(features[,2]))
selectedColNames <- features[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)
#------------------------------------------------

#Extract data by cols & using descriptive name
x_data <- x_data[selectedCols]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
allData$Subject <- as.factor(allData$Subject)
#------------------------------------------------

#Generate tidy dataset
meltedData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy.txt", row.names = FALSE, quote = FALSE)

