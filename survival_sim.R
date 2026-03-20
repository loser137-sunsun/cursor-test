library(survival)
library(survminer)

set.seed(42)

# ---------------------------------------------------------------------------
# Parameter settings
# ---------------------------------------------------------------------------
n_per_group      <- 100       # sample size per group
median_control   <- 12        # median survival (months) for Control
hr               <- 0.7       # hazard ratio (Treatment / Control)
enrollment_period <- 6        # enrollment window (months, uniform)
min_followup     <- 12        # minimum follow-up after last enrollment

# ---------------------------------------------------------------------------
# Derived quantities
# ---------------------------------------------------------------------------
lambda_control   <- log(2) / median_control
lambda_treatment <- lambda_control * hr
total_study_time <- enrollment_period + min_followup

# ---------------------------------------------------------------------------
# Data generation
# ---------------------------------------------------------------------------
enrollment_control   <- runif(n_per_group, min = 0, max = enrollment_period)
enrollment_treatment <- runif(n_per_group, min = 0, max = enrollment_period)

true_surv_control   <- rexp(n_per_group, rate = lambda_control)
true_surv_treatment <- rexp(n_per_group, rate = lambda_treatment)

censor_time_control   <- total_study_time - enrollment_control
censor_time_treatment <- total_study_time - enrollment_treatment

obs_time_control   <- pmin(true_surv_control,   censor_time_control)
obs_time_treatment <- pmin(true_surv_treatment, censor_time_treatment)

status_control   <- as.integer(true_surv_control   <= censor_time_control)
status_treatment <- as.integer(true_surv_treatment <= censor_time_treatment)

df <- data.frame(
  time   = c(obs_time_control, obs_time_treatment),
  status = c(status_control,   status_treatment),
  group  = factor(
    rep(c("Control", "Treatment"), each = n_per_group),
    levels = c("Control", "Treatment")
  )
)

# ---------------------------------------------------------------------------
# Kaplan-Meier estimation & survival curve plot
# ---------------------------------------------------------------------------
km_fit <- survfit(Surv(time, status) ~ group, data = df)

p <- ggsurvplot(
  km_fit,
  data          = df,
  pval          = TRUE,
  risk.table    = TRUE,
  xlab          = "Time (months)",
  ylab          = "Survival Probability",
  title         = "Kaplan-Meier Survival Curves (Simulated Data)",
  legend.title  = "Group",
  legend.labs   = c("Control", "Treatment"),
  palette       = c("#E41A1C", "#377EB8"),
  ggtheme       = theme_minimal()
)

png("survival_curve.png", width = 8, height = 6, units = "in", res = 150)
print(p)
invisible(dev.off())

# ---------------------------------------------------------------------------
# Log-rank test
# ---------------------------------------------------------------------------
lr_test <- survdiff(Surv(time, status) ~ group, data = df)
lr_pval <- pchisq(lr_test$chisq, df = 1, lower.tail = FALSE)

cat("\n===== Log-rank Test =====\n")
cat(sprintf("Chi-squared = %.4f,  p-value = %.4f\n", lr_test$chisq, lr_pval))

# ---------------------------------------------------------------------------
# Cox proportional hazards model
# ---------------------------------------------------------------------------
cox_fit <- coxph(Surv(time, status) ~ group, data = df)
cox_sum <- summary(cox_fit)

cox_hr      <- cox_sum$conf.int["groupTreatment", "exp(coef)"]
cox_hr_lo   <- cox_sum$conf.int["groupTreatment", "lower .95"]
cox_hr_hi   <- cox_sum$conf.int["groupTreatment", "upper .95"]

cat("\n===== Cox Proportional Hazards Model =====\n")
cat(sprintf("Hazard Ratio (Treatment vs Control) = %.4f\n", cox_hr))
cat(sprintf("95%% CI: [%.4f, %.4f]\n", cox_hr_lo, cox_hr_hi))
cat(sprintf("Cox model p-value = %.4f\n", cox_sum$coefficients["groupTreatment", "Pr(>|z|)"]))
