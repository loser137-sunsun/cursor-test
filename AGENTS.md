# AGENTS.md

## Cursor Cloud specific instructions

This repo contains two independent products — no shared backend, database, or build pipeline:

| Product | File | How to run |
|---|---|---|
| **Web app** (JS) | `index.html` | Serve via `python3 -m http.server 8080` from the repo root, then open `http://localhost:8080/index.html` in Chrome. Loads Chart.js and jStat from CDN — no `npm install` or build step. |
| **R script** | `survival_sim.R` | `Rscript survival_sim.R` — produces `survival_curve.png` and prints statistical output to stdout. |

### R environment

- R 4.3 is installed via `apt` (`r-base`, `r-base-dev`).
- Required R packages: `survival` (ships with `r-base`), `survminer` (installed from CRAN with `dependencies=TRUE`).
- Compiling `survminer` and its transitive deps (ggplot2, rstpm2, etc.) from source takes ~5 minutes; the update script handles this idempotently.
- System libs needed for R package compilation: `libcurl4-openssl-dev libssl-dev libxml2-dev libfontconfig1-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libharfbuzz-dev libfribidi-dev`.

### Notes

- There are no lint checks, automated tests, or CI pipelines in this repo.
- No `.env` files or secrets are required.
- The two products are completely independent — testing one does not require the other.
