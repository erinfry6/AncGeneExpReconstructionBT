The following scripts can be used to reconstruct ancestral posterior probability distributions of gene expression at internal nodes within a phylogenetic tree.

They will:

1) Reconstruct ancestral gene expression levels using BayesTrait’s continuous trait, random walk MCMC algorithm, transcriptome data from extant species, and the known species phylogeny with distances.

2) Identify genes with expression shifts in the lineage of interest by comparing the posterior probability distributions of the ancestral reconstructions

#################################################################################

## These scripts and pipeline were written by Erin Fry (efry@uchicago.edu) in the Lynch Laboratory at the University of Chicago
## Last modified: July 28 2016

#################################################################################

Before beginning, create a home directory for the pipeline that contains the following subdirectories

				home/data  		
				
				home/results
				
				home/scripts
				
				home/BayesTraitsV2
				
Place the contents of this repository in the scripts folder.

The home/BayesTraitsV2 directory is the downloaded Version 2 of BayesTraits (http://www.evolution.rdg.ac.uk/BayesTraits.html)
BayesTraits Manual: http://www.evolution.rdg.ac.uk/BayesTraitsV2.0Files/TraitsV2Manual.pdf

#################################################################################

Run the scripts in the following order.

1) run_MCMC.sh - Run the MCMC chain under the four evolutionary rate parameter models relavent to gene expression. 

   ./run_MCMC.sh Expression_Data.txt SampleTree.tree 4 2
   
   		Expression_Data.txt is a tab delimited .txt file containing expression data formatted according to the BayesTraits Manual.
		SampleTree.tree is an ultrametric nexus formatted phylogeny with branch distances formatted according to the BayesTraits Manual.
		4 and 2 are the two commands necessary to run BayesTraits and indicate 
		
		Make sure to keep track of the gene name order, as from now on, the gene will be known as gene#
		The third and fourth are the first two command necessary for BayesTraits (see Manual)


in the command line looks like$ ./run_MCMC.sh Expression_Data.txt SampleTree.tree 4 2

The output will be in home/results.

*It is important to look at the command files being created by run_MCMC.sh. If you would like to modify the commands given to BayesTraits,
you will need to manually change each of the four command file writing scripts.

2) find_best_model.sh - this script collects the likelihoods from the first step and identifies which model best fits the trait's evolution using the find_Likelihoods.R script
No input necessary, but be sure to change the local path at the top of the .sh file and find_Likelihoods.R scripts!

3) ancestral_reconstruction.sh - runs the MCMC chain again, but this time only given the best model for the trait's evolution
The chain will also calculate the posterior probably distribution of the reconstructing ancestral states for the desired ancestral nodes
Make sure to change this part of the code in the command file section to whatever node you would like. See BayesTraits Manual.
You will need the same 4 inputs from the first step to be located in the data folder, as well as the newly created modelchoice.txt file.

in the command line looks like$ ./ancestral_reconstruction.sh RPKM_Expression_Data.txt MyTree.tree 4 2

4) ID_divergent_genes.sh - if you would like to calculate the percent divergence between the two posterior probability distributions of two ancestral states,
	this file will be useful. It runs the R code Ancestral_Analysis.R. You'll need both R and the package dplyr. Be sure to change the paths in the headers.

If not, you may find the code helpful in Ancestral_Analysis.R useful, still.

in the command line looks like$ ID_divergent_genes.sh