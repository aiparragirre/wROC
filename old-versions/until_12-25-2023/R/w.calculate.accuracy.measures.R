# This function is mainly copied from OptimalCutpoints package, but sampling weights are incorporated.

w.calculate.accuracy.measures <-
function(data, weights, marker, status, tag.healthy, direction = c("<", ">"), pop.prev) {
	direction <- match.arg(direction)

	# Validate the prevalence:
	if (is.na(pop.prev) || is.null(pop.prev)) {
		pop.prev <- w.calculate.sample.prev(data = data, status = status, tag.healthy = tag.healthy, weights = weights)
	}
	w.validate.prevalence(pop.prev)

	cutoff <- sort(unique(data[,marker]))
	marker.healthy = data[data[,status] == tag.healthy, marker]
	marker.diseased = data[data[,status] != tag.healthy, marker]

	weights.healthy = data[data[,status] == tag.healthy, weights]
	weights.diseased = data[data[,status] != tag.healthy, weights]

	n <- list(h = sum(weights.healthy), d = sum(weights.diseased))

	if(n$h == 0) {
  		stop("There are no healthy subjects in your dataset, so Specificity cannot be calculated.")
	}
	if(n$d == 0) {
  		stop("There are no diseased subjects in your dataset, so Sensitivity cannot be calculated.")
	}

	c.names <- "Value"
	Se <- Sp <- matrix(ncol=1, nrow = length(cutoff), dimnames = list(1:length(cutoff), c.names))

	if(direction == "<") {
		testSe <- outer(marker.diseased,cutoff,">=")*weights.diseased
		testSp <- outer(marker.healthy,cutoff,"<")*weights.healthy
	} else {
		testSe <- outer(marker.diseased,cutoff,"<=")*weights.diseased
		testSp <- outer(marker.healthy,cutoff,">")*weights.healthy
	}
	Se[,1] <- apply(testSe,2,sum)/(n$d)
	Sp[,1] <- apply(testSp,2,sum)/(n$h)

	res <- list(cutoffs = cutoff,
	            Se = Se,
	            Sp = Sp,
	            pop.prev = pop.prev,
	            n = n
	            )
	return(res)
}
