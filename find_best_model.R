## this script identifies the best model parameters to include in analyzing the evolution of gene expression by finding the likelihood of each model and choosing the highest
## created by Erin Fry (efry@uchicago.edu)
## User should have R installed (brew install R)
## Non-indented lines should be evaluated for modification speficic to user's purpose

#################################################################

path="/Users/lynchlab/Desktop/ErinFry/ReconAncNeoTranscriptomes/BrainConstitiutive/BTReconstruct/" ##full absolute path to main directory
pathResults=paste(path,"results/",sep="")
pathData=paste(path,"data/",sep="")

#################################################################


#collect the log marginal likelihood of the stepping stone sampler for each model for each gene using the following function: 

findLML<-function(){
  options(stringsAsFactors = FALSE)
  ldf <- list() # creates a list of the files
  
  listcsv<-paste("gene",as.character((order(dir(pattern = "*.txt")))),".txt", sep="") # creates the list of all the csv files in the directory in true (not computer) numerical order
  for (k in 1:length(listcsv)){ 
    ldf[[k]]<- read.csv(listcsv[k], sep='\t') # read files in listcsv into the ldf list
  }
  #find the stepping stone sampler log marginal likelihood for each gene
  logmarginallikelihood<-vector(length=length(ldf))
  for (i in 1:length(listcsv)){
    logmarginallikelihood[i]<-as.numeric((ldf[[i]][nrow(ldf[[i]]),1]))
  }
  
  return(logmarginallikelihood)
  
}


## find the log marginal likelihood for each model for all genes


##first for model including the delta evolutionary rate parameter
setwd(paste(pathResults,"modelDelta/",sep=""))
delta<-findLML()

## for kappa
setwd(paste(pathResults,"modelKappa/",sep=""))
kappa<-findLML()

## kappa and delta
setwd(paste(pathResults,"modelKappaDelta/",sep=""))
kappadelta<-findLML()


## last without additional paramaters
setwd(paste(pathResults,"modelNone/",sep=""))
none<-findLML()

###########################################################

## Combine the information into one file to export, with the gene names and which model is opitmal based on the stepping stone sampler log marginal likelihoods

listcsv<-paste("gene",as.character((order(dir(pattern = "*.txt")))),".txt", sep="") # creates the list of all the csv files in the directory in true (not computer) numerical order

steppingstoneLML<-(rbind(t(listcsv),
                   t(delta),t(kappa),
                   t(none),t(kappadelta)))
## set the row names of the dataframe
rownames(steppingstoneLML)<-c("gene_number", "LML_Delta", "LML_Kappa",
                         "LML_None", "LML_KD")

## create a vector of which choice is best for the parameters for modeling each gene's evolution
modelchoice<-vector(length=length(listcsv))
for (i in 1:length(listcsv)){
  modelchoice[i]<-(which.max(steppingstoneLML[2:5,(i)]))
            #Choice of 1=delta, 2=Kappa 3=Plain 4=Kappa and Delta**
}

## combine model choices with LMLs
steppingstoneLML<-as.data.frame(t(rbind(steppingstoneLML, modelchoice)))

## take a look at the file
head(steppingstoneLML)

###########################################################

## Create a file to indicate which model to use during ancestral reconstruction

setwd(pathData)
write.table(t(modelchoice), "modelchoice.txt", sep= "\t",row.names=FALSE, col.names=FALSE)

## Save the data you have so far 
write.table(steppingstoneLML,"LikelihoodsUnderEachModel.txt",sep='\t', row.names=FALSE)