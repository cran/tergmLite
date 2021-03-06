
context("Test updateModelTermInputs function")

test_that("concurrent", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)

    est <- netest(nw = nw,
                  formation = ~edges + concurrent,
                  target.stats = c(50, 25),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("concurrent_by", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)
    nw <- set_vertex_attribute(nw, "riskg", rbinom(100, 1, 0.5))

    est <- netest(nw = nw,
                  formation = ~edges + concurrent(by = "riskg"),
                  target.stats = c(50, 20, 10),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("degree, single", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)

    est <- netest(nw = nw,
                  formation = ~edges + degree(1),
                  target.stats = c(50, 20),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("degree, multiple", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)

    est <- netest(nw = nw,
                  formation = ~edges + degree(1:2),
                  target.stats = c(50, 35, 20),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("degree_by_attr", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)
    nw <- set_vertex_attribute(nw, "riskg", sample(rep(0:1, each = 50)))

    est <- netest(nw = nw,
                  formation = ~edges + degree(1, by = "riskg"),
                  target.stats = c(50, 15, 20),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("degrange", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)

    est <- netest(nw = nw,
                  formation = ~edges + degrange(from = 4),
                  target.stats = c(50, 0),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)


    ## from + to args

    est <- netest(nw = nw,
                  formation = ~edges + degrange(from = 4, to = 6),
                  target.stats = c(50, 0),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("nodecov formula", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)
    risk <- runif(100)
    nw <- set_vertex_attribute(nw, "risk", risk)

    est <- netest(nw = nw,
                  formation = ~edges + nodecov(~risk^2),
                  target.stats = c(50, 65),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("nodecov function", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)
    risk <- runif(100)
    nw <- set_vertex_attribute(nw, "risk", risk)

    est <- netest(nw = nw,
                  formation = ~edges + nodecov(function(x) exp(1 + log((x %v% "risk")^2))),
                  target.stats = c(50, 200),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("nodefactor single", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)
    riskg <- rep(1:4, each = 25)
    nw <- set_vertex_attribute(nw, "riskg", riskg)

    est <- netest(nw = nw,
                  formation = ~edges + nodefactor("riskg"),
                  target.stats = c(50, 25, 25, 25),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})


test_that("nodefactor interaction", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)
    riskg <- sample(rep(1:2, each = 50))
    race <- sample(rep(0:1, each = 50))
    nw <- set_vertex_attribute(nw, "riskg", riskg)
    nw <- set_vertex_attribute(nw, "race", race)

    est <- netest(nw = nw,
                  formation = ~edges + nodefactor(c("riskg", "race")),
                  target.stats = c(50, 25, 25, 25),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("nodemix levels", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(200)
    race <- sample(rep(letters[1:4], each = 50))
    nw <- set_vertex_attribute(nw, "race", race)

    est <- netest(nw = nw,
                  formation = ~edges + nodemix("race", levels = c("a", "b", "d"), levels2 = -(2:3)),
                  target.stats = c(200, 12, 25, 25, 12),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("triangle", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)

    est <- netest(nw = nw,
                  formation = ~edges + triangle,
                  target.stats = c(50, 0),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("triangle_attr", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)
    nw <- set_vertex_attribute(nw, "riskg", rbinom(100, 1, 0.2))

    est <- netest(nw = nw,
                  formation = ~edges + triangle(attr = "riskg"),
                  target.stats = c(50, 0),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("triangle_attrdiff", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)
    nw <- set_vertex_attribute(nw, "riskg", rbinom(100, 1, 0.5))

    est <- netest(nw = nw,
                  formation = ~edges + triangle(attr = "riskg", diff = TRUE),
                  target.stats = c(50, 0, 0),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("triangle_attrdifflevels", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)
    nw <- set_vertex_attribute(nw, "riskg", rbinom(100, 2, 0.1))

    est <- netest(nw = nw,
                  formation = ~edges + triangle(attr = "riskg", diff = TRUE, levels = c(1, 2)),
                  target.stats = c(50, 0, 0),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})


test_that("gwesp_true", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)

    est <- netest(nw = nw,
                  formation = ~edges + gwesp(fixed = TRUE),
                  target.stats = c(50, 2),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})

test_that("gwesp_truedecay", {

  library("EpiModel")
  if (packageVersion("EpiModel") >= "2.0.0") {
    nw <- network_initialize(100)

    est <- netest(nw = nw,
                  formation = ~edges + gwesp(decay = 0.8, fixed = TRUE),
                  target.stats = c(50, 1.1),
                  coef.diss = dissolution_coefs(~offset(edges), duration = 100))

    param <- param.net(inf.prob = 0.3)
    init <- init.net(i.num = 10)
    control <- control.net(type = "SI", nsteps = 100, nsims = 1, tergmLite = TRUE,
                           resimulate.network = TRUE)

    dat <- crosscheck.net(est, param, init, control)
    dat <- initialize.net(est, param, init, control, s = 1)

    p <- dat$p
    dat <- updateModelTermInputs(dat, network = 1)

    expect_identical(dat$p, p)
  }

})
