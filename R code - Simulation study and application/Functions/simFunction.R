
simFunction <- function(population,
                        nclus.h = NULL, n.ch,
                        formula,
                        model.method = c("weighted","unweighted"), 
                        cluster = TRUE,
                        R=500, seed = 1){
  
  start <- Sys.time()
  
  formula <- as.formula(formula)
  
  # Fit the model and estimate the theoretical AUC --------------------------
  # This AUC is not mentioned in the paper, 
  # given that is the AUC of the model fitted to the finite population
  # and we are interested in estimating the AUC of the model fitted to sample.
  
  ps.model <- glm(formula, data = population, family=binomial())
  ps.model.auc <- pROC::roc(ps.model$y, ps.model$fitted.values)$auc[1]
  ps.ptrue <- ps.model$fitted.values
  

  # Vectors for the estimated AUCs ------------------------------------------

  auc.unw <- rep(NA, R)
  auc.pairw <- rep(NA, R)
  auc.w <- rep(NA, R)
  auc.ps <- rep(NA, R)
  

  # Computation times -------------------------------------------------------

  t.unw <- rep(NA, R)
  t.pairw <- rep(NA, R)
  t.w <- rep(NA, R)
  t.ps <- rep(NA, R)
  

  # Matrix: y, phat, w ------------------------------------------------------
  m.y <- m.phat <- m.w <- matrix(nrow = sum(n.ch), ncol = R)
  m.pop.phat <- matrix(nrow = nrow(population), ncol = R)
  
  
  
  # The result of the function is a list ------------------------------------
  
  out <- list()
  out$formula <- formula
  out$R <- R
  out$ps.model.auc <- ps.model.auc
  out$model.method <- model.method
  
  set.seed(seed)
  seeds <- runif(R)*1000000
  
  # Samples -----------------------------------------------------------------

  for(r in 1:R){
    
    start.r <- Sys.time()
    
    cat(">>>>> r =", r, " >>>>>\n\n")
    
    # Sample the population ---------------------------------------------------
    
    sample <- sample.2step(data = population, nclus.h = nclus.h, n.ch = n.ch,
                           seed = seeds[r], cluster = "cluster", strata = "strata")


    # Fit the model -----------------------------------------------------------
    # select model.method == "unweighted" in case you want to fit the model ignoring the sampling design
    # select model.method == "weighted" to fit the model considering the sampling design

    if(model.method=="unweighted"){
      
      model <- glm(formula, data = sample, family=binomial())
      
    } else {
      
      if(model.method=="weighted"){
        if(!cluster){
          sampling.design <- survey::svydesign(id=~1, strata=~strata, weights=~weights, data=sample, nest=TRUE)
        } else {
          sampling.design <- survey::svydesign(id=~cluster, strata=~strata, weights=~weights, data=sample, nest=TRUE)
        }
        model <- survey::svyglm(formula, design=sampling.design, family=quasibinomial())
        
      }
    }
    
    m.y[,r] <- model$y
    m.phat[,r] <- model$fitted.values
    m.w[,r] <- sample$weights 
    
    # Estimate the sample AUCs ------------------------------------------------
    
    # Unweighted method
    cat("*** Unweighted method: ***\n\n")
    start.unw <- Sys.time()
    auc.unw[r] <- unw(model$y, model$fitted.values) 
    end.unw <- Sys.time()
    t.unw[r] <- as.numeric(difftime(end.unw, start.unw, units="secs"))
    
    # AUC estimator considering pairwise sampling weights (Yao et al., 2015)
    population$h.clus <- interaction(population$strata, population$cluster)
    Thg <- table(population$h.clus)
    Kh <- apply(table(population$strata, population$cluster)!=0, 1, sum)
    
    cat("*** Pairwise sampling weights: ***\n\n") 
    start.pairw <- Sys.time()
    if(!cluster){
      auc.pairw[r] <- pairw.h(y = model$y, p = model$fitted.values, h = sample$strata, Th = table(population$strata)) 
    } else {
      population$h.clus <- interaction(population$strata, population$cluster)
      Thg <- table(population$h.clus)
      Kh <- apply(table(population$strata, population$cluster)!=0, 1, sum)
      auc.pairw[r] <- pairw.clus(y = model$y, p = model$fitted.values, h = sample$strata, clus = sample$clus, Kh = Kh, Thg = Thg) 
    }
    #auc.pairw[r] <- pairw.clus(y = model$y, p = model$fitted.values, h = sample$strata, clus = sample$clus, Kh = Kh, Thg = Thg) 
    end.pairw <- Sys.time()
    t.pairw[r] <- as.numeric(difftime(end.pairw, start.pairw, units="secs"))
    
    
    # Proposal: marginal sampling weights 
    cat("*** Marginal sampling weights (proposal): ***\n\n") 
    start.w <- Sys.time()
    auc.w[r] <- aucw(model$y, model$fitted.values, sample$weights) 
    end.w <- Sys.time()
    t.w[r] <- as.numeric(difftime(end.w, start.w, units="secs"))
    
    
    # Estimate the pseudo-population AUC --------------------------------------
    
    ps.pred <- predict(model, newdata=population, type="response")
    m.pop.phat[,r] <- ps.pred
    ps.y <- population[,as.character(formula[2])]
    start.ps <- Sys.time()
    auc.ps[r] <- pROC::roc(ps.y, ps.pred)$auc[1]
    end.ps <- Sys.time()
    t.ps[r] <- as.numeric(difftime(end.ps, start.ps, units="secs"))
    
    end.r <- Sys.time()
    time.r <- as.numeric(difftime(end.r, start.r, units="mins"))
    cat("--- Time:", time.r, " mins ---\n\n")
    

    # Save data ---------------------------------------------------------------
    
    
    
  }
  
  end <- Sys.time()
  time <- as.numeric(difftime(end, start, units="mins"))
  cat("---------- Total time:", time, " mins ----------\n\n")
  
  out$aucs <- list(unw = auc.unw, pairw = auc.pairw, w = auc.w, ps = auc.ps)
  out$times <- list(unw = t.unw, pairw = t.pairw, w = t.w, ps = t.ps)
  out$m.data <- list(y = m.y, phat = m.phat, w = m.w)
  out$m.pop <- list(y = population[,as.character(formula[2])],
                    phat = m.pop.phat,
                    pop.ptrue = ps.ptrue)

  class(out) <- "simauc"
  return(out)
  
}
