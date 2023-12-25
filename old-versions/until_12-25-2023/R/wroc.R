#' Estimation of the ROC curve of logistic regression models with complex survey data
#'
#' Calculate the ROC curve of a logistic regression model
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
#' If `data=NULL`, then specific numerical vectors must be included in
#' `response.var`, `phat.var` and `weights.var`
#' @param cutoff.method Method to be used for calculating the optimal cut-off point.
#' If `cutoff.method = NULL`, then no optimal cut-off point is drawn.
#' If an optimal cut-off point is to be drawn, one of the following methods needs to be selected:
#' `Youden`, `MaxProdSpSe`, `ROC01`, `MaxEfficiency`.
#' @param plotit default `plotit=TRUE` which plots the ROC curve. Turn to `plotit=FALSE` to avoid plotting it.
#'
#' @return a plot with the ROC curve. When saving it to object, all the values for sensitivity and specificity parameteres used to plot the curve, the value of the area under the curve (AUC), as well as, information about the optimal cut-off point are available.
#'
#' @export
#'
#' @importFrom graphics points text
#' @importFrom stats as.formula na.omit terms
#'
#' @examples
#' data(example_data_wroc)
#'
#' wroc(response.var = "y", phat.var = "phat", weights.var = "weights",
#'      data = example_data_wroc)
#'
#' # Or equivalently
#' wroc(response.var = example_data_wroc$y,
#'      phat.var = example_data_wroc$phat,
#'      weights.var = example_data_wroc$weights)
#'
#' # Indicate the optimality criteria to draw the optimal cut-off point. For example:
#' wroc(response.var = "y", phat.var = "phat", weights.var = "weights",
#'      data = example_data_wroc, cutoff.method = "Youden")
#'
#' # To save the numeric information about the curve, save it to an object:
#' curve <- wroc(response.var = "y", phat.var = "phat", weights.var = "weights",
#'               data = example_data_wroc, cutoff.method = "Youden",
#'               plotit = FALSE)
#'
wroc <- function(response.var, phat.var, weights.var, tag.event = 1, tag.nonevent = 0, data = NULL, cutoff.method = NULL, plotit = TRUE){

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


  all.phat <- sort(unique(phat.var))

  lower <- all.phat[1:(length(all.phat)-1)]
  upper <- all.phat[2:length(all.phat)]
  cutoffs <- c(0, (lower+upper)/2, 1)

  sew.v <- unlist(lapply(cutoffs, wse, response.var = response.var, tag.event = tag.event, phat.var = phat.var, weights.var = weights.var, data = data))
  spw.v <- unlist(lapply(cutoffs, wsp, response.var = response.var, tag.nonevent = tag.nonevent, phat.var = phat.var, weights.var = weights.var, data = data))
  inv.spw.v <- 1 - spw.v
  plot.df <- data.frame(sew.v, inv.spw.v)

  res <- list()
  res$wroc.curve <- list(sew = sew.v, spw = spw.v)

  auc <- wauc(response.var, phat.var, weights.var, tag.event, tag.nonevent, data)
  res$wauc <- auc


  if(plotit == TRUE){
    plot(x = plot.df$inv.spw.v, y = plot.df$sew.v, type = "l",
         xlab = "1-Spw(c)", ylab = "Sew(c)", main = "ROCw Curve")
  }

  if(!is.null(cutoff.method)){
    ocp <- wocp(response.var = name.response.var, phat.var = name.phat.var,
                weights.var=name.weights.var,
                tag.nonevent=0,
                method=cutoff.method, data=data)
    res$optimal.cutpoint$method <- cutoff.method
    res$optimal.cutpoint$cutoff.value <- ocp[[cutoff.method]][["optimal.cutoff"]][["cutoff"]]
    res$optimal.cutpoint$Sp <- ocp[[cutoff.method]][["optimal.cutoff"]][["Sp"]]
    res$optimal.cutpoint$Se <- ocp[[cutoff.method]][["optimal.cutoff"]][["Se"]]

    if(plotit == TRUE){
      points(x = 1-ocp[[cutoff.method]][["optimal.cutoff"]][["Sp"]],
             y = ocp[[cutoff.method]][["optimal.cutoff"]][["Se"]],
             col = "red", pch=19)
      text(x = 1-ocp[[cutoff.method]][["optimal.cutoff"]][["Sp"]],
           y = ocp[[cutoff.method]][["optimal.cutoff"]][["Se"]],
           pos = 4, cex = 0.75,
           labels = paste0(round(ocp[[cutoff.method]][["optimal.cutoff"]][["cutoff"]], digits = 4),
                           " (Sp: ", round(ocp[[cutoff.method]][["optimal.cutoff"]][["Sp"]], digits = 4),
                           ", Se: ", round(ocp[[cutoff.method]][["optimal.cutoff"]][["Se"]], digits = 4), ")"))
    }

  }

  if(plotit == TRUE){
    graphics::abline(a = 0, b = 1, lty = 2, col = "gray")
  }

  class(res) <- "wroc"
  invisible(res)
  return(invisible(res))

}
