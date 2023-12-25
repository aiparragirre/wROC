# This function is mainly copied from OptimalCutpoints package, but the result object has slightly changed.

w.function.Youden <-
function(data, marker, status, tag.healthy = 0, direction = c("<", ">"), pop.prev = NULL, measures.acc){
	direction <- match.arg(direction)

	expression.Youden <- measures.acc$Se[,1] + measures.acc$Sp[,1]-1

	cYouden <- measures.acc$cutoffs[which(round(expression.Youden,10) == round(max(expression.Youden, na.rm=TRUE),10))]

	optimal.cutoff <- w.obtain.optimal.measures(cYouden, measures.acc)
	Youden <- unique(round(optimal.cutoff$Se[,1]+optimal.cutoff$Sp[,1]-1, 10))

	res <- list(optimal.cutoff = optimal.cutoff,
	            optimal.criterion = Youden,
	            all.cutoffs = measures.acc$cutoffs,
	            criterion = expression.Youden)
	res
}
