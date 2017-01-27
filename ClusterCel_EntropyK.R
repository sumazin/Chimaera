rm(list=ls(all=TRUE))


library("tclust")


#file name
args <- commandArgs(trailingOnly="T")

hh <- paste(unlist(args),collapse=' ')
listoptions <- unlist(strsplit(hh,'--'))[-1]
options.args <- sapply(listoptions,function(x){
  unlist(strsplit(x, ' '))[-1]
})
options.names <- sapply(listoptions,function(x){
  option <-  unlist(strsplit(x, ' '))[1]
})
names(options.args) <- unlist(options.names)
print(options.args)


fn = options.args[1]

print(paste("fn:",fn))


sn = gsub(".txt","",fn)

#NumClust = 6
#if(grepl('^t=6', sn)){NumClust = 7}
#if(grepl('^t=8', sn)){NumClust = 7}
#if(grepl('^t=9', sn)){NumClust = 7}
#if(grepl('^t=10', sn)){NumClust = 8}


snv_df = read.table(fn,header=T)#,skipNul = T,fill = T)

library("tidyr")

snv_mv_df = spread(snv_df[,c(1,2,3)], sampleID, cellularity)
snv_mv_df[is.na(snv_mv_df)] <- 0 #missing values are 0s

#NumClust = as.integer(options.args[2]) #args[3]
output <- clustCombi(snv_mv_df[,-1]) 

#entPlot(output$MclustOutput$z, output$combiM, abc="standard", reg = c(2,3))

combiM <- output$combiM
Kmax <- ncol(output$MclustOutput$z)
z0 <- output$MclustOutput$z
ent <- numeric()


for (K in Kmax:1) {
  z0 <- t(combiM[[K]] %*% t(z0))
  ent[K] <- -sum(mclust:::xlog(z0))
}
EntMax = max(ent)
#dfEnt = data.frame(`Number of clusters` = 1:Kmax, `Entropy` = round(ent, 12), `EntPercent` = ent*100/EntMax)

for (K in 2:Kmax) {
  if((ent[K] - ent[K-1])/EntMax > 0.2){Kent = K-1; break;} # >= 20% increase will count as elbow
}

NumClust = Kent


# increasing alpha makes clustering more stringent
a = 0.15 #0.15 #0.5 #reset to 0.15 for n=3
NumPairLT95 = 100

#while(a <= 1 & NumPairLT95 > 0)
# remove the worst mutation in each cluster and recluster (if at least one pair has cor < 0.95)
count = 0
while(NumPairLT95 > 0)
{
  NumPairLT95 = 0
  
  #Z = tclust (snv_mv_df[,- c(1,ncol(snv_mv_df))], k = NumClust, alpha = a, restr.fact = 12, iter.max = 1000)
  Z = tclust (snv_mv_df[,- 1], k = NumClust, alpha = a, restr.fact = 12, iter.max = 1000)
  snv_mv_df$ClusterID = Z$cluster
  count = count + 1
  #if(count <= 1)#==1)
  #{
  #  snv_mv_df = snv_mv_df[!snv_mv_df$ClusterID==0,] #deleting outliers on the first iteration to avoid cluster drift
  #  next
  #}
  
  #Examine each cluster
  for(c in 1:NumClust)
  {
    temp = snv_mv_df[snv_mv_df$ClusterID==c,]
    if(nrow(temp) <= 2){next}
    mut_IDs = temp[1]
    mut_IDs$counts = rep(0,nrow(mut_IDs))
    temp[1] = NULL
    temp[ncol(temp)] = NULL
    #rownames(temp) = c(1:nrow(temp))
    temp = as.matrix(temp)
    
    b = combn(nrow(temp),2) #all pairs of combinations in columns of two rows
    for(i in 1:ncol(b))
    {
      #print(paste("b1:",temp[b[1,i],],"b2:",temp[b[2,i],]))
      if(is.na(cor(temp[b[1,i],],temp[b[2,i],]))){next}
      if(cor(temp[b[1,i],],temp[b[2,i],]) < 0.85)#0.95)
      {
        NumPairLT95 = NumPairLT95 + 1
        #find the worst mutation
        mut_IDs[b[1,i],2] = mut_IDs[b[1,i],2] + 1
        mut_IDs[b[2,i],2] = mut_IDs[b[2,i],2] + 1
      }
    }
    print(paste("cluster: ",c,"  mutation pairs with cor < 0.95 (including previous clusters):",NumPairLT95))
    
    #delete the worst ones (with the highest counts)
    if(max(mut_IDs[,2]) > 0)
    {
      worst = mut_IDs[mut_IDs[,2]==max(mut_IDs[,2]),1]
      snv_mv_df = snv_mv_df[!snv_mv_df[,1] %in% worst,]
    }
    
  }
  
  print(paste("alpha: ",a,"   number of mutation pairs with cor < 0.95:",NumPairLT95))
  #a = a + 0.01
}




TC = Z$cluster #Z$classification

print("Z:");
print(Z);

print("TC:")
print(TC)


rows = nrow(snv_mv_df)
a = which(table(snv_mv_df$Clust)>=2)  #0.02*rows) 2 % was too stringent, it is enough to have  at least 3 mutations in a cluster

#remove classes with less then 2% of the count 
snv_mv_df = snv_mv_df[snv_mv_df$Clust %in% names(a),]  # <---- Clustered SNVs 


write.table(snv_mv_df[snv_mv_df[ncol(snv_mv_df)]!="0",], file=paste(sn,'.cluster', sep=''), sep="\t", quote = F, row.names = F) 


