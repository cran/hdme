#' @title plot.corrected_lasso
#' @description Plot the output of fit_corrected_lasso
#' @param x Object of class corrected_lasso, returned from calling fit_corrected_lasso()
#' @param type Type of plot. Either "nonzero" or "path".
#' @param ... Other arguments to plot (not used)
#' @examples
#' # Example with linear regression
#' n <- 100 # Number of samples
#' p <- 50 # Number of covariates
#' # True (latent) variables
#' X <- matrix(rnorm(n * p), nrow = n)
#' # Measurement error covariance matrix
#' # (typically estimated by replicate measurements)
#' sigmaUU <- diag(x = 0.2, nrow = p, ncol = p)
#' # Measurement matrix (this is the one we observe)
#' W <- X + rnorm(n, sd = diag(sigmaUU))
#' # Coefficient
#' beta <- c(seq(from = 0.1, to = 1, length.out = 5), rep(0, p-5))
#' # Response
#' y <- X %*% beta + rnorm(n, sd = 1)
#' # Run the corrected lasso
#' fit <- fit_corrected_lasso(W, y, sigmaUU, family = "gaussian")
#' plot(fit)
#'
#' @import ggplot2
#' @export
plot.corrected_lasso <- function(x, type = "nonzero", ...) {

  if(type == "nonzero") {
    df <- data.frame(radius = x$radii, nonZero = colSums(abs(x$betaCorr) > 0))
    ggplot(df, aes_(x =~ radius, y =~ nonZero)) +
      geom_line() +
      labs(x = "radius", y = "Nonzero coefficients", title = "Number of nonzero coefficients")
  } else if (type == "path") {
    df <- data.frame(radius = rep(x$radii, nrow(x$betaCorr)),
                     coefficient_id = as.factor(rep(seq_along(1:nrow(x$betaCorr)), each = length(x$radii))),
                     beta_corr = as.vector(t(x$betaCorr)))

    ggplot(df, aes_(x =~ radius, y =~ beta_corr, color =~ coefficient_id)) +
      geom_path() +
      labs(x = "radius", y = "Coefficient estimate", title = "Coefficient paths") +
      theme(legend.position="none")
  } else {
    stop("type argument must have value 'nonzero' or 'path'")
  }
}