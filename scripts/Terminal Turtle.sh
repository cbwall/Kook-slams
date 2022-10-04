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

# now that cutadapt is in, let's grab the files and make sample names
# list the files in the directory,  then grab the important info and export
ls data/fastq/ | sed 's/_L[[:digit:]]\+_.*//g' > samples.txt

# did it work?
head samples.txt

