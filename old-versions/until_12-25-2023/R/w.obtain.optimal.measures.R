# This function is mainly copied from OptimalCutpoints package, but some unnecessary meassures have been deleted.

w.obtain.optimal.measures <-
function(value, measures.acc) {
	position <- which(measures.acc$cutoffs %in% value)

	Se.v <- measures.acc$Se[position,,drop = FALSE]
	Sp.v <- measures.acc$Sp[position,,drop = FALSE]

	res <- list(cutoff = value, Se = Se.v, Sp = Sp.v)
	return(res)
}
