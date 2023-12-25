#' Estimation of the specificity with complex survey data
#'
#' Estimate the specificity parameter
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
#' @param tag.nonevent label indicating the non-event in `response.var` (default `tag.nonevent = 0`)
#' @param cutoff.value a numeric value indicating the cut-off point to be used
#' @param data name of the data set.
#' If data=NULL, then specific numerical vectors must be included in
#' `response.var`, `phat.var` and `weights.var`
#' @return A numeric value indicating the estimated specificity parameter considering sampling weights
#'
#' @export
#' @examples
#' data(example_data_wroc)
#'
#' wsp(response.var = "y", phat.var = "phat", weights.var = "weights",
#'     tag.nonevent = 0, cutoff.value = 0.5, data = example_data_wroc)
#'
#' # Or equivalently
#' wsp(response.var = example_data_wroc$y,
#'     phat.var = example_data_wroc$phat,
#'     weights.var = example_data_wroc$weights,
#'     tag.nonevent = 0, cutoff.value = 0.5)

wsp <- function(response.var, phat.var, weights.var, tag.nonevent = 0, cutoff.value, data = NULL){

  if(inherits(response.var, "character")){
    response.var <- data[,response.var]
  }

  if(inherits(phat.var, "character")){
    phat.var <- data[,phat.var]
  }

  if(inherits(weights.var, "character")){
    weights.var <- data[,weights.var]
  }

  sum.weight <- sum(weights.var[which(response.var == tag.nonevent)])
  yhat.nonevent.w <- sum(weights.var[which(response.var == tag.nonevent & phat.var < cutoff.value)])

  spw.hat <- yhat.nonevent.w/sum.weight
  return(spw.hat)

}
