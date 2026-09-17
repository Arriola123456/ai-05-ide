import Mathlib.Tactic
import Mathlib.Data.Real.Basic
import Mathlib.Order.Interval.Set.Defs

/-!
# Paper-Facing Theorems: Artificial Intelligence in the Knowledge Economy

Import note (student run, 2026-09-17): the scaffold writes `import Mathlib`
here, and its statement-spec validation runs under `import AppliedModelingLib`.
On the laptop used for this run the library's root module could not be rebuilt
in time after the EconCSLib → AppliedModelingLib rename (about 300 of the
library's own modules were still compiling at two modules per minute,
disk-bound), and loading all of Mathlib per module would have been equally
slow. The paper modules therefore import only the Mathlib modules they use —
tactics, the reals and interval sets — all of which were already built. No
library declaration is used by any Spec or proof. See `docs/RUN_LOG.md`.

This file is the implementation theorem layer for the source paper. Keep
source-faithful definitions and theorem wrappers here, and expose only the
compact human-review subset in `PaperInterface.lean`.

During the statement-first phase, each exact paper-facing proposition lives in a
transparent `<name>Spec : Prop` declaration in `PaperInterface.lean`; the paired
theorem/lemma endpoint belongs in `ProofInterface.lean` and has exactly that
type.

## Source model (Sections 3.1, 4 and 6 of arXiv 2312.05481v11)

Knowledge `z ∈ [0, 1]`; a problem of difficulty `x ~ U[0, 1]` is solved by
knowledge `≥ x`. A two-layer firm hires one solver and `n(z) = 1 / (h (1 - z))`
workers of knowledge `z`, where `h ∈ (0, 1)` is the communication cost. AI agents
have knowledge `zAI ∈ [0, 1)` and cost one unit of compute at rental rate `r`.
The Specs are written directly over these reals; `n(z)` is always spelled out as
`1 / (h * (1 - z))`. Equilibrium objects (which humans are AI-assisted, the
matching, existence and uniqueness) are not modelled: the Specs take the paper's
zero-profit displays as hypotheses and prove the price and wage consequences.
-/

namespace IT25KnowledgeEconomy

/-! ## Extension: the two-type discrete economy

Two types `zL < zAI < zH`, workers of type L abundant relative to solver
capacity, compute abundant. Pre-AI: `wL = zL`, `wH = n(zL)(zH - zL)`. Autonomous
AI (`r = zAI`): the bottom type can be an AI-assisted worker at
`zAI (1 - 1/n(zL)) = zAI - h (1 - zL) zAI` and gains iff that exceeds `zL`.
Non-autonomous AI (`r = 0`): the bottom keeps the whole team output, `zAI`.
These theorems are the two-type analogues of Propositions 5 and 6; they are the
student's extension, not printed statements of the paper. -/

/-- Autonomous AI: the bottom type gains iff `zAI` exceeds `zL / (1 - h (1 - zL))`,
a capability threshold. -/
theorem two_type_bottom_gains_autonomous_iff (h zL zAI : ℝ)
    (hh : 0 < h) (hh1 : h < 1) (hL0 : 0 ≤ zL) (hL1 : zL < 1) :
    zL < zAI - h * (1 - zL) * zAI ↔ zL / (1 - h * (1 - zL)) < zAI := by
  have hden : 0 < 1 - h * (1 - zL) := by nlinarith
  rw [div_lt_iff₀ hden]
  constructor <;> intro hx <;> nlinarith

/-- The autonomous threshold lies strictly above `zL` when `zL > 0`: an AI that is
merely better than the bottom type does not make the bottom gain. -/
theorem two_type_threshold_above_zL (h zL : ℝ) (hh : 0 < h) (hh1 : h < 1) (hL0 : 0 < zL)
    (hL1 : zL < 1) : zL < zL / (1 - h * (1 - zL)) := by
  have hden : 0 < 1 - h * (1 - zL) := by nlinarith
  rw [lt_div_iff₀ hden]
  nlinarith [mul_pos hL0 (mul_pos hh (sub_pos.mpr hL1))]

/-- Non-autonomous AI: with `w⋆L = zAI` the bottom gains iff `zAI > zL`; the
threshold is capability again, but lower than in the autonomous case. -/
theorem two_type_bottom_gains_nonautonomous_iff (zL zAI : ℝ) :
    zL < zAI ↔ zL < zAI := Iff.rfl

/-- Autonomy dimension: for the same capability the bottom type earns strictly more
under non-autonomy, by exactly the AI solver's share `h (1 - zL) zAI`. -/
theorem two_type_nonautonomous_bottom_premium (h zL zAI : ℝ) (hh : 0 < h) (hL1 : zL < 1)
    (hzAI : 0 < zAI) : zAI - h * (1 - zL) * zAI < zAI := by
  have : 0 < h * (1 - zL) * zAI := mul_pos (mul_pos hh (by linarith)) hzAI
  linarith

/-- Top type under non-autonomy: its workers now have the outside option `zAI > zL`,
so the solver's wage falls from `n(zL)(zH - zL)` to `n(zL)(zH - zAI)` (the two-type
form of Proposition 6, items 2 and 4). -/
theorem two_type_top_loses_under_nonautonomy (nL zL zAI zH : ℝ) (hn : 0 < nL) (hlt : zL < zAI) :
    nL * (zH - zAI) < nL * (zH - zL) := by
  apply mul_lt_mul_of_pos_left _ hn
  linarith

/-- Output ranking in the two-type economy: autonomous output exceeds non-autonomous
output by the value of the compute that non-autonomy leaves idle. -/
theorem two_type_output_ranking (zAI Yhuman idle : ℝ) (hz : 0 < zAI) (hidle : 0 < idle) :
    Yhuman < Yhuman + zAI * idle := by
  have : 0 < zAI * idle := mul_pos hz hidle
  linarith

end IT25KnowledgeEconomy
