# wROC

In this repository, we put available the simulation study (code and results) of the paper entitled "Estimation of the ROC curve and the area under it with complex survey data" (2023) Iparragirre A., Barrio I., Arostegui I., *Stat* **12**(1), e635 (https://doi.org/10.1002/sta4.635). The R package `wROC` can also be installed from this repository.

The goal of this repository is two-fold:

- To put publicly available the R package `wROC`. This package allows to estimate the ROC curve and AUC of logistic regression models fitted to complex survey data. In addition, with this package, we can also obtain optimal cut-off points for individual classification considering sampling weights with complex survey data.
- The simulation study (code and results) of the paper entitled "Estimation of the ROC curve and the area under it with complex survey data" (Iparragirre A., Barrio I., Arostegui I.) can also be found.

**The package has now been UPDATED** to enable the optimism correction of the AUC with Complex Survey Data by means of replicate weights (see the related contribution on: https://link.springer.com/chapter/10.1007/978-3-031-65723-8_7).

## R package

> [!WARNING]
> **This package is now available in CRAN as [svyROC](https://cran.r-project.org/web/packages/svyROC/index.html).**

The R package `wROC` to plot weighted estimates of the ROC curves and to obtain weighted estimates of the AUC is available in the folder `wROC`.

The following functions are available:

- `wse`, `wsp`: estimate sensitivity and specificity parameters for a specific cut-off point considering sampling weights.
- `wroc`: estimate the ROC curve considering sampling weights.
- `wauc`: estimate the AUC considering sampling weights.
- `corrected.wauc`: correct the optimism of the weighted estimate of the AUC by means of replicate weights.
- `wocp`: calculate optimal cut-off points for individual classification considering sampling weights.
- `wroc.plot`: plot the ROC curve.

The methodology proposed for the above-mentioned functions can be found in the following **references**:

- Iparragirre, A., Barrio, I., Aramendi, J. and Arostegui, I. (2022). Estimation of cut-off points under complex-sampling design data. *SORT-Statistics and Operations Research Transactions* **46**(1), 137--158. (https://doi.org/10.2436/20.8080.02.121)

- Iparragirre, A., Barrio, I. and Arostegui, I. (2023). Estimation of the ROC curve and the area under it with complex survey data. *Stat* **12**(1), e635. (https://doi.org/10.1002/sta4.635)

- Iparragirre, A. and Barrio, I. (2024). Optimism Correction of the AUC with Complex Survey Data. In: Einbeck, J., Maeng, H., Ogundimu, E., Perrakis, K. (eds) Developments in Statistical Modelling. IWSM 2024. Contributions to Statistics. Springer, Cham. (https://doi.org/10.1007/978-3-031-65723-8_7) 

### Installation of the R package

Run the following code to install the package in R (package `devtools` required to run the code):

```{r}
library(devtools)
install_github("aiparragirre/wROC/wROC")
```
**The current package has been updated on 12/25/2023. The older versions are available in the folder `old_versions`.**


### Usage

We need information on three elements for each unit in the sample in order to estimate the ROC curve (`wroc()` function) and AUC (`wauc()` function):

- `response.var`: variable indicating the dichotomous response variable.
- `phat.var`: predicted probabilities of event.
- `weights.var`: variable indicating the sampling weights.

We can put these three vectors in a data frame, or save them separately in three different vectors. The data set `example_data_wroc` is set as an example in the package. We also need to define the tags for events and non-events.

```{r}
data(example_data_wroc)

mycurve <- wroc(response.var = "y", phat.var = "phat", weights.var = "weights",
                data = example_data_wroc,
                tag.event = 1, tag.nonevent = 0)

# Or equivalently
mycurve <- wroc(response.var = example_data_wroc$y,
                phat.var = example_data_wroc$phat,
                weights.var = example_data_wroc$weights,
                tag.event = 1, tag.nonevent = 0)
```


Similarly, we can run the following code to estimate the AUC:

```{r}
auc.obj <- wauc(response.var = "y",
                phat.var = "phat",
                weights.var = "weights",
                tag.event = 1,
                tag.nonevent = 0,
                data = example_data_wroc)

# Or equivalently
auc.obj <- wauc(response.var = example_data_wroc$y,
                phat.var = example_data_wroc$phat,
                weights.var = example_data_wroc$weights,
                tag.event = 1, tag.nonevent = 0)
```

We can correct the optimism of the weighted estimate of the AUC by means of replicate weights, as proposed in Iparragirre and Barrio (2024), by means of the `corrected.wauc()` function. For this purpose, we additionally need information on the covariates and the sampling design. Here is an example of the usage of this function:

```{r}

data(example_variables_wroc)
mydesign <- survey::svydesign(ids = ~cluster, strata = ~strata,
                              weights = ~weights, nest = TRUE,
                              data = example_variables_wroc)
m <- survey::svyglm(y ~ x1 + x2 + x3 + x4 + x5 + x6, design = mydesign,
                    family = quasibinomial())
phat <- predict(m, newdata = example_variables_wroc, type = "response")
myaucw <- wauc(response.var = example_variables_wroc$y, phat.var = phat,
               weights.var = example_variables_wroc$weights)

# Correction of the AUCw:
set.seed(1)
cor <- corrected.wauc(data = example_variables_wroc,
                      formula = y ~ x1 + x2 + x3 + x4 + x5 + x6,
                      tag.event = 1, tag.nonevent = 0,
                      weights.var = "weights", strata.var = "strata", cluster.var = "cluster",
                      method = "dCV", dCV.method = "pooling", k = 10, R = 20)
# Or equivalently:
set.seed(1)
cor <- corrected.wauc(design = mydesign,
                      formula = y ~ x1 + x2 + x3 + x4 + x5 + x6,
                      tag.event = 1, tag.nonevent = 0,
                      method = "dCV", dCV.method = "pooling", k = 10, R = 20)

```

We can also estimate the sensitivity (`wse()`) and specificity (`wsp()`) parameters for a specific cut-off point considering sampling weights. For this purpose, we need to indicate the cut-off point we want to use in the function by means of the argument `cutoff.value`:

```{r}

# Specificity ----------------------------------------------------------

sp.obj <- wsp(response.var = "y",
              phat.var = "phat",
              weights.var = "weights",
              tag.nonevent = 0,
              cutoff.value = 0.5,
              data = example_data_wroc)

# Or equivalently
sp.obj <- wsp(response.var = example_data_wroc$y,
              phat.var = example_data_wroc$phat,
              weights.var = example_data_wroc$weights,
              tag.nonevent = 0,
              cutoff.value = 0.5)
   
# Sensitivity ----------------------------------------------------------

se.obj <- wse(response.var = "y",
              phat.var = "phat",
              weights.var = "weights",
              tag.event = 1,
              cutoff.value = 0.5,
              data = example_data_wroc)

# Or equivalently
se.obj <- wse(response.var = example_data_wroc$y,
              phat.var = example_data_wroc$phat,
              weights.var = example_data_wroc$weights,
              tag.event = 1,
              cutoff.value = 0.5)
```

Finally, use the function `wocp()` to obtain optimal cut-off points for individual classification as proposed in Iparragirre et al (2022). Some functions of the package `OptimalCutpoints` have been modified in order for them to consider sampling weights:

Lopez-Raton, M., Rodriguez-Alvarez, M.X, Cadarso-Suarez, C. and Gude-Sampedro, F. (2014). OptimalCutpoints: An R Package for Selecting Optimal Cutpoints in Diagnostic Tests. *Journal of Statistical Software* **61**(8), 1--36.

One of the methods proposed in the paper needs to be selected when running the function by means of the argument `method`: `Youden`, `MaxProdSpSe`, `ROC01` or `MaxEfficiency`.

```{r}
myocp <- wocp(response.var = "y",
              phat.var = "phat", weights.var = "weights",
              tag.event = 1,
              tag.nonevent = 0,
              method = "Youden",
              data = example_data_wroc)

# Or equivalently
myocp <- wocp(example_data_wroc$y,
              example_data_wroc$phat,
              example_data_wroc$weights,
              tag.event = 1,
              tag.nonevent = 0,
              method = "Youden")

```

If you want to draw the optimal cut-off point in the ROC curve, then use the function `wroc.plot()` and indicate the method by means of the argument `cutoff.method` in the function `wroc()` as follows:

```{r}
mycurve <- wroc(response.var = "y",
                phat.var = "phat",
                weights.var = "weights",
                data = example_data_wroc,
                tag.event = 1,
                tag.nonevent = 0,
                cutoff.method = "Youden")
wroc.plot(x = mycurve,
          print.auc = TRUE,
          print.cutoff = TRUE)
```

## R code - Simulation study and application

In this folder, it is available all the code and results related to the simulation study. In particular:

- In the folder `Functions` all the functions needed to run the simulation study are available.
- In order to run the simulation study, run the code given in the script `exe-sim.R`. Results can also be [downloaded here](http://aiparragirre006.quickconnect.to/d/s/tgfgP7Ok1PNY7DUAzIux8J3WmfJmCYyS/_ZuzJJKB0iel11EC38x5yewjBAJseQGK-q71gVYbhuQo).
- In the folder `Outputs` all the numerical results and graphics of the simulation study are available (except for the main results, which cannot be uploaded to GitHub due to space limits, and need to be downloaded from the link indicated above). All the results available in this folder have been obtained by running the code in script `exe-results.R` (please, remember to download the main results and save them in the corresponding folder before trying to run this script). 
- In the script `application.R` we put available the code used in the application shown in the paper. Note that **real data** needed to run this code **cannot be set publicly available** due to privacy issues.

