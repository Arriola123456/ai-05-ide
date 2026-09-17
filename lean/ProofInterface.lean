import IT25KnowledgeEconomy.PaperInterface

/-!
# Proof Interface: Artificial Intelligence in the Knowledge Economy

This file contains exact-type proof endpoints for the transparent propositions
in `PaperInterface.lean`. It is not a human semantic-review surface: one source
claim is reviewed once, against its expanded `...Spec : Prop` declaration.

Notation shared with the Specs: `h` is the communication cost, `z` a worker's
knowledge, `zAI` the AI agents' knowledge, `n(z)` is spelled out as
`1 / (h * (1 - z))`, `w` a wage, `r` the rental rate of compute.
-/

namespace IT25KnowledgeEconomy

/--
Lean proof endpoint for `paper_span_of_controlSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_span_of_control :
  paper_span_of_controlSpec := by
  intro h z n hh _ _ hz1
  have hh' : h ≠ 0 := hh.ne'
  have h1z : (1 - z) ≠ 0 := (sub_pos.mpr hz1).ne'
  constructor
  · intro heq
    have hprod : n * (h * (1 - z)) = 1 := by linear_combination heq
    exact eq_one_div_of_mul_eq_one_left hprod
  · intro hn
    rw [hn]
    field_simp

/--
Lean proof endpoint for `paper_span_of_control_increasingSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_span_of_control_increasing :
  paper_span_of_control_increasingSpec := by
  intro h hh hh1
  refine ⟨?_, ?_⟩
  · intro z hz0 hz1
    have hpos : 0 < h * (1 - z) := mul_pos hh (by linarith)
    have hlt : h * (1 - z) < 1 := by nlinarith
    rw [lt_div_iff₀ hpos]
    linarith
  · intro a ha b hb hab
    simp only
    have ha1 : 0 < h * (1 - a) := mul_pos hh (by linarith [ha.2])
    have hb1 : 0 < h * (1 - b) := mul_pos hh (by linarith [hb.2])
    apply one_div_lt_one_div_of_lt hb1
    nlinarith

/--
Lean proof endpoint for `paper_profit_identitiesSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_profit_identities :
  paper_profit_identitiesSpec := by
  intro n nAI zAI s z w r ws
  refine ⟨by ring, by ring, by ring⟩

/--
Lean proof endpoint for `paper_prop2_rental_rateSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop2_rental_rate :
  paper_prop2_rental_rateSpec := by
  intro zAI r h
  linarith

/--
Lean proof endpoint for `paper_prop2_ai_assisted_worker_wageSpec`.

The zero-profit display `n(z)[zAI - w] - r = 0` with `r = zAI` is cleared of
its denominator by `field_simp` (legitimate because `h (1 - z) ≠ 0`); `linarith`
then isolates `w`, and `ring` matches the paper's form `zAI (1 - 1/n(z))`.
-/
theorem paper_prop2_ai_assisted_worker_wage :
  paper_prop2_ai_assisted_worker_wageSpec := by
  intro h z zAI w hh hh1 hz0 hz1 hzAI hzero
  have hpos : 0 < h * (1 - z) := mul_pos hh (by linarith)
  have hn : 1 / (1 / (h * (1 - z))) = h * (1 - z) := by
    rw [one_div_one_div]
  have hw : w = zAI - h * (1 - z) * zAI := by
    have hh' : h ≠ 0 := hh.ne'
    have h1z : (1 - z) ≠ 0 := (sub_pos.mpr hz1).ne'
    field_simp at hzero
    linarith [hzero]
  refine ⟨?_, ?_⟩
  · rw [hn, hw]; ring
  · rw [hw]
    have : 0 < h * (1 - z) * zAI := mul_pos hpos hzAI
    linarith

/--
Lean proof endpoint for `paper_prop2_ai_workers_solver_wageSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop2_ai_workers_solver_wage :
  paper_prop2_ai_workers_solver_wageSpec := by
  intro h s zAI w _ _ _ _ hzero
  linarith

/--
Lean proof endpoint for `paper_zAI_always_losesSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_zAI_always_loses :
  paper_zAI_always_losesSpec := by
  intro zAI wpre wpost hpost hpre
  rw [hpost]; exact hpre

/--
Lean proof endpoint for `paper_prop6_nonautonomous_worker_wageSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop6_nonautonomous_worker_wage :
  paper_prop6_nonautonomous_worker_wageSpec := by
  intro h z zAI w hh hh1 hz0 hz1 hzero
  have hh' : h ≠ 0 := hh.ne'
  have h1z : (1 - z) ≠ 0 := (sub_pos.mpr hz1).ne'
  field_simp at hzero
  linarith

/--
Lean proof endpoint for `paper_prop6_bottom_prefers_nonautonomousSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop6_bottom_prefers_nonautonomous :
  paper_prop6_bottom_prefers_nonautonomousSpec := by
  intro h z zAI wpre hh hh1 hz0 hz1 hzAI
  have hpos : 0 < h * (1 - z) := mul_pos hh (by linarith)
  have hn : 1 / (1 / (h * (1 - z))) = h * (1 - z) := by rw [one_div_one_div]
  refine ⟨?_, ?_, ?_⟩
  · rw [hn]; ring
  · rw [hn]
    have : 0 < h * (1 - z) * zAI := mul_pos hpos hzAI
    nlinarith
  · constructor
    · intro hlt
      have hmax : max wpre zAI = zAI := max_eq_right hlt.le
      exact ⟨by rw [hmax]; exact hlt, hmax.symm⟩
    · rintro ⟨hlt, hmax⟩
      rw [← hmax] at hlt; exact hlt

/--
Lean proof endpoint for `paper_prop6_output_idle_computeSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_prop6_output_idle_compute :
  paper_prop6_output_idle_computeSpec := by
  intro zAI used total Yhuman hz hlt
  have : zAI * used < zAI * total := mul_lt_mul_of_pos_left hlt hz
  linarith

end IT25KnowledgeEconomy
