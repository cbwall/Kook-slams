###########--- Cut Adapt on local machine
# "Listen to Turtle" -- check out the how to guide and workflow
# https://astrobiomike.github.io/amplicon/dada2_workflow_ex


# Use this terminal script for pipeline processing
# download conda
curl -LO https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-MacOSX-x86_64.sh

# download Bioconda
# first add the bioconda and conda-forge channel
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict

#### Now... 
# install Cutadapt into a new Conda environment, use this command:
conda create -n cutadaptenv cutadapt

# Then activate the environment. 
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
# now that cutadapt is in, some basics

# print directory
pwd

# go back one folder in directory 
cd ..

# go to last directory
cd -

# before we go too far....
# make a folder names "trimmed" and output
mkdir data/fastq/trimmed
mkdir output

### let's grab the files and make sample names
# list the files in the directory,  then grab the important info and export

# a loop that selects the fastq files in data folder, extracting names from those marked as R1 (so no repeats)
for i in data/fastq/
do echo $i
ls $i | grep R1 | grep fastq.gz | sed 's/\(.*\)_\(.*_\)\(.*\)_/\1|\2/;s/|.*//' > output/short_SampleList.txt
done

####--- alternatives to get different types of sample names
## only grabs the R1 samples, keeping statement in 1-4 (before the first _ and after the third_)
# ls data/fastq/ | grep R1 | grep fastq.gz |cut -f 1-4 -d "_" > output/samples.singles.txt

## grabs all sample names from all files (R1 and R2)
ls data/fastq/ | grep fastq.gz |cut -f 1-4 -d "_" > data/fastq/samples.txt
####---

# did it work?
cat data/fastq/samples.txt

# unzip sequence files, if necessary
gunzip data/fastq/*.fastq.gz

# run cutadapt
# but make sure you are in the directory for the project (i.e., in the '/Kook-slams' folder)
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

# to rezip, def need to do this if pushing to github
gzip data/fastq/*.fastq
gzip data/trimmed/*.fastq


