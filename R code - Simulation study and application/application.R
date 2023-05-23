
rm(list=ls())

library(pROC)
library(survey)
options("survey.lonely.psu"='remove')



# Application -------------------------------------------------------------

sampling.design <- survey::svydesign(id=~1, strata=~strata, weights=~weights, data=data, fpc = ~fpc)
model <- survey::svyglm(y ~ x1 + x2 + x3, design=sampling.design, family=quasibinomial())



# Unweighted AUC Bootstrap CI 
# -------------------------------------------------------------------------

roc(model$y, model$fitted.values)$auc[1]
set.seed(123)
ci.auc(model2$y, model2$fitted.values, method="bootstrap")



# Bootstrap CI for AUCw
# -------------------------------------------------------------------------

aucw(y = model$y, model$fitted.values, w=data$weights)

B <- 2000
conf.level <- 0.95

set.seed(123)
rep.design <- as.svrepdesign(design = sampling.design, type = "subbootstrap", replicates = B)
boot.weights <- rep.design$repweights$weights

aucw.B <- rep(NA, B)
for(b in 1:B){
  cat("\n>>>>> b = ", b," >>>>>\n")
  aucw.B[b] <- aucw(y = model$y, model$fitted.values, w=data$weights*boot.weights[,b])  
}
quantile(aucw.B, c(0+(1-conf.level)/2, .5, 1-(1-conf.level)/2))




# Plot ROC and ROCw curves
# -------------------------------------------------------------------------

data$phat <- model$fitted.values

# Weighted ROC curve:
all.phat <- sort(unique(data[,"phat"]))

lower <- all.phat[1:(length(all.phat)-1)]
upper <- all.phat[2:length(all.phat)]
cutoffs <- c(0, (lower+upper)/2, 1)

sew.v <- unlist(lapply(cutoffs, sew, data = data, response.var = "y", event = 1, phat.var = "phat", weight.var = "weights"))
spw.v <- unlist(lapply(cutoffs, spw, data = data, response.var = "y", nonevent = 0, phat.var = "phat", weight.var = "weights"))
inv.spw.v <- 1 - spw.v
plot.df <- data.frame(sew.v, inv.spw.v)


# Unweighted ROC curve
data$w1 <- rep(1, nrow(data))
se.v <- unlist(lapply(cutoffs, sew, data = data, response.var = "y", event = 1, phat.var = "phat", weight.var = "w1"))
sp.v <- unlist(lapply(cutoffs, spw, data = data, response.var = "y", nonevent = 0, phat.var = "phat", weight.var = "w1"))
inv.sp.v <- 1 - sp.v
plot.unw.df <- data.frame(se.v, inv.sp.v)


# Plot both curves:
pdf(file="application.pdf")
plot(x = plot.df$inv.spw.v, y = plot.df$sew.v, type = "l",
     xlab = "1-Spw(c)", ylab = "Sew(c)", main = "ROCw Curve", 
     col = "#588FC7", lwd = 2)
abline(a = 0, b = 1, lty = 2, col = "gray")
legend(x = "bottomright", legend = c("Weighted","Unweighted"), lty = c(1,1), 
       col = c("#588FC7","#DE912C"), bty = "n", lwd = 2)
points(x = plot.df$inv.sp.v, y = plot.df$se.v, type = "l", lty = 1, 
       col = "#DE912C", lwd = 2)
dev.off()





