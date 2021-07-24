
# Comments:
# The purpose of the following R code is to aid the user in loading, cleaning,
# and augmenting the highly imbalanced data set called 'drug-discovery.csv'
# which is a well-known NIH (National Institutes of Health) data set. It has been
# the subject of many papers and in particular was used in a paper by McCulloch
# et al. (2010). The goal of the present code is to prepare the data so that it
# can be used to reproduce and/or improve upon the work in McCulloch et al. (2010).

# Data Set Background Information

# The data consists of p = 266 molecular descriptors (variables/features) and one binary 
# outcome which implies either success or failure of a given variable combination 
# (compound) in treating the disorder. There are n = 29,374 compounds of which 542 
# are defined as active (where Y = 1 implies success in treatment and Y = 0 otherwise). 
# No specific description of the large list of variables is provided, as they are 
# highly specialized molecular forms familiar only to experts in the relevant field. 
# However, such a description is not necessary in successfully applying machine 
# learning methods to the dataset.


# Import data
temp = read.csv("drug-discovery.csv")
thedata = temp
numobs = dim(thedata)[1]  # get number of observations

# Combine y variable "somewhat active = 1" and "highly active = 2" into "active = 1"
for(i in 1:numobs){
  if(thedata[i,1] == 2){
    thedata[i,1] = 1
  }
}

# To create train/test split first extract all rows with y = 0 and place them 
# in new data frame and do the same with all rows with y = 1. Then split these two 
# data frames in half and recombine half the y = 0 rows and half the y = 1 rows to 
# get two new data frames which will be the train and test splits. The recombination
# can also be done randomly to obtain multiple train/test splits as needed.

#------------------------------------------------------
# Create data frame containing all rows with y = 0
yzeros = thedata[FALSE,]  # Create empty data frame with all the correct columns
for(i in 1:numobs){  # Fill the empty data frame only with rows containing y = 0
  if(thedata[i,1] == 0){
    yzeros[i,] = thedata[i,]
  }
}

yzeros_clean = yzeros[complete.cases(yzeros),]  # Remove NA rows
rownames(yzeros_clean) <- NULL  # reset row names to numerical order

# Output data files to disk
# write.csv(yzeros, "yzeros.csv")
# write.csv(yzeros_clean, "yzeros_clean.csv")


#-------------------------------------------------------
# Create data frame containing all rows with y = 1
yones = thedata[FALSE,]  # Create empty data frame with all the correct columns
for(i in 1:numobs){  # Fill the empty data frame only with rows containing y = 1
  if(thedata[i,1] == 1){
    yones[i,] = thedata[i,]
  }
}

yones_clean = yones[complete.cases(yones),]  # Remove NA rows
rownames(yones_clean) <- NULL  # reset row names to numerical order

# Output data files to disk
#write.csv(yones, "yones.csv")
#write.csv(yones_clean, "yones_clean.csv")


#-------------------------------------------------------


# train = sample(1:nrow(testitxm),floor(nrow(testitxm)/2)) #indices of train set
# Create randomly chosen numbers (without replacement) to randomly draw
# from both the y=1 and y=0 sets to create train and test splits
set.seed(14)
onesindeces = sample(1:nrow(yones_clean),nrow(yones_clean))
zerosindeces = sample(1:nrow(yzeros_clean),nrow(yzeros_clean))
# Take about 14K random samples of the first 271 of the 542 y=1 indeces created above 
trainonesindeces = sample(onesindeces[1:nrow(yones_clean)/2],nrow(yzeros_clean)/2, replace=TRUE)

# Now can just use half of the index values each for train and test 
# pulling from both ones and zeros lists

# set.seed(24)
# testindeces = sample(1:nrow(yones_clean),10)

# rownames(train_disc) <- NULL  # reset the row names of train_disc set 
# rownames(test_disc) <- NULL  # reset the row names of test_disc set

#-------------------------------------------------------
# Create data frame containing the training data randomly chosen from the data
emptyhalfframe = thedata[-c((nrow(thedata)/2+1):nrow(thedata)),]  # Create data frame with all the correct columns
trainset = emptyhalfframe[FALSE,]  # Create empty data frame for train, ready to fill
testset = emptyhalfframe[FALSE,]  # Create empty data frame for test, ready to fill

######################################  IMPORTANT:  #########################################
#############################################################################################
# Since our original data set is highly imbalanced (many more y = 0 classifiers than y = 1), 
# then to avoid severe bias in our model for y = 0, we shall use upsampling to create a
# training set which contains an equal proportion of y=0 and y=1 classes. This will be done
# by randomly sampling (with replacement) half the set of y=1 classes until an equal number
# of y=1 and y=0 are obtained. The other half of the y=1 class will be reserved for the 
# test set. The test set will maintain the imbalanced proportion of y=0 and y=1 classes.

# Fill the train set with same number of y = 1 rows equal to y = 0 rows.
for(i in 1:nrow(yzeros_clean)/2){
  trainset[i,] = yones_clean[trainonesindeces[i],]
}


# Fill the test set with half of randomly drawn rows with y = 1
for(i in 1:nrow(yones_clean)/2){
  testset[i,] = yones_clean[onesindeces[i+nrow(yones_clean)/2],]
}


# Fill the train set with randomly drawn rows with y = 0
for(i in 1:14416){  
  trainset[i+nrow(yzeros_clean)/2,] = yzeros_clean[zerosindeces[i],]
}


# Fill the test set with randomly drawn rows with y = 0
for(i in 1:nrow(yzeros_clean)/2){  
  testset[i+nrow(yones_clean)/2,] = yzeros_clean[zerosindeces[i+nrow(yzeros_clean)/2],]
}



#########################################################
####################  IMPORTANT:  #######################
#########################################################
# It might be a good idea to randomize the rows after 
# combining (concatinating) the y=1 and y=0 rows into one
# test set or one training set. This way, there are not
# large clusterings of y=1 and y=0 in the data. This
# might be an important step in case the code (e.g. h2o)
# is taking random draws from the train set to create
# the model. The way to do this is simply with the short
# R code below:
# temp3 = temp2[sample(nrow(temp2)),]
#########################################################
#########################################################

# Randomize twice

testset2 = testset[sample(nrow(testset)),]
trainset2 = trainset[sample(nrow(trainset)),]

testset2 = testset2[sample(nrow(testset2)),]
trainset2 = trainset2[sample(nrow(trainset2)),]

# Read number of 1 and 0 entries

table(trainset2$y)
table(testset2$y)

#########################################################
#########################################################



# yones_clean = yones[complete.cases(yones),]  # Remove NA rows from yones and yzeros
rownames(trainset2) <- NULL  # reset row names to numerical order
rownames(testset2) <- NULL  # reset row names to numerical order


# ===============================================================================
# ===============================================================================

