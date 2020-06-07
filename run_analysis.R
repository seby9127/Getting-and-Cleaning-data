file1=file.path("./UCI HAR Dataset")
files = list.files(file1, recursive=TRUE)
files

xtrain = read.table(file.path(file1, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(file1, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(file1, "train", "subject_train.txt"),header = FALSE)
#Reading the testing tables
xtest = read.table(file.path(file1, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(file1, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(file1, "test", "subject_test.txt"),header = FALSE)
#Read the features data
features = read.table(file.path(file1, "features.txt"),header = FALSE)
#Read activity labels data
activityLabels = read.table(file.path(file1, "activity_labels.txt"),header = FALSE)


colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"
#Create Sanity and column values to the test data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
#Create sanity check for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')

mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)
#Create the main data table merging both table tables - this is the outcome of 1
setAllInOne = rbind(mrg_train, mrg_test)


colNames = colnames(setAllInOne)
#Need to get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#A subtset has to be created to get the required dataset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

write.table(secTidySet, "TidySet.txt", row.name=FALSE)
