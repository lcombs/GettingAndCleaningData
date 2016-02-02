library(data.table)
library(reshape2)
library(magrittr)

setwd("/Users/lisacombs/Documents/DataScienceCoursera/GettingAndCleaning/")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "data.zip", 
              method = "curl")
date()

x_train <- 
        "./UCI HAR Dataset/train/X_train.txt" %>% 
        read.table()

y_train <- 
        "./UCI HAR Dataset/train/y_train.txt" %>% 
        read.table()

subject_train <- 
        "./UCI HAR Dataset/train/subject_train.txt" %>% 
        read.table()

x_test <- 
        "./UCI HAR Dataset/test/X_test.txt" %>% 
        read.table()

y_test <- 
        "./UCI HAR Dataset/test/y_test.txt" %>% 
        read.table()

subject_test <- 
        "./UCI HAR Dataset/test/subject_test.txt" %>% 
        read.table()

activity_labels <- 
        "./UCI HAR Dataset/activity_labels.txt" %>% 
        read.table()

activity_labels[, 2] <- 
        as.character(activity_labels[, 2])

features <- 
        "./UCI HAR Dataset/features.txt" %>% 
        read.table()

features[, 2] <- 
        as.character(features[, 2])

# Clean up labels.
features[, 2] <- 
        gsub('-mean', 'Mean', features[, 2])

features[, 2] <-
        gsub('-std', 'Std', features[, 2])

features[, 2] <- 
        gsub('[-()]', '', features[, 2])

# Merge the training and the test sets to create one data set.
x_merged <- 
        rbind(x_test, 
              x_train)

# Appropriately label the data set with descriptive variable names.
names(x_merged) <- 
        features[, 2]

y_merged <- 
        rbind(y_test, 
              y_train)

subject_merged <- 
        rbind(subject_test, 
              subject_train)

names(subject_merged) <- 
        "subject_id"

# Use descriptive activity names to name the activities in the data set.
activity <- 
        merge(y_merged, 
              activity_labels) %>% 
        as.data.frame()

activity <- 
        activity[, 2]

names(activity) <- 
        "activity"

# Extract only the measurements on the mean and standard deviation for each 
# measurement.
use <- 
        grep(".*Mean.*|.*Std.*", 
             features[, 2], 
             value = TRUE)
x <- 
        x_merged[, use] 

# From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

all_merged <- 
        cbind(subject_merged, x, activity)

write.table(all_merged, "all_merged.txt")

tidy_data <- 
        data.table(all_merged)

mean_sd_data <- 
        tidy_data[, lapply(.SD, mean), 
                 by = c("subject_id", "activity")]

write.table(mean_sd_data, 
            "mean_sd_data.txt", 
            row.name = FALSE)

