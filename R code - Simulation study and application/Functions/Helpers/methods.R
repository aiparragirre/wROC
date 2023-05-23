

# 1) Unweighted (Mann-Whitney U-statistic)

unw <- function(y, p){
  
  p0 <- p[which(y==0)]
  p1 <- p[which(y==1)]
  
  auc <- (sum(outer(p1, p0, ">")) + 0.5*sum(outer(p1, p0, "==")))/(length(p0)*length(p1))
  
  return(auc)
  
}


# 2) Proposal: marginal sampling weights

aucw <- function(y, p, w){
  
  p0 <- p[which(y==0)]
  p1 <- p[which(y==1)]
  
  w0 <- w[which(y==0)]
  w1 <- w[which(y==1)]
  
  
  auc <- (sum(outer(w1, w0, "*")[which(outer(p1, p0, ">"))]) + 0.5*sum(outer(w1, w0, "*")[which(outer(p1, p0, "=="))]))/(sum(w0)*sum(w1))
  
  return(auc)
  
}



# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
# -------------------------------------------------------------------------


# 3) Pairwise sampling weights (Yao et al., 2015)

pairw.h <- function(y, p, h, Th){
  

  # Reorganizing data
  df <- data.frame(y = y, p = p, h = h)
  
  df.Th <- data.frame(h = names(Th), Th = as.vector(Th))
  df <- merge(df, df.Th, by="h", all=T)
  df.th <- data.frame(h = names(table(h)), th = as.vector(table(h)))
  df <- merge(df, df.th, by="h", all=T)
  df$Th_th <- df$Th/df$th
  df$Th_th_1 <- (df$Th-1)/(df$th-1)
  
  # Strata information
  df.h <- merge(df.Th, df.th, by="h", all=T)
  df.th1 <- data.frame(h=names(table(df[which(df$y==1),"h"])), th1=as.vector(table(df[which(df$y==1),"h"])))
  df.h <- merge(df.h, df.th1, by="h", all=T)
  df.th0 <- data.frame(h=names(table(df[which(df$y==0),"h"])), th0=as.vector(table(df[which(df$y==0),"h"])))
  df.h <- merge(df.h, df.th0, by="h", all=T)
  df.h[which(is.na(df.h$th1)),"th1"] <- 0
  df.h[which(is.na(df.h$th0)),"th0"] <- 0
  

  rm(df.Th, df.th, df.th1, df.th0)
  
  # Calculating the sum ---------------------------------------------------
  
  df.0 <- df[which(df$y==0),]
  df.1 <- df[which(df$y==1),]
  
  # Pairs that satisfy the inequality
  elem.p <- which(outer(df.1$p, df.0$p, ">"))
  elem.p.equal <- which(outer(df.1$p, df.0$p, "=="))
  # Pairs in the same stratum
  elem.h <- which(outer(df.1$h, df.0$h, "=="))
  
  same.h <- elem.p[which(elem.p %in% elem.h)]
  diff.h <- elem.p[-which(elem.p %in% elem.h)]
  equal.same.h <- elem.p.equal[which(elem.p.equal %in% elem.h)]
  equal.diff.h <- elem.p.equal[-which(elem.p.equal %in% elem.h)]
  

  greater <- sum(outer(df.1$Th_th, df.0$Th_th_1, "*")[same.h]) + sum(outer(df.1$Th_th, df.0$Th_th, "*")[diff.h])
  equal <- sum(outer(df.1$Th_th, df.0$Th_th_1, "*")[equal.same.h]) + sum(outer(df.1$Th_th, df.0$Th_th, "*")[equal.diff.h])
  
  
  Th0_hat <- sum((df.h$th0/df.h$th)*df.h$Th)
  Th1_hat <- sum((df.h$th1/df.h$th)*df.h$Th)
  

  # AUC estimation -----------------------------------------------------
  
  auc <- (greater + 0.5*equal)/(Th0_hat*Th1_hat)
  
  return(auc)
  
}

pairw.clus <- function(y, p, h, clus, Kh, Thg){
  
  
  df <- data.frame(y = y, p = p, h = h, clus = clus)
  df$h.clus <- interaction(df$h, df$clus, drop=FALSE)
  
  df.Kh <- data.frame(h = names(Kh), Kh = as.vector(Kh))
  df <- merge(df, df.Kh, by="h", all=F)
  df.kh <- data.frame(h = names(apply(table(h, clus)!=0, 1, sum)), kh = as.vector(apply(table(h, clus)!=0, 1, sum)))
  df <- merge(df, df.kh, by="h", all=F)
  df$Kh_kh <- df$Kh/df$kh
  df$Kh_kh_1 <- (df$Kh-1)/(df$kh-1)
  
  df.Thg <- data.frame(h.clus = names(Thg), Thg = as.vector(Thg))
  df <- merge(df, df.Thg, by = "h.clus", all = F)
  df.thg <- data.frame(h.clus = names(table(df$h.clus)), thg = as.vector(table(df$h.clus)))
  df <- merge(df, df.thg, by="h.clus", all = F)
  df$Thg_thg <- df$Thg/df$thg
  df$Thg_thg_1 <- (df$Thg-1)/(df$thg-1)
  
  
  rm(df.Thg, df.thg, df.Kh, df.kh)
  
  
  df.0 <- df[which(df$y==0),]
  df.1 <- df[which(df$y==1),]
  
  elem.p <- which(outer(df.1$p, df.0$p, ">"))
  elem.p.equal <- which(outer(df.1$p, df.0$p, "=="))
  elem.hclus <- which(outer(df.1$h.clus, df.0$h.clus, "=="))
  elem.h <- which(outer(df.1$h, df.0$h, "=="))
  elem.hbai.clusez <- elem.h[-which(elem.h %in% elem.hclus)]
  
  
  same.hclus <- elem.p[which(elem.p %in% elem.hclus)]
  same.hbai.clusez <- elem.p[which(elem.p %in% elem.hbai.clusez)]
  diff.h <- elem.p[-which(elem.p %in% elem.h)]
  
  equal.same.hclus <- elem.p.equal[which(elem.p.equal %in% elem.hclus)]
  equal.same.hbai.clusez <- elem.p.equal[which(elem.p.equal %in% elem.hbai.clusez)]
  equal.diff.h <- elem.p.equal[-which(elem.p.equal %in% elem.h)]
  
  greater <- sum(outer(df.1$Kh_kh*df.1$Thg_thg, df.0$Thg_thg_1, "*")[same.hclus]) + sum(outer(df.1$Kh_kh*df.1$Thg_thg, df.0$Kh_kh_1*df.0$Thg_thg, "*")[same.hbai.clusez]) + sum(outer(df.1$Kh_kh*df.1$Thg_thg, df.0$Kh_kh*df.0$Thg_thg, "*")[diff.h])
  equal <- sum(outer(df.1$Kh_kh*df.1$Thg_thg, df.0$Thg_thg_1, "*")[equal.same.hclus]) + sum(outer(df.1$Kh_kh*df.1$Thg_thg, df.0$Kh_kh_1*df.0$Thg_thg, "*")[equal.same.hbai.clusez]) + sum(outer(df.1$Kh_kh*df.1$Thg_thg, df.0$Kh_kh*df.0$Thg_thg, "*")[equal.diff.h])
  
  
  Th0_hat <- sum(df.0$Thg_thg*df.0$Kh_kh)
  Th1_hat <- sum(df.1$Thg_thg*df.1$Kh_kh)
  
  
  auc <- (greater + 0.5*equal)/(Th0_hat*Th1_hat)
  
  return(auc)
  
}



