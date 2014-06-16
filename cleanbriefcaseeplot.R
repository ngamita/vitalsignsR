# VitalSigns clean up Scriptd
# Eplot - specifically fit for Eplot data format
# Simple script for scientists at vitalsigns.org

# Download all the Eplot surveys from Aggregate.
# Merge all files from ODK Briefcase.
# Merge them all to main .csv file 
# merge based on KEY and PARENT_KEY

# Author: 'ngamita@gmail.com' Richard Ngamita. 

# Ask user: File path. 
# mypath <- choose.dir()
# manually setwd() and work from CWD with files. 

filenames=list.files(path='./', pattern="*.csv")

# Select only files with "repeat" in filename. 
files_with_repeat <- filenames[grep("repeat",filenames, perl = TRUE)]

# Select all similar files, leave main file. 
# TODO: Richard Ngamita: Fix this with RegEx
# added_filenames <- filenames[2:length(filenames)]

# Loop through the .csv files and add them as list. 
data_list_hh = lapply(files_with_repeat, function(x) {read.csv(file=x, header=T, sep=',')})

# Get all list objects with 
# length equal to the first. # skip others #TODO: hardcoded fix. 
# length(datalist[[1]])
# datalist_clean <- list()


#for (i in 1:length(datalist)){
#  #print(length(datalist[[i]]))
#  if((length(datalist[[i]])) == 17){ #hardcoded 17. 
#    datalist_clean[[i]] <- datalist[[i]]
#  }
#  else{
#    datalist_clean[i] <- NULL
#  }
#}

# Remove all the null values from the List.
# datalist_clean <- datalist_clean[-(which(sapply(datalist_clean,is.null),arr.ind=TRUE))]

# Load gtools, rbind fix
# Column names not equal issue. 
require(gtools)
data_df_bind <- suppressWarnings(do.call(smartbind, data_list_hh)) #Supress warnings. 
#df <- do.call(rbind, datalist_clean) #throws an error.

# Rename columns for datadf with first columns. 
# TODO: 

# Load the first main dataframe.
# The main dataframe without repeats.

files_main <- filenames[grep("^((?!repeat).)*$",filenames, perl = TRUE)]

data_df_main <- read.csv(files_main, sep=',', header=TRUE)

# Merge the sets, avoid the warning of duplicate KEYS. 
# rename .x df KEY frame. index[500] hardcoded. TODO: Rixhard FIX

# names(data_df_main[500]) <- c('MAIN_KEY')
# Suppress warnings on KEY column repeat. 
merge_main_df <- suppressWarnings(merge(data_df_main, data_df_bind, by.x='KEY', by.y='PARENT_KEY', all.x=TRUE))

# Dump the files into a .csv file for analysis.
# TODO: Rename it accordingly to original file name.
# WOrks for **nix machines. 
write.csv(merge_main_df, file ="House_hold_surveys_clean.csv", row.names=FALSE)

