
# Helpers -----------------------------------------------------------------

#' Estimation of the sensitivity with complex survey data
#'
#' Estimate the sensitivity parameter
#' considering sampling weights with complex survey data
#' @param response.var vector with information of the response variable
#' or character string indicating the name of the variable
#' indicating the response variable in the data set
#' @param phat.var vector with information of the estimated probabilities
#' or character string indicating the name of the variable
#' indicating these probabilities in the data set
#' @param weights.var vector with information of the sampling weights
#' or character string indicating the name of the variable
#' indicating the sampling weights in the data set
#' @param event label indicating the event of interest (default `event = 1`)
#' @param cutoff.point a numeric value indicating the cut-off point to be used
#' @param data name of the data set.
#' If data=NULL, then specific numerical vectors must be included in
#' `response.var`, `phat.var` and `weights.var`
#' @return A numeric value indicating the estimated sensitivity parameter considering sampling weights
#'
#' @export
#'
#' @examples
#' data(example_data_wroc)
#'
#' sew(response.var = "y", phat.var = "phat", weights.var = "weights",
#'     event = 1, cutoff.point = 0.5, data = example_data_wroc)
#'
#' # Or equivalently
#' sew(response.var = example_data_wroc$y,
#'     phat.var = example_data_wroc$phat,
#'     weights.var = example_data_wroc$weights,
#'     event = 1, cutoff.point = 0.5)
sew <- function(response.var, phat.var, weights.var, event, cutoff.point, data = NULL){

  if(inherits(response.var, "character")){
    response.var <- data[,response.var]
  }

  if(inherits(phat.var, "character")){
    phat.var <- data[,phat.var]
  }

  if(inherits(weights.var, "character")){
    weights.var <- data[,weights.var]
  }

  # data.event <- subset(data, get(response.var) == event)
  # sum.weight <- sum(data.event[,weights.var])
  #
  # yhat.event.i <- which(data.event[,phat.var] >= cutoff.point)
  # yhat.event.w <- sum(data.event[yhat.event.i, weights.var])


  sum.weight <- sum(weights.var[which(response.var == event)])
  yhat.event.w <- sum(weights.var[which(response.var == event & phat.var >= cutoff.point)])

  sew.hat <- yhat.event.w/sum.weight
  return(sew.hat)

}

#' Estimation of the specificity with complex survey data
#'
#' Estimate the specificity parameter
#' considering sampling weights with complex survey data
#' @param response.var vector with information of the response variable
#' or character string indicating the name of the variable
#' indicating the response variable in the data set
#' @param phat.var vector with information of the estimated probabilities
#' or character string indicating the name of the variable
#' indicating these probabilities in the data set
#' @param weights.var vector with information of the sampling weights
#' or character string indicating the name of the variable
#' indicating the sampling weights in the data set
#' @param nonevent label indicating the non-event (default `nonevent = 0`)
#' @param cutoff.point a numeric value indicating the cut-off point to be used
#' @param data name of the data set.
#' If data=NULL, then specific numerical vectors must be included in
#' `response.var`, `phat.var` and `weights.var`
#' @return A numeric value indicating the estimated specificity parameter considering sampling weights
#'
#' @export
#' @examples
#' data(example_data_wroc)
#'
#' spw(response.var = "y", phat.var = "phat", weights.var = "weights",
#'     nonevent = 0, cutoff.point = 0.5, data = example_data_wroc)
#'
#' # Or equivalently
#' spw(response.var = example_data_wroc$y,
#'     phat.var = example_data_wroc$phat,
#'     weights.var = example_data_wroc$weights,
#'     nonevent = 0, cutoff.point = 0.5)

spw <- function(response.var, phat.var, weights.var, nonevent, cutoff.point, data = NULL){

  if(inherits(response.var, "character")){
    response.var <- data[,response.var]
  }

  if(inherits(phat.var, "character")){
    phat.var <- data[,phat.var]
  }

  if(inherits(weights.var, "character")){
    weights.var <- data[,weights.var]
  }

  # data.nonevent <- subset(data, get(response.var) == nonevent)
  # sum.weight <- sum(data.nonevent[,weights.var])
  #
  # yhat.nonevent.i <- which(data.nonevent[,phat.var] < cutoff.point)
  # yhat.nonevent.w <- sum(data.nonevent[yhat.nonevent.i, weights.var])

  sum.weight <- sum(weights.var[which(response.var == nonevent)])
  yhat.nonevent.w <- sum(weights.var[which(response.var == nonevent & phat.var < cutoff.point)])

  spw.hat <- yhat.nonevent.w/sum.weight
  return(spw.hat)

}


# Function ----------------------------------------------------------------

#' Estimation of the ROC curve of logistic regression models with complex survey data
#'
#' Calculate the ROC curve of a logistic regression model
#' considering sampling weights with complex survey data
#' @param response.var vector with information of the response variable
#' or character string indicating the name of the variable
#' indicating the response variable in the data set
#' @param phat.var vector with information of the estimated probabilities
#' or character string indicating the name of the variable
#' indicating these probabilities in the data set
#' @param weights.var vector with information of the sampling weights
#' or character string indicating the name of the variable
#' indicating the sampling weights in the data set
#' @param event label indicating the event of interest (default `event = 1`)
#' @param nonevent label indicating the non-event (default `nonevent = 0`)
#' @param data name of the data set.
#' If data=NULL, then specific numerical vectors must be included in
#' `response.var`, `phat.var` and `weights.var`
#'
#' @return A graphic with the ROC curve
#'
#' @export
#'
#' @examples
#' data(example_data_wroc)
#'
#' wroc(response.var = "y", phat.var = "phat", weights.var = "weights", data = example_data_wroc)
#'
#' # Or equivalently
#' wroc(response.var = example_data_wroc$y,
#'      phat.var = example_data_wroc$phat,
#'      weights.var = example_data_wroc$weights)
#'
wroc <- function(response.var, phat.var, weights.var, event = 1, nonevent = 0, data = NULL){

  if(inherits(response.var, "character")){
    response.var <- data[,response.var]
  }

  if(inherits(phat.var, "character")){
    phat.var <- data[,phat.var]
  }

  if(inherits(weights.var, "character")){
    weights.var <- data[,weights.var]
  }

  all.phat <- sort(unique(phat.var))

  lower <- all.phat[1:(length(all.phat)-1)]
  upper <- all.phat[2:length(all.phat)]
  cutoffs <- c(0, (lower+upper)/2, 1)

  sew.v <- unlist(lapply(cutoffs, sew, response.var = response.var, event = event, phat.var = phat.var, weights.var = weights.var, data = data))
  spw.v <- unlist(lapply(cutoffs, spw, response.var = response.var, nonevent = nonevent, phat.var = phat.var, weights.var = weights.var, data = data))
  inv.spw.v <- 1 - spw.v
  plot.df <- data.frame(sew.v, inv.spw.v)

  plot(x = plot.df$inv.spw.v, y = plot.df$sew.v, type = "l",
       xlab = "1-Spw(c)", ylab = "Sew(c)", main = "ROCw Curve")
  graphics::abline(a = 0, b = 1, lty = 2, col = "gray")

}
