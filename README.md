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


time domain , Body Accelerometer, Mean and Standard Deviations in the X,Y,Z directions<br>
tBodyAcc-mean()-X /br>
tBodyAcc-mean()-Y"</br> 
tBodyAcc-mean()-Z"</br>
tBodyAcc-std()-X"</br>
tBodyAcc-std()-Y"</br>
tBodyAcc-std()-Z"</br>


time domain , Gravity Accelerometer , Mean and Standard Deviations in the X,Y,Z directions<br>
tGravityAcc-mean()-X"</br>
tGravityAcc-mean()-Y"</br>
tGravityAcc-mean()-Z"</br>
tGravityAcc-std()-X"</br>
tGravityAcc-std()-Y"</br>
tGravityAcc-std()-Z"</br>


time domain , Body Accelerometer filtered for jerk, Mean and Standard Deviations in the X,Y,Z directions<br>
tBodyAccJerk-mean()-X"</br>
tBodyAccJerk-mean()-Y"</br>
tBodyAccJerk-mean()-Z"</br>
tBodyAccJerk-std()-X"</br>
tBodyAccJerk-std()-Y"</br>
tBodyAccJerk-std()-Z"</br>


time domain , Body Gyrometer, Mean and Standard Deviations in the X,Y,Z directions<br>
tBodyGyro-mean()-X"</br>
tBodyGyro-mean()-Y"</br>
tBodyGyro-mean()-Z"</br>
tBodyGyro-std()-X"</br>
tBodyGyro-std()-Y"</br>
tBodyGyro-std()-Z"</br>


time domain , Body Gyrometer filtered for jerk, Mean and Standard Deviations in the X,Y,Z directions<br>
tBodyGyroJerk-mean()-X"</br>
tBodyGyroJerk-mean()-Y"</br>
tBodyGyroJerk-mean()-Z"</br>
tBodyGyroJerk-std()-X"</br>
tBodyGyroJerk-std()-Y"</br>
tBodyGyroJerk-std()-Z"</br>


time domain , Body Accelerometer filtered for magnitude, Mean and Standard Deviations<br>
tBodyAccMag-mean()"</br>
tBodyAccMag-std()"</br>


time domain , Gravity Accelerometer filtered for magnitude, Mean and Standard Deviations<br>
tGravityAccMag-mean()"</br>
tGravityAccMag-std()"</br>


time domain , Body Accelerometer filtered for Jerk and magnitude, Mean and Standard Deviations<br>
tBodyAccJerkMag-mean()"</br>
tBodyAccJerkMag-std()"</br>


time domain , Gravity Accelerometer filtered for Jerk and magnitude, Mean and Standard Deviations<br>
tBodyGyroMag-mean()"</br>
tBodyGyroMag-std()"</br>


time domain , Gravity Gyrometer filtered for Jerk and magnitude, Mean and Standard Deviations<br>
tBodyGyroJerkMag-mean()"</br>
tBodyGyroJerkMag-std()"</br>


Frequency domain , Body Accelerometer, Mean and Standard Deviations in X,Y, and Z directions<br>
fBodyAcc-mean()-X"</br>
fBodyAcc-mean()-Y" - </br>
fBodyAcc-mean()-Z" </br>
fBodyAcc-std()-X" </br>
fBodyAcc-std()-Y" </br>
fBodyAcc-std()-Z" </br>
fBodyAcc-meanFreq()-X" </br>
fBodyAcc-meanFreq()-Y" </br>
fBodyAcc-meanFreq()-Z"</br>


Frequency domain , Body Accelerometer filtered for jerk, Mean and Standard Deviations in X,Y, and Z directions<br
fBodyAccJerk-mean()-X" </br>
fBodyAccJerk-mean()-Y" </br>
fBodyAccJerk-mean()-Z" </br>
fBodyAccJerk-std()-X" </br>
fBodyAccJerk-std()-Y"</br>
fBodyAccJerk-std()-Z" </br>
fBodyAccJerk-meanFreq()-X" </br>
fBodyAccJerk-meanFreq()-Y" </br>
fBodyAccJerk-meanFreq()-Z" </br>


Frequency domain , Body Gyrometer, Mean and Standard Deviations in X,Y, and Z directions<br
fBodyGyro-mean()-X" </br>
fBodyGyro-mean()-Y" </br>
fBodyGyro-mean()-Z" </br>
fBodyGyro-std()-X" </br>
fBodyGyro-std()-Y" </br>
fBodyGyro-std()-Z" </br>
fBodyGyro-meanFreq()-X" </br>
fBodyGyro-meanFreq()-Y" </br>
fBodyGyro-meanFreq()-Z" </br>


Frequency domain , Body Accelerometer filtered for jerk and magnitude, Mean and Standard Deviations in X,Y, and Z directions<br
fBodyAccMag-mean()" </br>
fBodyAccMag-std()" </br>
fBodyAccMag-meanFreq()" </br>
fBodyBodyAccJerkMag-mean()" </br>
fBodyBodyAccJerkMag-std()" </br>
fBodyBodyAccJerkMag-meanFreq()" </br>


Frequency domain , Body Gyrometer filtered for jerk and magnitude, Mean and Standard Deviations in X,Y, and Z directions<br
fBodyBodyGyroMag-mean()" </br>
fBodyBodyGyroMag-std()" </br>
fBodyBodyGyroMag-meanFreq()" </br>
fBodyBodyGyroJerkMag-mean()" </br>
fBodyBodyGyroJerkMag-std()" </br>
fBodyBodyGyroJerkMag-meanFreq()" </br>



