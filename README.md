# wroc

In this repository, we put available the simulation study (code and results) of the paper entitled "Estimation of the ROC curve and the area under it with complex survey data" (Iparragirre A., Barrio I., Arostegui I.) (under review). The R package `wROC` can also be installed from this repository.

The goal of this repository is two-fold:

- To put publicly available the R package `wROC`. This package allows to estimate the ROC curve and AUC of logistic regression models fitted to complex survey data. In addition, with this package, we can also obtain optimal cut-off points for individual classification considering sampling weights with complex survey data.
- The simulation study (code and results) of the paper entitled "Estimation of the ROC curve and the area under it with complex survey data" (Iparragirre A., Barrio I., Arostegui I.) (under review) can also be found.

## R package

The R package `wROC` to plot weighted estimates of the ROC curves and to obtain weighted estimates of the AUC is available in the folder `wROC`.

The following functions are available:

- `wse`, `wsp`: to estimate sensitivity and specificity parameters for a specific cut-off point considering sampling weights.
- `wroc`: to plot the ROC curve considering sampling weights.
- `wauc`: to estimate the AUC considering sampling weights.
- `wocp`: calculate optimal cut-off points for individual classification considering sampling weights.

The methodology proposed for the above-mentioned functions can be found in the following **references**:

Iparragirre, Amaia; Barrio, Irantzu; Aramendi, Jorge; Arostegui, Inmaculada. “Estimation of cut-off points under complex-sampling design data”. SORT-Statistics and Operations Research Transactions, 2022, Vol. 46, Num. 1, pp. 137-158, https://doi.org/10.2436/20.8080.02.121.

Iparragirre, Amaia; Barrio, Irantzu; Arostegui, Inmaculada. “Estimation of the ROC curve and the area under it with complex survey data”. *(under review)*


### Installation of the R package

Run the following code to install the package in R (package `devtools` required to run the code):

```{r}
library(devtools)
install_github("aiparragirre/wROC/wROC")
```

### Usage

We need information of three elements for each unit in the sample in order to estimate the ROC curve (`wroc()` function) and AUC (`wauc()` function):

- `response.var`: variable indicating the dichotomous response variable.
- `phat.var`: predicted probabilities of event.
- `weights.var`: variable indicating the sampling weights.

We can put these three vectors in a data frame, or save them separately in three different vectors. The data set `example_data_wroc` is set as an example in the package.

We also need to define the tags for events and non-events (default are: `tag.event = 1` and `tag.nonevent = 0`).

We can plot the ROC curve running as follows:

```{r}
data(example_data_wroc)

wroc(response.var = "y", phat.var = "phat", weights.var = "weights", data = example_data_wroc)

# Or equivalently
wroc(response.var = example_data_wroc$y,
     phat.var = example_data_wroc$phat,
     weights.var = example_data_wroc$weights)
```

To save the numeric information about the curve, save it to an object. In addition, if the argument `plotit` is set to `plotit = FALSE`, then the ROC curve will not be drawn (default: `plotit = TRUE`):

```{r}
curve <- wroc(response.var = "y", phat.var = "phat", weights.var = "weights",
              data = example_data_wroc, cutoff.method = "Youden",
              plotit = FALSE)
```

Similarly, we can run the following code to estimate the AUC:

```{r}
wauc(response.var = "y", phat.var = "phat", weights.var = "weights", data = example_data_wroc)

# Or equivalently:
wauc(response.var = example_data_wroc$y,
     phat.var = example_data_wroc$phat,
     weights.var = example_data_wroc$weights)
```

We can also estimate the sensitivity (`wse()`) and specificity (`wsp()`) parameters for a specific cut-off point considering sampling weights. For this purpose, we need to indicate the cut-off point we want to use in the function by means of the argument `cutoff.value`:

```{r}

# Specificity ----------------------------------------------------------

wsp(response.var = "y", phat.var = "phat", weights.var = "weights",
    tag.nonevent = 0, cutoff.value = 0.5, data = example_data_wroc)

# Or equivalently:
wsp(response.var = example_data_wroc$y,
    phat.var = example_data_wroc$phat,
    weights.var = example_data_wroc$weights,
    tag.nonevent = 0, cutoff.value = 0.5)
   
# Sensitivity ----------------------------------------------------------

wse(response.var = "y", phat.var = "phat", weights.var = "weights",
    tag.event = 1, cutoff.value = 0.5, data = example_data_wroc)

# Or equivalently
wse(response.var = example_data_wroc$y,
    phat.var = example_data_wroc$phat,
    weights.var = example_data_wroc$weights,
    tag.event = 1, cutoff.value = 0.5)
```

Finally, use the function `wocp()` to obtain optimal cut-off points for individual classification as proposed in: 

Iparragirre, A., Barrio, I., Aramendi, J. and Arostegui, I. (2022). Estimation of cut-off points under complex-sampling design data. *SORT-Statistics and Operations Research Transactions* **46**(1), 137--158.

Some functions of the package `OptimalCutpoints` have been modified in order them to consider sampling weights:

Lopez-Raton, M., Rodriguez-Alvarez, M.X, Cadarso-Suarez, C. and Gude-Sampedro, F. (2014). OptimalCutpoints: An R Package for Selecting Optimal Cutpoints in Diagnostic Tests. *Journal of Statistical Software* **61**(8), 1--36.

One of the methods proposed in the paper needs to be selected when running the function by means of the argument `method`: `Youden`, `MaxProdSpSe`, `ROC01` or `MaxEfficiency`.

```{r}
ocp <- wocp(response.var = "y", phat.var = "phat", weights.var = "weights",
            tag.nonevent = 0, method = "Youden",
            data = example_data_wroc)

# Or equivalently
ocp <- wocp(example_data_wroc$y, example_data_wroc$phat, example_data_wroc$weights,
            tag.nonevent = 0, method = "Youden")
```

If you want to draw the optimal cut-off point in the ROC curve, then use the function `wroc()` and indicate the method by means of the argument `cutoff.method` as follows:

```{r}
wroc(response.var = "y", phat.var = "phat", weights.var = "weights",
     data = example_data_wroc, cutoff.method = "Youden")
```

## R code - Simulation study and application

In this folder, it is avaialble all the code and results related to the simulation study. In particular:

- In the folder `Functions` all the functions needed to run the simulation study are available.
- In order to run the simulation study, run the code given in the script `exe-sim.R`. Results can also be [downloaded here](http://aiparragirre006.quickconnect.to/d/s/tgonhxerYVfZPFffGx60NxzgYZCTDK4J/gi-G5ZCWSziY7JX76ictlBbk4cA-thyh-D7uAkZf6ewo).
- In the folder `Outputs` all the numerical results and graphics of the simulation study are available (except for the main results, which cannot be uploaded to GitHub due to space limits, and need to be downloaded from the link indicated above). All the results available in this folder have been obtained by running the code in script `exe-results.R` (please, remember to download the main results and save them in the corresponding folder before trying to run this script). 
- In the script `application.R` we put available the code used in the application shown in the paper. Note that **real data** needed to run this code **cannot be set publicly available** due to privacy issues.

