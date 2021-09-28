#testy <- replace(testy, testy == 5, 'Standing')
#testy <- replace(testy, testy == 6, 'Laying')
#testy <- replace(testy, testy == 4, 'Sitting')
#testy <- replace(testy, testy == 3, 'Walking_Downstairs')
#testy <- replace(testy, testy == 2, 'Walking_Upstairs')
#testy <- replace(testy, testy == 1, 'Walking')
#run_analysis.R
#Merges training and test sets to create 1 data set
#Extracts only measurements on mean and standard deviation for each measurement
#Uses descriptive activity names to name activities in the data set
#Appropriately labels data set with descriptive variable names
#From data set, creates second tidy data set with avg of each variable for each activity/subject
library(dplyr)
filename <- 'UCI_HAR_Dataset.zip'
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if(!file.exists(filename)) {
        download.file(fileURL, destfile = filename, method = 'curl')
} else { print('dataset already downloaded.') }
if(!file.exists('UCI HAR Dataset')) {
        unzip(filename)
}
setwd('./UCI HAR Dataset/')
# getting df from dataset and assigning to variables
#testdata
testx <- read.table("./test/X_test.txt")
testy <- read.table("./test/y_test.txt", col.names = "activityno")
testsub <- read.table("./test/subject_test.txt", col.names = "subject")
#traindata
trainx <- read.table("./train/X_train.txt")
trainy <- read.table("./train/y_train.txt", col.names = "activityno")
trainsub <- read.table("./train/subject_train.txt", col.names = "subject")
#misc data
feats <- read.table("./features.txt", col.names = c("featno","functions"))
activities <- read.table("./activity_labels.txt", col.names = c("activityno", "activity"))
names(testx) <- feats$functions
names(trainx) <- feats$functions
#naming activities before binding
testy <- replace(testy, testy == 5, 'Standing')
testy <- replace(testy, testy == 6, 'Laying')
testy <- replace(testy, testy == 4, 'Sitting')
testy <- replace(testy, testy == 3, 'Walking_Downstairs')
testy <- replace(testy, testy == 2, 'Walking_Upstairs')
testy <- replace(testy, testy == 1, 'Walking')
trainy <- replace(trainy, trainy == 5, 'Standing')
trainy <- replace(trainy, trainy == 6, 'Laying')
trainy <- replace(trainy, trainy == 4, 'Sitting')
trainy <- replace(trainy, trainy == 3, 'Walking_Downstairs')
trainy <- replace(trainy, trainy == 2, 'Walking_Upstairs')
trainy <- replace(trainy, trainy == 1, 'Walking')
#begin rbinding X data and Y data, combining data from test and train due to split
Xdat <- rbind(testx, trainx); Ydat <- rbind(testy, trainy); sub <- rbind(trainsub, testsub)
datmerge <- mutate(sub, Ydat, Xdat)
#progressing to extracting mean and stddev measurements
MeasureDat <- select(datmerge, subject, activityno, contains('mean'), contains('std'))
featcolnames <- names(MeasureDat)
featcolnames <- gsub('mean', 'Mean', featcolnames, ignore.case = TRUE)
featcolnames <- gsub('std', 'StandardDev', featcolnames, ignore.case = TRUE)
featcolnames <- gsub('[()]', '', featcolnames)
featcolnames <- gsub('Acc', 'Acceleration', featcolnames)
featcolnames <- gsub('^t', 'Time', featcolnames)
featcolnames <- gsub('^f', 'Free', featcolnames)
featcolnames <- gsub('activityno', 'Activity', featcolnames)
names(MeasureDat) <- featcolnames
FinDat <- MeasureDat %>% group_by(subject, Activity) %>% summarize_all(list(mean))
write.table(FinDat, 'Final_Tidy_Data.txt', row.names = FALSE)
