

#' @title Fast Version of network::add.vertices for Edgelist-formated Network
#'
#' @description This function performs a simple operation of updating the
#'              edgelist attribute \code{n} that tracks the total network
#'              size implicit in an edgelist representation of the network.
#'
#' @param el A two-column matrix of current edges (edgelist) with an attribute
#'           variable \code{n} containing the total current network size.
#' @param nv A integer equal to the number of nodes to add to the network
#'           size at the given time step.
#'
#' @details
#' This function is used in \code{EpiModel} modules to add vertices (nodes) to the
#' edgelist object to account for entries into the population (e.g., births and
#' in-migration)
#'
#' @return
#' Returns the updated the attribute containing the population size on the
#' edgelist, \code{el}, based on the number of new vertices specified to be
#' added in \code{nv}.
#'
#' @export
#'
#' @examples
#' library("EpiModel")
#' nw <- network.initialize(n = 100, directed = FALSE)
#' formation <- ~edges
#' target.stats <- 50
#' coef.diss <- dissolution_coefs(dissolution = ~offset(edges), duration = 20)
#' x <- netest(nw, formation, target.stats, coef.diss, verbose = FALSE)
#'
#' param <- param.net(inf.prob = 0.3)
#' init <- init.net(i.num = 10)
#' control <- control.net(type = "SI", nsteps = 100, nsims = 5, depend = TRUE)
#'
#' # Full network structure after initialization
#' dat <- initialize.net(x, param, init, control)
#'
#' # networkLite representation used by tergmLite
#' dat <- init_tergmLite(dat)
#'
#' # Check current network size
#' attributes(dat$el[[1]])$n
#'
#' # Add 10 vertices
#' dat$el[[1]] <- add_vertices(dat$el[[1]], 10)
#'
#' # Check new network size
#' attributes(dat$el[[1]])$n
#'
add_vertices <- function(el, nv) {
  attributes(el)$n <- attributes(el)$n + nv
  return(el)
}


#' @title Fast Version of network::delete.vertices for Edgelist-formated Network
#'
#' @description Given a current two-column matrix of edges and a vector of IDs
#'              to delete from the matrix, this function first removes any rows
#'              of the edgelist in which the IDs are present and then permutes
#'              downward the index of IDs on the edgelist that were numerically
#'              larger than the IDs deleted.
#'
#' @param el A two-column matrix of current edges (edgelist) with an attribute
#'           variable \code{n} containing the total current network size.
#' @param vid A vector of IDs to delete from the edgelist.
#'
#' @details
#' This function is used in \code{EpiModel} modules to remove vertices (nodes)
#' from the edgelist object to account for exits from the population (e.g.,
#' deaths and out-migration)
#'
#' @return
#' Returns a updated edgelist object, \code{el}, with the edges of deleted
#' vertices removed from the edgelist and the ID numbers of the remaining edges
#' permuted downward.
#'
#' @export
#'
#' @examples
#' library("EpiModel")
#' nw <- network.initialize(n = 100, directed = FALSE)
#' formation <- ~edges
#' target.stats <- 50
#' coef.diss <- dissolution_coefs(dissolution = ~offset(edges), duration = 20)
#' x <- netest(nw, formation, target.stats, coef.diss, verbose = FALSE)
#'
#' param <- param.net(inf.prob = 0.3)
#' init <- init.net(i.num = 10)
#' control <- control.net(type = "SI", nsteps = 100, nsims = 5, depend = TRUE)
#'
#' # Set seed for reproducibility
#' set.seed(123456)
#'
#' # Full network structure after initialization
#' dat <- initialize.net(x, param, init, control)
#'
#' # networkLite representation used by tergmLite
#' dat <- init_tergmLite(dat)
#'
#' # Current edges include {1, 87}, {2, 33}, {4, 19}, and {5, 99}
#' head(dat$el[[1]], 4)
#'
#' # Remove nodes 1 and 2
#' nodes.to.delete <- 1:2
#' dat$el[[1]] <- delete_vertices(dat$el[[1]], nodes.to.delete)
#'
#' # Old nodes 1 and 2 removed, and old nodes 4 and 5 become nodes 2 and 3
#' # with edges 19 and 99 also shifted down to 17 and 97
#' head(dat$el[[1]], 4)
#'
delete_vertices <- function(el, vid) {

  new.el <- el
  if (length(vid) > 0) {
    el.rows.to.del <- which(el[, 1] %in% vid | el[, 2] %in% vid)
    if (length(el.rows.to.del) > 0) {
      new.el <- el[-el.rows.to.del, , drop = FALSE]
    }
    if (nrow(new.el) > 0) {
      elv <- as.vector(new.el)
      # shifted.elv <- vapply(1:length(elv),
      #                       function(x) elv[x] - sum(elv[x] > vid), FUN.VALUE = integer(1))
      shifted.elv <- shiftVec(elv, vid)
      new.el <- matrix(shifted.elv, ncol = 2)
    }
    attributes(new.el)$n <- attributes(el)$n - length(vid)
  }

  return(new.el)
}