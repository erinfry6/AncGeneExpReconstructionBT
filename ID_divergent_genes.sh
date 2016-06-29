## this script begins to analyze the posterior probabilities of the reconstructed ancestral states
## created by Erin Fry (efry@uchicago.edu)
## User should have R installed
## Non-indented lines should be evaluated for modification speficic to user's purpose

###########################################################

## for this step to work, you must have a gene 1. for me this is a duplicate of gene #2

	if [ -e ${pathRecon}/gene1 ]; then
   	echo 'already here'
    else
    cp -r ${pathResults}/gene2 ${pathResults}/gene1/ 
    fi

###########################################################

## The rest of my analysis is done in R





###########################################################