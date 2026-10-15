#' Outliers
#'
#' A simulated dataset containing cortex cell counts within the meristematic zone of roots
#' in an *Arabidopsis thaliana* transgenic plant (CYCB1;3-GFP).
#'
#' @format A list containing three data frames, each representing a different experimental batch:
#' \describe{
#'   \item{TEMP}{Air temperature in degrees Celsius}
#'   \item{RGF1}{Concentration of RGF1 peptide hormone treatment (0 nM, 5 nM)}
#'   \item{treatment}{TEMP x RGF1 -> 4 groups of treatments}
#'   \item{grp}{Labels for each treatment groups (A, B, C, D)}
#'   \item{cells}{Number of meristematic root cells}
#' }
#' @references
#' Hsiao, Y., Lai, J., Shiue, S., & Yamada, M. (2026).
#' RGF signaling bridges root development and nonlethal thermal stress adaptation.
#' New Phytologist, nph.71392.
#' https://doi.org/10.1111/nph.71392
"CYCB1"
