boxplot.simauc <- function(obj, methods=c("unw","pairw","w"), 
                              filename=NULL, cex.axis=1,...){
  
  boxes <- list()
  for(i in 1:length(methods)){
    boxes[[i]] <- obj$aucs[[methods[i]]] - obj$aucs$ps
  }
  
  if(is.null(filename)){filename <- "boxplots"}
  
  pdf(file=paste0("Outputs/Figures/boxplots_",filename,".pdf"))
  boxplot(boxes, cex.axis=cex.axis,...)
  abline(h=0, col="red")
  dev.off()
  
}

