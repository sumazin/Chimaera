use Getopt::Std;
getopt ('mpo');  # m VAF_CN dir, p purity, e.g., 0.9, o output dir

%Mut = ();


opendir (DIR, $opt_m) or die "Error in opening dir $opt_m\n";
while (my $file = readdir(DIR))
{
    if($file =~ /.txt/) 
    {
        
        open (FD_IN, "$opt_m/$file") || die "Error opening $file";
        
        $fn = $file;
        $fn =~ s/.txt//;
        open (FD_CEL, ">$opt_o/$fn.mutation.cellularity") || die "Error opening $opt_o/$fn.mutation.cellularity";
        print FD_CEL "sampleID\tmutationID\tcellularity\tsd\n";

        @SampleIDs = ();
        while($line = <FD_IN>) 
        {
            #if ($line =~ /^#/) {next;}
            
            if ($line =~ /^Mutation/)
            {
                @w = split(/\t/, $line);

                $ColN = @w;
                for($j=0;$j<($ColN-1)/4;$j++)
                {
                    $ID = $w[$j*4+1];
                    $ID =~ s/\.Ref//;
                    push @SampleIDs, $ID;
                }
                
                next;
            }
            
            
            @w = split(/\t/, $line);
            
            $Mut_ID = $w[0];
            
            for($j=0;$j<($ColN-1)/4;$j++)
            {
                $VAF = $w[$j*4+3];
                $CN = $w[$j*4+4];
                $DP = $w[$j*4+1] + $w[$j*4+2];
                
                $Cel = 2*$VAF*$CN/($CN - 2*(1-$opt_p));
                print "$j  samid:$SampleIDs[$j]   vaf:$VAF\n";
                $SD = (2*$CN/$opt_p)*sqrt($VAF*(1-$VAF)/$DP);
                
                $Mut{"$j:$Mut_ID"}[0] = $SampleIDs[$j];  
                $Mut{"$j:$Mut_ID"}[1] = $Mut_ID;
                $Mut{"$j:$Mut_ID"}[2] = $Cel;
                $Mut{"$j:$Mut_ID"}[3] = $SD;
                
            }
            
        }
        close(FD_IN);
 

    foreach $mut_id(sort {$a cmp $b} keys %Mut)
    {
        
        if ($Mut{$mut_id}[2] == 0)
        {
            next;
        }
        if ($Mut{$mut_id}[2] > 1)
        {
            $Mut{$mut_id}[2] = 1;
        }
        print FD_CEL "$Mut{$mut_id}[0]\t$Mut{$mut_id}[1]\t$Mut{$mut_id}[2]\t$Mut{$mut_id}[3]\n";
    }



close(FD_CEL);


       
    }
}
closedir(DIR);
