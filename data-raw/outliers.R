df0 <- data.frame(
    A = c(stats::rnorm(19, 1, 1), 4),
    B = c(stats::rnorm(18, 2, 1), -2, 6),
    C = c(stats::rnorm(16, 2, 1), -1, -2, 6, 7),
    D = c(stats::rnorm(10), stats::rnorm(10, 1))
)

outliers <- stats::reshape(
    data = df0,
    direction = "long",
    v.names = "val",
    varying = colnames(df0),
    timevar = "grp",
    times = colnames(df0)
)[, c("grp", "val")]

row.names(outliers) <- as.character(1:nrow(outliers))

usethis::use_data(outliers, overwrite = TRUE)
