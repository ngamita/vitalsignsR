# VitalSigns clean up Script
# Simple script for scientists at vitalsigns.org

# Merge all files from ODK Briefcase.
# Merge them all to main .csv file 
# merge based on KEY and PARENT_KEY

# Author: 'ngamita@gmail.com' Richard Ngamita. 

# Ask user: File path. 
# Or let user put script in cwd. 

filenames=list.files(path='.', pattern="*.csv", full.names=TRUE)

# Select all similar files, leave main file. 
# TODO: Richard Ngamita: Fix this with RegEx
added_filenames <- filenames[2:length(filenames)]

# Loop through the .csv files and add them as list. 
datalist = lapply(added_filenames, function(x) {read.csv(file=x,header=F, sep=',', skip=1)})

# Get all list objects with 
# length equal to the first. # skip others #TODO: hardcoded fix. 
#length(datalist[[1]])
datalist_clean <- list()
for (i in 1:length(datalist)){
  #print(length(datalist[[i]]))
  if((length(datalist[[i]])) == 17){ #hardcoded 17. 
    datalist_clean[[i]] <- datalist[[i]]
  }
  else{
    datalist_clean[i] <- NULL
  }
}

# Remove all the null values from the List.
datalist_clean <- datalist_clean[-(which(sapply(datalist_clean,is.null),arr.ind=TRUE))]

# Load gtools, rbind fix
# Column names not equal issue. 
require(gtools)
datadf <- suppressWarnings(do.call(smartbind, datalist)) #Supress warnings. 
#df <- do.call(rbind, datalist_clean) #throws an error.

# Rename columns for datadf with first columns. 
# TODO: 

# Load the first main dataframe. 
datadf_main <- read.csv(filenames[1], sep=',', header=TRUE)
mergedf <- merge(datadf_main, datadf, by.x='KEY', by.y='V15', all.x=TRUE)

# Dump the files into a .csv file for analysis.
# TODO: Rename it accordingly to original file name.
# WOrks for **nix machines. (Linux and Mac), not Windows tested.
write.csv(mergedf, file ="clean_csv.csv",row.names=FALSE)


