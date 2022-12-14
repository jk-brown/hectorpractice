% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_param.R
\name{generate_params}
\alias{generate_params}
\title{Generating Parameter Values}
\usage{
generate_params(draws)
}
\arguments{
\item{draws}{Number of random draws for each parameter.}
}
\value{
A data frame object with parameter values generated for each
draw. The column \code{run_number} indicates the number of \code{draws} provided
as an argument in the function.
}
\description{
This function will generate parameter values for running Hector.
Parameters are generated from random draws of a normal distribution.
}
\examples{
# Generate parameters for Hector iterations
generate_params(10)
}
