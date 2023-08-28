#' Optimal cut-off points for complex survey data
#'
#' Calculate optimal cut-off points for complex survey data (Iparragirre et al., 2022).
#' Some functions of the package OptimalCutpoints (Lopez-Raton et al, 2014) have been used and modified in order them to consider sampling weights.
#'
#' @param response.var vector with information of the response variable
#' or character string with the name of the variable
#' indicating the response variable in the data set
#' @param phat.var vector with information of the estimated probabilities
#' or character string with the name of the variable
#' indicating these probabilities in the data set
#' @param weights.var vector with information of the sampling weights
#' or character string with the name of the variable
#' indicating the sampling weights in the data set
#' @param tag.nonevent label indicating the non-event in `response.var` (default `tag.nonevent = 0`).
#' @param method choose one of the following methods (Lopez-Raton et al, 2014): `MaxProdSpSe`, `ROC01`, `Youden`, `MaxEfficiency`
#' @param data name of the data set.
#' If `data=NULL`, then specific numerical vectors must be included in
#' `response.var`, `phat.var` and `weights.var`
#'
#'
#' @references Iparragirre, A., Barrio, I., Aramendi, J. and Arostegui, I. (2022). Estimation of cut-off points under complex-sampling design data. \emph{SORT-Statistics and Operations Research Transactions} \bold{46}(1), 137--158.
#' @references Lopez-Raton, M., Rodriguez-Alvarez, M.X, Cadarso-Suarez, C. and Gude-Sampedro, F. (2014). OptimalCutpoints: An R Package for Selecting Optimal Cutpoints in Diagnostic Tests. \emph{Journal of Statistical Software} \bold{61}(8), 1--36.
#'
#' @returns an object of class `wocp`. This object is a list that contains information about the method used to calculate the optimal cut-off point, the optimal value of the cut-off point and the corresponding value of the selected optimality criterion, as well as all the cut-off points considered and the corresponding values of the criterion.
#'
#' @export
#'
#' @examples
#' wocp(response.var = "y", phat.var = "phat", weights.var = "weights",
#'      tag.nonevent = 0, method = "Youden",
#'      data = example_data_wroc)
#'
#'# Or equivalently
#' wocp(example_data_wroc$y, example_data_wroc$phat, example_data_wroc$weights,
#'      tag.nonevent = 0, method = "Youden")
#'
#'
wocp <- function(response.var, phat.var, weights.var, tag.nonevent = 0,
                 method = c("Youden", "MaxProdSpSe", "ROC01", "MaxEfficiency"),
                 data = NULL){

  if(missing(method) || is.null(method)) {
    stop("'method' argument required.", call.=FALSE)
  }
  if(any(!(method %in% c("MaxProdSpSe","ROC01","Youden","MaxEfficiency")))) {
    stop ("You have entered an invalid method.", call. = FALSE)
  }
  # if (missing(data)|| is.null(data)) {
  #   stop("'data' argument required.", call. = FALSE)
  # }
  if(missing(weights.var)) {
    weights <- "auxweights"
    data[,weights] <- 1
  }
  if (missing(phat.var)|| is.null(phat.var)) {
    stop("'phat.var' argument required.", call. = FALSE)
  }
  if (missing(response.var)|| is.null(response.var)) {
    stop("'response.var' argument required.", call. = FALSE)
  }
  if (missing(tag.nonevent)|| is.null(tag.nonevent)) {
    stop("'tag.nonevent' argument required.", call. = FALSE)
  }

  # if(!all(c(phat.var,response.var,weights.var) %in% names(data))) {
  #   stop("Not all needed variables are supplied in 'data'.", call. = FALSE)
  # }

  if(inherits(response.var, "character")){
    name.response.var <- response.var
    response.var <- data[,response.var]
  } else {
    name.response.var <- "response.var"
  }

  if(inherits(phat.var, "character")){
    name.phat.var <- phat.var
    phat.var <- data[,phat.var]
  } else {
    name.phat.var <- "phat.var"
  }

  if(inherits(weights.var, "character")){
    name.weights.var <- weights.var
    weights.var <- data[,weights.var]
  } else {
    name.weights.var <- "weights.var"
  }

  if(is.null(data)){
    data <- data.frame(response.var = response.var,
                       phat.var = phat.var,
                       weights.var = weights.var)
  }

  # NA's deleted
  data <- na.omit(data[,c(name.phat.var,name.response.var,name.weights.var)])
  # A data frame with the results is created:
  res <- vector("list", length(method))
  names(res) <- method

  pop.prev <- NA
  pop.prev.new <- pop.prev
  data.m <- data
  if (is.na(pop.prev.new)) {
    pop.prev.new <- w.calculate.sample.prev(data.m, name.response.var, tag.healthy = tag.nonevent, name.weights.var)
  }
  w.validate.prevalence(pop.prev.new)
  measures.acc <- w.calculate.accuracy.measures(data = data.m,
                                                weights = name.weights.var,
                                                marker = name.phat.var,
                                                status = name.response.var,
                                                tag.healthy = tag.nonevent,
                                                direction = "<",
                                                pop.prev = pop.prev.new)
  for (j in 1: length(method)) {
    res[[j]] <- eval(parse(text = paste("w.function.", method[j], sep = "")))(marker = phat.var,
                                                                            status = response.var,
                                                                            tag.healthy = tag.nonevent,
                                                                            direction = "<",
                                                                            pop.prev = pop.prev.new,
                                                                            measures.acc = measures.acc)
  }

  res$method <-  method
  res$call <- match.call()

  class(res) <- "wocp"
  invisible(res)

  return(res)

}
