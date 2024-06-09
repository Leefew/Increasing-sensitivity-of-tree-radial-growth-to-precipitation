## regional curve standardization 
## Step1
library(dplR)
setwd('F:\\few\\tree ring\\africa')
files <- list.files(path="F:\\few\\tree ring\\africa\\step1", pattern="*.rwl", full.names=T, recursive=FALSE)
for (currentFile in files) {
  file <- read.rwl(currentFile)
  po.names <- colnames(file)
  po <- data.frame(rep(1,length(po.names)),row.names=po.names,check.rows = FALSE, check.names = FALSE)
  write.table(po,"po.txt",sep="\t", quote=FALSE, row.names=TRUE, col.names=FALSE)
  po1 <- read.table("po.txt")
  detrended <- cms(file, po1, c.hat.t = FALSE, c.hat.i = FALSE)
  chornos <- chron(detrended, prefix = "ch", biweight = TRUE)
  write.table(chornos, file=sub(pattern=".rwl$", replacement="_RCS.txt", x=currentFile),sep="\t", quote=FALSE, row.names=T, col.names=T)
}

########################################################
## Step2
setwd('F:\\few\\tree ring\\africa\\step2')
files_all <- list.files(pattern="*.txt", full.names=T, recursive=FALSE)
for (currentFile in files_all){
  file <- read.table(currentFile, header=T)
  currentNames1 <- sub(pattern="_RCS.txt", replacement="", x=currentFile)
  currentNames1 <- as.character(currentNames1)
  currentNames2 <- sub(pattern="./", replacement="", x=currentNames1)
  names(file)[1] <- currentNames2
  file$year <- rownames(file) 
  file_new <- file[which(file$samp.depth>=5),]
  file_new <- file_new[,-2]
  write.table(file_new, file=sub(pattern=".txt", replacement="_new.txt", x=currentFile),sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)
}

########################################################
## Step3
setwd('F:\\few\\tree ring\\africa\\step3')
files_all <- list.files(pattern="*.txt", full.names=T, recursive=FALSE)
files_all2 <- lapply(files_all, read.table, header=T)
a = Reduce(function(...) merge(..., all=T), files_all2)
write.table(a, file=("alldata.txt"),sep="\t", quote=FALSE, row.names=FALSE, col.names=TRUE)