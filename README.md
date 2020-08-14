# README.md

## author: Bishr Tabbaa
## description: run_analysis.R contains several functions and scripts to fulfill the Week4 Assignment requirements:

* download_hardata  downloads data from web site and unzips to local data folder
* merge_hardata     reads training and testing CSV files and merges into one data set
* features_hardata  constructs subset of mean and stdev feature labels
* extract_hardata   extracts subset of data based on mean and stdev column indices
* rename_hardata    renames columns to use descriptive labels
* calc_mean_hardata calculates mean of all columns
* run_analysis_main executes all the function in the proper sequence