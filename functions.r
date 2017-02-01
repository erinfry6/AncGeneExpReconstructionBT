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
