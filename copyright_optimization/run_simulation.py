"""End-to-end driver: optimisation, sensitivity analysis, scenario comparison,
and plot generation for the copyright-term welfare model."""

from __future__ import annotations

import json
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

from src.model import Params, welfare_components, R, I, C, N, social_welfare, params_as_dict
from src.optimize import (
    BOUNDS,
    bayesian_optimisation,
    grid_search,
    monte_carlo_sensitivity,
    scenario_table,
    scipy_scalar,
)


HERE = Path(__file__).resolve().parent
FIG_DIR = HERE / "figures"
RES_DIR = HERE / "results"
FIG_DIR.mkdir(parents=True, exist_ok=True)
RES_DIR.mkdir(parents=True, exist_ok=True)


def plot_welfare_curve(xs: np.ndarray, fs: np.ndarray, p: Params, x_star: float, path: Path) -> None:
    rs = np.array([R(x, p) for x in xs])
    is_ = np.array([I(x, p) for x in xs])
    cs = np.array([C(x, p) for x in xs])
    ns = np.array([N(x, p) for x in xs])

    fig, axes = plt.subplots(2, 1, figsize=(10, 8), sharex=True)

    ax = axes[0]
    ax.plot(xs, rs, label="R(x) creator revenue (incentive)", color="#1f77b4")
    ax.plot(xs, is_, label="I(x) access / follow-on innovation", color="#2ca02c")
    ax.plot(xs, cs, label="C(x) DWL + enforcement", color="#d62728")
    ax.set_ylabel("Present value per work")
    ax.set_title("Welfare components R, I, C vs copyright term x")
    ax.legend(loc="center right")
    ax.grid(alpha=0.3)

    ax = axes[1]
    ax.plot(xs, fs, color="black", lw=2, label="f(x) = N(x) * [R + I - C]")
    ax.axvline(x_star, color="crimson", ls="--",
               label=f"x* = {x_star:.1f} years")
    for ref, label in [(15, "Pollock 15y"), (50, "Berne 50y"), (70, "Current 70y"), (95, "CTEA+95y")]:
        ax.axvline(ref, color="grey", ls=":", alpha=0.6)
        ax.text(ref, ax.get_ylim()[1] * 0.02 if ax.get_ylim()[1] else 0,
                label, rotation=90, fontsize=8, color="grey", va="bottom")
    ax.set_xlabel("Copyright term x (years)")
    ax.set_ylabel("Total social welfare f(x)")
    ax.set_title("Total social welfare and optimum")
    ax.legend(loc="upper right")
    ax.grid(alpha=0.3)

    fig.tight_layout()
    fig.savefig(path, dpi=140)
    plt.close(fig)


def plot_bo_trace(bo: dict, path: Path) -> None:
    xs = np.array(bo["xs_queried"])
    fs = np.array(bo["fs_queried"])
    running_best = np.maximum.accumulate(fs)

    fig, axes = plt.subplots(1, 2, figsize=(12, 4.5))
    ax = axes[0]
    ax.scatter(np.arange(len(xs)), xs, c=fs, cmap="viridis", s=35)
    ax.axhline(bo["x_star"], color="crimson", ls="--",
               label=f"x* = {bo['x_star']:.1f}")
    ax.set_xlabel("Iteration")
    ax.set_ylabel("Queried x")
    ax.set_title("Bayesian optimisation: queried terms")
    ax.legend()
    ax.grid(alpha=0.3)

    ax = axes[1]
    ax.plot(running_best, color="#1f77b4")
    ax.set_xlabel("Iteration")
    ax.set_ylabel("Best f found so far")
    ax.set_title("BO convergence")
    ax.grid(alpha=0.3)

    fig.tight_layout()
    fig.savefig(path, dpi=140)
    plt.close(fig)


def plot_mc_histogram(mc: dict, path: Path) -> None:
    xs = mc["x_stars"]
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.hist(xs, bins=40, color="#4c72b0", alpha=0.8, edgecolor="white")
    for q, c, ls in [(mc["summary"]["median"], "crimson", "-"),
                     (mc["summary"]["p05"], "grey", ":"),
                     (mc["summary"]["p95"], "grey", ":")]:
        ax.axvline(q, color=c, ls=ls, lw=2)
    ax.set_xlabel("Optimal copyright term x* (years)")
    ax.set_ylabel("Frequency")
    ax.set_title(
        "Monte-Carlo sensitivity of x* (lognormal perturbations, "
        f"n={len(xs)})\n"
        f"median={mc['summary']['median']:.1f}, "
        f"90% CI=[{mc['summary']['p05']:.1f}, {mc['summary']['p95']:.1f}]"
    )
    ax.grid(alpha=0.3)
    fig.tight_layout()
    fig.savefig(path, dpi=140)
    plt.close(fig)


def plot_scenarios(scen: dict, path: Path) -> None:
    names = list(scen.keys())
    fs = [scen[n]["f"] for n in names]
    rs = [scen[n]["R"] * scen[n]["N"] for n in names]
    is_ = [scen[n]["I"] * scen[n]["N"] for n in names]
    cs = [scen[n]["C"] * scen[n]["N"] for n in names]

    idx = np.arange(len(names))
    w = 0.22
    fig, ax = plt.subplots(figsize=(12, 5.5))
    ax.bar(idx - 1.5 * w, rs, w, label="N*R creator revenue", color="#1f77b4")
    ax.bar(idx - 0.5 * w, is_, w, label="N*I access/innovation", color="#2ca02c")
    ax.bar(idx + 0.5 * w, cs, w, label="N*C cost/DWL", color="#d62728")
    ax.bar(idx + 1.5 * w, fs, w, label="f(x) total welfare", color="black")
    ax.set_xticks(idx)
    ax.set_xticklabels(names, rotation=30, ha="right")
    ax.set_ylabel("Aggregate value (model units)")
    ax.set_title("Welfare decomposition across policy scenarios")
    ax.legend()
    ax.grid(alpha=0.3, axis="y")
    fig.tight_layout()
    fig.savefig(path, dpi=140)
    plt.close(fig)


def plot_sensitivity_tornado(base: Params, path: Path) -> None:
    """One-at-a-time sensitivity (tornado) on x* around the base parameters."""
    base_res = scipy_scalar(base)
    x_base = base_res["x_star"]

    labels = []
    low_vals = []
    high_vals = []

    def _shift(attr: str, factor: float) -> float:
        kwargs = params_as_dict(base)
        kwargs[attr] = kwargs[attr] * factor
        return scipy_scalar(Params(**kwargs))["x_star"]

    for name in ["r", "delta", "delta_i", "pi_0", "s_pd", "L0", "kappa", "F_mean"]:
        lo = _shift(name, 0.5)
        hi = _shift(name, 2.0)
        labels.append(name)
        low_vals.append(lo - x_base)
        high_vals.append(hi - x_base)

    order = np.argsort([abs(l) + abs(h) for l, h in zip(low_vals, high_vals)])
    labels = [labels[i] for i in order]
    low_vals = [low_vals[i] for i in order]
    high_vals = [high_vals[i] for i in order]

    fig, ax = plt.subplots(figsize=(9, 5.5))
    y = np.arange(len(labels))
    ax.barh(y, low_vals, color="#4c72b0", label="0.5x parameter")
    ax.barh(y, high_vals, color="#dd8452", label="2.0x parameter")
    ax.axvline(0, color="black", lw=0.8)
    ax.set_yticks(y)
    ax.set_yticklabels(labels)
    ax.set_xlabel(f"Shift in x* from base (x*_base = {x_base:.1f} years)")
    ax.set_title("One-at-a-time sensitivity of x* to parameters")
    ax.legend(loc="lower right")
    ax.grid(alpha=0.3, axis="x")
    fig.tight_layout()
    fig.savefig(path, dpi=140)
    plt.close(fig)


def main() -> None:
    base = Params()

    print("=" * 70)
    print("Copyright Term Optimisation")
    print("Base parameters:")
    for k, v in params_as_dict(base).items():
        print(f"  {k:>8} = {v}")

    print("\n--- 1. Grid search (ground truth) ---")
    grid = grid_search(base)
    print(f"x* = {grid['x_star']:.3f} years  f(x*) = {grid['f_star']:.5f}")

    print("\n--- 2. SciPy bounded scalar ---")
    sc = scipy_scalar(base)
    print(f"x* = {sc['x_star']:.3f} years  f(x*) = {sc['f_star']:.5f}  (iter={sc['nit']})")

    print("\n--- 3. Bayesian optimisation (GP-EI) ---")
    bo = bayesian_optimisation(base, n_calls=40)
    print(f"x* = {bo['x_star']:.3f} years  f(x*) = {bo['f_star']:.5f}")

    print("\n--- 4. Scenario comparison ---")
    scen = scenario_table(base)
    for name, d in scen.items():
        print(f"  {name:<30}  f={d['f']:.4f}  R={d['R']:.3f}  "
              f"I={d['I']:.3f}  C={d['C']:.3f}  N={d['N']:.3f}")

    print("\n--- 5. Monte-Carlo sensitivity (n=2000) ---")
    mc = monte_carlo_sensitivity(base, n_draws=2000)
    s = mc["summary"]
    print(f"  x* distribution: mean={s['mean']:.2f}, median={s['median']:.2f}, "
          f"std={s['std']:.2f}")
    print(f"  5%-95% CI: [{s['p05']:.2f}, {s['p95']:.2f}] years")

    plot_welfare_curve(grid["xs"], grid["fs"], base, grid["x_star"],
                       FIG_DIR / "fig1_welfare_components.png")
    plot_bo_trace(bo, FIG_DIR / "fig2_bayesian_optimisation.png")
    plot_scenarios(scen, FIG_DIR / "fig3_scenarios.png")
    plot_mc_histogram(mc, FIG_DIR / "fig4_monte_carlo.png")
    plot_sensitivity_tornado(base, FIG_DIR / "fig5_tornado.png")

    summary = {
        "base_params": params_as_dict(base),
        "grid": {"x_star": grid["x_star"], "f_star": grid["f_star"]},
        "scipy": sc,
        "bayes_opt": {"x_star": bo["x_star"], "f_star": bo["f_star"]},
        "monte_carlo": mc["summary"],
        "scenarios": scen,
    }
    (RES_DIR / "summary.json").write_text(json.dumps(summary, indent=2))
    print(f"\nWrote {RES_DIR/'summary.json'}")
    print(f"Wrote figures to {FIG_DIR}")


if __name__ == "__main__":
    main()
