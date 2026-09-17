"""Ide & Talamas (2025), "Artificial Intelligence in the Knowledge Economy": numerics.

The equilibrium of the paper is efficient (Propositions 1, 2 and 6: it maximises total
output), so it can be computed as the planner's linear programme over firm
configurations, and the equilibrium wages w(z) and the rental rate of compute r are
the dual variables (shadow prices) of the human-time and compute constraints.  This
file does exactly that for a discrete set of knowledge types:

  * a fine grid approximating the paper's own example, G(z) = z and h = 1/2, with
    z_AI = 0.425 (basic AI) and z_AI = 0.85 (advanced AI) as in Figures 3, 5, 7 and 9;
  * the two-type and three-type discrete versions the course issue asks to derive by
    hand, with the closed forms of the README checked against the LP.

Activities (one column each; x >= 0 is the mass of firms of that type):
  I(k)      human k independent:            uses 1 of k,            output z_k
  nA(k,j)   n(z_k) humans k + human solver j: uses n(z_k) of k, 1 of j, output n(z_k) z_j   (k < j)
  Aind      AI independent (autonomous):    uses 1 compute,         output z_AI
  tA(k)     n(z_k) humans k + AI solver:     uses n(z_k) of k, 1 compute, output n(z_k) z_AI  (z_k < z_AI)
  bA(j)     n(z_AI) AI workers + human j (autonomous): uses n(z_AI) compute, 1 of j, output n(z_AI) z_j (z_j > z_AI)
with n(z) = 1 / (h (1 - z)) (the span of control, page 10 of arXiv v11).
Non-autonomous AI (Section 6) drops Aind and bA.

Run:  python analysis/knowledge_economy.py        (writes analysis/figures/*.pdf and analysis/results.json)
"""
from __future__ import annotations

import json
import os
from dataclasses import dataclass

import numpy as np
from scipy.optimize import linprog
from scipy.sparse import coo_matrix

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
FIG = os.path.join(HERE, "figures")
os.makedirs(FIG, exist_ok=True)


def n_of(z: float, h: float) -> float:
    """Span of control: h * n(z) * (1 - z) = 1."""
    return 1.0 / (h * (1.0 - z))


@dataclass
class Equilibrium:
    w: np.ndarray          # wages by type (duals of the human-time constraints)
    r: float               # rental rate of compute (dual of the compute constraint)
    output: float          # total output
    labor_income: float
    used_compute: float
    idle_compute: float
    activity: dict         # activity name -> mass of firms (only positive ones)


def solve(z, mu, h, zAI=None, mu_c=0.0, autonomous=True) -> Equilibrium:
    z = np.asarray(z, dtype=float)
    mu = np.asarray(mu, dtype=float)
    K = len(z)
    rows, cols, vals, outs, names = [], [], [], [], []
    col = 0

    def add(name, out, usage):
        nonlocal col
        for rr, vv in usage.items():
            rows.append(rr)
            cols.append(col)
            vals.append(vv)
        outs.append(out)
        names.append(name)
        col += 1

    for k in range(K):
        add(("I", k), z[k], {k: 1.0})
    for k in range(K):
        nk = n_of(z[k], h)
        for j in range(k + 1, K):
            add(("nA", k, j), nk * z[j], {k: nk, j: 1.0})
    has_ai = zAI is not None and mu_c > 0
    C = K
    if has_ai:
        if autonomous:
            add(("Aind",), zAI, {C: 1.0})
            nAI = n_of(zAI, h)
            for j in range(K):
                if z[j] > zAI:
                    add(("bA", j), nAI * z[j], {C: nAI, j: 1.0})
        for k in range(K):
            if z[k] < zAI:
                nk = n_of(z[k], h)
                add(("tA", k), nk * zAI, {k: nk, C: 1.0})
    m = K + (1 if has_ai else 0)
    A = coo_matrix((vals, (rows, cols)), shape=(m, col)).tocsr()
    b = np.concatenate([mu, [mu_c]]) if has_ai else mu.copy()
    c = -np.asarray(outs)
    res = linprog(c, A_ub=A, b_ub=b, bounds=(0, None), method="highs")
    if res.status != 0:
        raise RuntimeError(res.message)
    duals = -np.asarray(res.ineqlin.marginals)  # >= 0: value of one more unit of the resource
    w = duals[:K]
    r = float(duals[K]) if has_ai else 0.0
    x = res.x
    used = 0.0
    if has_ai:
        used = float(np.asarray(A[K].dot(x)).ravel()[0])
    act = {str(names[i]): float(x[i]) for i in range(col) if x[i] > 1e-9}
    return Equilibrium(
        w=w, r=r, output=float(-res.fun), labor_income=float(np.dot(w, mu)),
        used_compute=used, idle_compute=(mu_c - used) if has_ai else 0.0, activity=act)


# ----------------------------------------------------------------------------------
# 1. The paper's example: G(z) = z, h = 1/2
# ----------------------------------------------------------------------------------
K = 240
H = 0.5
MU_C = 6.0          # abundant relative to human time (footnote 14 of the paper)
Z = (np.arange(K) + 0.5) / K
MU = np.full(K, 1.0 / K)

results = {"grid": K, "h": H, "mu_compute": MU_C}

pre = solve(Z, MU, H)
results["pre_AI"] = {"w_bottom": float(pre.w[0]), "w_top": float(pre.w[-1]), "output": pre.output}
# closed form for the pre-AI boundary between workers and solvers with G uniform:
# m'(z) = h(1 - z), m(0) = z*, m(z*) = 1  =>  z* + h (z* - z*^2/2) = 1
zstar = (6 - np.sqrt(36 - 16)) / 2 if H == 0.5 else None   # 3 - sqrt 5 for h = 1/2
results["pre_AI"]["z_star_closed_form"] = float(zstar) if zstar is not None else None

fig, ax = plt.subplots(figsize=(6.4, 4.2))
ax.plot(Z, pre.w, lw=2.2, label="$w(z)$ pre-AI (LP duals)")
ax.plot(Z, Z, "k--", lw=1, label="45°: $w = z$")
if zstar is not None:
    ax.axvline(zstar, color="grey", ls=":", lw=1)
    ax.text(zstar + 0.01, 0.05, "$z^*=3-\\sqrt{5}$\n$W$ | $S$", fontsize=9)
ax.set_xlabel("knowledge $z$")
ax.set_ylabel("wage")
ax.set_title("Pre-AI equilibrium, $G(z)=z$, $h=1/2$ (paper's Figure 3a)")
ax.legend(frameon=False)
fig.tight_layout()
fig.savefig(os.path.join(FIG, "pre_ai_wages.pdf"))
plt.close(fig)


def winners(w_post, w_pre, zAI):
    B = Z[(Z <= zAI) & (w_post > w_pre + 1e-9)]
    T = Z[(Z >= zAI) & (w_post > w_pre + 1e-9)]
    return B, T


results["autonomous"] = {}
results["non_autonomous"] = {}
for zAI in (0.425, 0.85):
    auto = solve(Z, MU, H, zAI=zAI, mu_c=MU_C, autonomous=True)
    nona = solve(Z, MU, H, zAI=zAI, mu_c=MU_C, autonomous=False)
    B, T = winners(auto.w, pre.w, zAI)
    Bn, Tn = winners(nona.w, pre.w, zAI)
    k_ai = int(np.argmin(np.abs(Z - zAI)))
    results["autonomous"][str(zAI)] = {
        "r": auto.r, "output": auto.output, "labor_income": auto.labor_income,
        "w_bottom": float(auto.w[0]), "w_top": float(auto.w[-1]), "w_at_zAI": float(auto.w[k_ai]),
        "pre_w_at_zAI": float(pre.w[k_ai]),
        "B_nonempty": bool(len(B) > 0), "B_sup": float(B.max()) if len(B) else None,
        "T_nonempty": bool(len(T) > 0), "T_inf": float(T.min()) if len(T) else None,
        "roles": sorted({a.split("'")[1] for a in auto.activity if a.startswith("('")} & {"Aind", "tA", "bA"}),
    }
    results["non_autonomous"][str(zAI)] = {
        "r": nona.r, "output": nona.output, "labor_income": nona.labor_income,
        "idle_compute": nona.idle_compute,
        "w_bottom": float(nona.w[0]), "w_top": float(nona.w[-1]),
        "B_nonempty": bool(len(Bn) > 0), "B_sup": float(Bn.max()) if len(Bn) else None,
        "T_nonempty": bool(len(Tn) > 0),
        "losers_exist": bool(np.any(nona.w < pre.w - 1e-9)),
        "bottom_ge_max": bool(nona.w[0] >= max(pre.w[0], auto.w[0]) - 1e-9),
        "top_le_autonomous": bool(nona.w[-1] <= auto.w[-1] + 1e-9),
    }
    # Figure 5-type plot: autonomous
    fig, ax = plt.subplots(figsize=(6.4, 4.2))
    ax.plot(Z, pre.w, lw=1.6, color="grey", label="$w(z)$ pre-AI")
    ax.plot(Z, auto.w, lw=2.2, color="C0", label="$w^*(z)$ autonomous AI")
    ax.plot(Z, Z, "k--", lw=0.8, label="45°")
    ax.axvline(zAI, color="C3", ls=":", lw=1)
    ax.text(zAI + 0.01, 0.02, "$z_{AI}$", color="C3")
    if len(B):
        ax.axvspan(0, B.max(), color="C2", alpha=0.12, label="$B$: winners at the bottom")
    if len(T):
        ax.axvspan(T.min(), 1, color="C1", alpha=0.12, label="$T$: winners at the top")
    kind = "basic ($z_{AI}\\in$ int$W$)" if zAI < zstar else "advanced ($z_{AI}\\in$ int$S$)"
    ax.set_title(f"Autonomous AI, $z_{{AI}}={zAI}$: {kind}")
    ax.set_xlabel("knowledge $z$")
    ax.set_ylabel("wage")
    ax.legend(frameon=False, fontsize=8)
    fig.tight_layout()
    fig.savefig(os.path.join(FIG, f"autonomous_zAI{str(zAI).replace('.', '')}.pdf"))
    plt.close(fig)
    # Figure 9-type plot: non-autonomous vs autonomous vs pre
    fig, ax = plt.subplots(figsize=(6.4, 4.2))
    ax.plot(Z, pre.w, lw=1.6, color="grey", label="$w(z)$ pre-AI")
    ax.plot(Z, auto.w, lw=2.0, color="C0", label="$w^*(z)$ autonomous")
    ax.plot(Z, nona.w, lw=2.0, color="C2", label="$w^\\star(z)$ non-autonomous")
    ax.plot(Z, Z, "k--", lw=0.8)
    ax.axvline(zAI, color="C3", ls=":", lw=1)
    ax.axhline(pre.w[0], color="grey", ls=":", lw=0.8)
    ax.text(0.02, pre.w[0] + 0.02, "$w(0)$", fontsize=8, color="grey")
    ax.set_title(f"Autonomous vs non-autonomous AI, $z_{{AI}}={zAI}$ (Proposition 6)")
    ax.set_xlabel("knowledge $z$")
    ax.set_ylabel("wage")
    ax.legend(frameon=False, fontsize=8)
    fig.tight_layout()
    fig.savefig(os.path.join(FIG, f"nonautonomous_zAI{str(zAI).replace('.', '')}.pdf"))
    plt.close(fig)

# Proposition 6, first bullet: z_AI <= w(0) -> non-autonomous AI unused, wages unchanged
zlow = 0.3
nona_low = solve(Z, MU, H, zAI=zlow, mu_c=MU_C, autonomous=False)
results["non_autonomous"]["unused_when_zAI_below_w0"] = {
    "zAI": zlow, "w0_pre": float(pre.w[0]), "max_abs_wage_change": float(np.max(np.abs(nona_low.w - pre.w))),
    "used_compute": nona_low.used_compute}

# ----------------------------------------------------------------------------------
# 2. Sweep over z_AI: the two dimensions (capability on the axis, autonomy as the regime)
# ----------------------------------------------------------------------------------
sweep = np.round(np.arange(0.05, 0.96, 0.025), 3)
bot_auto, top_auto, bot_non, top_non, out_auto, out_non = [], [], [], [], [], []
for zAI in sweep:
    a = solve(Z, MU, H, zAI=float(zAI), mu_c=MU_C, autonomous=True)
    nn = solve(Z, MU, H, zAI=float(zAI), mu_c=MU_C, autonomous=False)
    bot_auto.append(a.w[0] - pre.w[0])
    top_auto.append(a.w[-1] - pre.w[-1])
    bot_non.append(nn.w[0] - pre.w[0])
    top_non.append(nn.w[-1] - pre.w[-1])
    out_auto.append(a.output)
    out_non.append(nn.output)
bot_auto, top_auto, bot_non, top_non = map(np.array, (bot_auto, top_auto, bot_non, top_non))
out_auto, out_non = np.array(out_auto), np.array(out_non)


def first_cross(xs, ys):
    for i in range(1, len(xs)):
        if ys[i - 1] <= 0 < ys[i]:
            return float(xs[i - 1] + (xs[i] - xs[i - 1]) * (-ys[i - 1]) / (ys[i] - ys[i - 1]))
    return None


zbar_auto = first_cross(sweep, bot_auto)
zbar_non = first_cross(sweep, bot_non)
results["sweep"] = {
    "zAI": sweep.tolist(),
    "bottom_gain_autonomous": bot_auto.tolist(), "top_gain_autonomous": top_auto.tolist(),
    "bottom_gain_nonautonomous": bot_non.tolist(), "top_gain_nonautonomous": top_non.tolist(),
    "output_autonomous": out_auto.tolist(), "output_nonautonomous": out_non.tolist(),
    "zbar_AI_autonomous (Prop 5 threshold, LP)": zbar_auto,
    "zbar_nonautonomous (= w(0), Prop 6)": zbar_non,
    "top_always_gains_autonomous": bool(np.all(top_auto > -1e-9)),
    "output_autonomous_gt_nonautonomous_all": bool(np.all(out_auto > out_non + 1e-9)),
}

fig, ax = plt.subplots(figsize=(6.6, 4.3))
ax.axhline(0, color="k", lw=0.8)
ax.plot(sweep, bot_auto, "o-", color="C0", ms=3, label="bottom ($z=0$), autonomous")
ax.plot(sweep, bot_non, "s-", color="C2", ms=3, label="bottom ($z=0$), non-autonomous")
ax.plot(sweep, top_auto, "o--", color="C1", ms=3, label="top ($z=1$), autonomous")
ax.plot(sweep, top_non, "s--", color="C3", ms=3, label="top ($z=1$), non-autonomous")
if zbar_auto:
    ax.axvline(zbar_auto, color="C0", ls=":", lw=1)
    ax.text(zbar_auto + 0.01, ax.get_ylim()[0] * 0.9 if ax.get_ylim()[0] < 0 else 0.02, "$\\bar z_{AI}$", color="C0")
if zbar_non:
    ax.axvline(zbar_non, color="C2", ls=":", lw=1)
    ax.text(zbar_non + 0.01, 0.15, "$w(0)$", color="C2")
ax.set_xlabel("AI capability $z_{AI}$")
ax.set_ylabel("wage change relative to pre-AI")
ax.set_title("Who gains: capability on the axis, autonomy as the regime")
ax.legend(frameon=False, fontsize=8)
fig.tight_layout()
fig.savefig(os.path.join(FIG, "two_dimensions.pdf"))
plt.close(fig)

fig, ax = plt.subplots(figsize=(6.4, 4.0))
ax.plot(sweep, out_auto, "o-", color="C0", ms=3, label="autonomous $Y^*$")
ax.plot(sweep, out_non, "s-", color="C2", ms=3, label="non-autonomous $Y^\\star$")
ax.axhline(pre.output, color="grey", ls=":", label="pre-AI $Y$")
ax.set_xlabel("AI capability $z_{AI}$")
ax.set_ylabel("total output")
ax.set_title("Output: autonomous > non-autonomous (Proposition 6.1)")
ax.legend(frameon=False, fontsize=8)
fig.tight_layout()
fig.savefig(os.path.join(FIG, "output_comparison.pdf"))
plt.close(fig)

# ----------------------------------------------------------------------------------
# 3. Two-type discrete version (the hand-derivable case) and a three-type table
# ----------------------------------------------------------------------------------
zL, zH, muL, muH = 0.3, 0.9, 0.8, 0.2
nL = n_of(zL, H)
two = {"zL": zL, "zH": zH, "muL": muL, "muH": muH, "h": H, "n_zL": nL,
       "L_abundant": bool(muL > nL * muH), "cases": []}
pre2 = solve([zL, zH], [muL, muH], H)
two["pre"] = {"wL": float(pre2.w[0]), "wH": float(pre2.w[1]), "output": pre2.output,
              "closed_form_wL": zL, "closed_form_wH": nL * (zH - zL)}
for zAI in (0.35, 0.45, 0.55, 0.65, 0.75, 0.85):
    a2 = solve([zL, zH], [muL, muH], H, zAI=zAI, mu_c=MU_C, autonomous=True)
    n2 = solve([zL, zH], [muL, muH], H, zAI=zAI, mu_c=MU_C, autonomous=False)
    two["cases"].append({
        "zAI": zAI,
        "auto": {"wL": float(a2.w[0]), "wH": float(a2.w[1]), "r": a2.r, "output": a2.output,
                 "wL_tA_formula": zAI * (1 - 1 / nL), "activities": a2.activity},
        "non": {"wL": float(n2.w[0]), "wH": float(n2.w[1]), "r": n2.r, "output": n2.output,
                "activities": n2.activity},
    })
two["threshold_auto_closed_form"] = zL / (1 - H * (1 - zL))   # z_AI (1 - h(1 - zL)) > zL
two["threshold_non_closed_form"] = zL                           # z_AI > w_L = zL
results["two_type"] = two

sw2 = np.round(np.arange(0.31, 0.90, 0.01), 3)
wL_a, wL_n, wH_a, wH_n = [], [], [], []
for zAI in sw2:
    a2 = solve([zL, zH], [muL, muH], H, zAI=float(zAI), mu_c=MU_C, autonomous=True)
    n2 = solve([zL, zH], [muL, muH], H, zAI=float(zAI), mu_c=MU_C, autonomous=False)
    wL_a.append(a2.w[0]); wL_n.append(n2.w[0]); wH_a.append(a2.w[1]); wH_n.append(n2.w[1])
fig, axs = plt.subplots(1, 2, figsize=(9.2, 3.9))
axs[0].plot(sw2, wL_a, color="C0", lw=2, label="autonomous $w^*_L$")
axs[0].plot(sw2, wL_n, color="C2", lw=2, label="non-autonomous $w^\\star_L$")
axs[0].axhline(pre2.w[0], color="grey", ls=":", label="pre-AI $w_L=z_L$")
axs[0].axvline(two["threshold_auto_closed_form"], color="C0", ls=":", lw=1)
axs[0].set_title("Type L (bottom)")
axs[0].set_xlabel("$z_{AI}$"); axs[0].set_ylabel("wage"); axs[0].legend(frameon=False, fontsize=8)
axs[1].plot(sw2, wH_a, color="C0", lw=2, label="autonomous $w^*_H$")
axs[1].plot(sw2, wH_n, color="C2", lw=2, label="non-autonomous $w^\\star_H$")
axs[1].axhline(pre2.w[1], color="grey", ls=":", label="pre-AI $w_H=n(z_L)(z_H-z_L)$")
axs[1].set_title("Type H (top)")
axs[1].set_xlabel("$z_{AI}$"); axs[1].legend(frameon=False, fontsize=8)
fig.suptitle(f"Two-type economy: $z_L={zL}$, $z_H={zH}$, $\\mu_L={muL}$, $\\mu_H={muH}$, $h={H}$", fontsize=10)
fig.tight_layout(rect=(0, 0, 1, 0.94))
fig.savefig(os.path.join(FIG, "two_type.pdf"))
plt.close(fig)

z3, mu3 = [0.2, 0.5, 0.9], [0.5, 0.3, 0.2]
pre3 = solve(z3, mu3, H)
three = {"z": z3, "mu": mu3, "pre": pre3.w.tolist(), "cases": []}
for zAI in (0.35, 0.6, 0.8):
    a3 = solve(z3, mu3, H, zAI=zAI, mu_c=MU_C, autonomous=True)
    n3 = solve(z3, mu3, H, zAI=zAI, mu_c=MU_C, autonomous=False)
    three["cases"].append({"zAI": zAI, "auto": a3.w.tolist(), "auto_r": a3.r, "auto_output": a3.output,
                           "non": n3.w.tolist(), "non_output": n3.output})
results["three_type"] = three

with open(os.path.join(HERE, "results.json"), "w", encoding="utf-8") as f:
    json.dump(results, f, indent=2)

# a short human-readable summary
lines = []
lines.append(f"grid K={K}, h={H}, mu_c={MU_C}")
lines.append(f"pre-AI: w(0)={pre.w[0]:.4f} (paper Fig 3a: 0.36), w(1)={pre.w[-1]:.4f} (paper: 1.58), z*={zstar:.4f}, Y={pre.output:.4f}")
for zAI in ("0.425", "0.85"):
    A_ = results["autonomous"][zAI]; N_ = results["non_autonomous"][zAI]
    lines.append(f"zAI={zAI} autonomous: r={A_['r']:.4f}, w*(zAI)={A_['w_at_zAI']:.4f} vs w(zAI)={A_['pre_w_at_zAI']:.4f}, "
                 f"w*(0)={A_['w_bottom']:.4f}, w*(1)={A_['w_top']:.4f}, B nonempty={A_['B_nonempty']}, T nonempty={A_['T_nonempty']}, Y*={A_['output']:.4f}")
    lines.append(f"zAI={zAI} non-autonomous: r={N_['r']:.4f}, w(0)={N_['w_bottom']:.4f}, w(1)={N_['w_top']:.4f}, "
                 f"losers={N_['losers_exist']}, bottom>=max={N_['bottom_ge_max']}, top<=auto={N_['top_le_autonomous']}, Y={N_['output']:.4f}, idle={N_['idle_compute']:.3f}")
lines.append(f"Prop 5 threshold (LP): zbar_AI={zbar_auto}; Prop 6 threshold: w(0)={pre.w[0]:.4f}, LP crossing={zbar_non}")
lines.append(f"top always gains (autonomous): {results['sweep']['top_always_gains_autonomous']}; Y* > Ystar everywhere: {results['sweep']['output_autonomous_gt_nonautonomous_all']}")
lines.append(f"two-type pre: wL={pre2.w[0]:.4f} (closed {zL}), wH={pre2.w[1]:.4f} (closed {nL*(zH-zL):.4f}); thresholds: auto {two['threshold_auto_closed_form']:.4f}, non {zL}")
for c in two["cases"]:
    lines.append(f"  zAI={c['zAI']}: auto wL={c['auto']['wL']:.4f} (tA formula {c['auto']['wL_tA_formula']:.4f}) wH={c['auto']['wH']:.4f} r={c['auto']['r']:.3f} | non wL={c['non']['wL']:.4f} wH={c['non']['wH']:.4f} | Y* {c['auto']['output']:.4f} vs Ystar {c['non']['output']:.4f}")
for c in three["cases"]:
    lines.append(f"  3-type zAI={c['zAI']}: pre {np.round(pre3.w,4).tolist()} auto {np.round(c['auto'],4).tolist()} non {np.round(c['non'],4).tolist()}")
with open(os.path.join(HERE, "results.txt"), "w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")
print("\n".join(lines))
