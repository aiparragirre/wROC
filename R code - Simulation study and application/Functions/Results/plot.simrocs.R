
plot.simrocs <- function(obj, main){
  
  pdf(file = paste0("Outputs/Figures/roc_",obj,".pdf"))
  
  i <- 0
  
  for(r in 1:as.numeric(get(obj)["R"])){
    
    cat("\n>>>>>",r,"\n")
    
    
    # Organize the data -------------------------------------------------------
    
    # Sample information (including sampling weights)
    y = get(obj)[["m.data"]][["y"]][,r]
    phat = get(obj)[["m.data"]][["phat"]][,r]
    w = get(obj)[["m.data"]][["w"]][,r]
    data = data.frame(y = y, phat = phat, w = w)
    
    # Unweighted method equivalent to--> w = 1
    data$w1 <- rep(1, nrow(data))
    
    # Population information (w = 1)
    pop.y = get(obj)[["m.pop"]][["y"]]
    pop.phat = get(obj)[["m.pop"]][["phat"]][,r]
    pop <- data.frame(y = pop.y, phat = pop.phat)
    pop$w <- rep(1, nrow(pop))
    
    
    # Calculating cut-off points and estimating parameters --------------------
    
    
    # Defining cut-off points:
    all.phat <- sort(unique(data[,"phat"]))
    lower <- all.phat[1:(length(all.phat)-1)]
    upper <- all.phat[2:length(all.phat)]
    cutoffs <- c(0, (lower+upper)/2, 1)
    
    # Calculate sew and spw across all the cut-off points
    sew.v <- unlist(lapply(cutoffs, sew, data = data, response.var = "y", event = 1, phat.var = "phat", weight.var = "w"))
    spw.v <- unlist(lapply(cutoffs, spw, data = data, response.var = "y", nonevent = 0, phat.var = "phat", weight.var = "w"))
    inv.spw.v <- 1 - spw.v
    plot.df <- data.frame(sew.v, inv.spw.v)
    
    # Calculate unweighted se and sp across all the cut-off points
    se.v <- unlist(lapply(cutoffs, sew, data = data, response.var = "y", event = 1, phat.var = "phat", weight.var = "w1"))
    sp.v <- unlist(lapply(cutoffs, spw, data = data, response.var = "y", nonevent = 0, phat.var = "phat", weight.var = "w1"))
    inv.sp.v <- 1 - sp.v
    plot.df.unw <- data.frame(se.v, inv.sp.v)
    
    
    # Calculate population se and sp
    pop.phat <- sort(unique(pop[,"phat"]))
    pop.lower <- pop.phat[1:(length(pop.phat)-1)]
    pop.upper <- pop.phat[2:length(pop.phat)]
    pop.cutoffs <- c(0, (pop.lower+pop.upper)/2, 1)
    se.pop <- unlist(lapply(pop.cutoffs, sew, data = pop, response.var = "y", event = 1, phat.var = "phat", weight.var = "w"))
    sp.pop <- unlist(lapply(pop.cutoffs, spw, data = pop, response.var = "y", nonevent = 0, phat.var = "phat", weight.var = "w"))
    inv.sp.pop <- 1 - sp.pop
    plot.df.pop <- data.frame(se.pop, inv.sp.pop)
    
    
    # Plot the ROC curves -----------------------------------------------------
    
    # Weighted curves (and/or initialize plot):
    if(i == 0){
      # This runs only for the first (r=1) weighted ROC curve
      i <- 1
      plot(x = plot.df$inv.spw.v, y = plot.df$sew.v, type = "l",
           xlab = "1-Spw(c)", ylab = "Sew(c)", main = main, col = scales::alpha("#588FC7",0.25))
      abline(a = 0, b = 1, lty = 2, col = "gray")
      legend(x = "bottomright", lty = c(1,1,1),
             legend = c("True (population)","Weighted", "Unweighted"), bty = "n",
             col = c("black","#588FC7","#DE912C"))
    } else {
      points(x = plot.df$inv.spw.v, y = plot.df$sew.v, type = "l", col = scales::alpha("#588FC7",0.25))
    }
    
    # Unweighted curves
    points(x = plot.df.unw$inv.sp.v, y = plot.df.unw$se.v, type = "l", lty = 1, col = scales::alpha("#DE912C",0.25))
    
    # Population curves
    points(x = plot.df.pop$inv.sp.pop, y = plot.df.pop$se.pop, type = "l", col=scales::alpha("black",0.25))
    
  }
  
  dev.off()
  
  
}

