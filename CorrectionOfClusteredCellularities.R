rm(list=ls(all=TRUE))

myf = function(delt_cel,m,numBiopsies) {
  len = length(delt_cel)
  len2 = len - numBiopsies + 1
  len3 = len2 - 1
  norm((delt_cel[0:len3] %o% delt_cel[len2:len]) - m,"f")
}


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


fn=options.args[1] #"t=1.CNa=1.SDa=1.CNb=1.SDb=1.CNc=1.SDc=1.B.txt"

df = read.table(fn,header=T,stringsAsFactors=T)

numClusters = length(unique(df$ClusterID))
numBiopsies = (ncol(df) - 2)/2
ind2 = numBiopsies + 2
ind3 = ind2 + 1
ind4 = ind2 + numBiopsies


dfOpt = df[,1:ind2]
names(dfOpt) <- gsub("X","", names(dfOpt), fixed=T)
names(dfOpt) <- gsub(".VAF","", names(dfOpt), fixed=T)


for(i in 1:numClusters) 
{
  f = df[df$ClusterID==i,3:ind2]
  c = df[df$ClusterID==i,ind3:ind4]
  m = f*c
  write(i, stdout())
  ndelt = nrow(c)
  ncel = ncol(f)
  
  m = as.matrix(m) 
  
  opt = optim(
    par=c(rep(1,ndelt),runif(ncel, min = 0, max = 1)),
    fn = myf,
    m = as.matrix(m), 
    numBiopsies = numBiopsies,
    method = "L-BFGS-B",
    upper = c(rep(4,ndelt),rep(1,ncel)), lower = c(rep(0,ndelt),rep(0,ncel))
  )

  ind5=ncel+2
 
  
  for(j in 3:ind5)
  {
    k = ndelt - 2 + j
    dfOpt[dfOpt$ClusterID==i,j] = opt$par[k]
  }
  
  
}

ci = dfOpt$ClusterID
dfOpt[dfOpt>1] = 1
dfOpt$ClusterID = ci

sn = gsub(".B.txt","",fn)
write.table(dfOpt, file=paste(sn,'.opt.tsv', sep=''), sep="\t", quote = F, row.names = F) 

