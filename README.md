# Getting And Cleaning Data Course Project

## run_analytics.R
The file **run_analytics.R** will do the following:

1. Download and unzip file if not found
2. Merge the training and testing data sets into one
3. Select only columns that have to do with mean and standard deviation
4. Replaced labels with descriptive activity names
5. Appropriately relabels the data set with descriptive variable names
6. Takes the average for each variable based on activity and subject
7. Creates the file **tidy.txt** once it is done

## Code Book
The code book will contain variable names found in **tidy.txt** with information on how they are created and what do they mean and what are the values they have.

## tidy.txt
This file contains the output once **run_analytics.R** finishes.