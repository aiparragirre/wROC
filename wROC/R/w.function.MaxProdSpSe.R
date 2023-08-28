# This function is mainly copied from OptimalCutpoints package, but the result object has slightly changed.

w.function.MaxProdSpSe <-
function(data, marker, status, tag.healthy = 0, direction = c("<", ">"), pop.prev = NULL, measures.acc){
	direction <- match.arg(direction)

	prod <- measures.acc$Sp[,1] * measures.acc$Se[,1]
	cmaxProdSpSe <- measures.acc$cutoffs[which(round(prod,10) == round(max(prod,na.rm=TRUE),10))]
	optimal.prod <- max(prod,na.rm=TRUE)

	optimal.cutoff <- w.obtain.optimal.measures(cmaxProdSpSe, measures.acc)

	res <- list(optimal.cutoff = optimal.cutoff,
	            optimal.criterion = optimal.prod,
	            all.cutoffs = measures.acc$cutoffs,
	            criterion = prod)
	res
}
