# Code Book


The generated <code>run_analysis.R</code> aims to prepare data from the 
UCI Human Activity Recognition Dataset. This Code Book will provide you
with the variables that I used to keep track of the data storage as well as
how I tidied the data into the final table that is created in Final_Tidy_Data.txt

##### An additional note, the library dplyr was initialized.

### 1. First, I downloaded the dataset and extracted it.
Folder unzipped as UCI HAR Dataset, <code>setwd()</code> was used to simplify
later code BUT it means that you should only run this once, or it will infinitely
create UCI HAR Datasets.

### 2. Then, I extracted tables and assigned them to variables.
<code> testx </code> comes from X_test.txt, contains test data from recorded features.
<code> testy </code> comes from Y_test.txt, has activity numbers but needs to be labeled.
<code> testsub </code> comes from subject_test.txt, has test subset of volunteers.
<code> trainx </code> comes from X_train.txt, contains training data from recorded features.
<code> trainy </code> comes from Y_train.txt, contains training activity numbers.
<code> trainsub </code> comes from subject_train.txt, has majority subset subject data.
<code> feats </code> comes from features.txt, labels the features that we are working with.
<code> activities </code> comes from activity_labels.txt, plain English labels to assign to the Y data, which was accomplished using the <code>replace()</code> function prior to merging the data.

### 3. Merging the train data and test data.
<code> Xdat </code> merges <code> trainx </code> and <code> testx </code> with <code>rbind()</code>.
<code> Ydat </code> merges <code> trainy </code> and <code> testy </code> with <code>rbind()</code>
<code> sub </code> merges <code>trainsub</code> and <code>testsub</code> to create subject data.
<code> datmerge </code> uses the <code>dplyr::mutate()</code> function to concatenate columns in order.

### 4. Extracts only the measurements on the mean and standard deviation for each measurements.
<code> MeasureDat </code> takes the mean and stddev measures using the <code>dplyr::select()</code> to subset <code>datmerge</code> columns <code>subject</code>, <code>code</code>, and only the columns otherwise that have mean or standard deviation (std) for the measurements provided.

### 5. Uses descriptive activity names to name activities in data set.
This was done earlier, see line 24 with <code>replace()</code>.

### 6. Appropriately labels data set with descriptive variable names.
<code>code</code> column eventually renamed to Activities to reflect the English naming structure provided by <code>activity_labels.txt</code>.

> Acc -> Accelerometer

> mean() -> Mean

> std() -> Standard Deviation

> ^f -> Frequency

> ^t -> Time

> activityno -> Activities

### 7. From the data set in step 4, create a second, independent tidy data set with mean of each var for each activity/subject.
<code>Final_Tidy_Data.txt</code> is a table generated from the <code>FinDat</code> variable that takes the mean of each variable for each activity and subject from using <code>dplyr::summarize_all</code> on <code>MeasureDat</code> and is grouped by subject and activity using the <code>dplyr::group_by</code> function.
