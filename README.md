# augment_imbalanced_data
This R code helps to load, clean, and augment the highly imbalanced NIH drug discovery data set. 

NOTE NOTE NOTE:

The data set 'drug-discovery.csv' was split into two CSV files called part1 and part2
in order to facilitate uploading to the repo. Please combine the CSVs into one file 
called 'drug-discovery.csv' before processing the data with the provided R code.

==================================================================

Intro: 

Drug invention and discovery is a highly active field and modern computer 
hardware and methods from computational statics and machine learning are 
routinely employed in attempts to predict performance and attributes of new 
compounds. The dataset used in this project is the same one described in the
paper by R. E. McCulloch et al. in Annals of Applied Statistics, Vol 4 No. 1, 2010. 
The purpose is to predict if a certain drug compound, which is comprised of a 
specific combination of molecular descriptors, successfully treats a given disorder. 


Comments:

The purpose of the following R code is to aid the user in loading, cleaning,
and augmenting the highly imbalanced data set called 'drug-discovery.csv'
which is a well-known NIH (National Institutes of Health) data set. It has been
the subject of many papers and in particular was used in a paper by McCulloch
et al. (2010). The goal of the present code is to prepare the data so that it
can be used to reproduce and/or improve upon the work in McCulloch et al. (2010).


Data Set Background Information

The data consists of p = 266 molecular descriptors (variables/features) and one 
binary outcome which implies either success or failure of a given variable 
combination (compound) in treating the disorder. There are n = 29,374 compounds of 
which 542 are defined as active (where Y = 1 implies success in treatment and 
Y = 0 otherwise). No specific description of the large list of variables is provided, 
as they are highly specialized molecular forms familiar only to experts in the relevant 
field. However, such a description is not necessary in successfully applying machine 
learning methods to the dataset.


In the present case, only about 1.8 percent of the entire dataset is of the active 
type while the rest were inactive compounds. This presents serious problems for any 
machine learning method and can very easily bias the model being trained toward 
the Y = 0 class. After all, even a ridiculous model, one that always predicts an 
outcome of Y = 0, would be right 98.2 percent of the time. Of course it would be 
wrong 100 percent of the time for the Y = 1 cases which is not useful.


This is a serious issue for binary classification but fortunately it is also a 
well-known one which is common to multiple fields including drug discovery, and 
several approaches existto address it. The method of up-sampling was chosen (also 
called oversampling) for the minority class (Y = 1). Repeated random draws (with 
replacement) were performed of the training minority class (271 cases) to populate 
the training set until there was an equal number of the two classesin the training 
set. Thus the training set contains 14416 instances of Y = 0 and another 14416 
where Y = 1. The test set consists of 14416 instances of Y = 0 and 271 with Y = 1. 
This method is similar in principle to that employed by McCulloch et al. (2010) 
but differs in the details of the actual train test split. For this code it was 
preferred that the test set have the same proportion of the two classes as the 
original raw dataset, and the above recipe achieves that.
