Coursera - Getting and Cleaning Data Course Project
======================

Prerequisites
-------------
The script requires the `plyr` library.

Execution
--------------
Run `run_analysis.R`.  

Data Files
----------
The script will look for the downloaded zipfile in the
current working directory.  If the zipfile does not exist, it will attempt to
redownload the zip file.  If the expanded folder `UCI HAR Dataset` does not
already exist the script will then upzip the zipfile in the current working
directory.  The script will load the appropriate datafiles from the dataset
process the files. 

Output 
------
Script will output a "cleaned" file `clean_data.txt` in the
current working directory. The file is a whitespace delimited text file with
quoted headers.


Details
-------
Configurations for file paths are at the top of the script.  The necessary files
are read into memory and combined into a single data frame.  Only columns for
mean and standard deviation are kept from the original list of features.  This
is done automatically based on the column names in the feature file.  The
remaining columns are cleaned of invalid column title characters such as
parenthesis, commas and dashes.  *Note: Since the original feature names are not
valid column names in `R`, column names will differ slightly from the original
data.*  The activity codes are translated to their respective names.  The final
"clean" summary data file is grouped by volunteer and activity, showing the
average column value for each group.

