# Ancestral Transcriptome Reconstruction

The following scripts can be used to reconstruct ancestral posterior probability distributions of gene expression at internal nodes within a phylogenetic tree. These scripts and pipeline were written by Erin Fry (efry@uchicago.edu) in the Lynch Laboratory, Department of Human Genetics, University of Chicago.

They will:

1) Reconstruct ancestral gene expression levels using BayesTrait’s continuous trait, random walk MCMC algorithm, transcriptome data from extant species, and the known species phylogeny with distances.

2) Identify genes with expression shifts in the lineage of interest by comparing the posterior probability distributions of the ancestral reconstructions


#################################################################################

## Set up directories

Before beginning, create a home directory for the pipeline that contains the following subdirectories

				home/data  		
				
				home/results
				
				home/scripts
				
				
Place the contents of this repository in the scripts folder.

BayesTraits Manual: http://www.evolution.rdg.ac.uk/BayesTraitsV2.0Files/TraitsV2Manual.pdf

*For this particular pipeline, I have used a modified version of BayesTraits (by Andrew Meade) that allows for the specification of priors on ancestral nodes. This version can be obtained by cont*

#################################################################################

## Format input files

The following input files are required for this analysis

	-Expression_Data.txt: Expression data file with no column names. First column: names of the samples that coordinate with the Nexus tree file. All subsequent columns are the expression data for each gene. Be sure to keep another document that notes the gene in each column, as well as gene numbers, beginning at 2.

	-SampleTree.tree: This file should be a Nexus formatted tree in accordance with the BayesTraits Manual


#################################################################################

## Modify the script headers

The top of each script (all .sh and .R files) must be modified to contain the proper directory path for the home directory

The numbering will begin at 2, not 1. For steps 1 and 3, modify the .sh file for loops at the end of the script to run the analysis on the desired number of genes.


#################################################################################

## Run the Bayesian Ancestral Transcriptome Reconstruction Scripts


	1- run_MCMC.sh - Run the MCMC chain under the four evolutionary rate parameter models relavent to gene expression. 

```
./run_MCMC.sh Expression_Data.txt SampleTree.tree 4 2
```
   
Expression_Data.txt is a tab delimited file containing expression data formatted according to the BayesTraits Manual.
SampleTree.tree is an ultrametric nexus formatted phylogeny formatted according to the BayesTraits Manual.
4 (continuous walk) and 2 (MCMC) are the two commands necessary to run BayesTraits random walk MCMC algorithm

**It is important to look at the command files being created by run_MCMC.sh. If you would like to modify the command files, you will need to manually change each of the four command file writing scripts in the 'CREATING COMAMAND FILES' section.**


2) find_best_model.sh - This script collects the likelihoods from the first step and identifies which model best fits the trait's evolution using `find_Likelihoods.R`
```
./find_best_model.sh
```


3) ancestral_reconstruction.sh - Reconstructs the posterior probability distribution of ancestral states at specified internal nodes using the best model for the gene's evolution. 
   These nodes must be specified in the CREATING COMMAND FILES section. See BayesTraits Manual for instructions.
```
./ancestral_reconstruction.sh Expression_Data.txt SampleTree.tree 4 2
```
   
_All four inputs following the bash script should be the exact same as in step 1._

#################################################################################

4) ID_divergent_genes.sh - Calculates the percent divergence between the two posterior probability distributions of two ancestral states using `Ancestral_Analysis.R`

```
./ID_divergent_genes.sh
```

_Requires the R package 'dplyr'._

#################################################################################

**To run these scripts on the example test files, copy the files in scripts/test to the data directory and follow the above steps.**

### by Erin Fry, September 16 2016
### Last modified: February 1 2017