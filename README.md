# wroc

In this repository, we put available the simulation study (code and results) of the paper entitled "Estimation of the ROC curve and the area under it with complex survey data".

## R package

The R package to plot weighted estimates of the ROC curves and to obtain weighted estimates of the AUC is available in the folder `wroc`. Run the following code to install the package in R:

```{r}
library(devtools)
install_github("aiparragirre/wroc/wroc")
```

Two functions can be used:

- `wroc`: to plot the ROC curves.
- `wauc`: to estimate the AUC.



## R code - Simulation study and application

In this folder, it is avaialble all the code and results related to the simulation study. In particular:

- In the folder `Functions` all the functions needed to run the simulation study are available.
- In order to run the simulation study, run the code given in the script `exe-sim.R`.
- In order to obtain and depict the results of the simulation study, run the code in script `exe-results.R`
- In the folder `Outputs` all the results of the simulation study are available.
- In the script `application.R` we put available the code used in the application shown in the paper. Note that real data needed to run this code cannot be set publicly available due to privacy issues.
