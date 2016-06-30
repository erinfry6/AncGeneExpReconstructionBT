## this script begins to analyze the posterior probabilities of the reconstructed ancestral states
## created by Erin Fry (efry@uchicago.edu)
## User should have R and the dplyr packaged !!!!! installed
## Non-indented lines should be evaluated for modification speficic to user's purpose

###########################################################

export pathRecon=${pathResults}/AncRecon

###########################################################

## for this step to work, you must have a gene 1. for me this is a duplicate of gene #2

	if [ -e ${pathRecon}/gene1 ]; then
   	echo 'already here'
    else
    cp ${pathRecon}/gene2.txt ${pathRecon}/gene1.txt
    fi

###########################################################

## The rest of my analysis is done in R
## make sure you have the dplyr package installed in R

R --vanilla <Ancestral_Analysis.R

###########################################################