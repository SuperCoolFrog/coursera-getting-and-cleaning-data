# Data Dictionary - Coursera Getting and Cleaning Data

##  Helper Functions
---

### ```join_labels_x_y```
_line 9_
- __Description__: Collects the gathered information and performs a join with the labels and x, y data.
- __Parameters__:
    - ```features_labels``` - x labels as data table from the _data/features.txt_ file
        - Columns:
            1.  ```id: number```
            2.  ```label: char```
    - ```y_labels``` - y labels as data table from the _data/activity_labels.txt_ file
        - Columns:
            1.  ```id: number```
            2.  ```label: char```
    - ```x_data``` - x data as data table from the _data/train/X-train.txt_ file and the _data/test/X-test.txt_ file
        - Columns are matched according to ```features_labels```
    - ```y_data``` - y data as data table from the _data/train/y-train.txt_ file and the _data/test/y-test.txt_ file
        - Columns are matched according to ```y_labels```
- __Processing__
    -  _line 11_:  Make unique labels for features by concatenating id (_col 1_) and label (_col 2).  This is necessary because each feature should have a unique label, but the data does not in this case.
    -  _line 12_: Add column names to ```x_data```
    - _line 15_: bind ```y_data``` and ```x_data``` and convert to ```tibble``` to be able to left join later.  Assign to ```xy_data```
    - _line 20_: use ```dplyr``` function ```left_join``` to join the ```xy_data``` and ```y_labels``` based on the id column from ```y_labels``` and the ```y``` column from ```xy_data```
        - This is the value that is returned from the function

---
## Gather Data
---

### ```activity_labels```
_line 30_

Read the file _./data/activity_labels.txt_ as a data table which contains the mapping values for the different ```y``` data
- Columns
    - ```y: number```
    - ```label: char```

### ```features_f```
_line 36_

Read the file _./data/features.txt_ as a data table which contains the values for the ```x``` data labels
- Columns: 561 labels

### ```x_train_clean```
_line 42_

Read the file _./data/train/X_train.txt_ as a data table which contains the values for the ```x``` data
- Columns: Mapped to ```features_f```

### ```y_train_clean```
_line 48_

Read the file _./data/train/y_train.txt_ as a data table which contains the values for the ```y``` data
- Columns:
    - ```y: number``` which matches ```activity_labels```

### ```tidy_train_data```
_line 54_

Assigned from the call of the helper function ```join_labels_x_y``` which then returns a ```tibble``` of the data combined


### ```x_test_clean```
_line 60_

Read the file _./data/test/X_test.txt_ as a data table which contains the values for the ```x``` data
- Columns: Mapped to ```features_f```

### ```y_test_clean```
_line 67_

Read the file _./data/test/y_test.txt_ as a data table which contains the values for the ```y``` data
- Columns:
    - ```y: number``` which matches ```activity_labels```

### ```tidy_test_data```
_line 72_

Assigned from the call of the helper function ```join_labels_x_y``` which then returns a ```tibble``` of the data combined


---
## Getting the final result
---

### ```tidy_train_data_mean_std```
_line 81_

Select only the _standard deviation_ (label: _std_) and _mean_ (label: _mean_).  It was necessary to exclude _meanFreq_ since it would have matched the _mean_ label but was not part of the requirement.

A ```label``` column is added with the value ```training``` to distinguish this data from the ```test``` data after combining the datasets.

### ```tidy_test_data_mean_std```
_line 85_

Select only the _standard deviation_ (label: _std_) and _mean_ (label: _mean_).  It was necessary to exclude _meanFreq_ since it would have matched the _mean_ label but was not part of the requirement.

A ```label``` column is added with the value ```test``` to distinguish this data from the ```training``` data after combining the datasets.


### ```all_data```
_line 89_

Combines the _training_ data and _test_ data


### ```tidy_data``` 
_line 95_

Groups by the ```type``` and ```label``` columns and then calculates the mean