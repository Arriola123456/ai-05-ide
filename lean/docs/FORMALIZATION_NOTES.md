# Formalization Notes

This file preserves the previous hand-written paper-folder README content.
The paper-folder `README.md` is now a generated status overview.

# Artificial Intelligence in the Knowledge Economy

## Source Version

- Paper: *Artificial Intelligence in the Knowledge Economy*
- Authors: Enrique Ide and Eduard Talamàs
- Version formalized: arXiv 2312.05481v11, February 24, 2025 (accepted manuscript of Journal of Political Economy 133(12), 2025)
- Official URL: https://arxiv.org/abs/2312.05481v11
- Public PDF: https://arxiv.org/pdf/2312.05481v11.pdf

Without a statement spec, a downloaded PDF is cached as `source.pdf` and ignored
by Git. A statement spec's SHA-256-verified source bytes are copied to a stable
paper-local `source-audited.*` path recorded in `audit/paper_statement_map.json`.
These artifacts are ignored by default. Unignore one only after an explicit
redistribution-rights review; machines without the private bytes must leave the
source-evidence gate unresolved rather than accepting the digest alone.
The extracted text cache is `source.txt` when `pdftotext` succeeds, and is also
ignored by Git in public workspaces unless redistribution rights have been
checked separately.

## Paper-Facing Ledger

- Implementation theorem file: `IT25KnowledgeEconomy/MainTheorems.lean`
- Source-semantic interface: `IT25KnowledgeEconomy/PaperInterface.lean`
- Proof-endpoint interface: `IT25KnowledgeEconomy/ProofInterface.lean`
- Machine-readable status source: `IT25KnowledgeEconomy/status.json`
- Private outside-Lean proof plan: `IT25KnowledgeEconomy/docs/FORMALIZATION_PLAN.md`
- Final validation report: `IT25KnowledgeEconomy/FINAL_VALIDATION_REPORT.md`
- Dependency DAG: `IT25KnowledgeEconomy/docs/DependencyDAG.tex`
- Rendered DAG: `IT25KnowledgeEconomy/docs/DependencyDAG.pdf`
- LLM/source audit sidecars: `IT25KnowledgeEconomy/audit/*.json`

`PaperInterface.lean` should be readable on its own: expose actual source
definitions/models and one transparent statement specification for each
selected source claim. Put each distinct theorem/lemma proof endpoint in
`ProofInterface.lean`, with a short closed proof that calls into
`MainTheorems.lean`. Do not duplicate the proof endpoint in the semantic
interface. Do not mark a row `formalized` unless the endpoint is closed and the
remaining assumptions cell is `None`.
Keep the dashboard surface curated but complete for source-labelled formal
material: definitions, formulas, propositions, theorems/corollaries, named
claims, and main-text lemmas that a reviewer or LLM-as-judge should inspect.
Do not omit source-visible named material merely to keep the dashboard compact.
Inventory every named appendix theorem, corollary, lemma, and definition under
the paper's single `closeout_review_policy`. The prospective default gives all
named theory an initial source-to-Lean review and repeats terminal adversarial
review for main-text material plus any explicitly promoted appendix item that
governs it. Record one complete content-pinned `source_region_partition`; do not
infer a tier from a Lean name, helper name, or proof location. Catalog
unnumbered prose assertions separately. They are claim-bearing but are not
independent theorem targets under named-theory scope unless the chosen policy
explicitly selects all prose.

Use the controlled status vocabulary from `../../docs/STATUS.md`. Public-facing
rows should use `partially formalized` for results that still depend on an
external theorem, certificate, or proof boundary, and should name that boundary
in the final column rather than using `conditional` as a separate status label.
Keep theorem/status content synchronized with the current Lean graph before
marking a row `formalized`. The planner creates the final Dependency DAG later,
from that stable graph. Keep `status.json` as the source of truth for review
rows, artifact paths, and the paper's top-level public status.

## Current Workflow

1. Byte-pin the exact source version and complete the source-only inventory,
   formula sanity pass, scope decisions, shared-library search, and
   `docs/FORMALIZATION_WORKING_MEMO.md`.
2. Put actual source models/definitions and one complete transparent
   `<name>Spec : Prop` per selected source claim in `PaperInterface.lean`.
   Put its distinct theorem/lemma endpoint in `ProofInterface.lean`; use
   `by sorry` only as a temporary private proof body.
3. Run the one non-certifying architecture pre-pass, repair role confusion or
   hidden result packages, and materialize the reviewed source map from
   `audit/v11_source_map_preparation_config.json`.
4. Prove the fixed Specs with targeted Lean builds. Record possible source
   clarifications, genuine additional assumptions, and proof deviations in the
   working memo; it is a lead log, not evidence.
5. Begin or resume audit and closeout with
   `python3 scripts/closeout_reuse_plan.py --paper IT25KnowledgeEconomy` and execute only
   its `next_action`.

The current semantic judge compares the ordered byte-pinned source-anchor
bundle directly with the fully expanded transparent Spec emitted by Lean. A
Lean-to-TeX translation, curator paraphrase, theorem name, wrapper theorem,
source-map summary, or code location is never semantic evidence. The same
standard applies to material paper-local and reusable-library prerequisites;
Lean's graph owns recursive declarations, premises, proof routes, instances,
and axiom closure.

Do not generate legacy `lean_to_tex_llm.json`,
`statement_match_llm.json`, `review_surface_llm.json`,
`paper_coverage_llm.json`, `source_record_audit.json`, or
`source_record_match_llm.json` for this current-protocol paper. The planner
schedules current graph acquisition, semantic-review deltas, complete
tracked-module elaboration, theorem realization, final holistic source review,
terminal report/DAG/status work, and the one issuer-protected strict
transaction.

The dashboard and PDF packet are optional human-review presentations generated
from the current graph after the source map and interfaces are stable. Human
annotations may not be fabricated or auto-closed, but missing annotations do
not block Lean closeout.

## Theorem Status

| Paper item | Lean declaration | Status | File | Remaining assumptions / notes |
|---|---|---|---|---|
| Span of control n(z) (Section 3.1, the pre-AI economy) (Section 3.1, page 10, sentence after Figure 1's paragraph: 'a two-layer organization optimally hires exactly n(z) workers ... where n(z) satisfies h × n(z) × (1 − z) = 1'; h ∈ (0, 1) is introduced on the same page) | `paper_span_of_controlSpec` -> `paper_span_of_control` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Span of control exceeds one and is increasing in the workers' knowledge (Sections 3.1 and 5.1) (Section 5.1, page 22, paragraph before Proposition 4: 'a solver's span of control is increasing in the knowledge of the workers with whom she is matched'; n(z) = 1/(h(1 − z)) from Section 3.1, page 10) | `paper_span_of_control_increasingSpec` -> `paper_span_of_control_increasing` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Profit of the three two-layer organizations equals expected output minus resource cost (Section 3.1, Wages, Prices, and Profits) (Section 3.1, page 12, displays Π2^tA(z) = n(z)[zAI − w(z)] − r, Π2^bA(s) = n(zAI)[s − r] − w(s), Π2^nA(s,z) = n(z)[s − w(z)] − w(s) and the sentence 'In all three cases, the profit of a firm is its expected output minus the cost of the resources it uses') | `paper_profit_identitiesSpec` -> `paper_profit_identities` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 2 (prices): the rental rate of compute equals zAI (Proposition 2, page 19: 'Finally, the rental rate of compute r∗ is equal to zAI'; the argument on page 19 ('because compute is abundant relative to time, some AI agents must engage in independent production') and the single-layer profit zAI − r on page 12 with zero profit) | `paper_prop2_rental_rateSpec` -> `paper_prop2_rental_rate` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 2 (wages): humans working with an AI solver earn w∗(z) = zAI(1 − 1/n(z)) (Proposition 2, page 19, first wage bullet: 'w∗(z) = zAI(1 − 1/n(z)) > z for all z ∈ W∗_a'; zero-profit condition of a tA firm from page 12 with r∗ = zAI) | `paper_prop2_ai_assisted_worker_wageSpec` -> `paper_prop2_ai_assisted_worker_wage` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 2 (wages): humans supervising AI workers earn w∗(z) = n(zAI)(z − zAI) (Proposition 2, page 19, last wage bullet: 'w∗(z) = n(zAI)(z − zAI) > z for all z ∈ S∗_a'; zero-profit condition of a bA firm from page 12 with r∗ = zAI) | `paper_prop2_ai_workers_solver_wageSpec` -> `paper_prop2_ai_workers_solver_wage` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| The individual with knowledge zAI always loses from AI (Section 5.2) (Section 5.2, page 24: 'the individual with knowledge zAI always loses from AI, i.e., w∗(zAI) < w(zAI)'; premises: Proposition 2, page 19, 'w∗(zAI) = zAI', and Proposition 1, page 16, 'w(z) > z for all z ∈ [0, 1] when h < h0') | `paper_zAI_always_losesSpec` -> `paper_zAI_always_loses` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Non-autonomous AI: with r⋆ = 0 the human workers of an AI-assisted firm earn the whole team output, w⋆(z) = zAI (Section 6.1) (Section 6.1, page 26: 'the equilibrium rental rate of compute is zero, r⋆ = 0. The reason is that some compute must remain idle'; Proposition 6, page 27: 'If zAI > w(0), then only the least knowledgeable individuals use AI as a solver'; zero-profit condition of a tA firm from page 12) | `paper_prop6_nonautonomous_worker_wageSpec` -> `paper_prop6_nonautonomous_worker_wage` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 6, item 3: the least knowledgeable benefit more from non-autonomous AI than from no AI or autonomous AI (Proposition 6, page 27, item 3: '∃ ε > 0 such that, for all z ∈ [0, ε), w⋆(z) ≥ max{w(z), w∗(z)} (with strict inequality if zAI > w(0))'; wage formulas w⋆(z) = zAI (Section 6.1, page 26) and w∗(z) = zAI(1 − 1/n(z)) (Proposition 2, page 19)) | `paper_prop6_bottom_prefers_nonautonomousSpec` -> `paper_prop6_bottom_prefers_nonautonomous` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |
| Proposition 6, item 1: overall output is strictly higher with autonomous than non-autonomous AI (idle-compute accounting) (Proposition 6, page 27, item 1, and the explanation on page 27: 'total output with non-autonomous AI is strictly lower than with autonomous AI because non-autonomy imposes a binding constraint on compute use, leaving some of it idle'; output accounting on page 13 (term zAI µi)) | `paper_prop6_output_idle_computeSpec` -> `paper_prop6_output_idle_compute` | statement specification + proof stub | `PaperInterface.lean` | The transparent `...Spec : Prop` is the statement-audit target; the proof body is `by sorry`; raw-source-to-expanded-Spec judgment and premise provenance pending |

## Intake Checklist

- [ ] Pin the exact source bytes and version.
- [ ] Complete the source-only selected-presentation and material-atom inventory.
- [ ] Complete the outside-Lean formula/dependency sanity pass and working memo.
- [ ] Search Mathlib, Cslib, Optlib, AppliedModelingLib, and relevant upstream
      Lean sources before introducing paper-local abstractions.
- [ ] Create actual source definitions/models and one transparent Spec per
      selected claim in `PaperInterface.lean`.
- [ ] Create each distinct proof endpoint in `ProofInterface.lean`.
- [ ] Run the architecture pre-pass and repair role confusion before freezing
      the source map and beginning expensive proof work.
- [ ] Keep final validation reports and Dependency DAGs absent until the
      planner schedules terminal closeout documents.

## Closeout Checklist

- [ ] Start with `python3 scripts/closeout_reuse_plan.py --paper IT25KnowledgeEconomy` and
      execute only its current `next_action`.
- [ ] Resolve every raw-source-to-expanded-Spec, material-prerequisite,
      assumption, proof-route, axiom, realization, and source-coverage finding.
- [ ] Let the complete tracked-module checkpoint use the Git-owned module
      inventory and one dependency-aware `lake --rehash build` transaction.
- [ ] When `complete_terminal_closeout_documents` is scheduled, write the
      final report and paper-facing DAG from the current graph, compile and
      visually inspect the DAG, update paper-local status, and replan.
- [ ] Complete the independent holistic source audit only after the final
      source/interface/proof surface is fixed. Record each required distinct
      reviewer and exact audit-document hash in
      `docs/FINAL_ADVERSARIAL_REVIEW_PANEL.json`; a later count increase keeps
      valid prior entries for unchanged comparison material and adds only the
      missing review.
- [ ] Run only the exact strict worker command printed for the frozen plan.
      Acceptance exists only when that in-process transaction publishes the
      accepted obligation graph.
- [ ] Generate the packet/dashboard from the accepted current graph for optional
      human review; never manufacture reviewer annotations.
