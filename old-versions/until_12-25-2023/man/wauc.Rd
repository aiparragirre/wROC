% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wauc.R
\name{wauc}
\alias{wauc}
\title{Estimation of the AUC of logistic regression models with complex survey data}
\usage{
wauc(
  response.var,
  phat.var,
  weights.var,
  tag.event = 1,
  tag.nonevent = 0,
  data = NULL
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
If data=NULL, then specific numerical vectors must be included in
\code{response.var}, \code{phat.var} and \code{weights.var}}
}
\value{
A numeric value indicating the estimated AUC considering sampling weights
}
\description{
Calculate the AUC of a logistic regression model
considering sampling weights with complex survey data
}
\examples{
data(example_data_wroc)

wauc(response.var = "y", phat.var = "phat", weights.var = "weights", data = example_data_wroc)

# Or equivalently
wauc(response.var = example_data_wroc$y,
     phat.var = example_data_wroc$phat,
     weights.var = example_data_wroc$weights)

}
