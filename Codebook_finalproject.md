---
title: "Final Project Codebook"
author: "ME"
date: "December 9, 2019"
output: html_document
---

This codebook outlines the details of the "Getting and Cleaning data" course final project. The codebook outlines the project in the same sequence as per the project outline.

####1. Download the dataset
  - Download the dataset from the following URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
  - Save to workign folder (intentionally left out of codebook for assignment)
  
####2. Assign the data (in table and txt format) to variables
  - features<-features.txt: 561 rows, 2 columns  
    - Features (or variable names) from accelerometer and gyroscope data  
  - act_labels<-activity_labels.txt: 6 rows, 2 columns  
    - Activity labels linking class label code to activity names (1=walking, 4=sitting etc.)
  - datatrain_x<-x_train.txt: 7352 rows, 561 columns  
    - Contains features train raw data
  - datatrain_y<-y_train.txt: 7352 rows, 1 column  
    - Corresponding activity code (see act_labels) corresponding to feature observations  
  - datatest_x<-x_test.txt: 2947 rows, 561 columns  
    - Contains features test raw data
  - datatest_y<-y_test.txt: 2947 rows, 1 column  
    - Corresponding activity code (see act_labels) corresponding to feature observations  
  - datatrain_subject<-subject_train.txt: 7352 rows, 1 column  
    - specifies subject who performed actvity (range 1-30)  
  - datatest_subject<-subject_test.txt: 2947 rows, 1 column  
    - specifies subject who performed actvity (range 1-30)  
    
####3. Merge the training and test dataset
  - x is created using "rbind()" to merge x_train and x_test obs.  
  - y is created using "rbind()" to merge y_train and y_test obs.  
  - subject is created by using "rbind()" to merge datatrain_subject and datatest_subject obs.  
  - merged is created using "cbind()" to bind variables of x, y, ans subject to one large dataset  
  
####4. Extract only mean and std deviation
  - dataset "tidydata" selecting subject, code and mean and std deviation data  
    - 'contains' feature in dplyr select allows for easy selection of variable names with "mean" or "std"  
  
####5. Uses descriptive activity names in the dataset
  - "activity" variable is converted to a factor from a number using 'act_labels' table above; levels correspond to activity name  
  
####6. Label the dataset with descriptive variable names
  - Variables are renames with more descriptive names using 'gsub' function; brackets removed
  
####7. Create a second independant tidy dataset with average of each variable for each activity and each subject
  - used group by to group by subject and activity; summarise all is then used to summarize the data into the 'summary' dataset  
  - this dataset is then saves to SummaryData.txt in working file
