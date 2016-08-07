library(dplyr)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

## Read files
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Step 1: Merge training and testing to one dataset
x_all <- rbind(x_train,x_test)
y_all <- rbind(y_train,y_test)
colnames(y_all)<-c("labels")
subject_all <- rbind(subject_train,subject_test)
colnames(subject_all)<-c("subject")

## Step 2: Extract only measurements that are mean and std
features<- read.table("UCI HAR Dataset/features.txt")
variable_names<-features[,2]
colnames(x_all)<-make.names(variable_names,unique=T)

x_filtered<-select(x_all,matches("mean|std"))
x_filtered<-select(x_filtered,-starts_with("angle"))

## Step 3: Use descriptive activity names
activity_lookup<- read.table("UCI HAR Dataset/activity_labels.txt")
activity<-left_join(y_all,activity_lookup,by = c("labels"="V1"))
activity<-activity[,2]

big<- cbind(subject_all,activity,x_filtered)

## Step 4: Appropriately labels data with descriptive variable names
names(big) <- gsub("\\.", "", names(big))
names(big) <- gsub("mean","Mean",names(big))
names(big) <- gsub("std","Std", names(big))
names(big) <- gsub("^t","Time_",names(big))
names(big) <- gsub("^f","Frequency_",names(big))
names(big) <- gsub("Acc","Acceleration",names(big))
names(big) <- gsub("Mag","Magnitude",names(big))

## Step 5: Creates file with average of each variable for each activity and subject
final <- big %>% group_by(subject,activity) %>% summarise_each(funs(mean))
write.table(final, "tidy.txt", row.names = FALSE, quote = FALSE)