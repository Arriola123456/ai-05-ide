# Repository 5 — Ide & Talamàs (2025)

*Artificial Intelligence in the Knowledge Economy.* Journal of Political Economy
133(12), 3762–3800, https://doi.org/10.1086/737233. **Version read and pinned:**
arXiv **v11** (24 February 2025, 35 pp., SHA-256 `0b3c727a…8ebf`), the one the
course issue names for the Lean run; page numbers below are v11's. arXiv also
has a **v12** (17 May 2025, 39 pp., header date May 20, 2025), which is the
course PDF; Propositions 1–6 have the same numbers and statements in both. The
ChatGPT study session in `prompts.md` cites the JPE pagination (3775–3776).
`paper/README.md` has the pointers.

> **Tools, stated up front.** The model was studied first in a ChatGPT session
> (Session 1 of `prompts.md`). Everything else — the numerics, the Lean folder,
> this README and the deck — was produced with **Claude Code (Claude Fable 5.1)**
> in the session recorded as Session 2 of `prompts.md`. The issue asks for the
> Lean run to be done with Codex `gpt-5.6-sol`/`xhigh`; the author chose not to
> spend those tokens, so the AppliedModelingLib run in `lean/` was executed by
> Claude Code on the author's own clone, following the same workflow
> (`init-spec` → `new --statement-spec` → proofs → `lake build` →
> `check --fast`). The agent substitution is recorded in `lean/docs/RUN_LOG.md`
> and in `lean/status.json`.

---

## What question the paper answers

Modern AI does non-codifiable cognitive work and, unlike a human expert, can be
copied across compute. Who gains when such AI enters a knowledge economy in
which people organise into hierarchies of routine workers and problem solvers?
The answer separates two dimensions of the technology: **capability** (the
knowledge $z_{AI}$ of an AI agent) and **autonomy** (whether the agent can
pursue production opportunities on its own or only advise humans).

## The agent's problem

Knowledge $z \in [0,1]$ is distributed with a continuous positive density
$g$; a production opportunity carries a problem of difficulty $x \sim U[0,1]$
and yields one unit of output if the knowledge applied to it is at least $x$.
Firms have at most two layers. A one-layer firm uses one independent producer
(expected output $z$). A two-layer firm hires one solver of knowledge $s$ and
workers of knowledge $z \le s$; a worker who cannot solve her problem asks the
solver, at a communication cost $h \in (0,1)$ of the solver's time, so the
solver's time is exhausted by

$$n(z) = \frac{1}{h(1-z)} \quad\text{workers, and the team produces } n(z)\,s.$$

AI converts one unit of compute (rental rate $r$) into an agent of knowledge
$z_{AI} \in [0,1)$ that is a perfect substitute for a human with that knowledge.
Autonomous agents can be independent producers, workers or solvers;
non-autonomous agents (Section 6) can only be solvers. With $w(\cdot)$ the wage
schedule, the five profits are (v11, p. 12)

$$\Pi_1 = z - w(z) \ \text{or}\ z_{AI} - r,\qquad
\Pi_2^{tA}(z) = n(z)[z_{AI} - w(z)] - r,\qquad
\Pi_2^{bA}(s) = n(z_{AI})[s - r] - w(s),\qquad
\Pi_2^{nA}(s,z) = n(z)[s - w(z)] - w(s).$$

A competitive equilibrium is a compute allocation $(\mu_i,\mu_w,\mu_s)$, a
partition of humans into $(I, W_p, W_a, S_p, S_a)$, a matching $m: W_p \to S_p$
satisfying the time-clearing condition (1), wages $w$ and a rental rate $r$ such
that firms choose their structure optimally at zero profit and markets clear.
Compute is **abundant relative to human time** (some agents must produce
independently, footnote 14), and the main text takes $h < h_0$ so that there
are no independent producers before AI (p. 18). Because the equilibrium is
efficient (Propositions 1, 2, 6), it can be computed as the planner's linear
programme, which is what `analysis/knowledge_economy.py` does.

## The main result, with all its conditions

**Proposition 2 (prices, p. 19).** $r^* = z_{AI}$; humans assisted by an AI
solver earn $w^*(z) = z_{AI}(1 - 1/n(z))$; humans supervising AI workers earn
$w^*(z) = n(z_{AI})(z - z_{AI})$; and $w^*(z_{AI}) = z_{AI}$. AI is used as a
worker when $z_{AI} \in W$ (basic AI) and as a solver when $z_{AI} \in S$
(advanced AI).

**Proposition 5 (p. 24), autonomous AI.** Let $B = \{z \le z_{AI}: w^*(z) > w(z)\}$
and $T = \{z \ge z_{AI}: w^*(z) > w(z)\}$. *There are winners at the bottom if
AI is good enough:* $B \neq \emptyset$ **if and only if** $z_{AI} > \bar z_{AI}$,
with $\bar z_{AI} \in \operatorname{int} W$. *There are always winners at the
top:* $T \neq \emptyset$ for all $z_{AI} \in [0,1)$. The person with
$z = z_{AI}$ always loses.

**Proposition 6 (p. 27), non-autonomous AI.** $r^\star = 0$ (some compute is
idle). AI is used only if $z_{AI} > w(0)$, and then only by the least
knowledgeable. In any case: (1) output is strictly higher with autonomous AI;
(2) non-autonomous AI creates losers; (3) near $z = 0$,
$w^\star(z) \ge \max\{w(z), w^*(z)\}$, strictly if $z_{AI} > w(0)$; (4) near
$z = 1$, $w^\star(z) \le w^*(z)$.

Conditions the statements rest on, spelled out:

1. $g$ continuous and strictly positive on $[0,1]$; $x \sim U[0,1]$ is without
   loss (footnote 10).
2. $h \in (0,1)$ and **$h < h_0$** (no independent producers pre-AI); the
   "always winners at the top" part needs this and **$z_{AI} < 1$** — with a
   superintelligent AI the most knowledgeable lose (footnote 19).
3. **Compute abundant relative to time** (footnote 14) in both regimes, and the
   same compute in the autonomous and non-autonomous comparisons.
4. At most two layers; an AI agent is a perfect substitute for a human of
   knowledge $z_{AI}$ (autonomous case); all agents share one $z_{AI}$.
5. Free entry with zero profits; wages equal marginal products (First Welfare
   Theorem), which is why the LP duals are the equilibrium prices.

**The two dimensions, in one line.** Capability decides *whether* the bottom
gains (the thresholds $\bar z_{AI}$ in Proposition 5 and $w(0)$ in Proposition
6); autonomy decides *who gains more* and total output (Proposition 6). The
popular gloss "the distributional effect is driven by autonomy, not capability"
keeps the second half and drops the first.

## This week's trap

An LLM's one-liner for this paper is that autonomy, not capability, drives the
distribution. Against Propositions 5 and 6: the condition for winners at the
bottom is **about capability** in both regimes — $z_{AI} > \bar z_{AI}$ with
autonomous AI, $z_{AI} > w(0)$ with non-autonomous AI. What autonomy changes is
the size of the bottom's gain (all of $z_{AI}$ versus $z_{AI}(1 - 1/n(z))$), the
threshold (lower without autonomy, since $r^\star = 0$), the fate of the top
(always gains with autonomy, may lose without it) and output (higher with
autonomy). In the paper's own example ($G(z) = z$, $h = 1/2$; `analysis/`):
$\bar z_{AI} \approx 0.715 \in \operatorname{int} W = (0, 0.764)$, $w(0) = 0.358$,
no winners at the bottom at $z_{AI} = 0.425$ and winners at both ends at
$z_{AI} = 0.85$ (Figure 5 of the paper), and every item of Proposition 6.

## What is in this repository

| File | What it is |
|---|---|
| `README.md` | This page |
| `prompts.md` | Raw prompts and answers: the ChatGPT study session (14 turns) and the Claude Code session |
| `hand/hand-ide-talamas-2025.pdf` | Hand derivation (one long page): the firm problem, $n(z)$, the five profit functions, $r = z_{AI}$, the two AI wage formulas of Proposition 2, the compute accounting and the matching condition. `hand/*-part1..5.png` are crops of the same page for the deck |
| `presentation.tex` / `.pdf` | The 20-minute deck: paper and problem, main result with conditions, what I did, the Lean slides (equation → Spec → proof → interpretation, with the build/check result), where I did not believe the AI, backup figures one per slide |
| `lean/` | The AppliedModelingLib paper folder `papers/IT25KnowledgeEconomy/` exactly as generated by the run: statement spec pinned to v11, `PaperInterface.lean` with ten source-facing Specs, `ProofInterface.lean` with their proofs, `MainTheorems.lean` with the two-type extension, reports, DAG, audit stubs, `docs/RUN_LOG.md`, `docs/CHECK_FAST_OUTPUT.txt` |
| `analysis/` | `knowledge_economy.py`: the equilibrium as a linear programme with wages as duals; the paper's example, a $z_{AI}$ sweep for the two dimensions, the two- and three-type discrete versions; figures in `analysis/figures/`, numbers in `results.json` |
| `paper/README.md` | Pointers to the versions of the article (PDFs not committed) |

## The two-type discrete version (the case derived by hand)

Types $z_L < z_{AI} < z_H$, mass $\mu_L$ of L and $\mu_H$ of H, L abundant
relative to solver capacity ($\mu_L > n(z_L)\mu_H$), compute abundant.
Pre-AI: $w_L = z_L$ and $w_H = n(z_L)(z_H - z_L)$. Autonomous AI ($r = z_{AI}$):
the bottom type can work under an AI solver at $z_{AI}(1 - 1/n(z_L))
= z_{AI} - h(1-z_L)z_{AI}$, so it gains **iff**
$z_{AI} > z_L/(1 - h(1-z_L))$, a capability threshold strictly above $z_L$.
Non-autonomous AI ($r = 0$): the bottom keeps the whole team output,
$w^\star_L = z_{AI}$, so it gains **iff** $z_{AI} > z_L = w_L$, and by more
(the difference is the AI solver's share $h(1-z_L)z_{AI}$); the top's workers now
have the outside option $z_{AI}$, so $w^\star_H = n(z_L)(z_H - z_{AI}) < w_H$
until H prefers independence. These are the Proposition 5/6 mechanisms with two
types; `analysis/knowledge_economy.py` confirms them with the LP
($z_L = 0.3$, $z_H = 0.9$, $h = 1/2$: threshold $0.4615$ against $0.3$), and
`lean/MainTheorems.lean` proves the four inequalities.

## The Lean component in one paragraph

Ten source-facing statements of arXiv v11 were pinned in an AppliedModelingLib
statement spec, scaffolded with `paper_contribution.py new` and proved with no
`sorry`: the span of control $n(z)$ as the unique solution of $h\,n(1-z) = 1$,
$n > 1$ and strictly increasing on $[0,1)$; the three two-layer profit
identities of page 12; Proposition 2's prices — $r^* = z_{AI}$ from zero profit
in independent AI production, $w^*(z) = z_{AI}(1 - 1/n(z)) < z_{AI}$ for
AI-assisted workers and $w^*(s) = n(z_{AI})(s - z_{AI})$ for supervisors of AI
workers, both from zero profit; the claim that the person with $z = z_{AI}$
always loses; and, for non-autonomous AI, $w^\star(z) = z_{AI}$ from
$r^\star = 0$, the Proposition 6.3 comparison $w^\star - w^* = h(1-z)z_{AI} > 0$
with the pre-AI comparison holding exactly when $z_{AI} > w(z)$, and the
idle-compute form of Proposition 6.1. Status **partially formalized**: the
existence and uniqueness of equilibrium, the occupational partition (which
humans are in $W^*_a$, $S^*_a$, $W^\star_a$), the strict inequalities $> z$ of
Proposition 2 and the threshold $\bar z_{AI}$ of Proposition 5 are declared
boundaries, not Lean theorems; the numerics cover them. Build and check results
are in `lean/docs/CHECK_FAST_OUTPUT.txt`.
