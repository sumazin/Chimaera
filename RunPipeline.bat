
perl VAF_CN_2Cellularity.pl -m input -p 0.9 -o Cellularities
Rscript ClusterCel_ElbowSSE.R --inputf Cellularities/Exome_sample_data.mutation.cellularity
perl VAF_CN_2VAF_CN_ClusterID.pl -m input -c Cellularities -e .mutation.cellularity.cluster -o Cellularities
Rscript CorrectionOfClusteredCellularities.R --inputf Cellularities/Exome_sample_data.B.txt

