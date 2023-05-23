
table.simauc <- function(res, methods=c("std","yao","prop"),
                         filename = NULL){
  
  df <- matrix(NA, nrow = length(methods)+1, ncol = 5)
  colnames(df) <- c("min", "max", "mean(sd)", "median(Q1-Q3)","Av. Bias")
  df <- as.data.frame(df)
  rownames(df) <- c("pop", methods)
  
  
  # Table
  df[1,] <- c(round(min(res[["aucs"]][["ps"]]), digits = 3), 
              round(max(res[["aucs"]][["ps"]]), digits = 3), 
              paste0(round(mean(res[["aucs"]][["ps"]]), digits = 3), " (", round(sd(res[["aucs"]][["ps"]]), digits = 3),")"),
              paste0(round(quantile(res[["aucs"]][["ps"]], prob=0.5), digits = 3), " (", round(quantile(res[["aucs"]][["ps"]], prob = 0.25), digits = 3),", ", round(quantile(res[["aucs"]][["ps"]], prob = 0.75), digits = 3),")"),
              "-")
  
  for(m in 1:length(methods)){
    df[m+1,] <- c(round(min(res[["aucs"]][[methods[m]]]), digits = 3), 
                  round(max(res[["aucs"]][[methods[m]]]), digits = 3), 
                  paste0(round(mean(res[["aucs"]][[methods[m]]]), digits = 3), " (", round(sd(res[["aucs"]][[methods[m]]]), digits = 3),")"),
                  paste0(round(quantile(res[["aucs"]][[methods[m]]], prob=0.5), digits = 3), " (", round(quantile(res[["aucs"]][[methods[m]]], prob = 0.25), digits = 3),", ", round(quantile(res[["aucs"]][[methods[m]]], prob = 0.75), digits = 3),")"),
                  paste0(round(mean(res[["aucs"]][[methods[m]]]-res[["aucs"]][["ps"]]), digits = 3), " (", round(sd(res[["aucs"]][[methods[m]]]-res[["aucs"]][["ps"]]), digits = 3),")"))
  }
  
  if(is.null(filename)){filename <- "table"}
  write.csv(df,file = paste0("Outputs/Tables/table-", filename,".csv"))
  
}
