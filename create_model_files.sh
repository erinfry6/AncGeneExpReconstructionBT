## this script runs the BayesTraits program given a set of commands for the genes indicated in the for loop
## created by Erin Fry (efry@uchicago.edu)
## Non-indented lines should be evaluated for modification specific to the user's purpose

###########################################################

	## set directory paths

export path=/Users/lynchlab/Desktop/ErinFry/ReconAncNeoTranscriptomes/BrainConstitiutive/BTReconstruct ##full absolute path to main directory

	export pathData=${path}/data
	export pathScripts=${path}/scripts
	export pathResults=${path}/resultsFour
	export pathTemp=${pathResults}/temporary
	export pathModelResults=${pathResults}/Models
	export pathSSSResults=${pathResults}/SSS
	export pathCommands=${pathScripts}/commands
	
###########################################################
	
	## make directory to store the temporary files and commands
	
	if [ -e ${pathTemp} ]; then
   	echo 'Temporary dir already here'
    else
    mkdir ${pathTemp}
    fi
	
	if [ -e ${pathCommands} ]; then
   	echo 'Command dir already here'
    else
    mkdir ${pathCommands}
    fi
    
	## make directory to store the results from the chain
	if [ -e ${pathMCMCResults} ]; then
   	echo 'MCMC Results dir already here'
    else
    mkdir ${pathMCMCResults}
    fi
    
	## make directory to store the model from the chain
	if [ -e ${pathModelResults} ]; then
   	echo 'MCMC Results dir already here'
    else
    mkdir ${pathModelResults} ${pathModelResults}/kappa ${pathModelResults}/delta ${pathModelResults}/none ${pathModelResults}/kd
    fi
    
    ## make directory to store the results from the stepping stone sampler
	if [ -e ${pathSSSResults} ]; then
   	echo 'SSS Results dir already here'
    else
    mkdir ${pathSSSResults} ${pathSSSResults}/kappa ${pathSSSResults}/delta ${pathSSSResults}/none ${pathSSSResults}/kd
    fi


###########################################################

	## the first command is the file with all gene expression data, the second is the phylogenetic tree with distances
	## the next two are the two commands needed to run BayesTraits (for continuous walk MCMC, 4 and 2, respectively)

	Expressiondata=$1
	tree=$2
	command1=$3
	command2=$4

## if running multiple scripts at once, make sure to modify scriptversion to be a different number in each script to avoid creating the same numbered files

export scriptversion=1  ## modify this if running multiple files at once
	export singleexpression=${pathTemp}/singlegene$scriptversion.txt
	export model=${pathTemp}/Model$scriptversion.bin
	export commandfile=${pathCommands}/step1command$scriptversion.txt

###########################################################

## CREATING COMMAND FILES
## create model file and find log marginal likelihood for each of four models, including kappa, delta, kappa and delta or neither


###########################################################

## for kappa and delta

	## creates the command files to use or not use each evolutionary rate parameter

	echo $command1 > ${commandfile}
	echo $command2 >> ${commandfile}

## specifies how many iterations, the burnin period, and the number of stones to sample,

echo 'Iterations 1010000
Burnin 10000
stones 100 10000
Kappa
Delta' >> ${commandfile}
echo SaveModels $model >> ${commandfile}
echo run >> ${commandfile}


###########################################################

## for loop goes through each of the genes specified in { .. }

	## first, makes a temporary file to contain only gene expression from the one gene, then runs the MCMC chain exploring the evolution of each gene's expression
	## it then copies the stepping stone sampler file and model file for future use to their appropriate folders

for a in {2..3300}
	do

	awk -v a="$a" '{print $1,$a}' ${pathData}/${Expressiondata} > ${singleexpression}

		#run the MCMC chain, save the stepping stone sampler output
        ./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${singleexpression} <${commandfile} > ${pathTemp}/MCMC.txt
        		cp ${singleexpression}.log.txt.Stones.txt ${pathSSSResults}/kd/gene$a.txt
        		cp ${model} ${pathModelResults}/kd/gene$a.bin

	done


###########################################################

## for kappa

	## creates the command files to use or not use each evolutionary rate parameter

	echo $command1 > ${commandfile}
	echo $command2 >> ${commandfile}

## specifies how many iterations, the burnin period, and the number of stones to sample,

echo 'Iterations 1010000
Burnin 10000
stones 100 10000
Kappa' >> ${commandfile}
echo SaveModels $model >> ${commandfile}
echo run >> ${commandfile}


###########################################################

## for loop goes through each of the genes specified in { .. }

	## first, makes a temporary file to contain only gene expression from the one gene, then runs the MCMC chain exploring the evolution of each gene's expression
	## it then copies the stepping stone sampler file and model file for future use to their appropriate folders

for a in {2..3300}
	do

	awk -v a="$a" '{print $1,$a}' ${pathData}/${Expressiondata} > ${singleexpression}

		#run the MCMC chain, save the stepping stone sampler output
        ./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${singleexpression} <${commandfile} > ${pathTemp}/MCMC.txt
        		cp ${singleexpression}.log.txt.Stones.txt ${pathSSSResults}/kappa/gene$a.txt
        		cp ${model} ${pathModelResults}/kappa/gene$a.bin

	done
	
	
	###########################################################

## for delta

	## creates the command files to use or not use each evolutionary rate parameter

	echo $command1 > ${commandfile}
	echo $command2 >> ${commandfile}

## specifies how many iterations, the burnin period, and the number of stones to sample,

echo 'Iterations 1010000
Burnin 10000
stones 100 10000
Delta' >> ${commandfile}
echo SaveModels $model >> ${commandfile}
echo run >> ${commandfile}


###########################################################

## for loop goes through each of the genes specified in { .. }

	## first, makes a temporary file to contain only gene expression from the one gene, then runs the MCMC chain exploring the evolution of each gene's expression
	## it then copies the stepping stone sampler file and model file for future use to their appropriate folders

for a in {2..3300}
	do

	awk -v a="$a" '{print $1,$a}' ${pathData}/${Expressiondata} > ${singleexpression}

		#run the MCMC chain, save the stepping stone sampler output
        ./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${singleexpression} <${commandfile} > ${pathTemp}/MCMC.txt
        		cp ${singleexpression}.log.txt.Stones.txt ${pathSSSResults}/delta/gene$a.txt
        		cp ${model} ${pathModelResults}/delta/gene$a.bin

	done
	
	###########################################################

## for neither kappa nor delta

	## creates the command files to use or not use each evolutionary rate parameter

	echo $command1 > ${commandfile}
	echo $command2 >> ${commandfile}

## specifies how many iterations, the burnin period, and the number of stones to sample,

echo 'Iterations 1010000
Burnin 10000
stones 100 10000' >> ${commandfile}
echo SaveModels $model >> ${commandfile}
echo run >> ${commandfile}


###########################################################

## for loop goes through each of the genes specified in { .. }

	## first, makes a temporary file to contain only gene expression from the one gene, then runs the MCMC chain exploring the evolution of each gene's expression
	## it then copies the stepping stone sampler file and model file for future use to their appropriate folders

for a in {2..3300}
	do

	awk -v a="$a" '{print $1,$a}' ${pathData}/${Expressiondata} > ${singleexpression}

		#run the MCMC chain, save the stepping stone sampler output
        ./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${singleexpression} <${commandfile} > ${pathTemp}/MCMC.txt
        		cp ${singleexpression}.log.txt.Stones.txt ${pathSSSResults}/none/gene$a.txt
        		cp ${model} ${pathModelResults}/none/gene$a.bin

	done