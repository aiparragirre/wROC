# This function is mainly copied from OptimalCutpoints package, but the result object has slightly changed

w.function.MaxEfficiency <-
function(data, marker, status, tag.healthy = 0, direction = c("<", ">"), pop.prev, measures.acc){
	direction <- match.arg(direction)

	Efficiency <- pop.prev*measures.acc$Se[,1]+(1-pop.prev)*measures.acc$Sp[,1]

  cMaxEfficiency <- measures.acc$cutoffs[which(round(Efficiency,10) == round(max(Efficiency,na.rm=TRUE),10))]

	optimal.Efficiency <- max(Efficiency,na.rm=TRUE)

	optimal.cutoff <- w.obtain.optimal.measures(cMaxEfficiency, measures.acc)

  res <- list(optimal.cutoff = optimal.cutoff,
              optimal.criterion = optimal.Efficiency,
              all.cutoffs = measures.acc$cutoffs,
              criterion = Efficiency)
	res
}
