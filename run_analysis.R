##Clear working area
rm(list=ls())

##Reads a table with activity labels
##Sets activity labels to character class

actlabels <- read.table("activity_labels.txt")
actlabels[,2] <- as.character(actlabels[,2])

##Reads a table with Features
##Sets features to character class

feats <- read.table("features.txt")
feats[,2] <- as.character(feats[,2])

##Narrow to mean and standard deviation

narrowfeats <- grep(".*mean.*|.*std.*", feats[,2])
narrowfeats.names <- feats[narrowfeats,2]
narrowfeats.names = gsub('-mean', 'Mean', narrowfeats.names)
narrowfeats.names = gsub('-std', 'Std', narrowfeats.names)
narrowfeats.names <- gsub('[-()]', '', narrowfeats.names)

##Bring in the training data, the features, activities and participants

train <- read.table("train/X_train.txt")[narrowfeats]
trainacts <- read.table("train/Y_train.txt")
trainparts <- read.table("train/subject_train.txt")

##Merge training data together
train <- cbind(trainparts, trainacts, train)

##Bring in the test data, the features, activities and participants

test <- read.table("test/X_test.txt")[narrowfeats]
testacts <- read.table("test/Y_test.txt")
testparts <- read.table("test/subject_test.txt")

##Merge test data together

test <- cbind(testparts, testacts, test)

##Merge training and test data together

alldata <- rbind(train, test)

##Make lables descriptive variable names

colnames(alldata) <- c("subject", "activity", narrowfeats.names)

##Need factors from activity labels

alldata$activity <- factor(alldata$activity, 
                                levels = actlabels[,1], 
                                labels = actlabels[,2])

alldata$subject <- as.factor(alldata$subject)

##Make this combined data into a data frame
##Must download and install r package reshape2

library(reshape2)
alldata.melt <- melt(alldata, id = c("subject", "activity"))

##Create independent dataset with appropriate measures

alldata.mean <- dcast(alldata.melt, 
                          subject + activity ~ variable, mean)

##creates a txt file with the 'tidy' dataset

write.table(alldata.mean, file = "tidydataset.txt", 
            row.names = FALSE, quote = FALSE)

##creates a csv file with the tidy data

write.csv(alldata.mean, file = "tidydata.csv", row.names= FALSE)
