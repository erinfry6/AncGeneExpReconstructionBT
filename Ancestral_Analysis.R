## this script calculates the percent divergence of genes at two ancestral states
## User should have R installed (brew install R)
## Non-indented lines should be evaluated for modification speficic to user's purpose


###########################################################

#Examine the MRCA posteior probability distributions after running BayesTraits again with the best parameter file. 
##Find the genes with low overlap between the two distributions




setwd("~/Desktop/ErinFry/BrainTranscription/BrainConstitiutive/step2/ancestral")
ldf <- list() # creates a list
listcsv<-paste("gene",as.character((order(dir(pattern = "*.txt")))),".txt", sep="")

for (k in 1:length(listcsv)){ 
  ldf[[k]]<- read.csv(listcsv[k], sep='\t') # read files in listcsv into the ldf list
}


#The function DistDiv finds the frequency at which two distributions are different from one another
#'dylpr' is a required package for this function
#the first two arguments are the distributions of interest
#the second is the number of bins you would like to divide the data into, default 100

DistDiv<-function(dist1,dist2,nbin=100) {

#first, define the bins each distribution will be broken up into
  minimum=(min(dist1, dist2)) #minimum value of both distributions
  maximum=(max(dist1, dist2)) #maximum value of both distributions
  bins <- seq(minimum, maximum, by =(maximum-minimum)/nbin )  #create nbins from the minimum to maximum observed values

#Create a data frame to contain the number of counts from each distribution in each bin
  #the hist(plot=FALSE) function creates a list containing count information in each bin, speficied above
  counts<-as.data.frame(cbind(hist(dist1, plot=FALSE, breaks=bins)$counts,hist(dist2, plot=FALSE, breaks=bins)$counts))
  colnames(counts)<- c("Dist1Counts", "Dist2Counts") #set the column names
  
#find the number of overlapping counts across all bins
  ##create new column containing the minimum count of the two distributions
  ##this minimum count is equal to half of the overlap between the two in that bin
  counts$overlap<-apply(counts[,1:2],1,min)  #Take the minimum count for each bin
  
  #multiple the overlap by two to equal the percent overlap between the two distributions
  #then divide by the total number of observations to get the proportion overlap between the two distributions
  return(1-(2*sum(counts$overlap))/sum(counts$Dist1Counts,counts$Dist2Counts))    }



#look through the distributions of each gene to find genes with low percent overlap
genes<-1:length(ldf)

percent.divergent<-vector(length=length(genes)) #create empty vectors to contain percent divergence of each gene
for (i in genes){  #for each of these genes
  gene<- ldf[[i]][1:1000,]  #create a new file for only that gene
  
  #run the function distdiv for the human and H-C post prob distributions
  percent.divergent[i]<-DistDiv(gene$Est.Node.01...1, gene$Est.Node.02...1)
}

par(bg="#D6D6CE")
par(bg="white")
##what is the distribution of the divergences across all tested genes
hist((percent.divergent*100), #create histogram of percent divergence for tested genes
       main= "Percent Divergence in Posterior Probaility Distributions",#title
       xlab="Percent Posterior Probaility Divergence of Reconstructed Ancestral Transcriptional States", 
       ylab="Number of Genes", cex.lab=1.3,
       col="#800000", breaks=100)

```

