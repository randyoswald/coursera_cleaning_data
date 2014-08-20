run_analysis <- function() {
    library(plyr)
    
    ###########################################
    # Directory and file location constants
    ###########################################
    zipFile <- "data.zip"
    dataDir <- "UCI HAR Dataset/"   # Make sure to have the trailing slash!
    remoteFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    
    features_file <- "features.txt"
    activity_labels_file <- "activity_labels.txt"
    clean_data_file <- "clean_data.txt"
    
    x_train_file <- "train/X_train.txt"
    y_train_file <- "train/y_train.txt"
    subject_train_file <- "train/subject_train.txt"
    
    x_test_file <- "test/X_test.txt"
    y_test_file <- "test/y_test.txt"
    subject_test_file <- "test/subject_test.txt"
    ###########################################
    # End Constants
    ###########################################
    
    # Create full file paths
    features_path <-  paste(dataDir, features_file, sep="")
    activity_labels_path <- paste(dataDir, activity_labels_file, sep="")
    x_train_path <- paste(dataDir, x_train_file, sep="")
    y_train_path <- paste(dataDir, y_train_file, sep="")
    subject_train_path <- paste(dataDir, subject_train_file, sep="")
    x_test_path <- paste(dataDir, x_test_file, sep="")
    y_test_path <- paste(dataDir, y_test_file, sep="")
    subject_test_path <- paste(dataDir, subject_test_file, sep="")
    
    # Check if the files exist already - if not, go get them.
    if(!file.exists(zipFile)) {
        download.file(remoteFile, zipFile, method="curl")
    } else {
        # print("Already got it, nevermind!")
    }
    
    if(!file.exists(dataDir)) {
        unzip(zipFile, , exdir=".",junkpaths=FALSE, overwrite=FALSE) 
    } else {
        # print("Already Unzipped, too!")
    }
    
    # Read in the feature file
    features <- read.csv(features_path,header=FALSE, sep="", stringsAsFactors=FALSE)
    # set column names for convenience, readability
    colnames(features) <- c("featureID", "featureName")

    # Find the list of the colums we need by searching the list for mean and standard deviation features.
    necessaryColumns <- features[grep("mean\\(\\)|std\\(\\)",features$featureName),]
    
    # Remove the parenthesis
    necessaryColumns$featureName <- gsub("\\(\\)","",necessaryColumns$featureName)
    necessaryColumns$featureName <- gsub("-",".",necessaryColumns$featureName)
    necessaryColumns$featureName <- gsub(",",".",necessaryColumns$featureName)
    # str(necessaryColumns)  #debugging
    
    # Read in activity Labels
    activity_label_data <- read.csv(activity_labels_path,header=FALSE, sep="", stringsAsFactors=FALSE)
    
    
    # Read in the data files
    x_train <- read.csv(x_train_path,header=FALSE, sep="")
    y_train <- read.csv(y_train_path,header=FALSE,col.names="Activity", sep="")
    subject_train <- read.csv(subject_train_path,header=FALSE
                            ,col.names="Subject", sep="")
    x_test <- read.csv(x_test_path,header=FALSE, sep="")
    y_test <- read.csv(y_test_path,header=FALSE,col.names="Activity", sep="")
    subject_test <- read.csv(subject_test_path,header=FALSE
                            ,col.names="Subject", sep="")

    full_data <- rbind(x_train[ ,necessaryColumns$featureID]
                    , x_test[ ,necessaryColumns$featureID])
    full_subject <- rbind(subject_train, subject_test)
    full_y <- rbind(y_train, y_test)
    activity_labels <- activity_label_data$V2
    
    #create factor variables
    full_subject_factor <- factor(full_subject[[1]])
    full_y_factor <- factor(full_y[[1]],labels=activity_labels)
    
    #prepend subject, Y columns
    full_data <- cbind(full_subject_factor, full_y_factor, full_data)
    
    # unallocate old variables from memory
    remove(subject_train, y_train, x_train, subject_test, y_test, x_test);

    # Add in the names, skip the first two columns (subject and Y that wereprepended)
    names(full_data)[c(-1,-2)] <- necessaryColumns$featureName
    names(full_data)[c(1,2)] <- c("Subject","Activity")
    
    # Summarize Data 
    clean_data <- ddply(full_data, c("Subject","Activity"), numcolwise(mean))
    write.table(clean_data, clean_data_file, row.names=FALSE)   
}