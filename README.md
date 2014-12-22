Getting & Cleaning Data - Project 2
=============================


Overview & Purpose
------------------
This script will tidy up data from the experimentation shown here:    
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 




Raw Data
---------
Raw data was obtained from the zipped file here:   
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip   


Data was then unpackaged and saved to the working directory
The data has been split to a training and test dataset
Each of the datasets (Training & Test) contains the following data  
- 'README.txt'  
- 'features_info.txt': Shows information about the variables used on the feature vector.  
- 'features.txt': List of all features.  
- 'activity_labels.txt': Links the class labels with their activity name.  
- 'train/X_train.txt': Training set.  
- 'train/y_train.txt': Training labels.  
- 'test/X_test.txt': Test set.  
- 'test/y_test.txt': Test labels.  


Processing Steps of Raw Data to Tidy Data
------------------------------
1. Read each file into variables using read.table without headers.

```{r}
X_test<-read.table("./test/X_test.txt",header=FALSE)
Y_test<-read.table("./test/Y_test.txt",header=FALSE)
subject_test<-read.table("./test/subject_test.txt",header=FALSE)
X_train<-read.table("./train/X_train.txt",header=FALSE)
Y_train<-read.table("./train/Y_train.txt",header=FALSE)
subject_train<-read.table("./train/subject_train.txt",header=FALSE)
```


2. Read variable names

```{r}
features<-read.table("./features.txt",header=FALSE,stringsAsFactors=FALSE)
```

3. Combine the data and apply measurement labels

```{r}
#combine training and test data sets
x_data<-rbind(X_test,X_train)
y_data<-rbind(Y_test,Y_train)
subject<-rbind(subject_test,subject_train)

#Apply names of variables from features to x data
names(x_data)<-features$V2

#Apply names to test number and subject column
names(y_data)<-"test_no"
names(subject)<-"subject"

#Append subject and test no columns to X measurements dataset
data<-cbind(y_data,x_data)
data<-cbind(subject,data)
```

4. Apply the activity labels

```{r}
#read activity labels data
activities<-read.table("./activity_labels.txt",header=FALSE,stringsAsFactors=FALSE)
names(activities)<-c("index","activity")
  
#merge with existing dataset
merged_data <- merge(activities,data, by.x= "index", by.y = "test_no", all=TRUE) 
```

4. Extracts only the variables using mean and standard deviation for each measurement. 

```{r}
#Utilized grep to find columns including the strings "mean" or "std". 
target_columns<- grep("mean|std",names(merged_data),value=FALSE)
data2<-merged_data[,c(2,3,target_columns)]
```

5. Melt the data and recast such that each variable has one row and each set of measurement (Activity & subject) has one row. 

```{r}
#Pivot the data using melt
melted_data <- melt(data2,id=c("subject","activity"))

#recasting the data to the wide form
mean_data <- cast(melted_data, subject + activity ~variable ,fun.aggregate=mean)
```



Code Book
---------
**Variable descriptions**


time domain , Body Accelerometer, Mean and Standard Deviations in the X,Y,Z directions   
tBodyAcc-mean()-X   
tBodyAcc-mean()-Y"    
tBodyAcc-mean()-Z"   
tBodyAcc-std()-X"   
tBodyAcc-std()-Y"   
tBodyAcc-std()-Z"   


time domain , Gravity Accelerometer , Mean and Standard Deviations in the X,Y,Z directions    
tGravityAcc-mean()-X"   
tGravityAcc-mean()-Y"   
tGravityAcc-mean()-Z"   
tGravityAcc-std()-X"   
tGravityAcc-std()-Y"   
tGravityAcc-std()-Z"   


time domain , Body Accelerometer filtered for jerk, Mean and Standard Deviations in the X,Y,Z directions   
tBodyAccJerk-mean()-X"   
tBodyAccJerk-mean()-Y"   
tBodyAccJerk-mean()-Z"   
tBodyAccJerk-std()-X"   
tBodyAccJerk-std()-Y"   
tBodyAccJerk-std()-Z"   


time domain , Body Gyrometer, Mean and Standard Deviations in the X,Y,Z directions    
tBodyGyro-mean()-X"   
tBodyGyro-mean()-Y"   
tBodyGyro-mean()-Z"   
tBodyGyro-std()-X"   
tBodyGyro-std()-Y"   
tBodyGyro-std()-Z"   


time domain , Body Gyrometer filtered for jerk, Mean and Standard Deviations in the X,Y,Z directions   
tBodyGyroJerk-mean()-X"   
tBodyGyroJerk-mean()-Y"   
tBodyGyroJerk-mean()-Z"   
tBodyGyroJerk-std()-X"   
tBodyGyroJerk-std()-Y"   
tBodyGyroJerk-std()-Z"   


time domain , Body Accelerometer filtered for magnitude, Mean and Standard Deviations    
tBodyAccMag-mean()"   
tBodyAccMag-std()"   


time domain , Gravity Accelerometer filtered for magnitude, Mean and Standard Deviations    
tGravityAccMag-mean()"   
tGravityAccMag-std()"   


time domain , Body Accelerometer filtered for Jerk and magnitude, Mean and Standard Deviations    
tBodyAccJerkMag-mean()"   
tBodyAccJerkMag-std()"   


time domain , Gravity Accelerometer filtered for Jerk and magnitude, Mean and Standard Deviations    
tBodyGyroMag-mean()"   
tBodyGyroMag-std()"   


time domain , Gravity Gyrometer filtered for Jerk and magnitude, Mean and Standard Deviations    
tBodyGyroJerkMag-mean()"   
tBodyGyroJerkMag-std()"   


Frequency domain , Body Accelerometer, Mean and Standard Deviations in X,Y, and Z directions    
fBodyAcc-mean()-X"   
fBodyAcc-mean()-Y" -    
fBodyAcc-mean()-Z"    
fBodyAcc-std()-X"    
fBodyAcc-std()-Y"    
fBodyAcc-std()-Z"    
fBodyAcc-meanFreq()-X"    
fBodyAcc-meanFreq()-Y"    
fBodyAcc-meanFreq()-Z"   


Frequency domain , Body Accelerometer filtered for jerk, Mean and Standard Deviations in X,Y, and Z directions    
fBodyAccJerk-mean()-X"    
fBodyAccJerk-mean()-Y"    
fBodyAccJerk-mean()-Z"    
fBodyAccJerk-std()-X"    
fBodyAccJerk-std()-Y"   
fBodyAccJerk-std()-Z"    
fBodyAccJerk-meanFreq()-X"    
fBodyAccJerk-meanFreq()-Y"    
fBodyAccJerk-meanFreq()-Z"    


Frequency domain , Body Gyrometer, Mean and Standard Deviations in X,Y, and Z directions   
fBodyGyro-mean()-X"    
fBodyGyro-mean()-Y"    
fBodyGyro-mean()-Z"    
fBodyGyro-std()-X"    
fBodyGyro-std()-Y"    
fBodyGyro-std()-Z"    
fBodyGyro-meanFreq()-X"    
fBodyGyro-meanFreq()-Y"    
fBodyGyro-meanFreq()-Z"    


Frequency domain , Body Accelerometer filtered for jerk and magnitude, Mean and Standard Deviations in X,Y, and Z directions   
fBodyAccMag-mean()"    
fBodyAccMag-std()"    
fBodyAccMag-meanFreq()"    
fBodyBodyAccJerkMag-mean()"    
fBodyBodyAccJerkMag-std()"    
fBodyBodyAccJerkMag-meanFreq()"    


Frequency domain , Body Gyrometer filtered for jerk and magnitude, Mean and Standard Deviations in X,Y, and Z directions   
fBodyBodyGyroMag-mean()"    
fBodyBodyGyroMag-std()"    
fBodyBodyGyroMag-meanFreq()"    
fBodyBodyGyroJerkMag-mean()"    
fBodyBodyGyroJerkMag-std()"    
fBodyBodyGyroJerkMag-meanFreq()"    



