# MetadataDating

MetadataDating is a tool that gives researchers insight into the time related metadata of their files. 

MetadataDating extracts the time related metadata of files and puts them into a tsv file. This allows users to use spreadsheets to display graphs of this data, giving insights into the dataset.

## Usage:

| WARNING: Always work with copies of your dataset if you wish to preserve the metadata. Running MetadataDating will overwrite the access time of folders in your dataset. This is neccecery because the folders will need to be accessed to get the metadata of the files inside them. |
| --- |

In a terminal type: `bash MetadataDating.sh datasetDir resultsDir subset(optional)`

**datasetDir**: The directory containing the dataset to be dated 

**resultsDir**: The directory that will store the results

**subset**: A optional argument. A file that holds a susbset that you wish to have seperate a results file for.  

## Output:

When the script is run it will create results.tsv in the given resultsDir. 
This is a tab separated file with 9 columns

**File**: The full path to the file.

**Access Time**: The last time the file was accessed in a human readable format.

**Modify Time**: The last time contents of the file was modified in a human readable format.

**Change Time**: The last time the metadata of the file was changed in a human readable format.

**Access Time(epoch)**: The last time the file was accessed in seconds since the epoch.

**Modify Time(epoch)**: The last time contents of the file was modified in seconds since the epoch.

**Change Time(epoch)**: The last time the metadata of the file was changed in seconds since the epoch.

**Birth Time**: The time when the file was created.

**Extension**: The extention of the file.

If a subset was given, then a second file called subsetResults.tsv will be created in the given resultsDir. The format of this file is identical to results.tsv.
