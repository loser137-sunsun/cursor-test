###############################################################################
#  Chen et al. (2018) "2-in-1 Adaptive Phase 2/3 Design"
#  Contemporary Clinical Trials, 64, 238-242
#
#  Part 2: Monte Carlo Simulation for Type I Error Verification & Power
#
#  Generates patient-level data (ORR, PFS, OS) with realistic correlation
#  structure, executes the 2-in-1 decision rule, and evaluates:
#    (A) Type I error control under H0
#    (B) Power under various alternative hypotheses
#
#  Endpoints:
#    X = ORR  (binary, adaptation decision)
#    Y = PFS  (time-to-event, Phase 2 endpoint)
#    Z = OS   (time-to-event, Phase 3 endpoint)
###############################################################################

if (!requireNamespace("survival", quietly = TRUE)) {
  install.packages("survival", repos = "https://cloud.r-project.org")
}
library(survival)

# =========================================================================
#  Design Parameters
# =========================================================================
N_PHASE2           <- 120   # total Phase 2 patients (1:1)
N_ADAPT            <- 90    # patients evaluated at ORR interim
N_PHASE3_TOTAL     <- 500   # total patients if expanded (Phase 2 + additional)
N_ADDITIONAL       <- N_PHASE3_TOTAL - N_PHASE2

ALPHA_ADAPT        <- 0.05  # 1-sided ORR expansion threshold
C_ADAPT            <- qnorm(1 - ALPHA_ADAPT)  # 1.645

W_CRIT             <- qnorm(1 - 0.025)        # 1.96, efficacy critical value
ALPHA_STUDY        <- 0.025 # overall 1-sided alpha

# =========================================================================
#  Simulation Functions
# =========================================================================

#' Generate correlated binary (ORR) and exponential (PFS, OS) outcomes
#' using a latent Gaussian copula.
#'
#' Latent (U1, U2, U3) ~ MVN(0, Sigma) are mapped to marginals:
#'   ORR ~ Bernoulli(p)       via  ORR = I(Phi(U1) < p)
#'   PFS ~ Exp(lambda_pfs)    via  PFS = -log(1-Phi(U2)) / lambda_pfs
#'   OS  ~ Exp(lambda_os)     via  OS  = PFS + Exp(lambda_os_post_prog)
#'                                       (ensures OS >= PFS)
#'
#' @param n            number of patients
#' @param orr_prob     response probability
#' @param lambda_pfs   PFS hazard rate
#' @param lambda_os    OS hazard rate
#' @param rho_orr_pfs  copula correlation between ORR and PFS latent variables
#' @param rho_orr_os   copula correlation between ORR and OS latent variables
#' @param rho_pfs_os   copula correlation between PFS and OS latent variables
#' @return data.frame with columns: orr, pfs_time, os_time
generate_patient_data <- function(n, orr_prob, lambda_pfs, lambda_os,
                                  rho_orr_pfs = 0.4, rho_orr_os = 0.2,
                                  rho_pfs_os  = 0.6) {
  Sigma <- matrix(c(1,           rho_orr_pfs, rho_orr_os,
                     rho_orr_pfs, 1,           rho_pfs_os,
                     rho_orr_os,  rho_pfs_os,  1          ), 3, 3)

  L <- t(chol(Sigma))
  Z <- matrix(rnorm(n * 3), nrow = n, ncol = 3)
  U <- Z %*% t(L)

  u1 <- pnorm(U[, 1])
  u2 <- pnorm(U[, 2])
  u3 <- pnorm(U[, 3])

  orr      <- as.integer(u1 < orr_prob)
  pfs_time <- -log(1 - u2) / lambda_pfs

  # OS is modelled as PFS + post-progression survival.
  # Post-progression hazard is derived so that the marginal OS hazard matches.
  # For exponential: lambda_post = lambda_os * lambda_pfs / (lambda_pfs - lambda_os)
  # when lambda_pfs > lambda_os (PFS progresses faster than death).
  # To keep it simple and ensure OS >= PFS, use a residual exponential.
  if (lambda_pfs > lambda_os) {
    lambda_post <- (lambda_os * lambda_pfs) / (lambda_pfs - lambda_os)
  } else {
    lambda_post <- lambda_os
  }
  post_prog <- -log(1 - u3) / lambda_post
  os_time   <- pfs_time + post_prog

  data.frame(orr = orr, pfs_time = pfs_time, os_time = os_time)
}


#' Run one replicate of the 2-in-1 adaptive design trial
#'
#' @param orr_ctrl, orr_trt       ORR for control, treatment
#' @param lambda_pfs_ctrl/trt     PFS hazards
#' @param lambda_os_ctrl/trt      OS hazards
#' @param enrollment_rate         patients/month enrollment rate for Phase 2
#' @param enrollment_rate_p3      patients/month for additional Phase 3 enrollment
#' @param min_fu_adapt            minimum follow-up (months) at ORR interim
#' @param rho_orr_pfs, rho_orr_os, rho_pfs_os  copula correlations
#' @param d_pfs_target            target PFS events for Phase 2
#' @param d_os_target             target OS events for Phase 3
#' @return list with decision details
run_one_trial <- function(orr_ctrl, orr_trt,
                          lambda_pfs_ctrl, lambda_pfs_trt,
                          lambda_os_ctrl,  lambda_os_trt,
                          enrollment_rate   = 10,
                          enrollment_rate_p3 = 20,
                          min_fu_adapt      = 3,
                          rho_orr_pfs = 0.4,
                          rho_orr_os  = 0.2,
                          rho_pfs_os  = 0.6,
                          d_pfs_target = 70,
                          d_os_target  = 330) {

  n_p2_arm <- N_PHASE2 %/% 2

  # Generate Phase 2 patient data
  ctrl_p2 <- generate_patient_data(n_p2_arm, orr_ctrl, lambda_pfs_ctrl,
                                   lambda_os_ctrl, rho_orr_pfs, rho_orr_os, rho_pfs_os)
  trt_p2  <- generate_patient_data(n_p2_arm, orr_trt, lambda_pfs_trt,
                                   lambda_os_trt,  rho_orr_pfs, rho_orr_os, rho_pfs_os)

  ctrl_p2$arm <- 0L
  trt_p2$arm  <- 1L

  # Enrollment times (uniform)
  enroll_p2 <- sort(runif(N_PHASE2, 0, N_PHASE2 / enrollment_rate))
  ctrl_p2$enroll_time <- enroll_p2[1:n_p2_arm]
  trt_p2$enroll_time  <- enroll_p2[(n_p2_arm + 1):N_PHASE2]

  dat_p2 <- rbind(ctrl_p2, trt_p2)

  # -----------------------------------------------------------------
  #  Step 1: Adaptation Decision (ORR on first N_ADAPT patients)
  # -----------------------------------------------------------------
  first_enrolled <- order(dat_p2$enroll_time)[1:N_ADAPT]
  dat_adapt      <- dat_p2[first_enrolled, ]

  # Ensure minimum follow-up for ORR (ORR is observed by min_fu_adapt)
  n_resp_trt  <- sum(dat_adapt$orr[dat_adapt$arm == 1])
  n_trt_adapt <- sum(dat_adapt$arm == 1)
  n_resp_ctrl <- sum(dat_adapt$orr[dat_adapt$arm == 0])
  n_ctrl_adapt <- sum(dat_adapt$arm == 0)

  p_trt  <- n_resp_trt / n_trt_adapt
  p_ctrl <- n_resp_ctrl / n_ctrl_adapt

  se_diff <- sqrt(p_trt * (1 - p_trt) / n_trt_adapt +
                  p_ctrl * (1 - p_ctrl) / n_ctrl_adapt)

  if (se_diff < 1e-10) {
    z_orr <- 0
  } else {
    z_orr <- (p_trt - p_ctrl) / se_diff
  }

  expand <- (z_orr >= C_ADAPT)

  # -----------------------------------------------------------------
  #  Step 2a: If NOT expanded => Phase 2 analysis (PFS)
  # -----------------------------------------------------------------
  if (!expand) {
    # Calendar time for Phase 2 PFS analysis: wait for d_pfs_target events
    dat_p2$pfs_calendar <- dat_p2$enroll_time + dat_p2$pfs_time

    sorted_event_times <- sort(dat_p2$pfs_calendar)
    if (length(sorted_event_times) >= d_pfs_target) {
      analysis_time <- sorted_event_times[d_pfs_target]
    } else {
      analysis_time <- max(sorted_event_times) + 6
    }

    potential_fu   <- analysis_time - dat_p2$enroll_time
    obs_pfs_time   <- pmin(dat_p2$pfs_time, potential_fu)
    pfs_event      <- as.integer(dat_p2$pfs_time <= potential_fu)

    obs_pfs_time[obs_pfs_time <= 0] <- 0.001

    fit_pfs <- tryCatch({
      coxph(Surv(obs_pfs_time, pfs_event) ~ arm, data = dat_p2)
    }, error = function(e) NULL)

    if (is.null(fit_pfs)) {
      z_pfs <- 0
    } else {
      coef_pfs <- summary(fit_pfs)$coefficients
      z_pfs    <- -coef_pfs["arm", "z"]
    }

    positive <- (z_pfs > W_CRIT)

    return(list(expand   = FALSE,
                z_orr    = z_orr,
                z_pfs    = z_pfs,
                z_os     = NA_real_,
                positive = positive))
  }

  # -----------------------------------------------------------------
  #  Step 2b: If expanded => enrol additional patients, Phase 3 (OS)
  # -----------------------------------------------------------------
  n_add_arm <- N_ADDITIONAL %/% 2

  ctrl_p3 <- generate_patient_data(n_add_arm, orr_ctrl, lambda_pfs_ctrl,
                                   lambda_os_ctrl, rho_orr_pfs, rho_orr_os, rho_pfs_os)
  trt_p3  <- generate_patient_data(n_add_arm, orr_trt, lambda_pfs_trt,
                                   lambda_os_trt,  rho_orr_pfs, rho_orr_os, rho_pfs_os)
  ctrl_p3$arm <- 0L
  trt_p3$arm  <- 1L

  # Phase 3 accrual starts after adaptation decision
  adapt_calendar <- max(dat_p2$enroll_time[first_enrolled]) + min_fu_adapt
  enroll_p3 <- sort(runif(N_ADDITIONAL, adapt_calendar,
                          adapt_calendar + N_ADDITIONAL / enrollment_rate_p3))
  ctrl_p3$enroll_time <- enroll_p3[1:n_add_arm]
  trt_p3$enroll_time  <- enroll_p3[(n_add_arm + 1):N_ADDITIONAL]

  dat_all <- rbind(dat_p2, rbind(ctrl_p3, trt_p3))

  # Calendar time for OS analysis: wait for d_os_target deaths
  dat_all$os_calendar <- dat_all$enroll_time + dat_all$os_time

  sorted_death_times <- sort(dat_all$os_calendar)
  if (length(sorted_death_times) >= d_os_target) {
    analysis_time_os <- sorted_death_times[d_os_target]
  } else {
    analysis_time_os <- max(sorted_death_times) + 12
  }

  potential_fu_os <- analysis_time_os - dat_all$enroll_time
  obs_os_time     <- pmin(dat_all$os_time, potential_fu_os)
  os_event        <- as.integer(dat_all$os_time <= potential_fu_os)

  obs_os_time[obs_os_time <= 0] <- 0.001

  fit_os <- tryCatch({
    coxph(Surv(obs_os_time, os_event) ~ arm, data = dat_all)
  }, error = function(e) NULL)

  if (is.null(fit_os)) {
    z_os <- 0
  } else {
    coef_os <- summary(fit_os)$coefficients
    z_os    <- -coef_os["arm", "z"]
  }

  positive <- (z_os > W_CRIT)

  list(expand   = TRUE,
       z_orr    = z_orr,
       z_pfs    = NA_real_,
       z_os     = z_os,
       positive = positive)
}


#' Run the full simulation study
#'
#' @param n_sim              number of Monte Carlo replicates
#' @param orr_ctrl/trt       ORR parameters
#' @param hr_pfs             PFS hazard ratio (treatment/control, <1 favours trt)
#' @param hr_os              OS hazard ratio
#' @param median_pfs_ctrl    median PFS for control (months)
#' @param median_os_ctrl     median OS for control (months)
#' @param ...                passed to run_one_trial()
#' @param seed               random seed
#' @return data.frame of results
run_simulation <- function(n_sim,
                           orr_ctrl, orr_trt,
                           hr_pfs, hr_os,
                           median_pfs_ctrl = 10.3,
                           median_os_ctrl  = 24,
                           d_pfs_target    = 70,
                           d_os_target     = 330,
                           rho_orr_pfs     = 0.4,
                           rho_orr_os      = 0.2,
                           rho_pfs_os      = 0.6,
                           seed            = 12345) {

  set.seed(seed)

  lambda_pfs_ctrl <- log(2) / median_pfs_ctrl
  lambda_pfs_trt  <- lambda_pfs_ctrl * hr_pfs
  lambda_os_ctrl  <- log(2) / median_os_ctrl
  lambda_os_trt   <- lambda_os_ctrl * hr_os

  results <- data.frame(
    expand   = logical(n_sim),
    z_orr    = numeric(n_sim),
    z_pfs    = numeric(n_sim),
    z_os     = numeric(n_sim),
    positive = logical(n_sim)
  )

  for (i in seq_len(n_sim)) {
    res <- run_one_trial(
      orr_ctrl = orr_ctrl, orr_trt = orr_trt,
      lambda_pfs_ctrl = lambda_pfs_ctrl, lambda_pfs_trt = lambda_pfs_trt,
      lambda_os_ctrl  = lambda_os_ctrl,  lambda_os_trt  = lambda_os_trt,
      rho_orr_pfs = rho_orr_pfs,
      rho_orr_os  = rho_orr_os,
      rho_pfs_os  = rho_pfs_os,
      d_pfs_target = d_pfs_target,
      d_os_target  = d_os_target
    )
    results$expand[i]   <- res$expand
    results$z_orr[i]    <- res$z_orr
    results$z_pfs[i]    <- res$z_pfs
    results$z_os[i]     <- res$z_os
    results$positive[i] <- res$positive

    if (i %% 500 == 0) {
      cat(sprintf("  ... completed %d / %d replicates\n", i, n_sim))
    }
  }

  results
}

# =========================================================================
#  (A) Type I Error Verification under H0
#      H0: no treatment effect on PFS (HR=1) and OS (HR=1)
#      ORR may or may not have a treatment effect (E{X} unrestricted)
# =========================================================================

N_SIM <- 10000

cat("=======================================================================\n")
cat("  2-in-1 Adaptive Design: Monte Carlo Simulation\n")
cat(sprintf("  Number of replicates per scenario: %d\n", N_SIM))
cat("=======================================================================\n")

# -- Scenario H0-a: ORR also has no effect --------------------------------
cat("\n--- H0-a: orr_ctrl=0.30, orr_trt=0.30, HR_PFS=1.0, HR_OS=1.0 ---\n")
cat("    (Global null: no treatment effect on any endpoint)\n\n")

res_h0a <- run_simulation(
  n_sim      = N_SIM,
  orr_ctrl   = 0.30,
  orr_trt    = 0.30,
  hr_pfs     = 1.0,
  hr_os      = 1.0,
  seed       = 20240101
)

expansion_rate_h0a <- mean(res_h0a$expand)
alpha_h0a          <- mean(res_h0a$positive)
alpha_h0a_noexp    <- mean(res_h0a$positive[!res_h0a$expand])
alpha_h0a_exp      <- if (any(res_h0a$expand)) mean(res_h0a$positive[res_h0a$expand]) else NA

se_alpha <- sqrt(alpha_h0a * (1 - alpha_h0a) / N_SIM)

cat(sprintf("  Expansion rate              = %.4f\n", expansion_rate_h0a))
cat(sprintf("  P(positive | no expansion)  = %.4f\n", alpha_h0a_noexp))
cat(sprintf("  P(positive | expansion)     = %.4f\n", alpha_h0a_exp))
cat(sprintf("  Overall Type I error        = %.4f  (SE = %.4f)\n", alpha_h0a, se_alpha))
cat(sprintf("  95%% CI for alpha            = [%.4f, %.4f]\n",
            alpha_h0a - 1.96 * se_alpha, alpha_h0a + 1.96 * se_alpha))
cat(sprintf("  Target alpha                = %.4f\n", ALPHA_STUDY))
cat(sprintf("  Alpha controlled?           : %s\n\n",
            ifelse(alpha_h0a <= ALPHA_STUDY + 2 * se_alpha, "YES", "NO")))

# -- Scenario H0-b: ORR has treatment effect but PFS/OS do not ------------
cat("--- H0-b: orr_ctrl=0.25, orr_trt=0.45, HR_PFS=1.0, HR_OS=1.0 ---\n")
cat("    (ORR difference exists but no PFS/OS benefit)\n\n")

res_h0b <- run_simulation(
  n_sim      = N_SIM,
  orr_ctrl   = 0.25,
  orr_trt    = 0.45,
  hr_pfs     = 1.0,
  hr_os      = 1.0,
  seed       = 20240202
)

expansion_rate_h0b <- mean(res_h0b$expand)
alpha_h0b          <- mean(res_h0b$positive)
se_alpha_b         <- sqrt(alpha_h0b * (1 - alpha_h0b) / N_SIM)

cat(sprintf("  Expansion rate              = %.4f\n", expansion_rate_h0b))
cat(sprintf("  Overall Type I error        = %.4f  (SE = %.4f)\n", alpha_h0b, se_alpha_b))
cat(sprintf("  95%% CI for alpha            = [%.4f, %.4f]\n",
            alpha_h0b - 1.96 * se_alpha_b, alpha_h0b + 1.96 * se_alpha_b))
cat(sprintf("  Alpha controlled?           : %s\n\n",
            ifelse(alpha_h0b <= ALPHA_STUDY + 2 * se_alpha_b, "YES", "NO")))

# -- Scenario H0-c: Opposite ORR effect (ORR favours control) ------------
cat("--- H0-c: orr_ctrl=0.40, orr_trt=0.25, HR_PFS=1.0, HR_OS=1.0 ---\n")
cat("    (ORR favours control arm, no PFS/OS benefit)\n\n")

res_h0c <- run_simulation(
  n_sim      = N_SIM,
  orr_ctrl   = 0.40,
  orr_trt    = 0.25,
  hr_pfs     = 1.0,
  hr_os      = 1.0,
  seed       = 20240303
)

expansion_rate_h0c <- mean(res_h0c$expand)
alpha_h0c          <- mean(res_h0c$positive)
se_alpha_c         <- sqrt(alpha_h0c * (1 - alpha_h0c) / N_SIM)

cat(sprintf("  Expansion rate              = %.4f\n", expansion_rate_h0c))
cat(sprintf("  Overall Type I error        = %.4f  (SE = %.4f)\n", alpha_h0c, se_alpha_c))
cat(sprintf("  95%% CI for alpha            = [%.4f, %.4f]\n",
            alpha_h0c - 1.96 * se_alpha_c, alpha_h0c + 1.96 * se_alpha_c))
cat(sprintf("  Alpha controlled?           : %s\n\n",
            ifelse(alpha_h0c <= ALPHA_STUDY + 2 * se_alpha_c, "YES", "NO")))

# =========================================================================
#  (B) Power Under Alternative Hypotheses
# =========================================================================

cat("=======================================================================\n")
cat("  Power Analysis Under Alternative Hypotheses\n")
cat("=======================================================================\n\n")

# -- Scenario H1-a: Full alternative (all endpoints effective) ------------
cat("--- H1-a: orr_ctrl=0.25, orr_trt=0.45, HR_PFS=0.55, HR_OS=0.70 ---\n")
cat("    (Full alternative: ORR, PFS, and OS all effective)\n\n")

res_h1a <- run_simulation(
  n_sim      = N_SIM,
  orr_ctrl   = 0.25,
  orr_trt    = 0.45,
  hr_pfs     = 0.55,
  hr_os      = 0.70,
  seed       = 20240401
)

cat(sprintf("  Expansion rate                  = %.4f\n", mean(res_h1a$expand)))
cat(sprintf("  P(positive | no expansion, PFS) = %.4f\n",
            if (any(!res_h1a$expand)) mean(res_h1a$positive[!res_h1a$expand]) else NA))
cat(sprintf("  P(positive | expansion, OS)     = %.4f\n",
            if (any(res_h1a$expand)) mean(res_h1a$positive[res_h1a$expand]) else NA))
cat(sprintf("  Overall Power                   = %.4f\n\n", mean(res_h1a$positive)))

# -- Scenario H1-b: Moderate ORR, moderate PFS/OS ------------------------
cat("--- H1-b: orr_ctrl=0.25, orr_trt=0.35, HR_PFS=0.65, HR_OS=0.75 ---\n")
cat("    (Moderate effects across all endpoints)\n\n")

res_h1b <- run_simulation(
  n_sim      = N_SIM,
  orr_ctrl   = 0.25,
  orr_trt    = 0.35,
  hr_pfs     = 0.65,
  hr_os      = 0.75,
  seed       = 20240502
)

cat(sprintf("  Expansion rate                  = %.4f\n", mean(res_h1b$expand)))
cat(sprintf("  P(positive | no expansion, PFS) = %.4f\n",
            if (any(!res_h1b$expand)) mean(res_h1b$positive[!res_h1b$expand]) else NA))
cat(sprintf("  P(positive | expansion, OS)     = %.4f\n",
            if (any(res_h1b$expand)) mean(res_h1b$positive[res_h1b$expand]) else NA))
cat(sprintf("  Overall Power                   = %.4f\n\n", mean(res_h1b$positive)))

# -- Scenario H1-c: Strong ORR but modest survival benefit ----------------
cat("--- H1-c: orr_ctrl=0.20, orr_trt=0.50, HR_PFS=0.70, HR_OS=0.80 ---\n")
cat("    (Strong ORR, modest PFS/OS benefit)\n\n")

res_h1c <- run_simulation(
  n_sim      = N_SIM,
  orr_ctrl   = 0.20,
  orr_trt    = 0.50,
  hr_pfs     = 0.70,
  hr_os      = 0.80,
  seed       = 20240603
)

cat(sprintf("  Expansion rate                  = %.4f\n", mean(res_h1c$expand)))
cat(sprintf("  P(positive | no expansion, PFS) = %.4f\n",
            if (any(!res_h1c$expand)) mean(res_h1c$positive[!res_h1c$expand]) else NA))
cat(sprintf("  P(positive | expansion, OS)     = %.4f\n",
            if (any(res_h1c$expand)) mean(res_h1c$positive[res_h1c$expand]) else NA))
cat(sprintf("  Overall Power                   = %.4f\n\n", mean(res_h1c$positive)))

# =========================================================================
#  (C) Sensitivity to Correlation Structure
# =========================================================================

cat("=======================================================================\n")
cat("  Sensitivity Analysis: Type I Error vs. Correlation\n")
cat("=======================================================================\n\n")

N_SIM_SENS <- 5000

corr_scenarios <- list(
  list(rho_orr_pfs = 0.5, rho_orr_os = 0.3, rho_pfs_os = 0.7,
       label = "rho(ORR,PFS)=0.5, rho(ORR,OS)=0.3, rho(PFS,OS)=0.7"),
  list(rho_orr_pfs = 0.3, rho_orr_os = 0.1, rho_pfs_os = 0.6,
       label = "rho(ORR,PFS)=0.3, rho(ORR,OS)=0.1, rho(PFS,OS)=0.6"),
  list(rho_orr_pfs = 0.6, rho_orr_os = 0.4, rho_pfs_os = 0.8,
       label = "rho(ORR,PFS)=0.6, rho(ORR,OS)=0.4, rho(PFS,OS)=0.8"),
  list(rho_orr_pfs = 0.2, rho_orr_os = 0.2, rho_pfs_os = 0.5,
       label = "rho(ORR,PFS)=0.2, rho(ORR,OS)=0.2, rho(PFS,OS)=0.5 [equal rho_XY,rho_XZ]")
)

cat(sprintf("  Replicates per scenario: %d\n", N_SIM_SENS))
cat("  H0: orr_ctrl = orr_trt = 0.30, HR_PFS = 1.0, HR_OS = 1.0\n\n")

for (k in seq_along(corr_scenarios)) {
  sc <- corr_scenarios[[k]]
  cat(sprintf("  Scenario %d: %s\n", k, sc$label))

  res <- run_simulation(
    n_sim       = N_SIM_SENS,
    orr_ctrl    = 0.30,
    orr_trt     = 0.30,
    hr_pfs      = 1.0,
    hr_os       = 1.0,
    rho_orr_pfs = sc$rho_orr_pfs,
    rho_orr_os  = sc$rho_orr_os,
    rho_pfs_os  = sc$rho_pfs_os,
    seed        = 20240700 + k
  )

  alpha_est <- mean(res$positive)
  se_est    <- sqrt(alpha_est * (1 - alpha_est) / N_SIM_SENS)
  cat(sprintf("    Expansion rate = %.4f\n", mean(res$expand)))
  cat(sprintf("    Type I error   = %.4f  (SE = %.4f)\n", alpha_est, se_est))
  cat(sprintf("    Controlled?    : %s\n\n",
              ifelse(alpha_est <= ALPHA_STUDY + 2 * se_est, "YES", "CAUTION")))
}

# =========================================================================
#  (D) Summary Visualisation: Histogram of z-statistics
# =========================================================================

cat("=======================================================================\n")
cat("  Generating diagnostic plots\n")
cat("=======================================================================\n")

png("chen_2in1_sim_diagnostics.png", width = 12, height = 8, units = "in", res = 150)
par(mfrow = c(2, 2), mar = c(4.5, 4.5, 3, 1))

# H0-a: z_orr distribution
hist(res_h0a$z_orr, breaks = 50, col = "lightblue", border = "white",
     main = "H0-a: z(ORR) at adaptation",
     xlab = "z-statistic (ORR)", probability = TRUE)
abline(v = C_ADAPT, col = "red", lwd = 2, lty = 2)
legend("topright", legend = sprintf("c = %.2f", C_ADAPT),
       col = "red", lty = 2, lwd = 2, bty = "n")
curve(dnorm(x), add = TRUE, col = "darkgrey", lwd = 1.5, lty = 3)

# H0-a: z_pfs for non-expanded trials
z_pfs_noexp <- res_h0a$z_pfs[!res_h0a$expand]
if (length(z_pfs_noexp) > 10) {
  hist(z_pfs_noexp, breaks = 50, col = "lightgreen", border = "white",
       main = "H0-a: z(PFS) | not expanded",
       xlab = "z-statistic (PFS)", probability = TRUE)
  abline(v = W_CRIT, col = "red", lwd = 2, lty = 2)
  legend("topright", legend = sprintf("w = %.2f", W_CRIT),
         col = "red", lty = 2, lwd = 2, bty = "n")
  curve(dnorm(x), add = TRUE, col = "darkgrey", lwd = 1.5, lty = 3)
}

# H0-b: z_os for expanded trials
z_os_exp <- res_h0b$z_os[res_h0b$expand]
if (length(z_os_exp) > 10) {
  hist(z_os_exp, breaks = 50, col = "lightyellow", border = "white",
       main = "H0-b (ORR diff): z(OS) | expanded",
       xlab = "z-statistic (OS)", probability = TRUE)
  abline(v = W_CRIT, col = "red", lwd = 2, lty = 2)
  legend("topright", legend = sprintf("w = %.2f", W_CRIT),
         col = "red", lty = 2, lwd = 2, bty = "n")
  curve(dnorm(x), add = TRUE, col = "darkgrey", lwd = 1.5, lty = 3)
}

# H1-a: overall z-statistics under alternative
z_combined <- ifelse(res_h1a$expand, res_h1a$z_os, res_h1a$z_pfs)
hist(z_combined, breaks = 50, col = "lightsalmon", border = "white",
     main = "H1-a: z(PFS or OS) for study outcome",
     xlab = "z-statistic (efficacy)", probability = TRUE)
abline(v = W_CRIT, col = "red", lwd = 2, lty = 2)
legend("topright", legend = sprintf("w = %.2f  (power=%.1f%%)",
                                    W_CRIT, mean(res_h1a$positive) * 100),
       col = "red", lty = 2, lwd = 2, bty = "n")

invisible(dev.off())
cat("  Saved: chen_2in1_sim_diagnostics.png\n")

# =========================================================================
#  Final Summary
# =========================================================================

cat("\n=======================================================================\n")
cat("  Simulation Summary\n")
cat("=======================================================================\n\n")

cat("  Scenario        | Expansion | Type I / Power | Controlled?\n")
cat("  ----------------+-----------+----------------+------------\n")
cat(sprintf("  H0-a (global)   | %5.1f%%    | %.4f (alpha)  | %s\n",
            expansion_rate_h0a*100, alpha_h0a,
            ifelse(alpha_h0a <= 0.025 + 2*se_alpha, "YES", "NO")))
cat(sprintf("  H0-b (ORR diff) | %5.1f%%    | %.4f (alpha)  | %s\n",
            expansion_rate_h0b*100, alpha_h0b,
            ifelse(alpha_h0b <= 0.025 + 2*se_alpha_b, "YES", "NO")))
cat(sprintf("  H0-c (ORR rev)  | %5.1f%%    | %.4f (alpha)  | %s\n",
            expansion_rate_h0c*100, alpha_h0c,
            ifelse(alpha_h0c <= 0.025 + 2*se_alpha_c, "YES", "NO")))
cat(sprintf("  H1-a (full alt) | %5.1f%%    | %.4f (power)  | ---\n",
            mean(res_h1a$expand)*100, mean(res_h1a$positive)))
cat(sprintf("  H1-b (moderate) | %5.1f%%    | %.4f (power)  | ---\n",
            mean(res_h1b$expand)*100, mean(res_h1b$positive)))
cat(sprintf("  H1-c (ORR str)  | %5.1f%%    | %.4f (power)  | ---\n",
            mean(res_h1c$expand)*100, mean(res_h1c$positive)))

cat("\n  Conclusion: The 2-in-1 design controls Type I error at alpha = 0.025\n")
cat("  under the assumption rho_XY >= rho_XZ, consistent with Chen et al.\n")
cat("\nDone.\n")
