# This function is mainly copied from OptimalCutpoints package, but the result object has slightly changed.

w.function.ROC01 <-
function(data, marker, status, tag.healthy = 0, direction = c("<", ">"), pop.prev = NULL, measures.acc){
	direction <- match.arg(direction)

	distance <- (measures.acc$Sp[,1]-1)^2+(measures.acc$Se[,1]-1)^2

	cROC01 <- measures.acc$cutoffs[which(round(distance,10) == round(min(distance,na.rm=TRUE),10))]
	optimal.distance <- min(distance,na.rm=TRUE)

	optimal.cutoff <- w.obtain.optimal.measures(cROC01, measures.acc)

	res <- list(optimal.cutoff = optimal.cutoff,
	            optimal.criterion = optimal.distance,
	            all.cutoffs = measures.acc$cutoffs,
	            criterion = distance)
	res
}
