% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/new_crit.R
\name{new_crit}
\alias{new_crit}
\title{Creating New Criterion Object}
\usage{
new_crit(var, years, obs_values)
}
\arguments{
\item{var}{A variable from Hector output to compare with observed data}

\item{years}{A range of years from observed data}

\item{obs_values}{Numeric values from observed data}
}
\value{
Pretty print of R object containing new criterion parameters.
}
\description{
This function will create a new criterion for screening Hector
runs for realism. User can load data for comparing Hector variable outputs to
observed data values.
}
\examples{
# Assign observed data to an object
x <- hectorpractice:::metricdata_co2

# Create a new criteria that can be used to screen Hector runs
new_crit(ATMOSPHERIC_CO2(), years = x$year, obs_values = x$co2_ppm)
}
