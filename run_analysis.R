library(dplyr)
library(readr)
library(tidyr)
library(data.table)

#to download data:
# library(data.table)
# fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
# if (!file.exists('./UCI HAR Dataset.zip')){
#   download.file(fileurl,'./UCI HAR Dataset.zip', mode = 'wb')
#   unzip("UCI HAR Dataset.zip", exdir = getwd())
# }

#setwd("./2. Getting and Cleaning Data/Course Project")

#Data downloaded previously manually

#READ and CONVERT Data
    features<-read_delim("./UCI HAR Dataset/features.txt", delim=" ", col_names = c("n","features")) #col names for raw data
    act_labels<-read_table("./UCI HAR Dataset/activity_labels.txt",col_names = c("code","activity"))
    
    datatrain_x <- read_table("./UCI HAR Dataset/train/X_train.txt",col_names = features$features) #training set (raw), adds meaningful names
    datatrain_y <-read_table("./UCI HAR Dataset/train/y_train.txt",col_names = "code") # training labels correspond to activity labels
    datatrain_subject <- read_table("./UCI HAR Dataset/train/subject_train.txt",col_names = "subject") #subject codes (for test subject)

    datatest_x <- read_table("./UCI HAR Dataset/test/X_test.txt",col_names = features$features) #test set (raw), adds meaningful names
    datatest_y <-read_table("./UCI HAR Dataset/test/y_test.txt",col_names = "code") # test labels correspond to activity labels
    datatest_subject <- read_table("./UCI HAR Dataset/test/subject_test.txt",col_names = "subject") #subject codes (for test subject)
    
#MERGE ALL DATA
    x<-rbind(datatrain_x, datatest_x) #merges raw data
    y<-rbind(datatrain_y, datatest_y) #merges activity values for raw data
    subject <- rbind(datatrain_subject, datatest_subject) #merges subject codes for the raw data
    merged <- cbind(subject, y, x) #merges all datasets, with train data before test
    
#2. Select only mean and standard deviation data from dataset 
    tidydata<-merged%>%select(subject,code,contains("mean"),contains("std")) 
    
#3. Use descriptive activity names to name activities in dataset
    as.character(tidydata$code)
    actgroup<-factor(tidydata$code)
    #levels(actgroup)<-act_labels[,2] #for some reason does not work????
    levels(actgroup)<-c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
    tidydata$code<-actgroup
    
#4. Labels dataset with "descriptive" variable names

    tidydata<-rename(tidydata,activity=code)
    #names(tidydata)[2]<-"activity"

  #gsub used to replace all matches
    
    names(tidydata)<-gsub("[()]","",names(tidydata)) #removes parenthases-needs square brackets
    names(tidydata)<-gsub("^t","Time",names(tidydata)) #replaces t with time
    names(tidydata)<-gsub("^f","Frequency",names(tidydata)) #replace f with frequency
    names(tidydata)<-gsub("BodyBody","Body",names(tidydata)) #removes repeat of body
    names(tidydata)<-gsub("std","STD",names(tidydata)) #emphasizes Standard deviation
    names(tidydata)<-gsub("mean","MEAN",names(tidydata)) #emphasizes mean
    names(tidydata)<-gsub("tBody","TimeBody",names(tidydata)) #more meaning

#5. Create an average dataset for each activity and each subset
    #tidydata$activity<-as.factor(tidydata$activity)
    summary<-tidydata%>%group_by(activity,subject)%>%summarise_all(mean)
    
    write.table(summary, "SummaryData.txt", row.name=FALSE)

