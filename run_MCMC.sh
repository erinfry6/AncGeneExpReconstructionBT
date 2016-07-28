## this script runs the BayesTraits program given a set of commands for the genes indicated in the for loop
## created by Erin Fry (efry@uchicago.edu)
## User should have BayesTraits installed in the main path directory
## Non-indented lines should be evaluated for modification specific to the user's purpose

###########################################################

export path=/Users/lynchlab/Desktop/ErinFry/BrainTranscription/BrainConstitiutive/BTReconstruct ##full absolute path to main directory

	export pathData=${path}/data
	export pathScripts=${path}/scripts
	export pathResults=${path}/results
	export pathTemp=${pathResults}/temporary
	export pathCommands=${pathScripts}/commands
	
###########################################################
	
	## make directory to store the temporary files and commands
	
	if [ -e ${pathTemp} ]; then
   	echo 'Temporary dir already here'
    else
    mkdir ${pathTemp}
    fi

## make directory to store the results
	
	if [ -e ${pathCommands} ]; then
   	echo 'Command dir already here'
    else
    mkdir ${pathCommands}
    fi

###########################################################

	## the first command is the file with all gene expression data, the second is the phylogenetic tree with distances
	## the next two are the two commands needed to run BayesTraits (for continuous walk MCMC, 4 and 2, respectively)

	Expressiondata=$1
	tree=$2
	command1=$3
	command2=$4

## if running multiple of these files at once, make sure to modify scriptversion to be a different number in each script to avoid creating the same numbered files

export scriptversion=1  ## modify this if running multiple files at once
	export expData=${pathTemp}/singlegene$scriptversion.txt
	export MCMC=${pathTemp}/MCMC$scriptversion.txt
	export model=${pathTemp}/Model$scriptversion.bin

###########################################################

	## creates the command files to use or not use each evolutionary rate parameter

	echo $command1 > ${pathCommands}/delta.txt
	echo $command1 > ${pathCommands}/kappa.txt
	echo $command1 > ${pathCommands}/kappadelta.txt
	echo $command1 > ${pathCommands}/none.txt
	echo $command2 >> ${pathCommands}/delta.txt
	echo $command2 >> ${pathCommands}/kappa.txt
	echo $command2 >> ${pathCommands}/kappadelta.txt
	echo $command2 >> ${pathCommands}/none.txt

## specifies how many iterations, the burnin period, and the number of stones to sample,

	echo 'Delta
Iterations 1010000
Burnin 10000
stones 100 10000' >> ${pathCommands}/delta.txt
echo SaveModels $model >> ${pathCommands}/delta.txt
echo run >> ${pathCommands}/delta.txt

	echo 'Kappa
Iterations 1010000
Burnin 10000
stones 100 10000' >> ${pathCommands}/kappa.txt
echo SaveModels $model >> ${pathCommands}/kappa.txt
echo run >> ${pathCommands}/kappa.txt

	echo 'Delta
	Kappa
Iterations 1010000
Burnin 10000
stones 100 10000' >> ${pathCommands}/kappadelta.txt
echo SaveModels $model >> ${pathCommands}/kappadelta.txt
echo run >> ${pathCommands}/kappadelta.txt

echo 'Iterations 1010000
Burnin 10000
stones 100 10000' >> ${pathCommands}/none.txt
echo SaveModels $model >> ${pathCommands}/none.txt
echo run >> ${pathCommands}/none.txt


###########################################################

## for loop goes through each of the genes specified in { .. }

	## first, makes a temporary file to contain only gene expression from the one gene, then creates the directory for that gene

for a in {2..100}
	do

	awk -v a="$a" '{print $1,$a}' ${pathData}/${Expressiondata} > ${expData}

	mkdir ${pathResults}/gene$a

		#run the MCMC chain under each model for that gene, save the stepping stone sampler output to determine which model has the highest likelihood
        ./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${expData} <${pathCommands}/none.txt > ${MCMC}
        		cp ${expData}.log.txt.Stones.txt ${pathResults}/gene$a/none.txt
        		cp ${model} ${pathResults}/gene$a/noneModel.bin
        		
        ./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${expData} <${pathCommands}/kappa.txt> ${MCMC}
                cp ${expData}.log.txt.Stones.txt ${pathResults}/gene$a/kappa.txt 
                cp ${model} ${pathResults}/gene$a/kappaModel.bin
                
        ./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${expData} <${pathCommands}/delta.txt> ${MCMC}
                cp ${expData}.log.txt.Stones.txt ${pathResults}/gene$a/delta.txt 
            	cp ${model} ${pathResults}/gene$a/deltaModel.bin 
            	
        ./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${expData} <${pathCommands}/kappadelta.txt > ${MCMC}
                cp ${expData}.log.txt.Stones.txt ${pathResults}/gene$a/kappadelta.txt
                cp ${model} ${pathResults}/gene$a/kappadeltaModel.bin

	done
