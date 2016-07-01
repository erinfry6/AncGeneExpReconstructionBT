Before you begin, create a home directory that contains directories titled: data, reults and scripts. 
Also, download and place BayesTraits's file in this directory. Name it BayesTraitsV2.

The scripts should be run in the following order with the described purpose:


1) run_MCMC.sh - this will run the MCMC chain under the four evolutionary rate parameter models relavent to gene expression. 
You will need a simple tabular '.txt' file with expression data. First column with sample names (that match the tree (Nexus formatted) file).
The rest of the columns in the .txt file should be the expression values for each gene. 
Make sure to keep track of the gene name order, as from now on, the gene will be known as gene#
The second input is a tree file, again NEXUS formatted (see manual)
The third and fourth are the first two command necessary for BayesTraits (see Manual)


in the command line looks like$ ./run_MCMC.sh RPKM_Expression_Data.txt MyTree.tree 4 2

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