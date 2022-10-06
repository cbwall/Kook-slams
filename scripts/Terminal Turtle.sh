################## ################## ################## 
# "Terminal Turtle" -- check out the how to guide and workflow
# https://astrobiomike.github.io/amplicon/dada2_workflow_ex
################## ################## ##################

################## --------  Cut Adapt on local machine


###########---Setup and getting conda and cutadapt to play nice

# Use this terminal script for pipeline processing
# download conda
curl -LO https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-MacOSX-x86_64.sh

# download Bioconda
# first add the bioconda and conda-forge channel
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict

# install Cutadapt into a new Conda environment, use this command:
conda create -n cutadaptenv cutadapt

################## -------- ################## -------- ################## --------
# For me, running this in R and having gone through the set up above, I start here:
################## -------- ################## -------- ################## --------

#  activate the environment. 
# This needs to be done every time you open a new shell before you can use Cutadapt:
conda activate cutadaptenv

# did it work?
cutadapt --version


##################--- trouble shooting
# No?
# do you have Xcode? You will need this for commandline in Mac
xcode-select --install # will open a dialog for installation of the command line tools.

# still have issues? try with python
python3 -m pip install --user --upgrade cutadapt
cutadapt --version

# Seriously?
# To install this package run one of the following from Bioconda https://anaconda.org/bioconda/cutadapt
conda install -c bioconda cutadapt
conda install -c "bioconda/label/cf201901" cutadapt

# STILL?!?! 
brew install cutadapt
##################--- end
################## -------- ################## -------- ################## --------


################## -------- ################## --------################## --------
################## -------- CUTADAPT PREPROCESSING ################## --------
# now that cutadapt is in, some basics

# print directory
pwd

# go back one folder in directory 
cd ..

# go to last directory
cd -

# if you are using R Projects, your directory will be the .Rproject where you have all your files and folders
# this should look like the github repo page...
# so on any device, calling "pwd" yields: "computer:Kook-slams user$"

##### do some setup for processing:
# make a folder names "trimmed" and output 
# (if you pull the repo from github this isn't necessary)

mkdir data/fastq/trimmed
mkdir output

### let's grab the files and make sample names
# list the files in the directory,  then grab the important info and export

# a loop that selects the fastq files in data folder, extracting names from those marked as R1 (so no repeats)
# this will make a name file for ONLY the forward reads (R1)
for i in data/fastq/
do echo $i
ls $i | grep R1 | grep fastq.gz | sed 's/\(.*\)_\(.*_\)\(.*\)_/\1|\2/;s/|.*//' > output/short_SampleList.txt
done

####--- alternatives to get different types of sample names
## only grabs the R1 samples, keeping statement in 1-4 (before the first _ and after the third_)
# ls data/fastq/ | grep R1 | grep fastq.gz |cut -f 1-4 -d "_" > output/samples.singles.txt
####--- 

## let's grabs all sample names from all files (R1 and R2), we will use this later
ls data/fastq/ | grep fastq.gz |cut -f 1-4 -d "_" > data/fastq/samples.txt

# did it work?
cat data/fastq/samples.txt

# are the raw files zipped (.gz) or not (.fastq)
ls data/fastq/

# unzip sequence files, if necessary
gunzip data/fastq/*.fastq.gz


################## -------- ################## --------################## --------
################## -------- READY TO RUN CUTADAPT ################## --------

# here our 16S primers have mixed concentrations of nucelotides to account for degeneracy,
# Y = equal molar mix of C or T
# M = A or C
# N = any base
# V = A, C, or G
# W = A or T

# what is cut adapt doing here?
# -g ADAPTER for forward primer/adapter
# -G adapter for reverse primer/adapter
# -o for output of forward read
# -p for output of reverse read
# -m for minimum and -M for maximum read length

# but make sure you are in the directory for the project (i.e., in the '/Kook-slams' folder)
# also, the \ here are just to ignore line returns and make the code less vomit-y

for SAMPLEID in $(cat data/fastq/samples.txt);
do
    echo "On sample: $SAMPLEID"
    cutadapt -g GTGYCAGCMGCCGCGGTAA -G GGACTACNVGGGTWTCTAAT \
    -o data/trimmed/${SAMPLEID}_R1_trimmed.fastq \
    -p data/trimmed/${SAMPLEID}_R2_trimmed.fastq \
    data/fastq/${SAMPLEID}_L001_R1_001.fastq \
    data/fastq/${SAMPLEID}_L001_R2_001.fastq \
	>> output/cutadapt_primer_trimming_stats.txt 2>&1
done

# by adding the ".gz" for the output for forward and reverse, it will compress the files for us
# example: -o data/trimmed/${SAMPLEID}_R1_trimmed.fastq.gz \

# to rezip, def need to do this if pushing to github
gzip data/fastq/*.fastq # rezip the raw data
gzip data/trimmed/*.fastq  # no need if output rezips for you


################## --------################## -------- ################## --------
################## -------- EVALUATING CUTADAPT ################## --------
# do these steps while everything is in unzipped form

### R1 BEFORE TRIMMING PRIMERS
## the "TAAGGCGA+TAGATCGC" in the first line is the i7 and i5 index 
head -n 2 data/fastq/CBW_01_16S_S1_L001_R1_001.fastq
head -n 2 data/trimmed/CBW_01_16S_S1_R1_trimmed.fastq
# can see the start nucelotides are removed (N-TGTCAGCAGCCGCGGTAA)
# the "N" is weird, should be "G" but is likely something from the sequencing run
# luckily cut-adapt has an allowance for error at ~3 nucleotides


####### # how many times does the primer sequence turn up in the sample?
# use '-s' to suppress warnings
# must use exact matches so change primers accordingly
# make SURE in the directory where the files exist, let's chance the wd

cd data/fastq/
grep "GTGCCAGCCGCCGCGGTAA" CBW_01_16S_S1_L001_R1_001.fastq | wc -l 
# this shows 986 occurrences in the orignal

cd - # reverts to project directoty

# let's look at the trimmed files
cd data/trimmed/
grep "GTGCCAGCCGCCGCGGTAA" CBW_01_16S_S1_R1_trimmed.fastq | wc -l 
# this shows 0 occurrences for primer in the trimmed -- GOOD!

#####  WE DID IT!!!! SO PITTED!!! ######


################## -------- 
# this is a good point to push the trimmed files to GitHub (if you're using your own repo)
# the unzipped fastq raw and trimmed files are too large to be pushed
################## -------- 

#rezip and move to DADA2
cd -
gzip data/fastq/*.fastq # these can go back to zip, won't use later
gzip data/trimmed/*.fastq # rezip these too

# if files <10MB can go to REPO (check to avoid an error that eats a day!)

################## ################## ##################
# --- BOOM
# output looks good, primers removed, not onto processing with DADA2
# let's move into DADA2 in the Rmarkdown.
################## ################## ##################

