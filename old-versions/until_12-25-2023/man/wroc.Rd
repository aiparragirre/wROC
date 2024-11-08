% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wroc.R
\name{wroc}
\alias{wroc}
\title{Estimation of the ROC curve of logistic regression models with complex survey data}
\usage{
wroc(
  response.var,
  phat.var,
  weights.var,
  tag.event = 1,
  tag.nonevent = 0,
  data = NULL,
  cutoff.method = NULL,
  plotit = TRUE
)
}
\arguments{
\item{response.var}{vector with information of the response variable
or character string with the name of the variable
indicating the response variable in the data set}

\item{phat.var}{vector with information of the estimated probabilities
or character string with the name of the variable
indicating these probabilities in the data set}

\item{weights.var}{vector with information of the sampling weights
or character string with the name of the variable
indicating the sampling weights in the data set}

\item{tag.event}{label indicating the event of interest in \code{response.var} (default \code{tag.event = 1})}

\item{tag.nonevent}{label indicating the non-event in \code{response.var} (default \code{tag.nonevent = 0})}

\item{data}{name of the data set.
If \code{data=NULL}, then specific numerical vectors must be included in
\code{response.var}, \code{phat.var} and \code{weights.var}}

\item{cutoff.method}{Method to be used for calculating the optimal cut-off point.
If \code{cutoff.method = NULL}, then no optimal cut-off point is drawn.
If an optimal cut-off point is to be drawn, one of the following methods needs to be selected:
\code{Youden}, \code{MaxProdSpSe}, \code{ROC01}, \code{MaxEfficiency}.}

\item{plotit}{default \code{plotit=TRUE} which plots the ROC curve. Turn to \code{plotit=FALSE} to avoid plotting it.}
}
\value{
a plot with the ROC curve. When saving it to object, all the values for sensitivity and specificity parameteres used to plot the curve, the value of the area under the curve (AUC), as well as, information about the optimal cut-off point are available.
}
\description{
Calculate the ROC curve of a logistic regression model
considering sampling weights with complex survey data
}
\examples{
data(example_data_wroc)

wroc(response.var = "y", phat.var = "phat", weights.var = "weights",
     data = example_data_wroc)

# Or equivalently
wroc(response.var = example_data_wroc$y,
     phat.var = example_data_wroc$phat,
     weights.var = example_data_wroc$weights)

# Indicate the optimality criteria to draw the optimal cut-off point. For example:
wroc(response.var = "y", phat.var = "phat", weights.var = "weights",
     data = example_data_wroc, cutoff.method = "Youden")

# To save the numeric information about the curve, save it to an object:
curve <- wroc(response.var = "y", phat.var = "phat", weights.var = "weights",
              data = example_data_wroc, cutoff.method = "Youden",
              plotit = FALSE)

}
