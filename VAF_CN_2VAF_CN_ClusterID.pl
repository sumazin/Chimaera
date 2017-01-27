use Getopt::Std;
getopt ('mceo');  # m VAF_CN dir, c cluster dir, e ending of the cluster file, e.g. .MyCel.cluster (the other part identical to m without .txt, o output dir

%Mut = ();


opendir (DIR, $opt_m) or die "Error in opening dir $opt_m\n";
while (my $file = readdir(DIR))
{
    if($file =~ /.txt/) 
    {
        
        open (FD_IN, "$opt_m/$file") || die "Error opening $file";
        
        $fn = $file;
        $fn =~ s/.txt//;
        open (FD_CEL, ">$opt_o/$fn.B.txt") || die "Error opening $opt_o/$fn.B.txt";
        

       
      
        open (FD_C, "$opt_c/$fn$opt_e") || die next; #"Error opening $opt_c/$fn$opt_e";
        while($line = <FD_C>) 
        {
            chomp $line;
            if ($line =~ /^mutationID/)
            {
                next;
            }
            
                @w = split(/\t/, $line);
                $sz = @w;
                $Mut{$w[0]} = $w[$sz-1]; # Cluster ID
                print "m:$w[0]  cl:$Mut{$w[0]}\n";
        }
        close(FD_C);
        
        
         while($line = <FD_IN>) 
        {
            chomp $line;
            
            if ($line =~ /^Mutation/)
            {
                
                @w = split(/\t/, $line);
                $w[0] = "MutID\tClusterID\t";
                $head = $w[0];
                $sz = @w;
                for($i=3;$i<$sz;$i+=4)
                {
                    $head .= "$w[$i]\t";
                }
                for($i=4;$i<$sz;$i+=4)
                {
                    $head .= "$w[$i]\t";
                }
                chop $head;
                print FD_CEL "$head\n";
               next;
            }
            
            
            @w = split(/\t/, $line);
            if (not exists $Mut{$w[0]}) {next;}
            
            $w[0] = "$w[0]\t$Mut{$w[0]}\t";
                $sz = @w;
                $d=$w[0];
                for($i=3;$i<$sz;$i+=4)
                {
                    $d .= "$w[$i]\t";
                }
                for($i=4;$i<$sz;$i+=4)
                {
                    $d .= "$w[$i]\t";
                }
                chop $d;
                print FD_CEL "$d\n";
            
            
       }
        close(FD_IN);
        


close(FD_CEL);
       
    }
}
closedir(DIR);


