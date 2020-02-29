% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util.R
\name{networkLite}
\alias{networkLite}
\title{networkLite Constructor Utility}
\usage{
networkLite(el, attr)
}
\arguments{
\item{el}{an edgelist-formatted network representation, including network
attributes.}

\item{attr}{a list of named vertex attributes for the network represented
by \code{el}.}
}
\value{
A networkLite object with edge list \code{el}, vertex attributes \code{attr},
and network attributes \code{gal}.
}
\description{
Constructor function for a networkLite object.
}
\details{
This function takes an edge list \code{el} with network attributes attached,
and a list of vertex attributes \code{attr}, and returns a networkLite object,
which is a list with named fields \code{el}, \code{attr}, and \code{gal}, with
each of the first two corresponding to the argument of the same name, and
\code{gal} being the list of network attributes (copied from \code{attributes(el)})
for compatibility with some \code{network} accessors. Missing attributes
\code{directed}, \code{bipartite}, \code{loops}, \code{hyper}, and \code{multiple}
are defaulted to \code{FALSE}. The network size attribute \code{n} must not
be missing.

This new data structure is then used within the \code{\link{updateModelTermInputs}}
function for updating the structural information on the network used for ERGM
simulation.
}
\examples{
library("EpiModel")
nw <- network.initialize(n = 100, directed = FALSE)
formation <- ~edges
target.stats <- 50
coef.diss <- dissolution_coefs(dissolution = ~offset(edges), duration = 20)
x <- netest(nw, formation, target.stats, coef.diss, verbose = FALSE)

param <- param.net(inf.prob = 0.3)
init <- init.net(i.num = 10)
control <- control.net(type = "SI", nsteps = 100, nsims = 5, depend = TRUE)

# Full network structure after initialization
dat <- initialize.net(x, param, init, control)

# networkLite representation used by tergmLite
dat <- init_tergmLite(dat)

# Conversion to networkLite class format
nwl <- networkLite(dat$el[[1]], dat$attr)
nwl

}