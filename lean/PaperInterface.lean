import IT25KnowledgeEconomy.MainTheorems
import IT25KnowledgeEconomy.Assumptions

/-!
# Human-Facing Paper Interface: Artificial Intelligence in the Knowledge Economy

This is the compact Lean file a human should read after formalization to check
whether the paper's definitions and named theorem statements were represented
correctly. Keep the row-level dashboard and LLM audit statements in this file
for every paper. Move implementation details, proof aliases, and bulky helper
lemmas behind imported modules such as `AuditInterface.lean`, but expose the
audited paper-facing statements directly here; do not use
`paper_interface.audit_surface_path`.

Rules for completing this file:

- Keep the paper's definitions/formatted objects first, in source order.
- Expose the actual paper formulas here; do not only point to generic library
  definitions or implementation witnesses.
- A material reusable `AppliedModelingLib` primitive may remain a reference here only
  after `audit/library_semantic_review.json` records its exact bounded library
  declaration and an explicit byte-pinned paper-source connection. The
  dashboard and human-review packet show and source-check that declaration
  before the dependent Spec; a library name, docstring, or glossary is not a
  semantic bridge. Do not add a duplicate paper claim merely to restate it.
- If a named theorem needs a hypothesis that is not derived from earlier Lean
  declarations, declare that hypothesis in `Assumptions.lean` and list it in
  `status.json` `review_surface.assumption_names`.
- Then state the named results directly, with assumptions visible in each
  theorem signature by referencing named paper assumptions imported from
  `Assumptions.lean`.
- In the statement-first phase, write every complete source-facing statement as
  a transparent `<name>Spec : Prop` here, exactly once. Put the paired
  theorem/lemma of that exact type in `ProofInterface.lean`; its temporary
  proof body may be `by sorry` only in a private draft. This separation keeps
  the human semantic surface free of thin wrapper declarations.
- Before drafting that Lean surface, independently inventory every material
  source atom from exact pinned source quote bytes. Do not infer source atoms
  from declaration, binder, field, function, or source-map names.
- Run raw-source-to-expanded-Spec statement matching plus Lean-emitted
  premise/conclusion claim-atom review on the skeleton. The semantic comparison uses
  only byte-pinned source quotes (and separately pinned source context) against
  the expanded transparent Spec; map summaries and proof wrappers are not
  semantic inputs. Then freeze each canonical Lean declaration-manifest digest.
- In the proof phase, replace the `ProofInterface.lean` `sorry` with a short
  proof that calls into `MainTheorems.lean` or lower proof files without
  changing the specification or theorem type. Any specification/type change
  invalidates the freeze and requires a fresh statement audit.
- At formalized closeout, complete the v11 realization receipt: Lean Meta checks
  the theorem has exactly the transparent Spec type; each source atom is bound
  to the elaborated Spec surface; closure traversal includes proof and instance
  arguments; and every material terminal has a source, approved correction or
  additional assumption, checked derivation, or version-pinned foundation
  disposition. No data, container, or identifier-based exemption is allowed.
- The transparent `...Spec` is the sole semantic-review target for its source
  claim. The paired theorem/lemma is a proof endpoint whose exact Spec type is
  verified by Lean Meta, not a duplicate source-to-Lean comparison row.
- Keep proof endpoints, exhaustive endpoint aliases, and proof-seam checks in
  `ProofInterface.lean`, implementation modules, or `ProofLedger.lean`, not
  here. Do not create new `PostPaperAudit.lean` or `AuditLedger.lean` files;
  those names are legacy.

## Named Results

Each entry has one semantic-review target (`Spec`) and one proof endpoint (the
paired theorem/lemma). The human dashboard and review packet present that pair
once rather than treating the two declarations as duplicate paper claims.

- `paper_span_of_controlSpec` -> `paper_span_of_control`: Span of control n(z) (Section 3.1, the pre-AI economy), Section 3.1, page 10, sentence after Figure 1's paragraph: 'a two-layer organization optimally hires exactly n(z) workers ... where n(z) satisfies h × n(z) × (1 − z) = 1'; h ∈ (0, 1) is introduced on the same page.
- `paper_span_of_control_increasingSpec` -> `paper_span_of_control_increasing`: Span of control exceeds one and is increasing in the workers' knowledge (Sections 3.1 and 5.1), Section 5.1, page 22, paragraph before Proposition 4: 'a solver's span of control is increasing in the knowledge of the workers with whom she is matched'; n(z) = 1/(h(1 − z)) from Section 3.1, page 10.
- `paper_profit_identitiesSpec` -> `paper_profit_identities`: Profit of the three two-layer organizations equals expected output minus resource cost (Section 3.1, Wages, Prices, and Profits), Section 3.1, page 12, displays Π2^tA(z) = n(z)[zAI − w(z)] − r, Π2^bA(s) = n(zAI)[s − r] − w(s), Π2^nA(s,z) = n(z)[s − w(z)] − w(s) and the sentence 'In all three cases, the profit of a firm is its expected output minus the cost of the resources it uses'.
- `paper_prop2_rental_rateSpec` -> `paper_prop2_rental_rate`: Proposition 2 (prices): the rental rate of compute equals zAI, Proposition 2, page 19: 'Finally, the rental rate of compute r∗ is equal to zAI'; the argument on page 19 ('because compute is abundant relative to time, some AI agents must engage in independent production') and the single-layer profit zAI − r on page 12 with zero profit.
- `paper_prop2_ai_assisted_worker_wageSpec` -> `paper_prop2_ai_assisted_worker_wage`: Proposition 2 (wages): humans working with an AI solver earn w∗(z) = zAI(1 − 1/n(z)), Proposition 2, page 19, first wage bullet: 'w∗(z) = zAI(1 − 1/n(z)) > z for all z ∈ W∗_a'; zero-profit condition of a tA firm from page 12 with r∗ = zAI.
- `paper_prop2_ai_workers_solver_wageSpec` -> `paper_prop2_ai_workers_solver_wage`: Proposition 2 (wages): humans supervising AI workers earn w∗(z) = n(zAI)(z − zAI), Proposition 2, page 19, last wage bullet: 'w∗(z) = n(zAI)(z − zAI) > z for all z ∈ S∗_a'; zero-profit condition of a bA firm from page 12 with r∗ = zAI.
- `paper_zAI_always_losesSpec` -> `paper_zAI_always_loses`: The individual with knowledge zAI always loses from AI (Section 5.2), Section 5.2, page 24: 'the individual with knowledge zAI always loses from AI, i.e., w∗(zAI) < w(zAI)'; premises: Proposition 2, page 19, 'w∗(zAI) = zAI', and Proposition 1, page 16, 'w(z) > z for all z ∈ [0, 1] when h < h0'.
- `paper_prop6_nonautonomous_worker_wageSpec` -> `paper_prop6_nonautonomous_worker_wage`: Non-autonomous AI: with r⋆ = 0 the human workers of an AI-assisted firm earn the whole team output, w⋆(z) = zAI (Section 6.1), Section 6.1, page 26: 'the equilibrium rental rate of compute is zero, r⋆ = 0. The reason is that some compute must remain idle'; Proposition 6, page 27: 'If zAI > w(0), then only the least knowledgeable individuals use AI as a solver'; zero-profit condition of a tA firm from page 12.
- `paper_prop6_bottom_prefers_nonautonomousSpec` -> `paper_prop6_bottom_prefers_nonautonomous`: Proposition 6, item 3: the least knowledgeable benefit more from non-autonomous AI than from no AI or autonomous AI, Proposition 6, page 27, item 3: '∃ ε > 0 such that, for all z ∈ [0, ε), w⋆(z) ≥ max{w(z), w∗(z)} (with strict inequality if zAI > w(0))'; wage formulas w⋆(z) = zAI (Section 6.1, page 26) and w∗(z) = zAI(1 − 1/n(z)) (Proposition 2, page 19).
- `paper_prop6_output_idle_computeSpec` -> `paper_prop6_output_idle_compute`: Proposition 6, item 1: overall output is strictly higher with autonomous than non-autonomous AI (idle-compute accounting), Proposition 6, page 27, item 1, and the explanation on page 27: 'total output with non-autonomous AI is strictly lower than with autonomous AI because non-autonomy imposes a binding constraint on compute use, leaving some of it idle'; output accounting on page 13 (term zAI µi).
-/

namespace IT25KnowledgeEconomy

/--
Span of control n(z) (Section 3.1, the pre-AI economy)

Paper statement: Communication is costly in that each request for help consumes h ∈ (0, 1) units of the solver's time, regardless of whether the solver knows the solution. Hence, a two-layer organization optimally hires exactly n(z) workers of knowledge z < 1 to fully exploit its solver's time, where n(z) satisfies h × n(z) × (1 − z) = 1.

Source location: Section 3.1, page 10, sentence after Figure 1's paragraph: 'a two-layer organization optimally hires exactly n(z) workers ... where n(z) satisfies h × n(z) × (1 − z) = 1'; h ∈ (0, 1) is introduced on the same page
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_span_of_controlSpec : Prop :=
  ∀ h z n : ℝ, 0 < h → h < 1 → 0 ≤ z → z < 1 →
    (h * n * (1 - z) = 1 ↔ n = 1 / (h * (1 - z)))

/--
Span of control exceeds one and is increasing in the workers' knowledge (Sections 3.1 and 5.1)

Paper statement: Similarly, a solver's span of control is equal to the number of workers (human or AI) under her supervision. Hence, a solver's span of control is increasing in the knowledge of the workers with whom she is matched. [With n(z) = 1/(h(1 − z)), h ∈ (0, 1) and z ∈ [0, 1): n(z) > 1 and n is strictly increasing.]

Source location: Section 5.1, page 22, paragraph before Proposition 4: 'a solver's span of control is increasing in the knowledge of the workers with whom she is matched'; n(z) = 1/(h(1 − z)) from Section 3.1, page 10
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_span_of_control_increasingSpec : Prop :=
  ∀ h : ℝ, 0 < h → h < 1 →
    (∀ z : ℝ, 0 ≤ z → z < 1 → 1 < 1 / (h * (1 - z))) ∧
    StrictMonoOn (fun z : ℝ => 1 / (h * (1 - z))) (Set.Ico 0 1)

/--
Profit of the three two-layer organizations equals expected output minus resource cost (Section 3.1, Wages, Prices, and Profits)

Paper statement: Π2^tA(z) = n(z)[zAI − w(z)] − r (where z ≤ zAI); Π2^bA(s) = n(zAI)[s − r] − w(s) (where zAI ≤ s); Π2^nA(s, z) = n(z)[s − w(z)] − w(s) (where z ≤ s). In all three cases, the profit of a firm is its expected output minus the cost of the resources it uses. For instance, in the case of a tA firm that hires workers with knowledge z, its total expected output is n(z)zAI, while the cost of resources is n(z)w(z) + r.

Source location: Section 3.1, page 12, displays Π2^tA(z) = n(z)[zAI − w(z)] − r, Π2^bA(s) = n(zAI)[s − r] − w(s), Π2^nA(s,z) = n(z)[s − w(z)] − w(s) and the sentence 'In all three cases, the profit of a firm is its expected output minus the cost of the resources it uses'
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_profit_identitiesSpec : Prop :=
  ∀ n nAI zAI s z w r ws : ℝ,
    n * (zAI - w) - r = n * zAI - (n * w + r) ∧
    nAI * (s - r) - ws = nAI * s - (nAI * r + ws) ∧
    n * (s - w) - ws = n * s - (n * w + ws)

/--
Proposition 2 (prices): the rental rate of compute equals zAI

Paper statement: Finally, the rental rate of compute r∗ is equal to zAI. [Reason given on page 19: because compute is abundant relative to time, some AI agents must engage in independent production; the profit of a single-layer firm using an AI agent is zAI − r (page 12), which is zero in a competitive equilibrium.]

Source location: Proposition 2, page 19: 'Finally, the rental rate of compute r∗ is equal to zAI'; the argument on page 19 ('because compute is abundant relative to time, some AI agents must engage in independent production') and the single-layer profit zAI − r on page 12 with zero profit
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop2_rental_rateSpec : Prop :=
  ∀ zAI r : ℝ, zAI - r = 0 → r = zAI

/--
Proposition 2 (wages): humans working with an AI solver earn w∗(z) = zAI(1 − 1/n(z))

Paper statement: w∗(z) = zAI(1 − 1/n(z)) > z for all z ∈ W∗_a. [Formalized as: the zero-profit condition n(z)[zAI − w] − r = 0 with r = zAI and n(z) = 1/(h(1 − z)) yields w = zAI(1 − 1/n(z)), and this wage is strictly below zAI. The strict inequality w∗(z) > z on W∗_a is an equilibrium property (which humans belong to W∗_a) and is a declared boundary.]

Source location: Proposition 2, page 19, first wage bullet: 'w∗(z) = zAI(1 − 1/n(z)) > z for all z ∈ W∗_a'; zero-profit condition of a tA firm from page 12 with r∗ = zAI
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop2_ai_assisted_worker_wageSpec : Prop :=
  ∀ h z zAI w : ℝ, 0 < h → h < 1 → 0 ≤ z → z < 1 → 0 < zAI →
    (1 / (h * (1 - z))) * (zAI - w) - zAI = 0 →
      w = zAI * (1 - 1 / (1 / (h * (1 - z)))) ∧ w < zAI

/--
Proposition 2 (wages): humans supervising AI workers earn w∗(z) = n(zAI)(z − zAI)

Paper statement: w∗(z) = n(zAI)(z − zAI) > z for all z ∈ S∗_a. [Formalized as: the zero-profit condition n(zAI)[s − r] − w = 0 with r = zAI yields w = n(zAI)(s − zAI). The strict inequality > z on S∗_a is an equilibrium property and a declared boundary.]

Source location: Proposition 2, page 19, last wage bullet: 'w∗(z) = n(zAI)(z − zAI) > z for all z ∈ S∗_a'; zero-profit condition of a bA firm from page 12 with r∗ = zAI
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop2_ai_workers_solver_wageSpec : Prop :=
  ∀ h s zAI w : ℝ, 0 < h → h < 1 → 0 ≤ zAI → zAI < 1 →
    (1 / (h * (1 - zAI))) * (s - zAI) - w = 0 →
      w = (1 / (h * (1 - zAI))) * (s - zAI)

/--
The individual with knowledge zAI always loses from AI (Section 5.2)

Paper statement: To begin, note that the individual with knowledge zAI always loses from AI, i.e., w∗(zAI) < w(zAI). [Premises as stated in the paper: In particular, w∗(sup W∗) = sup W∗_p, w∗(zAI) = zAI (Proposition 2); w(z) > z for all z ∉ cl I (so w(z) > z for all z ∈ [0, 1] when h < h0) (Proposition 1).]

Source location: Section 5.2, page 24: 'the individual with knowledge zAI always loses from AI, i.e., w∗(zAI) < w(zAI)'; premises: Proposition 2, page 19, 'w∗(zAI) = zAI', and Proposition 1, page 16, 'w(z) > z for all z ∈ [0, 1] when h < h0'
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_zAI_always_losesSpec : Prop :=
  ∀ zAI wpre wpost : ℝ, wpost = zAI → zAI < wpre → wpost < wpre

/--
Non-autonomous AI: with r⋆ = 0 the human workers of an AI-assisted firm earn the whole team output, w⋆(z) = zAI (Section 6.1)

Paper statement: Since compute is abundant relative to time and AI is non-autonomous, the equilibrium rental rate of compute is zero, r⋆ = 0. [Combined with the zero-profit condition of a firm that uses AI as a solver, n(z)[zAI − w(z)] − r = 0 (page 12), this gives w⋆(z) = zAI for every human worker assisted by non-autonomous AI. The formula is derived from the paper's displays; it is not printed as such in v11.]

Source location: Section 6.1, page 26: 'the equilibrium rental rate of compute is zero, r⋆ = 0. The reason is that some compute must remain idle'; Proposition 6, page 27: 'If zAI > w(0), then only the least knowledgeable individuals use AI as a solver'; zero-profit condition of a tA firm from page 12
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop6_nonautonomous_worker_wageSpec : Prop :=
  ∀ h z zAI w : ℝ, 0 < h → h < 1 → 0 ≤ z → z < 1 →
    (1 / (h * (1 - z))) * (zAI - w) - 0 = 0 → w = zAI

/--
Proposition 6, item 3: the least knowledgeable benefit more from non-autonomous AI than from no AI or autonomous AI

Paper statement: The least knowledgeable benefit more from non-autonomous AI than from no AI or autonomous AI: ∃ ε > 0 such that, for all z ∈ [0, ε), w⋆(z) ≥ max{w(z), w∗(z)} (with strict inequality if zAI > w(0)). [Formalized for a worker assisted by AI in both regimes: w⋆(z) − w∗(z) = zAI/n(z) = h(1 − z)zAI > 0, and w⋆(z) = zAI exceeds the pre-AI wage exactly when zAI > w(z). That the least knowledgeable are AI-assisted in both regimes near z = 0 is an equilibrium property and a declared boundary.]

Source location: Proposition 6, page 27, item 3: '∃ ε > 0 such that, for all z ∈ [0, ε), w⋆(z) ≥ max{w(z), w∗(z)} (with strict inequality if zAI > w(0))'; wage formulas w⋆(z) = zAI (Section 6.1, page 26) and w∗(z) = zAI(1 − 1/n(z)) (Proposition 2, page 19)
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop6_bottom_prefers_nonautonomousSpec : Prop :=
  ∀ h z zAI wpre : ℝ, 0 < h → h < 1 → 0 ≤ z → z < 1 → 0 < zAI →
    zAI - zAI * (1 - 1 / (1 / (h * (1 - z)))) = h * (1 - z) * zAI ∧
    zAI * (1 - 1 / (1 / (h * (1 - z)))) < zAI ∧
    (wpre < zAI ↔ wpre < max wpre zAI ∧ zAI = max wpre zAI)

/--
Proposition 6, item 1: overall output is strictly higher with autonomous than non-autonomous AI (idle-compute accounting)

Paper statement: Overall output is strictly higher with autonomous than non-autonomous AI. [Explanation given on page 27: non-autonomy imposes a binding constraint on compute use, leaving some of it idle. Formalized in the accounting form: with human output Yhuman fixed, compute used in independent production at zAI per unit, strictly less compute used under non-autonomy gives strictly less output.]

Source location: Proposition 6, page 27, item 1, and the explanation on page 27: 'total output with non-autonomous AI is strictly lower than with autonomous AI because non-autonomy imposes a binding constraint on compute use, leaving some of it idle'; output accounting on page 13 (term zAI µi)
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_prop6_output_idle_computeSpec : Prop :=
  ∀ zAI used total Yhuman : ℝ, 0 < zAI → used < total →
    Yhuman + zAI * used < Yhuman + zAI * total

end IT25KnowledgeEconomy
