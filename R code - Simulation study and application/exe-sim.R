rm(list=ls())

# Packages ----------------------------------------------------------------

library(MASS)
library(survey)

# Functions ---------------------------------------------------------------

sapply(paste0("Functions/",list.files(path = "Functions", full.names=F, recursive = TRUE, pattern='\\.[rR]$')), source)


# -------------------------------------------------------------------------
# Scenario SH
# -------------------------------------------------------------------------

pop_scenario_SH <- generate.pop(npop = 10000,
                                mu = rep(0, 7),
                                rho = 0.15,
                                beta0 = -5,
                                beta = rep(2.5, 5),
                                gamma = rep(-3.5, 2),
                                H = 10, C = 1,
                                seed = 1)
# (a)

sim_scenario_SH_a <- simFunction(population = pop_scenario_SH$data,
                                 nclus.h = rep(1,10),
                                 n.ch = c(75*2, 50*2, 25*2, 20*2, 15*2, 
                                          15*2, 20*2, 25*2, 50*2, 75*2),
                                 formula <- y ~ x.1 + x.2 + x.3 + x.4 + x.5,
                                 model.method = "weighted",
                                 cluster = FALSE,
                                 R=500)

save(sim_scenario_SH_a, file = paste0("Outputs/Results/sim_scenario_SH_a.RData"))

# (b)

sim_scenario_SH_b <- simFunction(population = pop_scenario_SH$data,
                                 nclus.h = rep(1, 10),
                                 n.ch = c(15*2, 20*2, 25*2, 50*2, 75*2, 
                                          75*2, 50*2, 25*2, 20*2, 15*2),
                                 formula <- y ~ x.1 + x.2 + x.3 + x.4 + x.5,
                                 model.method = "weighted",
                                 cluster = FALSE,
                                 R=500)

save(sim_scenario_SH_b, file = paste0("Outputs/Results/sim_scenario_SH_b.RData"))



# -------------------------------------------------------------------------
# Scenario SC.0
# -------------------------------------------------------------------------

pop_scenario_SC0 <- generate.pop(npop = 10000,
                                 mu = rep(0, 7),
                                 rho = 0.15,
                                 beta0 = -5,
                                 beta = rep(2.5, 5),
                                 gamma = rep(-3.5, 2),
                                 H = 10, C = 10,
                                 seed = 1)


# (a)

sim_scenario_SC0_a <- simFunction(population = pop_scenario_SC0$data,
                                  nclus.h = rep(2, 10),
                                  n.ch = c(rep(75, 2), rep(50, 2), rep(25, 2), rep(20, 2), rep(15, 2), 
                                           rep(15, 2), rep(20, 2), rep(25, 2), rep(50, 2), rep(75, 2)),
                                  formula <- y ~ x.1 + x.2 + x.3 + x.4 + x.5,
                                  model.method = "weighted",
                                  R=500)

save(sim_scenario_SC0_a, file = paste0("Outputs/Results/sim_scenario_SC0_a.RData"))


# (b)

sim_scenario_SC0_b <- simFunction(population = pop_scenario_SC0$data,
                                  nclus.h = rep(2, 10),
                                  n.ch = c(rep(15, 2), rep(20, 2), rep(25, 2), rep(50, 2), rep(75, 2), 
                                           rep(75, 2), rep(50, 2), rep(25, 2), rep(20, 2), rep(15, 2)),
                                  formula <- y ~ x.1 + x.2 + x.3 + x.4 + x.5,
                                  model.method = "weighted",
                                  R=500)

save(sim_scenario_SC0_b, file = paste0("Outputs/Results/sim_scenario_SC0_b.RData"))



# -------------------------------------------------------------------------
# Scenario SC.1
# -------------------------------------------------------------------------

pop_scenario_SC1 <- generate.pop(npop = 10000,
                                 mu = rep(0, 7),
                                 rho = 0.15,
                                 beta0 = -5,
                                 var.clus = 1,
                                 beta = rep(2.5, 5),
                                 gamma = rep(-3.5, 2),
                                 H = 10, C = 10,
                                 seed = 1)


# (a)

sim_scenario_SC1_a <- simFunction(population = pop_scenario_SC1$data,
                                  nclus.h = rep(2, 10),
                                  n.ch = c(rep(75, 2), rep(50, 2), rep(25, 2), rep(20, 2), rep(15, 2), 
                                           rep(15, 2), rep(20, 2), rep(25, 2), rep(50, 2), rep(75, 2)),
                                  formula <- y ~ x.1 + x.2 + x.3 + x.4 + x.5,
                                  model.method = "weighted",
                                  R=500)

save(sim_scenario_SC1_a, file = paste0("Outputs/Results/sim_scenario_SC1_a.RData"))

# (b)

sim_scenario_SC1_b <- simFunction(population = pop_scenario_SC1$data,
                                  nclus.h = rep(2, 10),
                                  n.ch = c(rep(15, 2), rep(20, 2), rep(25, 2), rep(50, 2), rep(75, 2), 
                                           rep(75, 2), rep(50, 2), rep(25, 2), rep(20, 2), rep(15, 2)),
                                  formula <- y ~ x.1 + x.2 + x.3 + x.4 + x.5,
                                  model.method = "weighted",
                                  R=500)

save(sim_scenario_SC1_b, file = paste0("Outputs/Results/sim_scenario_SC1_b.RData"))


