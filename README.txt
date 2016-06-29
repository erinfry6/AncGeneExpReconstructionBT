Before you begin, create a home directory that contains directories titled data reults and scripts. 
Also, download and place BayesTraits's file in this directory.

The scripts should be run in the following order with the described purpose:


1) run_MCMC.sh - this will run the MCMC under the four evolutionary rate parameter models relavent to gene expression. 
You will need a simple tabular .txt file with expression data. First column with individual names (matching up the tree Nexus file), the rest of the columns with the gene expression values.
The second input is a tree file.
The third and fourth are the first two command necessary for BayesTraits (see Manual)

The output will be in results.

*It is important to look at the command files being create by run_MCMC.sh. If you would like to modify the commands given to BayesTraits,
you will need to manually change each of the four command file writing scripts.

2) find_best_model.sh - this script collects the likelihoods from the first step and identifies which model best fits the trait's evolution using the find_Likelihoods.R script
No input necessary, but be sure to change the local path and the paths in the find_Likelihoods.R file!!!

3) ancestral_reconstruction.sh - runs the MCMC chain again, but this time only given the best model for the trait's evolution
The chain will also calculate the posterior probably distribution of the reconstructing ancestral states for the desired ancestral nodes
Make sure to change this part of the code in the command file section to whatever node you would like. See BayesTraits Manual.
You will need the same 4 inputs from the first step to be located in the data folder, as well as the newly created modelchoice.txt file.

4) ID_divergent_genes - if you would like to find genes with divergent expression between two ancestral states, continue with this step. 

If not, you may find the code helpful in Ancestral_Analysis.R useful, still.

