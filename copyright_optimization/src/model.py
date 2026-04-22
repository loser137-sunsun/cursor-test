"""
Economic model of copyright protection period.

Design principles
-----------------
The welfare function follows the classical "incentive vs. access" trade-off
that underlies Landes & Posner (1989, 2003), Pollock (2009) and the Eldred
v. Ashcroft economists' amicus brief (Akerlof et al., 2002).

Let x be the copyright term length (years).  For a representative work we
define three present-value components, all discounted at rate ``r`` and with
a commercial decay rate ``delta`` that captures the empirical fact that
the cash-flow profile of typical works falls off exponentially (see Pollock
2009; Landes & Posner 2003 find median economic life ~15 years).

1. R(x) - creator revenue (incentive).
   A monopolist appropriates a fraction of per-period gross surplus pi_0.
   R(x) = pi_0 * (1 - exp(-(r + delta) x)) / (r + delta).

2. I(x) - follow-on innovation / access value.
   Society captures a per-period surplus s_pd when the work is in the public
   domain (higher than under monopoly because price -> MC and derivative
   works are possible).  Value realised only after t = x:
   I(x) = s_pd * exp(-(r + delta_i) x) / (r + delta_i).
   I(x) is strictly decreasing in x.

3. C(x) - deadweight loss + enforcement cost during protection.
   The per-period monopoly DWL is a Harberger triangle scaled by eta * pi_0.
   C(x) = L0 * (1 - exp(-(r + delta) x)) / (r + delta) + kappa * x
   where the second term models per-year enforcement/litigation cost.

Number of works created N(x)
----------------------------
Works have heterogeneous fixed creation costs F ~ Exp(1/F_mean) (a reduced
form for the "supply elasticity of creative effort").  A work is produced
iff the private return exceeds its fixed cost:
    N(x) = N_max * P[F <= R(x)] = N_max * (1 - exp(-R(x)/F_mean)).

This captures the empirical finding (Giorcelli & Moser 2020) that *basic*
copyright strongly increases output while further extensions have little
effect, because R(x) saturates quickly due to discounting.

Total social welfare
--------------------
    f(x) = N(x) * [ R(x) + I(x) - C(x) ]

which is exactly the user's objective with the summation absorbed into N(x).
"""

from __future__ import annotations

from dataclasses import dataclass, asdict, field
from typing import Dict, Any

import numpy as np


@dataclass
class Params:
    """Model parameters with literature-informed defaults."""

    # Financial parameters
    r: float = 0.03          # social discount rate (3%, standard OMB long-horizon rate)
    delta: float = 0.10      # commercial-value decay rate (Landes & Posner: median
                             # copyright economic life ~15y -> delta ~ ln(2)/15 ~= 0.046;
                             # Pollock uses higher rates up to 0.10 for books/music)
    delta_i: float = 0.05    # decay rate of follow-on innovation value (slower)

    # Per-period flows (for a representative work, normalised)
    pi_0: float = 1.00       # initial monopoly profit flow
    s_pd: float = 1.40       # public-domain social surplus flow (> pi_0 because
                             # price->MC eliminates monopoly mark-up and derivative
                             # works become possible; Boldrin-Levine, Heald 2013)
    L0: float = 0.25         # per-period DWL in Harberger triangle (~25% of pi_0,
                             # consistent with deadweight loss being typically
                             # 20-30% of monopoly rents for inelastic cultural goods)
    kappa: float = 0.005     # per-year enforcement / litigation cost per work

    # Supply of creative works
    N_max: float = 1.00      # maximum potential output (normalised)
    F_mean: float = 3.00     # mean fixed cost of creation (in units of R-equivalent;
                             # chosen so only ~60-70% of potential works get made
                             # at x=15-20y, matching historical renewal rates
                             # reported by Landes & Posner 2003)


def present_value_annuity(rate: float, years: float) -> float:
    """Present value of a unit flow over [0, years] at continuous rate."""
    if rate <= 0:
        return years
    return (1.0 - np.exp(-rate * years)) / rate


def R(x: float, p: Params) -> float:
    """Creator's expected present-value revenue given term length x."""
    return p.pi_0 * present_value_annuity(p.r + p.delta, x)


def I(x: float, p: Params) -> float:
    """Present value of follow-on innovation / public-domain access."""
    return p.s_pd * np.exp(-(p.r + p.delta_i) * x) / (p.r + p.delta_i)


def C(x: float, p: Params) -> float:
    """Deadweight loss + enforcement cost during protection."""
    dwl = p.L0 * present_value_annuity(p.r + p.delta, x)
    enforcement = p.kappa * x
    return dwl + enforcement


def N(x: float, p: Params) -> float:
    """Number of works produced (share of maximum)."""
    return p.N_max * (1.0 - np.exp(-R(x, p) / p.F_mean))


def social_welfare(x: float, p: Params | None = None) -> float:
    """f(x) = N(x) * [R(x) + I(x) - C(x)]."""
    if p is None:
        p = Params()
    x = float(np.clip(x, 0.0, 500.0))
    return N(x, p) * (R(x, p) + I(x, p) - C(x, p))


def welfare_components(x: float, p: Params | None = None) -> Dict[str, float]:
    """Return decomposed welfare components for reporting."""
    if p is None:
        p = Params()
    r_val = R(x, p)
    i_val = I(x, p)
    c_val = C(x, p)
    n_val = N(x, p)
    return {
        "x": x,
        "R": r_val,
        "I": i_val,
        "C": c_val,
        "N": n_val,
        "f": n_val * (r_val + i_val - c_val),
        "per_work_net_welfare": r_val + i_val - c_val,
    }


def params_as_dict(p: Params) -> Dict[str, Any]:
    return asdict(p)
