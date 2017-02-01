## this script reconstructs the ancestral state, or transcription level, of your transcriptome
## created by Erin Fry (efry@uchicago.edu)
## User should have BayesTraits installed
## Non-indented lines should be evaluated for modification speficic to user's purpose

###########################################################

export path=/Users/lynchlab/Desktop/ErinFry/BrainTranscription/BrainConstitiutive/BTReconstruct ##full absolute path to main directory

	export pathData=${path}/data
	export pathScripts=${path}/scripts
	export pathResults=${path}/results
	export pathTemporary=${pathResults}/temporary
	export pathCommands=${pathScripts}/commands

###########################################################

	## make directory to store the reconstructions
	
	if [ -e ${pathResults}/AncRecon ]; then
   	echo 'AncRecon already here'
    else
    mkdir ${pathResults}/AncRecon
    fi

	export pathRecon=${pathResults}/AncRecon

###########################################################

	## the first command is the file with all gene expression data, the second is the phylogenetic tree with distances
	## the next two are the two commands needed to run BayesTraits (for continuous walk MCMC, 4 and 2, respectively)

	Expressiondata=$1
	tree=$2
	command1=$3
	command2=$4

## if running multiple of these files at once, make sure to modify scriptversion to be a different number in each script to avoid creating the same numbered files

export scriptversion=1  ## modify this if running multiple files at once
	export expData=${pathTemporary}/singlegene$scriptversion.txt
	export MCMC=${pathTemporary}/MCMC$scriptversion.txt

###########################################################

## CREATING COMMAND FILES

	## creates the command files to use or not use each evolutionary rate parameter

	echo $command1 > ${pathCommands}/delta$scriptversion.txt
	echo $command1 > ${pathCommands}/kappa$scriptversion.txt
	echo $command1 > ${pathCommands}/kappadelta$scriptversion.txt
	echo $command1 > ${pathCommands}/none$scriptversion.txt
	echo $command2 >> ${pathCommands}/delta$scriptversion.txt
	echo $command2 >> ${pathCommands}/kappa$scriptversion.txt
	echo $command2 >> ${pathCommands}/kappadelta$scriptversion.txt
	echo $command2 >> ${pathCommands}/none$scriptversion.txt

## specifies how many iterations, the burnin period, and the number of stones to sample
## it is important to read the AddMRCA instructions in the BayesTraits manual and modify the label and node numbers to specify
## which common ancestor you are reconstructing, do so for all 4 models

	echo 'Delta
Iterations 1010000
AddMRCA Node-01 1 2 3 4 6 7 8 9 10 11 12 13 14 15
AddMRCA Node-02 1 2 3 4 6
Burnin 10000
stones 100 10000' >> ${pathCommands}/delta$scriptversion.txt
	echo LoadModels ${pathTemporary}/model$scriptversion.bin >> ${pathCommands}/delta$scriptversion.txt
	echo run >> ${pathCommands}/delta$scriptversion.txt

	echo 'Kappa
Iterations 1010000
AddMRCA Node-01 1 2 3 4 6 7 8 9 10 11 12 13 14 15
AddMRCA Node-02 1 2 3 4 6
Burnin 10000
stones 100 10000' >> ${pathCommands}/kappa$scriptversion.txt
	echo LoadModels ${pathTemporary}/model$scriptversion.bin >> ${pathCommands}/kappa$scriptversion.txt
	echo run >> ${pathCommands}/kappa$scriptversion.txt

	echo 'Delta
Kappa
Iterations 1010000
AddMRCA Node-01 1 2 3 4 6 7 8 9 10 11 12 13 14 15
AddMRCA Node-02 1 2 3 4 6
Burnin 10000
stones 100 10000' >> ${pathCommands}/kappadelta$scriptversion.txt
	echo LoadModels ${pathTemporary}/model$scriptversion.bin >> ${pathCommands}/kappadelta$scriptversion.txt
	echo run >> ${pathCommands}/kappadelta$scriptversion.txt

echo 'Iterations 1010000
AddMRCA Node-01 1 2 3 4 6 7 8 9 10 11 12 13 14 15
AddMRCA Node-02 1 2 3 4 6
Burnin 10000
stones 100 10000' >> ${pathCommands}/none$scriptversion.txt
	echo LoadModels ${pathTemporary}/model$scriptversion.bin >> ${pathCommands}/none$scriptversion.txt
	echo run >> ${pathCommands}/none$scriptversion.txt


###########################################################

## for loop goes through each of the genes specified in { .. }

	## first, specify which model should be used for each gene
	## make a temporary file to contain only gene expression from the one gene, then creates the directory for that gene
	
	## then, depending on which model, copy the model file created in the first step and run BayesTraits again, informed by the model file to
	## reconstruct ancestral transcriptional state

for a in {2..15}
	do
	
	choice=$(awk -v a="$a" '{print $a}' ${pathData}/modelchoice.txt)

	awk -v a="$a" '{print $1,$a}' ${pathData}/${Expressiondata} > ${expData}

## number=$(grep -n "string" filename | grep -Eo '^[^:]+')	

	if [[ $choice == 4 ]]; then
	cp ${pathResults}/gene$a/kappadeltaModel.bin ${pathTemporary}/model$scriptversion.bin
	./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${expData} <${pathCommands}/kappadelta$scriptversion.txt | awk 'NR >=93' > ${pathRecon}/gene$a.txt

	elif [[ $choice == 3 ]]; then
	cp ${pathResults}/gene$a/noneModel.bin ${pathTemporary}/model$scriptversion.bin
	./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${expData} <${pathCommands}/none$scriptversion.txt | awk 'NR >=91' > ${pathRecon}/gene$a.txt


	elif [[ $choice == 2 ]]; then
	cp ${pathResults}/gene$a/kappaModel.bin ${pathTemporary}/model$scriptversion.bin
	./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${expData} <${pathCommands}/kappa$scriptversion.txt | awk 'NR >=92' > ${pathRecon}/gene$a.txt


	#or else its delta
	else 
	cp ${pathResults}/gene$a/deltaModel.bin ${pathTemporary}/model$scriptversion.bin
	./../BayesTraitsV2/BayesTraitsV2 ${pathData}/${tree} ${expData} <${pathCommands}/delta$scriptversion.txt | awk 'NR >=92' > ${pathRecon}/gene$a.txt

	fi
	done
