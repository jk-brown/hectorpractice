% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/score_hruns.R
\name{score_hruns}
\alias{score_hruns}
\title{Screen Hector outputs with observed data}
\usage{
score_hruns(x, crit, score_function, ...)
}
\arguments{
\item{x}{Result data frame from \code{\link{iterate_hector}}.}

\item{crit}{Criterion to use for screening Hector runs.}

\item{score_function}{Scoring function to use for screening Hector model runs.}

\item{...}{Additional arguments needed to run the selected scoring function.}
}
\value{
Data frame with mean score for each Hector run
}
\description{
This is a function uses a scoring function to screen Hector runs
based on proximity of climate variable values to observed data. Default score
functions are provided in \code{matilda}, but users can also supply their own.
Scoring criteria (\code{'crit'}) defaults are also available in the package.
Users can also build their own scoring criteria using the \code{\link{new_crit}}.
}
\examples{
# Load scenario file and initiate a new Hector core
ssp245 <- system.file("input/hector_ssp245.ini", package = "hector")
core <- newcore(ssp245)

# Create new metric
metric <- new_metric(ATMOSPHERIC_CO2(), years = 2000:2100, op = mean)

# Compute parameter values for Hector iterations
params <- generate_params(10)

# Iterate Hector runs with parameter uncertainty
h_result <- iterate_hector(core, metric, params)

# Score Hector using observed CO2 data with the score_ramp method
score_hruns(h_result, crit_co2_obs(), score_ramp, w1 = 2, w2 = 20)
}
