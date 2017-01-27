# Chimaera
Chimæra: Clonality Inference from Mutations Across Biopsies. Chimæra estimates mutation frequencies from WES of tumors with genomic instability. Chimæra relies on multiple biopsies for the same tumor to, first, approximate CNVs and mutation frequencies; then, identify mutations with similar approximate frequencies and associate them with subclones; and, finally, to estimate the true frequencies of these mutations and the associated subclones. The development of Chimæra was primarily sponsored by European Union’s Horizon 2020 research and innovation programme under grant agreement 668858 to the PrECISE consortium. The PrECISE project maintains webpage at http://www.precise-project.eu.

The software will take as input a file or a collection of files with reference and alternative read counts, VAFs, and copy numbers of mutations commonly occurring in multiple biopsies. The output is the corresponding cluster cellularities of these mutations after clustering. Subclone usage within each biopsy can be calculated by division of the cluster cellularity matrix by the corresponding tumor heterogeneity tree matrix using non-negative matrix factorization. The tree matrix generation is beyond the scope of this program, but can be generated using other software, e.g., SCHISM.
The provided pipeline consists of four scripts that should be run in sequence. This is a DOS version and can be run on a Windows PC, but it can be easily adapted for Linux too. Two subdirectories are required for the analysis (input and Cellularities). The names can be changed after the analysis to keep the analyzed data. Sample files are provided. The input format should be the same as in the examples, but the number of biopsies can be different. The Cellularities folder will contain all intermediate files and the *opt.tsv file that will contain optimized cluster cellularity.  The input folder can contain multiple files (they will be analyzed in the same run).  To run the pipeline, execute RunPipeline.bat (Windows) or RunPipeline.sh (Linux/Unix).

Requirements:
R environment with tidyr and tclust packages installed
Perl

This software release accmpanies a paper submission "Inferring clonal composition from multiple tumor biopsies". The paper's preprint is available for download from arXiv. Chimæra was used to analyze WES profiles of CRPC biopsies. These (fastq files), together with blood controls, are available for download from ENA project PRJEB19193. The data is encoded as follows:


LibraryID	Biopsy
<Br>
JAD-1C  1 
<Br>
JAD-23C	2
<Br>
JAD-24C	3
<Br>
JAD-4C	4
<Br>
JAD-5C	5
<Br>
JAD-6C	6
<Br>
JAD-7C	7
<Br>
JAD-25C	8
<Br>
JAD-9C	9
<Br>
JAD-26C	10
<Br>
JAD-11C	Normal
