
#Synopsis: 
The data for this project was obtained from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#. The data was tidied, filtered to use only means and standard deviations in the input data, and then further collapsed by finding mean values of variables for all combinations of activity and subjects.

##File Descriptions

###df1: 
merged and tidied version of 7 upper-level input data files:

getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt

getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt

getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt

getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt

getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt
  
getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt

getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt


###df2:
Variables with means and standard deviations were extracted from df1, and then averages for these features were calculated by combinations of subject id and activity code.

###CodeBook.md:
describes the variables in df1 and df2

###run_analysis_R:
the script which starts with the 7raw files mentioned above, and outputs df1 and df2
