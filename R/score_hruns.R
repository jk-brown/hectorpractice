# compute vector of score for two numeric vectors (x and y)
# w1 - distance at which score ramps down from 1.
# w2 - distance at which score becomes 0.

#' Computing vector of scores for numeric vectors
#'
#' @description Computes scores based on proximity of two numeric values in a vector.
#' Scores are derived from cutoffs provided by the user (w1, w2).
#'
#' @param x First set of numeric vectors
#' @param y Second set of numeric vectors
#' @param w1 Distance at which score ramps down from 1.
#' @param w2 Distance at which score becomes 0
#' @param na.omit How should score_ramp deal with rows in data frame containing NAs?
#' Defaults to FALSE, leaving NAs in data frame.
#'
#' @return Vector of scores
#' @export
#'
#' @examples
#' # Example vectors
#' x <- c(3, 5, 3, 4, 9)
#' y <- c(3, 6.5, 5, 9, 10)
#'
#' # Computing scores from score ramp
#' score_ramp(x, y, w1 = 1, w2 = 3)

score_ramp <- function(x, y, w1, w2, na.omit = FALSE) {

  if (na.omit) {
    x <- na.omit(x)
    y <- na.omit(y)
  }

  if (w1 < 0) stop("w1 must be at least 0")

  if (w2 < w1) stop("w2 must be at least as big as w1")

  if (length(x) != length(y)) stop("Length of x must be equal to length of y")

  if ( all(is.na(x))) stop("No non-NA values in x")

  if ( all(is.na(y))) stop("No non-NA values in y")

  abs_diffs <- abs(x - y)

  scores <- rep(NA_real_, length(x))

  # the order of the following two statements matters, because
  # we want a diff exactly equal to w1 to get a score of 1, even when w1 = w2
  scores [abs_diffs >= w2] <- 0
  scores [abs_diffs <= w1] <- 1

  # for abs_diffs between w1 and w2 - compute how far between w1 and w2 the
  # abs_diff value is
  between_w1_w2 <- abs_diffs > w1 & abs_diffs < w2
  w1_w2_frac <- (abs_diffs [between_w1_w2] - w1) / (w2 - w1)

  # for scores between w1 and w2 use (1- computed distance) as score value
  scores [between_w1_w2] <- 1 - w1_w2_frac

  return(scores)

}

#' Screen Hector outputs with observed data
#'
#' @description This is a function uses a scoring function to screen Hector runs
#' based on proximity of climate variable values to observed data. Default score
#' functions are provided in \code{matilda}, but users can also supply their own.
#' Scoring criteria (\code{'crit'}) defaults are also available in the package.
#' Users can also build their own scoring criteria using the \code{\link{new_crit}}.
#'
#' @param x Result data frame from \code{\link{iterate_hector}}.
#' @param score_function Scoring function to use for screening Hector model runs.
#' @param ... Additional arguments needed to run the selected scoring function.
#' @param crit Criterion to use for screening Hector runs.
#'
#' @return Data frame with mean score for each Hector run
#' @export
#'
#' @import stats
#'
#' @examples
#' # Load scenario file and initiate a new Hector core
#' ssp245 <- system.file("input/hector_ssp245.ini", package = "hector")
#' core <- newcore(ssp245)
#'
#' # Create new metric
#' metric <- new_metric(ATMOSPHERIC_CO2(), years = 2000:2100, op = mean)
#'
#' # Compute parameter values for Hector iterations
#' params <- generate_params(10)
#'
#' # Iterate Hector runs with parameter uncertainty
#' h_result <- iterate_hector(core, metric, params)
#'
#' # Score Hector using observed CO2 data with the score_ramp method
#' score_hruns(h_result, crit_co2_obs(), score_ramp, w1 = 2, w2 = 20)

score_hruns <- function(x, crit, score_function,...) {

  # error if x is not a data frame
  if( !is.data.frame(x)) stop('user supplied x is not a data frame')

  # error if crit is not a criterion
  if( !is.crit(crit)) stop('user supplied crit is not a criterion')

  # error if score_function is not a function
  if( !is.function(score_function)) stop('user supplied score_function is not a function')

  # subset to include years for CO2 screening
  x_subset <- subset(x, year %in% crit$years & variable == crit$var)

  # error if variable in x does not match variable in the criterion being used
  if( !nrow(x_subset)) stop('criterion year and variable combination not represented in data')

  #creates observed data frame
  obs_dat <- data.frame(year = crit$years, value_obs = crit$obs_values)

  # merge hector results with calibration data observed CO2 data
  x_merge <- merge(x_subset, obs_dat, by = 'year')

  # add new column to res_merge computing scores so that we can
  x_merge$scores <- score_function(x_merge$value_obs, x_merge$value,...)

  # calculate mean scores for each run.
  score_mean <- aggregate(scores ~ run_number, data = x_merge, FUN = mean)

  return(score_mean)

}
