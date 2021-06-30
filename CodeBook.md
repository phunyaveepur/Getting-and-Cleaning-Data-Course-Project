
# CodeBook for run_analysis.R

**run_analysis.R** consists on R commands to produce tidy data regarding instructions from Getting and Cleaning Data Course Project 

Steps to achieve tidy data as followings:  

**1. Download and examine source files**  

- Download source files 
- Extract them in a sub folder of the project directory called `UCI HAR Dataset`  
- Examine source files to identify files relating to this assignment  
  
**2. Prepare data frames containing required source data to produce tidy data**  

- Assign file paths of related source files to variables which consist of `feature.txt`, `activity_labels.txt`, `subject_test.txt`, `X_test.txt`, `Y_text.txt`, `subject_train.txt`, `X_train.txt`, `Y_train.txt`  
- Read each file into variables using *read.table* function. Also define column names for each table
  - Store `features.txt` with two columns; `id` and `features` into `feature`  
  - Store `activity_labels.txt` with two columns; `activityID` and activity into `activity`  
  - Store `subject_test.txt` with a single column; `subject` into `test_subject`  
  - Store `X_test.txt` with 561 columns which column names can be retrieved from `feature$features` into `test_x`  
  - Store `Y_test.txt` with a single column; `activityID` into `test_y`  
  - Store `subject_train.txt` with a single column; `subject` into `train_subject`  
  - Store `X_train.txt` with 561 columns which column names can be retrieved from `feature$features` into `train_x`   
  - Store `Y_train.txt` with a single column; `activityID` into `train_y`  
- Using Library *dplyr*  
- Define columns with Mean and Standard Deviation to be selected using *grep* function with *regular expression* `grepl("[Mm]ean|[Ss]td")` as `sel_features`  
- Left join description of activity to `test_y` and `train_y` using *left_join* function  
  
**3. Merge all files to create tidy data**  

- Merge columns using *cbind* function  
  - `test_data` consists of `test_subject`, `activity` and `test_x` with selected columns only using `sel_features`  
  - `train_data` consists of `train_subject`, `activity` and `train_x` with selected columns only using `sel_features`  
- Combine `test_data` and `train_data` using *rbind* function and store it in `tidy_data`  
- Remove `activityID` column since activity column already contains activity description   
  
**4. Verify if data is complete **   

- Check dimension of test_data, train_data and tidy_data using *dim* function  
  - `test_data` consists of 2947 observations with 89 variables  
  - `train_data` consists of 7352 observations with 89 variables  
  - `tidy_data` consists of 10299 observations with 88 variables (removed activityID column)  
- Verify if merging is complete that `nrow(tidy_data) equals to nrow(test_data)+nrow(train_data)` (10299 records)  
  
**5. Rename tidy_data column names with descriptive column names using gsub function and regular expression**  

- Automatic column names replacement from R; replace *multiple dots '.'* with *a single underscore '_'*  
- Remove *an underscore at the end of the line*  
- Replace *'t' at the beginning of the line* with *'Time'*  
- Replace *'f' at the beginning of the line* with *'Frequency'*  
- Replace *'Acc'* with *'Accelerometer'*  
- Replace *'Gyro'* with *'Gyroscope'*  
- Replace *'Mag'* with *'Magnitude'*  
- Replace *'BodyBody'* with *'Body'*  
- Replace *'tBody'* with *'TimeBody'*  
- Replace *'Freq'* with *'Frequency'*  
- Replace *'mean'* with *'Mean'*  
- Replace *'std','Std'* with *'STD'*   

**6. Calculate average of all variables into `Average_All` for each subject and activity using *group_by* function and *summarise_all*  **  
   Average_All contains 180 rows with 88 columns  
  
**7. Write data into text file `Average_All.txt` using *write.table* function  **  
