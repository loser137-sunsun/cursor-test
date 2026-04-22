# Copyright Term Optimization

A literature-informed economic simulation that searches for the copyright
protection term `x` which maximises total social welfare:

```
f(x) = N(x) * [R(x) + I(x) - C(x)]
```

- `R(x)` — creator's expected revenue (incentive effect)
- `I(x)` — follow-on innovation / public-domain access value (negatively
  correlated with `x`)
- `C(x)` — enforcement cost and deadweight loss (positively correlated with `x`)
- `N(x)` — endogenous number of works produced given incentive `R(x)`

## Structure

```
copyright_optimization/
├── run_simulation.py            # end-to-end driver
├── src/
│   ├── __init__.py
│   ├── model.py                 # economic model and welfare components
│   └── optimize.py              # grid / SciPy / Bayesian optimisation + MC
├── figures/                     # generated plots
├── results/                     # summary.json, run.log
├── copyright_optimization_report.md
└── requirements.txt
```

## Quick start

```bash
cd copyright_optimization
pip install -r requirements.txt
python3 run_simulation.py
```

See `copyright_optimization_report.md` for the literature review, methodology,
results, and policy recommendations.
