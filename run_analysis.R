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
  test_hardata <- read.table('data/UCI HAR Dataset/test/X_test.txt',header=FALSE)
  train_hardata <- read.table('data/UCI HAR Dataset/train/X_train.txt', header=FALSE)
  hardata <- rbind(test_hardata, train_hardata, all=TRUE)
  
  return(hardata)
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

# 4. rename variable columns using activity names from feature
rename_hardata <- function(features, data) {
  print('Renaming...')
  colnames(data) <- features$desc
  return (data)
}

# 5. calculate independent tidy data set with average of each variable for each activity and each subject
calc_mean_hardata <- function(data) {
  print('Calculating...')
  
  return (colMeans(data))
}

# 0. run ALL ETL functions in correct sequence

run_analysis_main <- function() {
  print('Executing main()...')
  
  download_hardata()
  hardata <- merge_hardata()
  features <- features_hardata()
  ext_hardata <- extract_hardata(features, hardata)
  ext_hardata <- rename_hardata( features, ext_hardata )
  mean_hardata <- calc_mean_hardata( ext_hardata)
  return (mean_hardata)
}

