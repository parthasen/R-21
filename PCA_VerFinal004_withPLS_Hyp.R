#functions for a smooth PCA analysis
#display, choose PCs and plot ... do not use MATLAB
############################################
############################################

library(hyperSpec)
library(rgl)
library(RColorBrewer)
library(pls)

############################################ 
############################################ 
############################################ 

readDataHyp <- function(name = FALSE)
{
  cat("Do you have a conc./density file prepared to be loaded? Press '1' and <RETURN> to load the file or '0' and <RETURN> to skip ...")
  cat(sep = "\n")
  cat(sep = "\n")
  ua <- readline()
  cat(sep = "\n")
  cat(sep = "\n")
  ############################################ -> read user answer into ua
  if(ua == 1){
    cat("Choose your spectra file first ...")
    cat(sep = "\n")
    cat(sep = "\n")
    #if(name != FALSE){
     # path <- paste("T:/Technik/Spektroskopie/UserData_p-mbe/IC 940 Professional Vaio/Project/Sugars/DecompositionExperiments/", name, ".csv", sep="")
      ############################################ -> path of the spectra file (csv)
    path <- file.choose()  
    cat("Now choose your conc./density file ...")
    cat(sep = "\n")
    cat(sep = "\n")
    path2 <- file.choose()
    spc <- t(read.csv(path, skip = 3, header = T, sep = ";"))
    concD <- read.csv(path2, skip = 0, header = T, sep = ";")
    concD <- as.data.frame(concD)
    wl <- spc[1,];
    spc <- spc[-1,];
    
    colnames(spc) <- sprintf("wl_%5.1f",wl);
    rownames(spc) <- 1:dim(spc)[1];
    
    spc.hyper <- new("hyperSpec", wavelength = wl, spc = spc, labels = list(.wavelength =   "Wavelength in nm", spc = "Absorbance"), data = data.frame(sample = rownames(spc), conc = concD))
    ############################################ -> read csv into pca.spc
    
    smplNo <- dim(spc)[2];
    cat(paste("File read ... dimensions of data file ...", smplNo, "variables,", dim(spc)[1],"samples. Use model <- doPCA(YourData) or model  <- doPLS(YourData, ncomp) for further investigation ..."))
    cat(sep = "\n")
    cat(sep = "\n")
    ############################################ -> print the dimensions of the file (rows and samples)
  }
  else{
    cat(sep = "\n")
    cat(sep = "\n")
    cat("Choose your spectra file ...")
    cat(sep = "\n")
    cat(sep = "\n")
    path <- file.choose() 
    spc <- t(read.csv(path, skip = 3, header = T, sep = ";"))
    #dens <- read.csv(path2, skip = 0, header = F, sep = ";")
    wl <- spc[1,];
    spc <- spc[-1,];
    
    colnames(spc) <- sprintf("wl_%5.1f",wl);
    rownames(spc) <- 1:dim(spc)[1];
    
    spc.hyper <- new("hyperSpec", wavelength = wl, spc = spc, labels = list(.wavelength =   "Wavelength in nm", spc = "Absorbance"), data = data.frame(sample = rownames(spc), conc = dens))
    ############################################ -> read csv into pca.spc
    
    smplNo <- dim(spc)[2];
    cat(paste("File read ... dimensions of data file ...", smplNo, "variables,", dim(spc)[1],"samples. Use model <- doPCA(YourData) or model  <- doPLS(YourData, ncomp) for further investigation ..."))
    cat(sep = "\n")
    cat(sep = "\n")
    ############################################ -> print the dimensions of the file (rows and samples)
  }
  return (spc.hyper);
}

############################################ 
############################################ 
############################################ 

readData <- function(name = FALSE)
{
  if(name != FALSE){
    path <- paste("T:/Technik/Spektroskopie/UserData_p-mbe/IC 940 Professional Vaio/Project/Sugars/DecompositionExperiments/", name, ".csv", sep="")
    ############################################ -> path of the file (csv)
  }
  
  else{
    path <- file.choose() 
    ############################################ -> choose path of the file (csv)
  }
  spc <- t(read.csv(path, skip = 3, header = T, sep=";"))
  wl <- spc[1,];
  spc <- spc[-1,];
  colnames(spc) <- sprintf("wl_%5.1f",wl);
  rownames(spc) <- 1:dim(spc)[1];
  ############################################ -> read csv into pca.spc
  
  smplNo <- dim(spc)[1];
  cat(paste("File read ... dimensions of data file ...", dim(spc)[2], "variables,", smplNo, "samples. Use model <- doPCA(YourData) for further investigation ..."))
  ############################################ -> print the dimensions of the file (rows and samples)
  return (spc);
}

############################################ 
############################################ 
############################################ 

doPCA <- function(data = FALSE)
{
  if(typeof(data) == "S4"){
    pca.hyp <- data$spc
    cat("Doing some PCA with your hyperSpec object ...")
    #smplNo <- dim(data)[2] - 1;
    ############################################ -> get number of samples to extract data
    
    cat(sep = "\n")
    cat("Plotting you the screeplot ... look at the PCs ...")
    ############################################ -> screeplot is being prepared, pca has to be done first
    
    #smplNo1 <- smplNo + 1;
    #mat <- as.matrix(data[2:smplNo1])
    ############################################ -> extract samples, first column is no sample
    
    #Tmat <- t(mat);
    ############################################ -> transpose matrix
    
    #dTmat <- as.data.frame(mat);
    ############################################ -> read in as data.frame (better to handle)
    
    pca.mod <- prcomp(pca.hyp, retx = T, center = F);
    ############################################ -> do the pca, for scores retx = T, center = F, otherwise another result (than MATLAB) is being obtained
    
    plot(pca.mod, type = "l", main = "Screeplot")
    cat(sep = "\n")
    cat(sep = "\n")
    cat("Kaiser's criteria ...")
    cat(sep = "\n")
    cat(sep = "\n")
    print((pca.mod$sdev)^2)
    cat(sep = "\n")
    cat(sep = "\n")
    cat("Scroll up for Kaiser's criteria ...")
    cat(sep = "\n")
    cat(sep = "\n")
    ############################################ -> plot screeplot
    
    cat("Done ... continue with plotLoadingsPCA(PC1, PC2, PC3, model) or plotScoresPCA(PC1, PC2, PC3, model) ... ")
    ############################################ -> print out the usable functions
    return(pca.mod);
  }
  else{
    if(data == FALSE){
      cat("You forgot the data file ...")
    }
    else{
      #smplNo <- dim(data)[2] - 1;
      ############################################ -> get number of samples to extract data
      
      cat(sep = "\n")
      cat("Plotting you the screeplot ... look at the PCs ...")
      ############################################ -> screeplot is being prepared, pca has to be done first
      
      #smplNo1 <- smplNo + 1;
      #mat <- as.matrix(data[2:smplNo1])
      ############################################ -> extract samples, first column is no sample
      
      #Tmat <- t(mat);
      ############################################ -> transpose matrix
      
      #dTmat <- as.data.frame(mat);
      ############################################ -> read in as data.frame (better to handle)
      
      pca.mod <- prcomp(data, retx = T, center = F);
      ############################################ -> do the pca, for scores retx = T, center = F, otherwise another result (than MATLAB) is being obtained
      
      plot(pca.mod, type = "l", main = "Screeplot")
      cat(sep = "\n")
      cat(sep = "\n")
      cat("Kaiser's criteria ...")
      cat(sep = "\n")
      cat(sep = "\n")
      print((pca.mod$sdev)^2)
      cat(sep = "\n")
      cat(sep = "\n")
      cat("Scroll up for Kaiser's criteria ...")
      cat(sep = "\n")
      cat(sep = "\n")
      ############################################ -> plot screeplot
      
      cat("Done ... continue with plotLoadingsPCA(PC1, PC2, PC3, model) or plotScoresPCA(PC1, PC2, PC3, model) ... ")
      ############################################ -> print out the usable functions
      return(pca.mod);
    }
  }
}
      
############################################ 
############################################ 
############################################ 

plotLoadingsPCA <- function(PC1 = F, PC2 = F, PC3 = F, model)
{
  library("rgl")
  ############################################ -> load plot3d lib
  
  if(PC1 != F && PC2 != F && PC3 != F){
    pcs <- c(PC1, PC2, PC3)
    s.pcs <- sort(pcs)
    ############################################ -> sort PCs
    
    plot3d(model$rotation[,s.pcs[1]:s.pcs[3]], col = brewer.pal(3, "Set2"), size = 7, main = "Loading plot - PC1 vs. PC2 vs. PC3", xlab = paste("PC", PC1), ylab = paste("PC", PC2), zlab = paste("PC", PC3))
    #decorate3d(box = T, axes = T, main = "Loading plot - PC1 vs. PC2 vs. PC3", xlab = paste("PC", PC1), ylab = paste("PC", PC2), zlab = paste("PC", PC3))
    ############################################ -> plot 3d and decorate
  }
  else{
    if(PC1 != F && PC2 != F && PC3 != T){
      pcs  <- c(PC1, PC2)
      s.pcs <- sort(pcs)
      plot(model$rotation[,PC1:PC2], pch = 21, bg = "grey", main = "Loading plot", xlab = paste("PC", PC1), ylab = paste("PC", PC2))
    }
    else{
      if(PC1 != F && PC2 !=T && PC3 != T){
        wave <- seq(400,2499.5,by=0.5)
        plot(wave, model$rotation[,PC1], main ="Loading plot", xlab = "Wavelength in nm", ylab = paste("PC", PC1), type = "l")
      }
    }
  }
  ############################################ -> when user has assigned 3 PCs, then do 3d plot otherwise use 2d plot
}

############################################ 
############################################ 
############################################ 

plotScoresPCA <- function(PC1 = F, PC2 = F, PC3 = F, model)
{
  library("rgl")
  ############################################ -> load plot3d lib
  
  if(PC1 != F && PC2 != F && PC3 != F){
    pcs <- c(PC1, PC2, PC3)
    s.pcs <- sort(pcs)
    ############################################ -> sort PCs
    
    plot3d(model$x[,s.pcs[1]:s.pcs[3]], col = brewer.pal(3, "Set2"), size = 7, main = "Score plot - PC1 vs. PC2 vs. PC3", xlab = paste("PC", PC1), ylab = paste("PC", PC2), zlab = paste("PC", PC3))
    #decorate3d(box = T, axes = F, main = "Score plot - PC1 vs. PC2 vs. PC3", xlab = paste("PC", PC1), ylab = paste("PC", PC2), zlab = paste("PC", PC3))
    ############################################ -> plot 3d and decorate
  }
  else{
    if(PC1 != F && PC2 != F && PC3 != T){
      pcs  <- c(PC1, PC2)
      s.pcs <- sort(pcs)
      plot(model$x[,PC1:PC2], pch = 21, bg = "grey", main = "Score plot", xlab = paste("PC", PC1), ylab = paste("PC", PC2))
    }
    else{
      if(PC1 != F && PC2 !=T && PC3 != T){
        wave <- seq(1,dim(model$rotation)[2],by=1)
        plot(wave, model$x[,PC1], main ="Score plot", xlab = "Samples", ylab = paste("PC", PC1), pch = 21, bg = "grey")
      }
    }
  }
  ############################################ -> when user has assigned 3 PCs, then do 3d plot otherwise use 2d plot
}

############################################ 
############################################ 
############################################ 

doPLS <- function(data1, ncomp1 = 10)
{
  #if(data == FALSE){
  #  cat("You forgot the data file ...")
  #}
  #else{
    cat(sep = "\n")
    cat(sep = "\n")
    cat("Plotting the cross-validated RMSEP curves for your data ...")
    hypcolname <- colnames(data1)[2]
    pls.mod <- plsr(hypcolname ~ spc, ncomp = ncomp1, validation = "CV", data = data1)
    plot(RMSEP(pls.mod), legendpos = "topright", xlab = "No. of components", main = "Cross-validated RMSEP curves", ylab = "RMSEP")
    cat(sep = "\n")
    cat(sep = "\n")
    cat("Plotting you the summary ...")
    cat(sep = "\n")
    cat(sep = "\n")
    cat("Done ... continue with plotLoadingsPLS(PC1, PC2, PC3, model) or plotScoresPLS(PC1, PC2, PC3, model) ... ")
    ############################################ -> print out the usable functions
    return(pls.mod);
 # }
}