## this script identifies the best model parameters to include in analyzing the evolution of gene expression
## created by Erin Fry (efry@uchicago.edu)
## User should have R installed
## Non-indented lines should be evaluated for modification speficic to user's purpose

###########################################################

export path=/Users/lynchlab/Desktop/ErinFry/ReconAncNeoTranscriptomes/BrainConstitiutive/BTReconstruct ##full absolute path to main directory
	
	export pathData=${path}/data
	export pathScripts=${path}/scripts
	export pathResults=${path}/resultsFour
	export pathTemporary=${pathResults}/temporary
	export pathCommands=${pathScripts}/commands

###########################################################

	## for the following code to work, you must have a gene 1. for me this is a duplicate of gene #2

	if [ -e ${pathResults}/SSS/kappa/gene1.txt ]; then
   	echo 'already here'
    else
    cp -r ${pathResults}/SSS/kappa/gene2.txt ${pathResults}/SSS/kappa/gene1.txt
    fi


if [ -e ${pathResults}/SSS/delta/gene1.txt ]; then
   	echo 'already here'
    else
    cp -r ${pathResults}/SSS/delta/gene2.txt ${pathResults}/SSS/delta/gene1.txt
    fi
    
    
    if [ -e ${pathResults}/SSS/kd/gene1.txt ]; then
   	echo 'already here'
    else
    cp -r ${pathResults}/SSS/kd/gene2.txt ${pathResults}/SSS/kd/gene1.txt
    fi
    
    
    if [ -e ${pathResults}/SSS/none/gene1.txt ]; then
   	echo 'already here'
    else
    cp -r ${pathResults}/SSS/none/gene2.txt ${pathResults}/SSS/none/gene1.txt
    fi


###########################################################

	## Extract reconstruction information using 'Create.AGER.Summary.File.R'
	
	R --vanilla <ID.best.model.R
	
	
echo created model choice file in ${pathResults} directory
