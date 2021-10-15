---
title: "Untitled"
author: "Jonathan Talbot"
date: "10/14/2021"
output: html_document
---
 

#Tidying Activity Tracking Data

#This data tidying project begins with seven different data sources from a study of predictability of human activity based on mobile phone data. Three files are data on the training portion of the data and three files are data on the testing portion on the data. The seventh file is a list of variable names. This project first transforms them into a single, tidy data set. It then creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Data Processing 1 - Transform all raw data into a single, tidy data set

### Read in the data to 7 dataframes
 

subject_train <- read.delim("C:/Users/Jonathan/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

X_train <- read.delim("C:/Users/Jonathan/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt",sep = "")

y_train <- read.delim("C:/Users/Jonathan/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

subject_test <- read.delim("C:/Users/Jonathan/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

X_test<- read.delim("C:/Users/Jonathan/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", sep = "")
  
y_test <- read.delim("C:/Users/Jonathan/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

features <- read.delim("C:/Users/Jonathan/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
```

###Correct loss of variable name during loading of raw data
 

install.packages("berryFunctions")
library(berryFunctions)

features2 <-insertRows(features, 1, new = "1 tBodyAcc-mean()-X") 
 head(features2)
 

###Transpose features dataframe and make first row of 'data' into header
 

library(data.table)

t_features <- transpose(features2)

head(t_features)
 


 
names(t_features) <- t_features[1,]


head(t_features)
 
###Remove 'data' from first row of features dataframe
 
t_features[1,] <- 'NULL'

head(t_features)
 
###Use headers from features dataframe to create headers for other dataframe

 
#merge rows of t_features and X_train

names(X_train) <- names(t_features)

train_new <- rbind(t_features, X_train)

head(train_new)
 


###Add column to training data indicating each observation is an observation of training data
 
train_new$train <- 'train'

 

###Use headers from features dataframe to create headers for other dataframe
 
#merge rows of t_features and X_train

names(X_test) <- names(t_features)

test_new <- rbind(t_features, X_test)

head(test_new)
 

###Add column to testing data indicating each observation is an observation of testing data
 
test_new$test <- 'test'

 

###Remove null row from training data
 

train_new <- train_new[2:7352,]

rownames(train_new) <- 1:7351
head(train_new)           
 

###Remove null row from testing data
 
test_new <- test_new[2:2947,]

rownames(test_new) <- 1:2946
head(test_new)

 

###Check dimensions of dataframes
 

dim(subject_train) # 7351 x1 

#dim(X_train) # 7351 x 561

dim(y_train) # 7351 x 1

dim(train_new) # 7351 x 562

dim(subject_test) ##2946 x 1

#dim(X_test) #2946 x 1 ?

dim(y_test) #2946 x 1

dim(test_new) #2947 x 562

#dim(t_features) #1 x 560
 


###To help with later merge, add incremented 'id' column to each dataframe
 

#add ID column to all 6


train_new$trainID <-  1:7351 

#X_train$ID <-  1:7351 

y_train$ID <-  1:7351 

subject_train$subject_ID <- 1:7351

test_new$test_ID <-  1:2946 

#X_test$ID <-  1:2946 
  
y_test$ID <-  1:2946 

subject_test$subject_ID <- 1:2946



 

###Merge dataframes from 6 to 2
 

train_all <- merge(train_new, y_train, by.x="trainID", by.y="ID")

train_all$tid <- 1:7351

head(train_all)
 
train_all <- merge(train_all, subject_train, by.x="tid", by.y="subject_ID")

head(train_all)

tail(train_all)
 

 
test_all <- merge(test_new, y_test, by.x="test_ID", by.y="ID")

test_all$tid <- 1:2946

head(test_all)

test_all <- merge(test_all, subject_test, by.x="tid", by.y="subject_ID")

head(test_all)

 




###To help with later merge, add needed columns to each of 2 merged dataframes
 

dim(test_all) #ID, test_ID, 1:561, test, testID, X5, X2

#remove column 565
test_all <- test_all[,-565]

#add train column
test_all$train <- 'NA'

#add X1 column
test_all$X1<-'NA'

#add X5 column
test_all$X5<-'NA'

#add train_ID
test_all$trainID<-'NA'

#head(test_all) #568 columns 

test_all <- test_all[,-1]
head(test_all) #test_ID, 1:561, test, X2, train, X1, X5, trainID
```

 
library(dplyr)

#add X2 column to train_all
train_all$X2 <- 'NA'
#add test column to train_all
train_all$test <-'NA'
#add X2 column to train_all
train_all$X2<-'NA'
train_all$test_ID <- 'NA'
#head(train_all) #567 columns

train_all <- train_all[,-1] 


head(train_all) # trainID, 1:561, train, X5, X1, X2, test, test_id

setdiff(names(train_all), names(test_all))

 

###Merge 2 dataframes to 1
 
 
 compendium <- rbind(train_all, test_all)
  head(compendium)
 
 
dim(compendium)

 

### Change to meaningful names as needed
 
library(dplyr)

names(compendium)[names(compendium) == "X5"] <- "y_train_activity"

#X5 is y_train activity code


#X2 is y_test activity code
names(compendium)[names(compendium) == "X2"] <- "y_test_activity"
#X1 is subject id

names(compendium)[names(compendium) == "X1"] <- "subject_id"

 

 #################################################
 


##Data Processing 2 - Keep only mean or standard deviation data, based on column names
 
compendium_limited <- compendium[,c(2:7,42:47,82:87,122:127,162:167,202,203,215,216,228,241,242,254,255,267:272,295:297,346:351, 374:376, 425:430, 453:455,504,505,514, 517, 518, 527, 530,531, 543,544,553,556:562, 563:568)]
 
head(compendium_limited)

dim(compendium_limited)

 
## Data Processing 3 -  Create a second, independent tidy data set with the average of each variable for each subject and activity

 
#convert cols to numeric
library(dplyr)
compendium_limited <- compendium_limited %>% 
  mutate_at(c(1:84), as.numeric)
 
#group by subject and activity
#note that this project left training activity and test activity distinct

df2 <- compendium_limited %>%
  group_by(subject_id, y_train_activity, y_test_activity) %>%
  summarise_at(vars(1:84), list(name = mean))

df2
 
###Write dataframes to files
 

write.csv(compendium, file="C:/Users/Jonathan/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/df1.csv")

write.csv(df2, file="C:/Users/Jonathan/Downloads/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/df2.csv")

 
