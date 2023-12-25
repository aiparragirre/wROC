#' Estimation of the AUC of logistic regression models with complex survey data
#'
#' Calculate the AUC of a logistic regression model
#' considering sampling weights with complex survey data
#' @param response.var vector with information of the response variable
#' or character string with the name of the variable
#' indicating the response variable in the data set
#' @param phat.var vector with information of the estimated probabilities
#' or character string with the name of the variable
#' indicating these probabilities in the data set
#' @param weights.var vector with information of the sampling weights
#' or character string with the name of the variable
#' indicating the sampling weights in the data set
#' @param tag.event label indicating the event of interest in `response.var` (default `tag.event = 1`)
#' @param tag.nonevent label indicating the non-event in `response.var` (default `tag.nonevent = 0`)
#' @param data name of the data set.
#' If data=NULL, then specific numerical vectors must be included in
#' `response.var`, `phat.var` and `weights.var`
#'
#' @return A numeric value indicating the estimated AUC considering sampling weights

#' @export
#'
#' @examples
#' data(example_data_wroc)
#'
#' wauc(response.var = "y", phat.var = "phat", weights.var = "weights", data = example_data_wroc)
#'
#' # Or equivalently
#' wauc(response.var = example_data_wroc$y,
#'      phat.var = example_data_wroc$phat,
#'      weights.var = example_data_wroc$weights)
#'
wauc <- function(response.var, phat.var, weights.var, tag.event = 1, tag.nonevent = 0, data = NULL){

  if(inherits(response.var, "character")){
    response.var <- data[,response.var]
  }

  if(inherits(phat.var, "character")){
    phat.var <- data[,phat.var]
  }

  if(inherits(weights.var, "character")){
    weights.var <- data[,weights.var]
  }

  p0 <- phat.var[which(response.var==tag.nonevent)]
  p1 <- phat.var[which(response.var==tag.event)]

  w0 <- weights.var[which(response.var==tag.nonevent)]
  w1 <- weights.var[which(response.var==tag.event)]

  auc <- (sum(outer(w1, w0, "*")[which(outer(p1, p0, ">"))]) + 0.5*sum(outer(w1, w0, "*")[which(outer(p1, p0, "=="))]))/(sum(w0)*sum(w1))

  return(auc)

}


