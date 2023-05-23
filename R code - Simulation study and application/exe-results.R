rm(list=ls())

# Functions ---------------------------------------------------------------

sapply(paste0("Functions/",list.files(path = "Functions", full.names=F, recursive = TRUE, pattern='\\.[rR]$')), source)


# Results -----------------------------------------------------------------

# select one from: 
# --> "sim_scenario_SH_a"
# --> "sim_scenario_SH_b"
# --> "sim_scenario_SC0_a"
# --> "sim_scenario_SCO_b"
# --> "sim_scenario_SC1_a"
# --> "sim_scenario_SC1_b"

res <- "sim_scenario_SH_a"


# Run all:

load(paste0("Outputs/Results/", res, ".RData"))

opts <- c("sim_scenario_SH_a", 
          "sim_scenario_SH_b",
          "sim_scenario_SC0_a",
          "sim_scenario_SC0_b",
          "sim_scenario_SC1_a",
          "sim_scenario_SC1_b")

mains <- c("Scenario SH (a)",
           "Scenario SH (b)",
           "Scenario SC.0 (a)",
           "Scenario SC.0 (b)",
           "Scenario SC.1 (a)",
           "Scenario SC.1 (b)")
main <- mains[which(opts %in% res)]


# 1) Boxplots: to compare weighted and unweighted estimates
# -------------------------------------------------------------------------
if(res %in% c("sim_scenario_SH_a", "sim_scenario_SC0_a", "sim_scenario_SC1_a")){
  ylim = c(-0.2, 0.15)
} else {
  ylim = c(-0.10, 0.25)
}
boxplot(get(res), methods=c("unw","w"), 
        names=c("unweighted","weighted"), 
        ylab = "diff", main = main,
        ylim = ylim,
        col = c("#DE912C","#588FC7"),
        filename = res)



# 2) ROC curves
# -------------------------------------------------------------------------
# It takes quite a long time, don't run unless necessary:

plot.simrocs(res, main = main) 



# 3) Comparing pairwise and marginal sampling weights estimators
# -------------------------------------------------------------------------

pdf(file = paste0("Outputs/Figures/diff_pairw_", res,".pdf"))
par(mar = c(2, 4, 4, 2) + 0.1)
diff2 <- get(res)[["aucs"]][["pairw"]]-get(res)[["aucs"]][["w"]]
boxplot(diff2, col = "#B2BEB5", ylim = c(-0.0025, 0.007), 
        ylab = "diff.2", main = main, cex.lab=1.25, cex.axis=1.25, cex.main=1.25)
abline(h=0, col = "red")
dev.off()



# 4) Numerical results
# -------------------------------------------------------------------------

table.simauc(get(res), methods = c("unw", "pairw", "w"), filename = res)



