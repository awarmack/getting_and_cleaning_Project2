##Assumptions
#1) You've downloaded and unzipped the data into a directory ././UCI HAR Dataset
#2) your working directory is set to "././UCI HAR Dataset"
#3) Na.values have value as missing information. NA's will be kept. 
#loaded packages
library(reshape)
library(data.table)

#read test data into variables
X_test<-read.table("./test/X_test.txt",header=FALSE)
Y_test<-read.table("./test/Y_test.txt",header=FALSE)
subject_test<-read.table("./test/subject_test.txt",header=FALSE)
X_train<-read.table("./train/X_train.txt",header=FALSE)
Y_train<-read.table("./train/Y_train.txt",header=FALSE)
subject_train<-read.table("./train/subject_train.txt",header=FALSE)

#read variable names
features<-read.table("./features.txt",header=FALSE,stringsAsFactors=FALSE)

#combine the data
x_data<-rbind(X_test,X_train)
y_data<-rbind(Y_test,Y_train)
subject<-rbind(subject_test,subject_train)
names(x_data)<-features$V2
names(y_data)<-"test_no"
names(subject)<-"subject"
data<-cbind(y_data,x_data)
data<-cbind(subject,data)

#Extracts only the measurements on the mean and standard deviation for each measurement.
  #read activity labels data
    activities<-read.table("./activity_labels.txt",header=FALSE,stringsAsFactors=FALSE)
    names(activities)<-c("index","activity")
  
  #merge with existing dataset
    merged_data <- merge(activities,data, by.x= "index", by.y = "test_no", all=TRUE) 


#Extract only the measurements on the mean and standard deviation
#Utilized grep to find columns including the strings "mean" or "std". 
target_columns<- grep("mean|std",names(merged_data),value=FALSE)
data2<-merged_data[,c(2,3,target_columns)]

#Pivot the data using melt
melted_data <- melt(data2,id=c("subject","activity"))

#recasting the data to the wide form
mean_data <- cast(melted_data, subject + activity ~variable ,fun.aggregate=mean)

write.table(mean_data,file="tidy_data.txt",row.names=FALSE)


