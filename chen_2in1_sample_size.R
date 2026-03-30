###############################################################################
#  Chen et al. (2018) "2-in-1 Adaptive Phase 2/3 Design"
#  Contemporary Clinical Trials, 64, 238-242
#
#  Part 1: Sample Size Calculation & Analytical Type I Error
#
#  Endpoints assumed:
#    X  = ORR  (intermediate endpoint for adaptation decision)
#    Y  = PFS  (Phase 2 primary endpoint)
#    Z  = OS   (Phase 3 primary endpoint)
###############################################################################

if (!requireNamespace("mvtnorm", quietly = TRUE)) {
  install.packages("mvtnorm", repos = "https://cloud.r-project.org")
}
library(mvtnorm)

# =========================================================================
#  Helper Functions
# =========================================================================

#' Schoenfeld formula: required number of events for a log-rank test
#' in a two-arm trial with 1:1 randomisation
#'
#' @param hr       target hazard ratio (treatment / control, < 1 favours trt)
#' @param alpha    one-sided Type I error
#' @param power    desired power
#' @return integer number of events
schoenfeld_events <- function(hr, alpha, power) {
  z_a <- qnorm(1 - alpha)
  z_b <- qnorm(power)
  d   <- 4 * (z_a + z_b)^2 / log(hr)^2
  ceiling(d)
}

#' Expected probability of observing an event under exponential survival
#' with uniform accrual over [0, R] and analysis at calendar time T = R + F.
#'
#' @param lambda             hazard rate
#' @param enrollment_period  accrual window R (months)
#' @param followup_period    additional follow-up F after last accrual (months)
#' @return probability of event
prob_event_exponential <- function(lambda, enrollment_period, followup_period) {
  total <- enrollment_period + followup_period
  integrand <- function(e) exp(-lambda * (total - e))
  1 - integrate(integrand, 0, enrollment_period)$value / enrollment_period
}

#' Convert required events to total number of patients (1:1 randomisation)
#'
#' @param d                  required number of events
#' @param lambda_c           control-arm hazard rate
#' @param lambda_t           treatment-arm hazard rate
#' @param enrollment_period  accrual window R
#' @param followup_period    additional follow-up F
#' @return list with total and per-arm patient counts
events_to_patients <- function(d, lambda_c, lambda_t,
                               enrollment_period, followup_period) {
  pe_c <- prob_event_exponential(lambda_c, enrollment_period, followup_period)
  pe_t <- prob_event_exponential(lambda_t, enrollment_period, followup_period)
  pe   <- (pe_c + pe_t) / 2
  N    <- ceiling(d / pe)
  list(total = N, per_arm = ceiling(N / 2),
       prob_event_ctrl = pe_c, prob_event_trt = pe_t)
}

#' Analytical Type I error of the 2-in-1 design
#'
#' P(X < c, Y > w) + P(X >= c, Z > w)
#' under H0: E{Y}=E{Z}=0, with E{X} = mu_x (arbitrary).
#'
#' @param c_val   cut-point for adaptation decision on X
#' @param w       critical value for efficacy on Y or Z
#' @param rho_xy  correlation between X and Y
#' @param rho_xz  correlation between X and Z
#' @param mu_x    mean of X (may be non-zero when X is a different endpoint)
#' @return overall Type I error probability
compute_type1_error <- function(c_val, w, rho_xy, rho_xz, mu_x = 0) {
  sigma_xy <- matrix(c(1, rho_xy, rho_xy, 1), 2, 2)
  sigma_xz <- matrix(c(1, rho_xz, rho_xz, 1), 2, 2)

  p_no_expand <- pmvnorm(lower = c(-Inf,  w),
                          upper = c(c_val, Inf),
                          mean  = c(mu_x, 0),
                          sigma = sigma_xy)[1]

  p_expand    <- pmvnorm(lower = c(c_val, w),
                          upper = c(Inf,   Inf),
                          mean  = c(mu_x, 0),
                          sigma = sigma_xz)[1]

  p_no_expand + p_expand
}

# =========================================================================
#  Design Parameters  (Hypothetical Example, Chen et al. 2018 Section 3)
# =========================================================================

cat("=======================================================================\n")
cat("  Chen et al. (2018) 2-in-1 Adaptive Phase 2/3 Design\n")
cat("  Sample Size Calculation & Analytical Type I Error\n")
cat("=======================================================================\n")

cat("\n--- Design Overview ---\n")
cat("  X (adaptation)  : ORR   (Objective Response Rate)\n")
cat("  Y (Phase 2)     : PFS   (Progression-Free Survival)\n")
cat("  Z (Phase 3)     : OS    (Overall Survival)\n\n")

# -- Phase 2 (PFS) --------------------------------------------------------
hr_pfs             <- 0.55
alpha_p2           <- 0.025       # 1-sided for positive Phase 2
power_p2           <- 0.80
median_pfs_ctrl    <- 10.3        # months (PD-L1 >= 50% population)
lambda_pfs_ctrl    <- log(2) / median_pfs_ctrl
lambda_pfs_trt     <- lambda_pfs_ctrl * hr_pfs
enrollment_p2      <- 12          # accrual window (months)
n_p2_total         <- 120         # total Phase 2 patients (per paper)

d_pfs <- schoenfeld_events(hr_pfs, alpha_p2, power_p2)

cat("--- Phase 2: PFS ---\n")
cat(sprintf("  Target HR (PFS)         = %.2f\n", hr_pfs))
cat(sprintf("  Median PFS (control)    = %.1f months\n", median_pfs_ctrl))
cat(sprintf("  Median PFS (treatment)  = %.1f months\n", median_pfs_ctrl / hr_pfs))
cat(sprintf("  Alpha                   = %.3f (1-sided)\n", alpha_p2))
cat(sprintf("  Power                   = %.0f%%\n", power_p2 * 100))
cat(sprintf("  Required PFS events (d) = %d\n", d_pfs))
cat(sprintf("  Phase 2 patients (N)    = %d  (1:1 randomisation)\n\n", n_p2_total))

# -- Phase 3 (OS) ---------------------------------------------------------
hr_os              <- 0.70
alpha_p3           <- 0.025       # 1-sided
power_p3           <- 0.90
median_os_ctrl     <- 24          # months (assumed)
lambda_os_ctrl     <- log(2) / median_os_ctrl
lambda_os_trt      <- lambda_os_ctrl * hr_os

d_os <- schoenfeld_events(hr_os, alpha_p3, power_p3)

cat("--- Phase 3: OS ---\n")
cat(sprintf("  Target HR (OS)          = %.2f\n", hr_os))
cat(sprintf("  Median OS (control)     = %.1f months\n", median_os_ctrl))
cat(sprintf("  Median OS (treatment)   = %.1f months\n", median_os_ctrl / hr_os))
cat(sprintf("  Alpha                   = %.3f (1-sided)\n", alpha_p3))
cat(sprintf("  Power                   = %.0f%%\n", power_p3 * 100))
cat(sprintf("  Required OS deaths (d)  = %d\n\n", d_os))

# -- Adaptation decision (ORR) --------------------------------------------
n_adapt            <- 90          # patients for ORR analysis
alpha_adapt        <- 0.05        # 1-sided significance for expansion
c_adapt            <- qnorm(1 - alpha_adapt)   # 1.645

cat("--- Adaptation Decision: ORR ---\n")
cat(sprintf("  Patients for ORR analysis   = %d  (first enrolled)\n", n_adapt))
cat(sprintf("  Minimum follow-up           = 3 months\n"))
cat(sprintf("  Expansion if ORR p-value    < %.2f (1-sided)\n", alpha_adapt))
cat(sprintf("  Corresponding z cut-point c = %.4f\n", c_adapt))
cat(sprintf("  Approx. ORR diff to trigger ~ 17%%\n\n"))

# -- Total Phase 3 patients -----------------------------------------------
n_p3_additional  <- 380   # approximate additional patients for Phase 3
n_p3_total       <- n_p2_total + n_p3_additional

os_pt <- events_to_patients(d_os, lambda_os_ctrl, lambda_os_trt,
                            enrollment_period = 30, followup_period = 18)

cat("--- Phase 3 Sample Size (if expanded) ---\n")
cat(sprintf("  Phase 2 patients (carried forward)  = %d\n", n_p2_total))
cat(sprintf("  Additional Phase 3 patients         ~ %d\n", n_p3_additional))
cat(sprintf("  Total Phase 3 patients              ~ %d\n", n_p3_total))
cat(sprintf("  Required OS deaths                  = %d\n\n", d_os))

# =========================================================================
#  Analytical Type I Error
# =========================================================================

cat("=======================================================================\n")
cat("  Analytical Type I Error Assessment\n")
cat("=======================================================================\n\n")

w <- qnorm(1 - 0.025)   # 1.96, critical value for efficacy

# Representative correlation scenarios
scenarios <- data.frame(
  label  = c("ρ_XY=0.5, ρ_XZ=0.3",
             "ρ_XY=0.7, ρ_XZ=0.3",
             "ρ_XY=0.5, ρ_XZ=0.5",
             "ρ_XY=0.3, ρ_XZ=0.1"),
  rho_xy = c(0.5, 0.7, 0.5, 0.3),
  rho_xz = c(0.3, 0.3, 0.5, 0.1),
  stringsAsFactors = FALSE
)

cat(sprintf("Critical value w = %.4f  (corresponds to alpha = 0.025, 1-sided)\n", w))
cat(sprintf("Adaptation cut-point c = %.4f  (corresponds to ORR p < 0.05)\n\n", c_adapt))

for (i in seq_len(nrow(scenarios))) {
  err <- compute_type1_error(c_adapt, w, scenarios$rho_xy[i],
                              scenarios$rho_xz[i], mu_x = 0)
  cat(sprintf("  %-25s  =>  Type I error = %.6f  [%s]\n",
              scenarios$label[i], err,
              ifelse(err <= 0.025 + 1e-9, "OK", "INFLATED")))
}

cat("\n  Note: Under the assumption rho_XY >= rho_XZ, Type I error <= 0.025\n")
cat("        with no alpha penalty, for any value of c.\n")

# =========================================================================
#  Reproduce Figure 1 from Chen et al. (2018)
#
#  Overall Type I error at w = 1.96 as a function of the standardised
#  cut-point (c - E{X}) for different correlation combinations.
# =========================================================================

cat("\n=======================================================================\n")
cat("  Generating Figure 1 (Type I error vs. standardised cut-point)\n")
cat("=======================================================================\n\n")

std_cutpoints <- seq(-4, 4, by = 0.05)

corr_combos <- list(
  list(rho_xy = 0.5,  rho_xz = 0.5,  label = expression(rho[XY]==0.5~","~rho[XZ]==0.5)),
  list(rho_xy = 0.5,  rho_xz = 0.3,  label = expression(rho[XY]==0.5~","~rho[XZ]==0.3)),
  list(rho_xy = 0.5,  rho_xz = 0.0,  label = expression(rho[XY]==0.5~","~rho[XZ]==0.0)),
  list(rho_xy = 0.7,  rho_xz = 0.3,  label = expression(rho[XY]==0.7~","~rho[XZ]==0.3)),
  list(rho_xy = 0.3,  rho_xz = 0.1,  label = expression(rho[XY]==0.3~","~rho[XZ]==0.1))
)

# The standardised cut-point is c - E{X}. We parameterise by fixing c at
# different values while E{X} = 0, which is equivalent to varying c - E{X}.
plot_data <- list()
for (cc in corr_combos) {
  errs <- sapply(std_cutpoints, function(sc) {
    compute_type1_error(c_val = sc, w = w,
                        rho_xy = cc$rho_xy, rho_xz = cc$rho_xz, mu_x = 0)
  })
  plot_data[[length(plot_data) + 1]] <- list(
    x = std_cutpoints, y = errs,
    rho_xy = cc$rho_xy, rho_xz = cc$rho_xz, label = cc$label
  )
}

cols <- c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00")
ltys <- c(1, 2, 4, 5, 6)

png("chen_2in1_figure1.png", width = 9, height = 6, units = "in", res = 150)
par(mar = c(5, 5, 4, 2))

plot(NULL, xlim = c(-4, 4), ylim = c(0.020, 0.026),
     xlab = expression("Standardised cut-point " ~ (c - E(X))),
     ylab = "Overall Type I error",
     main = "Figure 1 (Chen et al. 2018): Type I error of the 2-in-1 design\nat w = 1.96",
     cex.lab = 1.2, cex.main = 1.1)

abline(h = 0.025, lty = 3, col = "grey40")

for (k in seq_along(plot_data)) {
  lines(plot_data[[k]]$x, plot_data[[k]]$y,
        col = cols[k], lwd = 2, lty = ltys[k])
}

legend("bottom", ncol = 2,
       legend = sapply(corr_combos, function(cc)
         bquote(rho[XY]==.(cc$rho_xy) ~ "," ~ rho[XZ]==.(cc$rho_xz))),
       col = cols, lwd = 2, lty = ltys, cex = 0.85, bty = "n")

invisible(dev.off())
cat("  Saved: chen_2in1_figure1.png\n")

# =========================================================================
#  Sensitivity: Type I error as a function of mu_x
#  (when ORR has a treatment effect but PFS/OS do not)
# =========================================================================

cat("\n--- Sensitivity to E{X} (non-zero ORR treatment effect under H0) ---\n\n")

mu_x_vals <- c(-1, 0, 0.5, 1.0, 1.5, 2.0, 2.5)
rho_xy_sens <- 0.5
rho_xz_sens <- 0.3

cat(sprintf("  c = %.3f, w = %.3f, rho_XY = %.1f, rho_XZ = %.1f\n\n",
            c_adapt, w, rho_xy_sens, rho_xz_sens))
cat(sprintf("  %-12s  %-15s  %-10s\n", "E{X}", "Type I error", "Status"))
cat(sprintf("  %-12s  %-15s  %-10s\n", "----", "------------", "------"))

for (mx in mu_x_vals) {
  err <- compute_type1_error(c_adapt, w, rho_xy_sens, rho_xz_sens, mu_x = mx)
  cat(sprintf("  %-12.1f  %-15.6f  %-10s\n",
              mx, err, ifelse(err <= 0.025, "OK", "INFLATED")))
}

cat("\n  Result: Type I error <= 0.025 for all E{X} values\n")
cat("  (confirming the design controls alpha regardless of the ORR effect).\n")

# =========================================================================
#  Summary Table
# =========================================================================

cat("\n=======================================================================\n")
cat("  Design Summary\n")
cat("=======================================================================\n\n")

cat("  +--------------------------------------------------------------+\n")
cat("  | Component          | Parameter               | Value         |\n")
cat("  +--------------------------------------------------------------+\n")
cat(sprintf("  | Adaptation (ORR)   | N for ORR analysis      | %d           |\n", n_adapt))
cat(sprintf("  |                    | Min follow-up           | 3 months     |\n"))
cat(sprintf("  |                    | Expansion if p <        | %.2f (1-sided)|\n", alpha_adapt))
cat(sprintf("  |                    | Cut-point c             | %.3f        |\n", c_adapt))
cat(sprintf("  | Phase 2 (PFS)      | HR target               | %.2f         |\n", hr_pfs))
cat(sprintf("  |                    | Alpha                   | %.3f (1-sided)|\n", alpha_p2))
cat(sprintf("  |                    | Power                   | %d%%           |\n", power_p2 * 100))
cat(sprintf("  |                    | Required PFS events     | %d            |\n", d_pfs))
cat(sprintf("  |                    | N (Phase 2 only)        | %d           |\n", n_p2_total))
cat(sprintf("  | Phase 3 (OS)       | HR target               | %.2f         |\n", hr_os))
cat(sprintf("  |                    | Alpha                   | %.3f (1-sided)|\n", alpha_p3))
cat(sprintf("  |                    | Power                   | %d%%           |\n", power_p3 * 100))
cat(sprintf("  |                    | Required OS events      | %d           |\n", d_os))
cat(sprintf("  |                    | N (total, Phase 2 + 3)  | ~%d          |\n", n_p3_total))
cat(sprintf("  | Overall alpha      | Target                  | %.3f (1-sided)|\n", 0.025))
cat(sprintf("  |                    | No penalty required     | YES          |\n"))
cat("  +--------------------------------------------------------------+\n\n")

cat("Done.\n")
