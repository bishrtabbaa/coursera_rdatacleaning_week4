# 0. download data
download_hardata <- function() {
  
  print('Downloading...')
  
  # create data folder
  if (!dir.exists("./data")) {
    dir.create("data")
  }
  
  # download data
  if (!file.exists("data/ucihardata.zip")) {
    download.file( url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip', destfile = 'data/ucihardata.zip')
  }
  
  # extract data
  unzip( 'data/ucihardata.zip', overwrite=TRUE, exdir="data")
}

# 1. merge test and training data frames
merge_hardata <- function() {
  print('Merging...')
  
  test_data <- read.table('data/UCI HAR Dataset/test/X_test.txt',header=FALSE)
  test_activities <- read.table('data/UCI HAR Dataset/test/y_test.txt',header=FALSE)
  test_subjects <- read.table('data/UCI HAR Dataset/test/subject_test.txt',header=FALSE)
  
  train_data <- read.table('data/UCI HAR Dataset/train/X_train.txt',header=FALSE)
  train_activities <- read.table('data/UCI HAR Dataset/train/y_train.txt',header=FALSE)
  train_subjects <- read.table('data/UCI HAR Dataset/train/subject_train.txt', header=FALSE)
  
  data <- rbind(test_data, train_data, all=TRUE)
  activities <- rbind(test_activities, train_activities, all=TRUE)
  subjects <- rbind(test_subjects, train_subjects, all=TRUE)
  
  features <- features_hardata()
  filter_data <- extract_hardata(features,data)
  
  alldata <- cbind(subjects, activities, filter_data)
  
  return(alldata)
}

# 2. identify mean and std features
features_hardata <- function() {
  features <- read.table('data/UCI HAR Dataset/features.txt', header=FALSE, col.names=c('id','name'), stringsAsFactors = FALSE)
  mean_std_features <- features[ grep('mean|std', features$name),]
  # cleanup descriptor column
  mean_std_features$desc <- unlist(lapply(X = mean_std_features$name, FUN = function(s) gsub(pattern="()",replacement="",x=s, fixed=TRUE)))
  return (mean_std_features)
}

# 2. extract mean and std features from HAR data
extract_hardata <- function(features, data) {
  print('Extracting...')
  return (data[features$id])
}

# 3 . get descriptive activity names
activities_hardata <- function() {
  activities <- read.table('data/UCI HAR Dataset/activity_labels.txt')
  return (activities)
}

# 4. rename variable columns using activity names from feature
rename_hardata <- function(features, activities, data) {
  print('Renaming...')
  data[,2] <- activities[data[,2],2]
  colnames(data) <- c('subject','activity',features$desc)
  return (data)
}

# 5. calculate independent tidy data set with average of each variable for each activity and each subject
calc_mean_hardata <- function(data) {
  print('Calculating...')
  
  data_melted <- melt(data, id=c('subject','activity'))
  data_mean <- dcast(data_melted, subject+activity ~ variable, mean)
  return (data_mean)
}

# 0. run ALL ETL functions in correct sequence

run_analysis_main <- function() {
  print('Executing main()...')
  
  library(reshape2)
  
  download_hardata()
  hardata <- merge_hardata()
  features <- features_hardata()
  activities <- activities_hardata()
  hardata <- rename_hardata( features, activities, hardata )
  mean_hardata <- calc_mean_hardata( hardata)
  return (mean_hardata)
}

