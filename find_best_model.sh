## this script identifies the best model parameters to include in analyzing the evolution of gene expression
## created by Erin Fry (efry@uchicago.edu)
## User should have R installed
## Non-indented lines should be evaluated for modification speficic to user's purpose

###########################################################

export path=/Users/lynchlab/Desktop/ErinFry/BrainTranscription/BrainConstitiutive/BTReconstruct ##full absolute path to main directory

	export pathData=${path}/data
	export pathScripts=${path}/scripts
	export pathResults=${path}/results
	export pathTemporary=${pathResults}/temporary
	export pathCommands=${pathScripts}/commands

###########################################################

	## for the following code to work, you must have a gene 1. for me this is a duplicate of gene #2

	if [ -e ${pathResults}/gene1 ]; then
   	echo 'already here'
    else
    cp -r ${pathResults}/gene2 ${pathResults}/gene1/ 
    fi

###########################################################

	## first make directories
	
	mkdir ${pathResults}/modelDelta ${pathResults}/modelKappa ${pathResults}/modelKappaDelta ${pathResults}/modelNone

	## copy the files containing the likelihood under each model to a directory for better analysis

for x in {1..15}  ## modify this to match the total number of genes you are analyzing
	do
	cp ${pathResults}/gene$x/delta.txt ${pathResults}/modelDelta/gene$x.txt
	cp ${pathResults}/gene$x/kappa.txt ${pathResults}/modelKappa/gene$x.txt
	cp ${pathResults}/gene$x/kappadelta.txt ${pathResults}/modelKappaDelta/gene$x.txt
	cp ${pathResults}/gene$x/none.txt ${pathResults}/modelNone/gene$x.txt
	done

###########################################################

	## Collect the likelihoods and find the highest for each gene using the R script titled 'find_Likelihoods.R'
	
	R --vanilla <find_Likelihoods.R 


