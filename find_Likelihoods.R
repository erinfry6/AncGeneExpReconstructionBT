## this script identifies the best model parameters to include in analyzing the evolution of gene expression by finding the likelihood of each model and choosing the highest
## created by Erin Fry (efry@uchicago.edu)
## User should have R installed (brew install R)
## Non-indented lines should be evaluated for modification speficic to user's purpose


###########################################################


#collect the likelihood of the stepping stone sampler for each model for each gene

##first for model including the delta evolutionary rate parameter
setwd("/Users/lynchlab/Desktop/ErinFry/BrainTranscription/BrainConstitiutive/BTReconstruct/results/modelDelta")
options(stringsAsFactors = FALSE)

ldf <- list() # creates a list
listcsv<-paste("gene",as.character((order(dir(pattern = "*.txt")))),".txt", sep="") # creates the list of all the csv files in the directory in true (not computer) numerical order
for (k in 1:length(listcsv)){ 
  ldf[[k]]<- read.csv(listcsv[k], sep='\t') # read files in listcsv into the ldf list
  }
#find the harmonic means
deltass<-vector(length=length(ldf))
for (i in 1:length(listcsv)){
  deltass[i]<-as.numeric((ldf[[i]][nrow(ldf[[i]]),1]))
}

#now for the kappa model
setwd("/Users/lynchlab/Desktop/ErinFry/BrainTranscription/BrainConstitiutive/BTReconstruct/results/modelKappa")
ldf <- list() # creates a list
listcsv<-paste("gene",as.character((order(dir(pattern = "*.txt")))),".txt", sep="") # creates the list of all the csv files in the directory in true (not computer) numerical order
for (k in 1:length(listcsv)){ 
  ldf[[k]]<- read.csv(listcsv[k], sep='\t') # read files in listcsv into the ldf list
  }
#find the harmonic means
kappass<-vector(length=length(ldf))
for (i in 1:length(ldf)){
  kappass[i]<-as.numeric((ldf[[i]][nrow(ldf[[i]]),1]))
}

#now for the model with no evo rate parameters
setwd("/Users/lynchlab/Desktop/ErinFry/BrainTranscription/BrainConstitiutive/BTReconstruct/results/modelNone")
ldf <- list() # creates a list
listcsv<-paste("gene",as.character((order(dir(pattern = "*.txt")))),".txt", sep="") # creates the list of all the csv files in the directory in true (not computer) numerical order
for (k in 1:length(listcsv)){ 
  ldf[[k]]<- read.csv(listcsv[k], sep='\t') # read files in listcsv into the ldf list
  }
#find the harmonic means
plainss<-vector(length=length(ldf))
for (i in 1:length(ldf)){
 plainss[i]<-as.numeric((ldf[[i]][nrow(ldf[[i]]),1]))
}

#lastly, for the model with both kappa and delta
setwd("/Users/lynchlab/Desktop/ErinFry/BrainTranscription/BrainConstitiutive/BTReconstruct/results/modelKappaDelta")
ldf <- list() # creates a list
listcsv<-paste("gene",as.character((order(dir(pattern = "*.txt")))),".txt", sep="") # creates the list of all the csv files in the directory in true (not computer) numerical order
for (k in 1:length(listcsv)){ 
  ldf[[k]]<- read.csv(listcsv[k], sep='\t') # read files in listcsv into the ldf list
  }
#find the harmonic means
kappadeltass<-vector(length=length(ldf))
for (i in 1:length(ldf)){
  kappadeltass[i]<-as.numeric((ldf[[i]][nrow(ldf[[i]]),1]))
}


###########################################################

## Combine the information into one file to export, also indicate which model choice is best based on the harmonic mean of the Lh values

steppingstonevals<-(rbind(t(listcsv),
                   t(deltass),t(kappass),
                   t(plainss),t(kappadeltass)))
## set the row names of the dataframe
rownames(steppingstonevals)<-c("gene_number", "ss_Delta", "ss_Kappa",
                         "ss_Plain", "ss_KD")

## create a vector of which choice is best for the parameters for that gene's evolution
choicess<-vector(length=length(ldf))
for (i in 1:length(ldf)){
  choicess[i]<-(which.max(steppingstonevals[2:5,(i)]))
            #Choice of 1=delta, 2=Kappa 3=Plain 4=Kappa and Delta**
}

## combine that with the information and create a column
steppingstonevals<-as.data.frame(t(rbind(steppingstonevals, choicess)))

## take a look at the file
head(steppingstonevals)

###########################################################

## First, create a file to indicate which model to use during ancestral reconstruction

setwd("/Users/lynchlab/Desktop/ErinFry/BrainTranscription/BrainConstitiutive/BTReconstruct/data")
write.table(t(choicess), "modelchoice.txt", sep= "\t",row.names=FALSE, col.names=FALSE)

## then just save the data you have so far 
write.table(steppingstonevals,"16-04-28Likelihoods.txt",sep='\t', row.names=FALSE)