

# Packages ----------------------------------------------------------------

library(ggplot2)

# Helpers -----------------------------------------------------------------

sew <- function(data, response.var, event, phat.var, weight.var, cutoff.point){
  
  data.event <- subset(data, get(response.var) == event)
  sum.weight <- sum(data.event[,weight.var])
  
  yhat.event.i <- which(data.event[,phat.var] >= cutoff.point)
  yhat.event.w <- sum(data.event[yhat.event.i, weight.var])
  
  sew.hat <- yhat.event.w/sum.weight
  return(sew.hat)
  
}

spw <- function(data, response.var, nonevent, phat.var, weight.var, cutoff.point){
  
  data.nonevent <- subset(data, get(response.var) == nonevent)
  sum.weight <- sum(data.nonevent[,weight.var])
  
  yhat.nonevent.i <- which(data.nonevent[,phat.var] < cutoff.point)
  yhat.nonevent.w <- sum(data.nonevent[yhat.nonevent.i, weight.var])
  
  spw.hat <- yhat.nonevent.w/sum.weight
  return(spw.hat)
  
}


# Function ----------------------------------------------------------------

rocw.curve <- function(data, response.var, event, nonevent, phat.var, weight.var){
  
  all.phat <- sort(unique(data[,phat.var]))
  
  lower <- all.phat[1:(length(all.phat)-1)]
  upper <- all.phat[2:length(all.phat)]
  cutoffs <- c(0, (lower+upper)/2, 1)
  
  sew.v <- unlist(lapply(cutoffs, sew, data = data, response.var = response.var, event = event, phat.var = phat.var, weight.var = weight.var))
  spw.v <- unlist(lapply(cutoffs, spw, data = data, response.var = response.var, nonevent = nonevent, phat.var = phat.var, weight.var = weight.var))
  inv.spw.v <- 1 - spw.v
  plot.df <- data.frame(sew.v, inv.spw.v)
  
  # ggplot(plot.df, aes(x = inv.spw.v, y=sew.v)) +
  #   geom_line() +
  #   geom_point() + 
  #   geom_abline(slope=1, intercept=0, col="gray",linetype = "dashed") +
  #   labs(x = "1-Sp.w(c)", y = "Se.w(c)", title="ROCw Curve")
  plot(x = plot.df$inv.spw.v, y = plot.df$sew.v, type = "l",
       xlab = "1-Spw(c)", ylab = "Sew(c)", main = "ROCw Curve")
  abline(a = 0, b = 1, lty = 2, col = "gray")
  
}
