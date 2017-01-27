# Chimaera
Clonality Inference from Mutations Across Biopsies.


The software will take as input a file or a collection of files with reference and alternative read counts, VAFs, and copy numbers of mutations commonly occurring in multiple biopsies. The output is the corresponding cluster cellularities of these mutations after clustering. Subclone usage within each biopsy can be calculated by division of the cluster cellularity matrix by the corresponding tumor heterogeneity tree matrix using non-negative matrix factorization. The tree matrix generation is beyond the scope of this program, but can be generated using other software, e.g., SCHISM.
The provided pipeline consists of four scripts that should be run in sequence. This is a DOS version and can be run on a Windows PC, but it can be easily adapted for Linux too. Two subdirectories are required for the analysis (input and Cellularities). The names can be changed after the analysis to keep the analyzed data. Sample files are provided. The input format should be the same as in the examples, but the number of biopsies can be different. The Cellularities folder will contain all intermediate files and the *opt.tsv file that will contain optimized cluster cellularity.  The input folder can contain multiple files (they will be analyzed in the same run).  To run the pipeline, execute RunPipeline.bat (Windows) or RunPipeline.sh (Linux/Unix).

Requirements:
R environment with tidyr and tclust packages installed
Perl

This software release accmpanies a paper submission "Inferring clonal composition from multiple tumor biopsies". The paper's prepring is available from arXiv. Chimæra was used to analyze WES profiles of CRPC biopsies. These, together with blood controls, are available from ENA project PRJEB19193. The data is encoded as follows:


LibraryID	Biopsy
JAD-1C	1
JAD-23C	2
JAD-24C	3
JAD-4C	4
JAD-5C	5
JAD-6C	6
JAD-7C	7
JAD-25C	8
JAD-9C	9
JAD-26C	10
JAD-11C	Normal
