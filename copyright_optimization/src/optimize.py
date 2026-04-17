"""Optimisation of copyright term via SciPy + Bayesian optimisation (skopt)."""

from __future__ import annotations

from typing import Dict, Any, List

import numpy as np
from scipy.optimize import minimize_scalar

from .model import Params, social_welfare, welfare_components


BOUNDS = (0.0, 200.0)


def grid_search(p: Params, n: int = 4001) -> Dict[str, Any]:
    """Dense grid evaluation - serves as ground truth."""
    xs = np.linspace(BOUNDS[0], BOUNDS[1], n)
    fs = np.array([social_welfare(float(x), p) for x in xs])
    i_star = int(np.argmax(fs))
    return {
        "method": "grid",
        "x_star": float(xs[i_star]),
        "f_star": float(fs[i_star]),
        "xs": xs,
        "fs": fs,
    }


def scipy_scalar(p: Params) -> Dict[str, Any]:
    """Scalar bounded optimisation via SciPy."""
    res = minimize_scalar(
        lambda x: -social_welfare(float(x), p),
        bounds=BOUNDS,
        method="bounded",
        options={"xatol": 1e-4},
    )
    return {
        "method": "scipy-bounded",
        "x_star": float(res.x),
        "f_star": float(-res.fun),
        "nit": int(res.nit),
    }


def bayesian_optimisation(p: Params, n_calls: int = 40, seed: int = 42) -> Dict[str, Any]:
    """Bayesian optimisation with scikit-optimize (Gaussian Process)."""
    try:
        from skopt import gp_minimize
        from skopt.space import Real
    except ImportError as exc:  # pragma: no cover
        raise RuntimeError("scikit-optimize is required") from exc

    space = [Real(BOUNDS[0], BOUNDS[1], name="x")]

    def neg_f(v: List[float]) -> float:
        return -social_welfare(float(v[0]), p)

    res = gp_minimize(
        neg_f,
        space,
        n_calls=n_calls,
        n_initial_points=10,
        acq_func="EI",
        random_state=seed,
    )
    return {
        "method": "gp-ei",
        "x_star": float(res.x[0]),
        "f_star": float(-res.fun),
        "xs_queried": [float(xi[0]) for xi in res.x_iters],
        "fs_queried": [float(-v) for v in res.func_vals],
    }


def monte_carlo_sensitivity(
    base: Params,
    n_draws: int = 2000,
    seed: int = 7,
) -> Dict[str, Any]:
    """Monte-Carlo uncertainty propagation.

    Each of the key economic parameters is perturbed by a log-normal factor
    centred at the literature point estimate.  For each draw we re-optimise
    x* via bounded scalar search and record the resulting optimum.
    """
    rng = np.random.default_rng(seed)
    x_stars: List[float] = []
    f_stars: List[float] = []

    def _lognorm(mean: float, sigma: float) -> float:
        return float(mean * np.exp(rng.normal(0.0, sigma) - 0.5 * sigma**2))

    param_draws = []
    for _ in range(n_draws):
        p = Params(
            r=_lognorm(base.r, 0.30),
            delta=_lognorm(base.delta, 0.35),
            delta_i=_lognorm(base.delta_i, 0.35),
            pi_0=_lognorm(base.pi_0, 0.20),
            s_pd=_lognorm(base.s_pd, 0.25),
            L0=_lognorm(base.L0, 0.35),
            kappa=_lognorm(base.kappa, 0.50),
            N_max=base.N_max,
            F_mean=_lognorm(base.F_mean, 0.30),
        )
        res = scipy_scalar(p)
        x_stars.append(res["x_star"])
        f_stars.append(res["f_star"])
        param_draws.append(p)

    arr = np.array(x_stars)
    return {
        "x_stars": arr,
        "f_stars": np.array(f_stars),
        "param_draws": param_draws,
        "summary": {
            "mean": float(arr.mean()),
            "median": float(np.median(arr)),
            "std": float(arr.std()),
            "p05": float(np.quantile(arr, 0.05)),
            "p25": float(np.quantile(arr, 0.25)),
            "p75": float(np.quantile(arr, 0.75)),
            "p95": float(np.quantile(arr, 0.95)),
        },
    }


def scenario_table(p: Params, scenarios: Dict[str, float] | None = None) -> Dict[str, Dict[str, float]]:
    """Evaluate welfare at canonical policy scenarios."""
    if scenarios is None:
        scenarios = {
            "Abolition (x=0)": 0.0,
            "Very short (5y)": 5.0,
            "Short / Pollock (15y)": 15.0,
            "Moderate (25y)": 25.0,
            "Berne (life~50y, proxy)": 50.0,
            "Current (70y post-mortem)": 70.0,
            "Extreme (95y)": 95.0,
            "Perpetual (200y proxy)": 200.0,
        }
    out: Dict[str, Dict[str, float]] = {}
    for name, x in scenarios.items():
        out[name] = welfare_components(x, p)
    return out
