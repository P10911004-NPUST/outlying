#' @title Grubbs' test
#'
#' @description
#' Iteratively search for all possible outliers in a numeric vector.
#'
#' @param x A numeric vector.
#' @param alpha Default: 0.05 (two-tailed, thus 0.025 for each side).
#' @param min_n A positive integer (default: 7). The minimum observations required for the test.
#' @param iteration How many iterations of the test should be proceeded (default: -1; means unlimited)?
#'  Each iteration will only recognize one outlier. For example, `iteration = 3` means the test will find
#'  no more than 3 outliers.
#' @param max_out The maximum proportion (ranged from 0 to 1) of outliers to be detected in the
#'  dataset (default: 0.2, which means the data contain no more than 20% of outliers data points).
#'  If too many outliers, simply discarding them using this approach might be inappropriate.
#' @param use_median Use the median or the mean value as the center (default: FALSE).
#' @param sensitivity An integer value range from 1 to 3.
#'  The higher the value, the more sensitive of the test to outliers (default: 2).
#' @param verbose Should the output includes statistics result (default: FALSE)?
#'
#' @returns By default (verbose = FALSE), return a logical named vector indicating the
#'  outlying elements. If verbose = TRUE, return a list which contains statistic values.
#'
#' @examples
#' set.seed(1)
#' #----------------------------------------------------------------------------
#' Grubbs_test(c(0, 0, 7, 0, 0, 1, 0))
#' #>     0     0     7     0     0     1     0
#' #> FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE
#' #----------------------------------------------------------------------------
#' x <- c(round(rnorm(3, 0, 1), 2), -5, 3)
#' Grubbs_test(x, min_n = 5, max_out = 0.4)
#' #> -0.63  0.18 -0.84    -5     3
#' #> FALSE FALSE FALSE  TRUE  TRUE
#' #----------------------------------------------------------------------------
#' x <- round(c(rnorm(10, 0, 1), 5))
#' Grubbs_test(x)
#' #>     2     0    -1     0     1     1     0     2     0    -1     5
#' #> FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#' @references
#' Grubbs, F. E. (1969). Procedures for Detecting Outlying Observations in Samples.
#' Technometrics, 11(1), 1–21. https://doi.org/10.1080/00401706.1969.10490657
#' @export
Grubbs_test <- function(
        x,
        alpha = 0.05,
        min_n = 7L,
        iteration = -1L,
        max_out = 0.2,
        use_median = FALSE,
        sensitivity = 2,
        verbose = FALSE
) {
    if (!is.atomic(x) || !is.null(dim(x)) || !(is.double(x) | is.integer(x)))
        stop("The input `x` should be a numeric vector.")

    if (any(is.na(x)) || any(is.nan(x)))
        stop("The input `x` should not contains NA or NaN.")

    X <- x[stats::complete.cases(x)]
    N <- length(X)
    min_n <- floor(min_n)  # coerce to integer value

    if (iteration == 0)
        return(logical(N))

    # Sample size is too small
    if ( N < min_n )
    {
        warning(paste0(
            "The number of valid observations is less than `min_n`, ",
            "Grubbs_test is not conducted. ",
            "All values are considered as non-outlying."
        ))
        return(logical(length(x)))
    }

    # Maximum outliers proportion 0
    if ( isFALSE(max_out > 0 & max_out < 1) || is.na(max_out) || is.null(max_out) )
    {
        warning(paste0(
            "`max_out` should be a numeric value range from 0 to 1. ",
            "Automatically coerce to 0.2, which is the default."
        ))
        max_out <- 0.2
    }

    # At least how many observations should be kept
    keep_N <- N * (1 - max_out)

    # Return values
    ret_bool <- vector("logical", N)
    ret_who <- vector(class(X), N)
    ret_G <- vector("double", N) / 0
    ret_G_crit <- vector("double", N) / 0

    names(ret_bool) <- as.character(X)
    names(ret_G) <- as.character(X)
    names(ret_G_crit) <- as.character(X)

    X_tmp <- X
    i <- 0

    while ( length(X_tmp) > keep_N )
    {
        i <- i + 1

        out <- .GrubbsTest(X_tmp, alpha, use_median, sensitivity)
        who <- out[["who"]]

        if (is.null(who)) break
        if ( iteration > 0 && i > iteration ) break

        ind <- which(X == who)
        X_tmp <- X_tmp[ X_tmp != who ]

        ret_bool[ind] <- TRUE
        ret_who[ind] <- who

        if (isTRUE(verbose))
        {
            ret_G[ind] <- out[["G"]]
            ret_G_crit[ind] <- out[["G_crit"]]
        }
    }

    # Output
    if (isTRUE(verbose))
    {
        return(
            list(
                is_outlier = ret_bool,
                who = as.numeric(ret_who[ ! grepl("^$", ret_who) ]),
                G = ret_G[ ! is.nan(ret_G) ],
                G_crit = ret_G_crit[ ! is.nan(ret_G_crit) ],
                t_crit = out[["t_crit"]]
            )
        )
    } else {
        return(ret_bool)
    }
}


#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Internal function for Grubbs_test()
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.GrubbsTest <- function(x, alpha = 0.05, use_median = FALSE, sensitivity = 2)
{
    if (!is.atomic(x) || !is.null(dim(x)) || !(is.double(x) || is.integer(x)))
        stop("`x` should be a numeric vector")

    N <- length(x)
    AVG <- ifelse(isTRUE(use_median), stats::median(x), mean(x))
    DIFF <- abs(x - AVG)
    STDEV <- stats::sd(x)
    alpha <- alpha / (N + N)
    t_crit <- stats::qt(p = alpha, df = (N - 2), lower.tail = FALSE)
    G_crit <- ((N - 1) * t_crit) / sqrt( N * (N - 2 + t_crit ^ 2) )

    if ( isTRUE(STDEV == 0) )
        return(list(who = NULL, G = Inf, G_crit = G_crit, t_crit = t_crit))

    if ( is.na(STDEV) || is.nan(STDEV) || is.null(STDEV) )
        return(list(who = NULL, G = NA, G_crit = G_crit, t_crit = t_crit))

    ind <- which(DIFF == max(DIFF))[1]  # index of potential outlier
    who <- x[ind]

    trim_x <- x[ x != who ]  # exclude outliers from the input `x` vector
    trim_avg <- mean(trim_x)
    trim_std <- stats::sd(trim_x)

    G <- switch(
        sensitivity,
        abs(who - AVG) / STDEV,
        abs(who - trim_avg) / STDEV,
        abs(who - trim_avg) / trim_std
    )

    if (G > G_crit)
        return(list(who = who, G = G, G_crit = G_crit, t_crit = t_crit))
    else
        return(list(who = NULL, G = G, G_crit = G_crit, t_crit = t_crit))
}
