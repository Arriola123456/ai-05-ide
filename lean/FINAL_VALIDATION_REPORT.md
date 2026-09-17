# Final Validation Report: Ide and Talamàs (2025), Artificial Intelligence in the Knowledge Economy
Updated: 2026-09-16

## 1. Human Verdict
Partially formalized. The price and wage algebra of the model — Sections 3.1,
4 and 6 of arXiv v11 — is checked with closed Lean proofs: the span of control
$n(z) = 1/(h(1-z))$ as the unique solution of $h\,n(1-z) = 1$, with $n > 1$ and
strictly increasing; the three two-layer profit identities of page 12;
Proposition 2's prices ($r^* = z_{AI}$ from zero profit in independent AI
production, the AI-assisted worker's wage $z_{AI}(1 - 1/n(z)) < z_{AI}$ and the
AI-supervisor's wage $n(z_{AI})(s - z_{AI})$, both from zero profit); the claim
that the individual with knowledge $z_{AI}$ always loses; and, for
non-autonomous AI, the worker's wage $z_{AI}$ from $r^\star = 0$, the comparison
of Proposition 6.3 ($w^\star - w^* = h(1-z)z_{AI} > 0$, and $w^\star > w$ exactly
when $z_{AI} > w$) and the idle-compute form of Proposition 6.1. The paper does
not reach `formalized` for three reasons. The competitive equilibrium is not
modelled: existence, uniqueness, the occupational partition (which humans are
in $W^*_a$, $S^*_a$, $W^\star_a$), the strict inequalities $> z$ of Proposition
2 and the threshold $\bar z_{AI}$ of Proposition 5 are declared boundaries.
Propositions 1, 3, 4 and 5 are read-only. And the protocol's independent
semantic audits were not executed. The run was executed by Claude Code, not by
the Codex configuration named in the course issue.

## 2. Closeout Status
- Completion status: partially formalized
- One-sentence recap: ten of ten selected statements proved; the equilibrium
  partition and the distributional thresholds are declared boundaries; the
  two-type discrete extension is proved in `MainTheorems.lean`.

## 3. Source and Scope
- Paper: Artificial Intelligence in the Knowledge Economy (Enrique Ide, Eduard
  Talamàs), Journal of Political Economy 133(12), 2025.
- Source version: arXiv 2312.05481v11, 24 February 2025 (accepted manuscript),
  35 pp., SHA-256 `0b3c727a…8ebf`. arXiv v12 (17 May 2025, 39 pp.) is the
  course PDF; Propositions 1–6 have the same numbers and statements.
- Lean folder: `papers/IT25KnowledgeEconomy`
- Human-facing theorem file: `papers/IT25KnowledgeEconomy/PaperInterface.lean`
- Paper assumption file: `papers/IT25KnowledgeEconomy/Assumptions.lean`
  (empty: every premise is a visible binder)
- DAG artifacts: `papers/IT25KnowledgeEconomy/docs/DependencyDAG.tex`,
  `papers/IT25KnowledgeEconomy/docs/DependencyDAG.pdf`
- Lean footprint: four paper modules; `lake build IT25KnowledgeEconomy`
  completes with no errors.
- Scope: Section 3.1 (span of control, profits), Proposition 2's price and
  wage bullets, the "$z_{AI}$ always loses" claim of Section 5.2, Section 6.1's
  $r^\star = 0$ and Proposition 6 items 1 and 3 in algebraic form. Out of
  scope: Proposition 1 (pre-AI equilibrium), Propositions 3–5 (occupational
  choice, matching, winners at the bottom), the Online Appendix.

## 4. Researcher Summary of Checked Results
A two-layer firm's solver, with one unit of time and a communication cost
$h \in (0,1)$ per request, is fully occupied by $n(z)$ workers of knowledge
$z$ where $h\,n(z)(1-z) = 1$; Lean checks that $n(z) = 1/(h(1-z))$ is the only
solution, that $n(z) > 1$, and that $n$ is strictly increasing on $[0,1)$ (more
knowledgeable workers ask less often). The profits of the three two-layer
configurations are expected output minus resource cost; Lean checks the three
identities of page 12.

With autonomous AI and compute abundant relative to time, some agents produce
independently, and zero profit there pins $r^* = z_{AI}$. Given $r^* = z_{AI}$,
zero profit of a top-automated firm (humans of knowledge $z$ under an AI
solver) yields $w^*(z) = z_{AI}(1 - 1/n(z))$, which Lean also shows is strictly
below $z_{AI}$ (the AI solver keeps $z_{AI}/n(z)$ of each worker's output);
zero profit of a bottom-automated firm (AI workers under a human solver
$s$) yields $w^*(s) = n(z_{AI})(s - z_{AI})$. With $w^*(z_{AI}) = z_{AI}$
(Proposition 2) and $w(z_{AI}) > z_{AI}$ (Proposition 1, $h < h_0$), the person
with knowledge $z_{AI}$ loses from AI.

With non-autonomous AI the rental rate is $r^\star = 0$ (idle compute), so zero
profit of an AI-assisted firm leaves the whole team output to the human
workers, $w^\star(z) = z_{AI}$. For a worker assisted by AI in both regimes,
$w^\star - w^* = h(1-z)z_{AI} > 0$ and $w^\star > w \iff z_{AI} > w$, which at
$z = 0$ is Proposition 6's condition $z_{AI} > w(0)$. Output is higher with
autonomous AI because the compute left idle would have produced $z_{AI}$ per
unit.

The two-type extension (`MainTheorems.lean`): with types $z_L < z_{AI} < z_H$,
the bottom type gains under autonomous AI iff $z_{AI} > z_L/(1 - h(1-z_L))$, a
threshold strictly above $z_L$, and under non-autonomous AI iff $z_{AI} > z_L$;
the non-autonomous premium is $h(1-z_L)z_{AI}$; the top type's wage falls from
$n(z_L)(z_H - z_L)$ to $n(z_L)(z_H - z_{AI})$ under non-autonomy; output ranks
by idle compute.

## 5. Remaining Boundaries and Gaps
- The competitive equilibrium (Definition, page 13) is not modelled. Which
  humans belong to $W^*_a$, $S^*_a$ or $W^\star_a$, the matching $m$, and the
  existence and uniqueness statements of Propositions 1, 2 and 6 are declared
  boundaries.
- Proposition 2's "$> z$" for $z \in W^*_a$ and $z \in S^*_a$ is an
  equilibrium property (participation), not a consequence of zero profit
  alone; only the formulas and $w^* < z_{AI}$ are proved.
- Proposition 5's threshold $\bar z_{AI}$ and the sets $B$, $T$ are not
  formalized; the course repository's numerics locate $\bar z_{AI} \approx
  0.715$ for $G(z) = z$, $h = 1/2$.
- Proposition 6.3 is proved for a worker assisted by AI in both regimes; that
  the least knowledgeable are AI-assisted in both regimes near $z = 0$ (true
  when $z_{AI} \in \operatorname{int} S$ by Proposition 2, and when
  $z_{AI} > w(0)$ by Proposition 6) is a declared boundary.
- Proposition 6.1 is proved in accounting form (human output held fixed);
  the paper's statement compares two equilibria.
- The LLM/human semantic audit lanes were not run; `audit/` holds the
  scaffold stubs.
- Import deviation: `MainTheorems.lean` imports `Mathlib.Tactic`,
  `Mathlib.Data.Real.Basic` and `Mathlib.Order.Interval.Set.Defs` instead of
  the scaffold's `import Mathlib`, and the scaffold's statement-spec
  validation ran under those three imports instead of `import
  AppliedModelingLib`, because the library root was not built on this machine
  (`docs/RUN_LOG.md`). No library declaration is used.

## 6. Additional Assumptions Beyond Paper
None. Every hypothesis is a visible binder: $0 < h < 1$, $0 \le z < 1$,
$0 < z_{AI}$ (or $0 \le z_{AI} < 1$), and the zero-profit displays.

## 7. Proof-Strategy Deviations
The paper derives prices from equilibrium reasoning; the Lean rows take the
zero-profit displays as hypotheses and derive the price and wage formulas
algebraically (`field_simp`, `linarith`, `ring`). Proposition 6.3 is stated as
an identity plus an equivalence rather than as an existence statement in
$\varepsilon$.

## 8. Proof Tricks Worth Reusing
- `one_div_one_div` to rewrite $1/(1/n)$ back into $h(1-z)$ before `ring`.
- `field_simp at h` on a zero-profit display with a positive denominator,
  followed by `linarith`, isolates the wage in one step.
- `div_lt_iff₀` / `lt_div_iff₀` to move a positive denominator across a
  threshold inequality, then `nlinarith` with the bounds on $h$ and $z_L$.

## 9. Generalizations, Conjectures, and Extensions
- The two-type economy (Section 4 above) is the hand-derivable case the course
  issue asks for; its thresholds make the two dimensions of the paper's
  taxonomy explicit and are confirmed by the LP in the course repository.
- Conjecture (numerical, not formalized): in the continuum with $G(z) = z$
  the Proposition 5 threshold satisfies $\bar z_{AI} \approx 0.715$ for
  $h = 1/2$, well inside $\operatorname{int} W = (0, 3 - \sqrt5)$.

## 10. Mathematical Typos or Other Fixes Suggested in the Source Paper
None found in the rows formalized.

## 11. Paper Issues or Caveats
The formula $w^\star(z) = z_{AI}$ for humans assisted by non-autonomous AI is
implied by page 26 ($r^\star = 0$) and the zero-profit display of page 12 but
is not printed as such in v11.

## 12. Detailed Formalization Evidence
- `lake build IT25KnowledgeEconomy`: Build completed successfully (3302 jobs;
  the four paper modules compiled in 65 s, 10 s, 4.4 s and 4.8 s).
- `python3 scripts/paper_contribution.py check IT25KnowledgeEconomy --fast`:
  exit code 0 (`lake build +IT25KnowledgeEconomy.PaperInterface` and
  `git diff --check` passed); see `docs/CHECK_FAST_OUTPUT.txt`.
- No declaration in the paper folder uses `sorry`, `axiom` or `unsafe`.
- `Assumptions.lean` declares nothing.

## 13. Paper Assumption Provenance
| Assumption declaration | Lean declaration | Source location / statement | Assumption validators | Comments |
| --- | --- | --- | --- | --- |
| None | `none` | $h \in (0,1)$ (page 10), $z_{AI} \in [0,1)$ (page 11), compute abundant relative to time (page 13, footnote 14) enter as visible binders or as the zero-profit hypothesis | None | No axiom-like premise. |

## 14. Displayed Formula Provenance
| Paper formula / subclaim | Lean declaration | Provenance | Validators | Comments |
| --- | --- | --- | --- | --- |
| $h\,n(z)(1-z) = 1$, page 10 | `paper_span_of_controlSpec` | derived in Lean (`field_simp`) | Lean build | equivalence with $n = 1/(h(1-z))$ |
| Profits, page 12 | `paper_profit_identitiesSpec` | derived in Lean (`ring`) | Lean build | three identities |
| $r^* = z_{AI}$, page 19 | `paper_prop2_rental_rateSpec` | derived from zero profit | Lean build | abundant compute declared |
| $w^*(z) = z_{AI}(1 - 1/n(z))$, page 19 | `paper_prop2_ai_assisted_worker_wageSpec` | derived from zero profit | Lean build | "$> z$" is a boundary |
| $w^*(s) = n(z_{AI})(s - z_{AI})$, page 19 | `paper_prop2_ai_workers_solver_wageSpec` | derived from zero profit | Lean build | "$> z$" is a boundary |
| $w^\star(z) = z_{AI}$, page 26 | `paper_prop6_nonautonomous_worker_wageSpec` | derived from $r^\star = 0$ and zero profit | Lean build | not printed in v11 |

## 15. Library Lift Pass
- Reusable library extraction candidates: none; the rows are elementary real
  algebra.
- Library certificate/source-boundary audit: not run; no certificate-taking
  library API is used.
- Paper-local hidden-premise audit: not run; all premises are visible binders.

## 16. DAG Audit
- Rendered artifact: `docs/DependencyDAG.pdf` rendered from
  `docs/DependencyDAG.tex`.
- Topology: the model feeds the span of control and the profit identities;
  the profits with abundant compute feed $r^* = z_{AI}$; $r^*$ and $n(z)$
  feed the two Proposition 2 wage rows and the "$z_{AI}$ loses" claim; the
  profits with $r^\star = 0$ feed the non-autonomous wage; the two wage rows
  feed Proposition 6.3; $r^*$ feeds the idle-compute row; the equilibrium
  definition is a declared boundary feeding the read-only propositions.
- Layout: checked visually.

## 17. Validation Checks
- Targeted Lean build: passed.
- Statement precheck / assumption precheck / repository audit / LLM audits:
  not run (see Section 5).

## 18. Paper Definitions Checked
- Span of control $n(z)$ (page 10).
- Profits of the five firm configurations (page 12).
- Rental rate of compute and the wage schedule bullets of Proposition 2
  (page 19); $r^\star = 0$ (page 26).

## 19. Named Theorem Statements Checked
### Proposition 2 (prices and wages)
**Paper statement.** $r^* = z_{AI}$; $w^*(z) = z_{AI}(1 - 1/n(z)) > z$ on
$W^*_a$; $w^*(z) = n(z_{AI})(z - z_{AI}) > z$ on $S^*_a$; $w^*(z_{AI}) = z_{AI}$.

**Lean interface statement.**
- `paper_prop2_rental_rateSpec`, `paper_prop2_ai_assisted_worker_wageSpec`,
  `paper_prop2_ai_workers_solver_wageSpec`.

**Status.** formalized for the formulas (from zero profit); the strict
inequalities $> z$ are declared boundaries.

### Section 5.2 claim: $z_{AI}$ always loses
**Paper statement.** $w^*(z_{AI}) < w(z_{AI})$.

**Lean interface statement.** `paper_zAI_always_losesSpec`.

**Status.** formalized with the premises $w^*(z_{AI}) = z_{AI}$ and
$w(z_{AI}) > z_{AI}$ as binders.

### Proposition 6 (items 1 and 3; $r^\star = 0$)
**Paper statement.** $r^\star = 0$; output strictly higher with autonomous AI;
near $z = 0$, $w^\star \ge \max\{w, w^*\}$, strictly if $z_{AI} > w(0)$.

**Lean interface statement.**
- `paper_prop6_nonautonomous_worker_wageSpec`,
  `paper_prop6_bottom_prefers_nonautonomousSpec`,
  `paper_prop6_output_idle_computeSpec`.

**Status.** formalized in algebraic form for an AI-assisted worker; the
equilibrium partition near $z = 0$ and the two-equilibrium output comparison
are declared boundaries.

## 20. Paper-Facing Statement Validator Ledger
| Lean declaration | Source item | Status |
| --- | --- | --- |
| `paper_span_of_controlSpec` | span of control, page 10 | proved |
| `paper_span_of_control_increasingSpec` | span of control increasing, page 22 | proved |
| `paper_profit_identitiesSpec` | profits, page 12 | proved |
| `paper_prop2_rental_rateSpec` | Proposition 2, page 19 | proved |
| `paper_prop2_ai_assisted_worker_wageSpec` | Proposition 2, page 19 | proved |
| `paper_prop2_ai_workers_solver_wageSpec` | Proposition 2, page 19 | proved |
| `paper_zAI_always_losesSpec` | Section 5.2, page 24 | proved |
| `paper_prop6_nonautonomous_worker_wageSpec` | Section 6.1, page 26 | proved |
| `paper_prop6_bottom_prefers_nonautonomousSpec` | Proposition 6.3, page 27 | proved |
| `paper_prop6_output_idle_computeSpec` | Proposition 6.1, page 27 | proved |

## 21. Source-Coverage Audit Ledger
Not run. Named results of v11 not covered: Proposition 1 (pre-AI equilibrium),
Proposition 3 (occupational displacement), Proposition 4 (productivity and
span of control), Proposition 5 (winners at the bottom and at the top),
Proposition 6 items 2 and 4 and its occupational bullets.
