# Kook-slams
*Disclaimer* -- this is not an authorative pipeline tutorial. I am learning, you probably are too, hopefully this helps!  
Also, this repo will be loaded with surf jargon, as well as reference to the all time classic 1987 surf film [*North Shore.*](https://www.imdb.com/title/tt0093648/)  
  
If you haven't seen it, go watch it **IMMEDIATELY**. 

<img src="https://beachgrit.com/wp-content/uploads/2022/02/24177195_401536426942206_155723050587185162_n.jpg" width="50%" height="50%">

## Learning the bioinformatic pipeline for microbiome analyses (16S and 18S).  
> A few solid turns, but mostly KOOK SLAMS.  

Data here comes from water sampling in the Eastern Sierras, where water was collected and filtered onto Sterivex filters, and DNA extracted using the Qiagen PowerWater Sterivex Kit. DNA from the V4 region of the 16S-rRNA gene was amplified using Illumina overhangs and the 515F-Parada and 806R-Apprill primer set for 16S and the TAReuk454FWD1 and TAReukREV3 primter set for 18S. Unique barcades were annealed to samples using PCR and Nextera-XT i7 and i5 barcodes. Sequencing 16S and 18S amplicons was performed using a MiSeq 600 (300-PE) in a single run.

> *16S-primers*: yields ~290 bp amplicon from v4 region of prokaryote 16S-rRNA gene  
> 515F-Parada (also called '515F-Y'): 5'-GTGYCAGCMGCCGCGGTAA-3'   
> 806R-Apprill: 5'-GGACTACNVGGGTWTCTAAT-3'  
> References: [Parada et al. 2016](http://dx.doi.org/10.1111/1462-2920.13023) and [Apprill et al., 2015](http://www.int-res.com/abstracts/ame/v75/n2/p129-137/)

> *18S-primers*: yields ~500 bp amplicon from v4 region of eukaryotic 18S-rRNA gene  
> TAReuk454FWD1: 5′-CCAGCASCYGCGGTAATTCC-3′  
> TAReukREV3: 5′-ACTTTCGTTCTTGATYRA-3′  
> References: [Schulhof et al. 2020](http://dx.doi.org/10.1111/mec.15469) and [Bertrand et al. 2015](https://www.pnas.org/doi/epdf/10.1073/pnas.1501615112)

## What's the surf report?
This tutorial leverages other online tutorial workflows for processing fastq files through cut-adapt and DADA2. It will use R, Rstudio, and Terminal shell scripts that run through Terminal in RStudio. I find working with the shell scripts in RStudio is much easier (and more familiar) than coding directly from a .txt file.  

This workflow will use a small number of fastq files and demonstrate how you can:  
(1) run cut-adapt in terminal (trimming primers/adapters)  
(2) examine cut-adapt outputs   
(3) process samples and examing quality scores through DADA2 (filtering)  
(4) build taxonomic tables (ASV tables) in phyloseq  

...more? we'll see where it goes...  

## Listen to Turtle  
> "When wave breaks here, don't be there!"
> -Turtle 

I am standing on (or paddling in over) the shoulder of giants, so use these other resources! As I am literally stuck in a rip current.  
  
*These resources include*:  
The ultimate paddleout guides -- i.e, how to work through your 16S pipeline:  
https://astrobiomike.github.io/amplicon/dada2_workflow_ex  
https://benjjneb.github.io/dada2/tutorial.html

Dialing those cut backs -- i.e, working with cut-adapt:  
https://cutadapt.readthedocs.io/en/stable/index.html  

In the green room -- i.e, working with microbiome data:  
https://www.cd-genomics.com/bioinformatics-analysis-of-16s-rrna-amplicon-sequencing.html  

Happy coding!  
Shoots!  

<img src="https://wavearcade.com/wp-content/uploads/2020/01/frustrationshaka-1024x526.jpg" width="50%" height="50%">



