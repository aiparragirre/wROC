# wroc

In this repository, we put available the simulation study (code and results) of the paper entitled "Estimation of the ROC curve and the area under it with complex survey data" (Iparragirre A., Barrio I., Arostegui I.) (submitted). The R package `wROC` can also be installed from this repository.

The goal of this repository is two-fold:

- To put publicly available the R package wROC. This package allows to estimate the ROC curve and AUC of logistic regression models fitted to complex survey data.
- The simulation study (code and results) of the paper entitled "Estimation of the ROC curve and the area under it with complex survey data" (Iparragirre A., Barrio I., Arostegui I.) (submitted) can also be found.

## R package

The R package `wROC` to plot weighted estimates of the ROC curves and to obtain weighted estimates of the AUC is available in the folder `wROC`.

The following functions are available:

- `sew`, `spw`: to estimate sensitivity and specificity parameters for a specific cut-off point considering sampling weights.
- `wroc`: to plot the ROC curve considering sampling weights.
- `wauc`: to estimate the AUC considering sampling weights.

This package **will be updated soon**, in order to incorporate optimal cut-off point estimates for individual classification, as proposed in the following paper:

Iparragirre, Amaia; Barrio, Irantzu; Aramendi, Jorge; Arostegui, Inmaculada. “Estimation of cut-off points under complex-sampling design data”. SORT-Statistics and Operations Research Transactions, 2022, Vol. 46, Num. 1, pp. 137-158, https://doi.org/10.2436/20.8080.02.121.


### Installation of the R package

Run the following code to install the package in R (package `devtools` required to run the code):

```{r}
library(devtools)
install_github("aiparragirre/wROC/wROC")
```

### Usage

We need information of three elements for each unit in the sample in order to estimate the ROC curve (`wroc()` function) and AUC (`wauc()` function):

- `response.var`: dichotomous response variable.
- `phat.var`: predicted probabilities of event.
- `weights.var`: sampling weights.

We can put these three vectors in a data frame, or save them separately in three different vectors. The data set `example_data_wroc` is set as an example in the package.

We also need to define the tags for events and non-events (default are: `event = 1` and `nonevent = 0`).

We can plot the ROC curve running as follows:

```{r}
data(example_data_wroc)

wroc(response.var = "y", phat.var = "phat", weights.var = "weights", data = example_data_wroc)

# Or equivalently
wroc(response.var = example_data_wroc$y,
     phat.var = example_data_wroc$phat,
     weights.var = example_data_wroc$weights)
```
Similarly, we can run the following code to estimate the AUC:

```{r}
wauc(response.var = "y", phat.var = "phat", weights.var = "weights", data = example_data_wroc)

# Or equivalently
wauc(response.var = example_data_wroc$y,
     phat.var = example_data_wroc$phat,
     weights.var = example_data_wroc$weights)
```
We can also estimate the sensitivity (`sew()`) and specificity (`spw()`) parameters for a specific cut-off point considering sampling weights. For this purpose, we need to indicate the cut-off point we want to use in the function:

```{r}

# Specificity ----------------------------------------------------------

spw(response.var = "y", phat.var = "phat", weights.var = "weights",
    nonevent = 0, cutoff.point = 0.5, data = example_data_wroc)

# Or equivalently
spw(response.var = example_data_wroc$y,
    phat.var = example_data_wroc$phat,
    weights.var = example_data_wroc$weights,
    nonevent = 0, cutoff.point = 0.5)
   
# Sensitivity ----------------------------------------------------------

sew(response.var = "y", phat.var = "phat", weights.var = "weights",
    event = 1, cutoff.point = 0.5, data = example_data_wroc)

# Or equivalently
sew(response.var = example_data_wroc$y,
    phat.var = example_data_wroc$phat,
    weights.var = example_data_wroc$weights,
    event = 1, cutoff.point = 0.5)
```


## R code - Simulation study and application

In this folder, it is avaialble all the code and results related to the simulation study. In particular:

- In the folder `Functions` all the functions needed to run the simulation study are available.
- In order to run the simulation study, run the code given in the script `exe-sim.R`.
- In order to obtain and depict the results of the simulation study, run the code in script `exe-results.R`. Results can also be [downloaded here](http://aiparragirre006.quickconnect.to/d/s/tgonhxerYVfZPFffGx60NxzgYZCTDK4J/gi-G5ZCWSziY7JX76ictlBbk4cA-thyh-D7uAkZf6ewo).
- In the folder `Outputs` all the results of the simulation study are available (except for the main results, which cannot be uploaded to GitHub due to space limits, and need to be downloaded from the link indicated above).
- In the script `application.R` we put available the code used in the application shown in the paper. Note that **real data** needed to run this code **cannot be set publicly available** due to privacy issues.
