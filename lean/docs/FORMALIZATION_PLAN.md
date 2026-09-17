# Formalization Plan: Artificial Intelligence in the Knowledge Economy

This is a working scratchpad for outside-Lean proof thinking. Keep it short and
useful; it is not the final validation report.

- Namespace: `IT25KnowledgeEconomy`

## Initial Outside-Lean Paper Audit

- Source version / local files inspected: arXiv 2312.05481v11 (24 February
  2025, 35 pp., SHA-256 `0b3c727a…8ebf`), read in full for Sections 3.1, 3.3,
  4, 5.2 and 6; compared with arXiv v12 (17 May 2025, 39 pp., the course PDF).
- Source/version mismatch notes: the course issue calls v11 "the latest arXiv
  version"; v12 exists. Propositions 1–6 have the same numbers and statements
  in both; page numbers differ. The student's ChatGPT session cites the JPE
  pagination (3775–3776).
- Complete named-result ledger status: Propositions 1–6; Definition of
  competitive equilibrium (page 13); displays for $n(z)$ (page 10), the five
  profits (page 12), total output (page 13), the wage bullets of Propositions
  1 and 2, $r^\star = 0$ (page 26). Ten targets selected: $n(z)$ (×2), the
  profit identities, Proposition 2's three price/wage bullets, the "$z_{AI}$
  always loses" claim, the non-autonomous wage, Proposition 6.3 and 6.1.
- Formula sanity check:
  - Signs, constants, normalizations, quantifiers, domains: $h \in (0,1)$
    makes $n(z) = 1/(h(1-z)) > 1$ on $[0,1)$; $z_{AI} < 1$ keeps $n(z_{AI})$
    finite; $r^* = z_{AI}$ needs $\mu_i > 0$ (abundant compute, footnote 14).
    Checked numerically with the planner's LP in the course repository:
    duals reproduce Proposition 1's closed forms for $G(z) = z$, $h = 1/2$
    ($w(1) = 1.578$, $w(0) = 0.357$).
  - Density vs mass / likelihood-kernel representation issues: none in the
    selected rows (the equilibrium integrals are out of scope).
  - Dependency map between named source results: model → $n(z)$, profits →
    (abundant compute) $r^* = z_{AI}$ → Proposition 2 wages → "$z_{AI}$ loses"
    (with Proposition 1's $w(z) > z$); profits with $r^\star = 0$ →
    non-autonomous wage → Proposition 6.3; $r^*$ → Proposition 6.1 accounting.
  - Formula-bearing displayed claims that need derivation, not source-row
    assumptions: $n(z)$ as the unique solution; the two Proposition 2 wage
    formulas from zero profit; $w^\star = z_{AI}$.
- Named result sanity check:
  - Results that look correct as stated: all selected rows.
  - Suspected bugs, missing assumptions, or ambiguous wording: Proposition
    2's "$> z$" on $W^*_a$ and $S^*_a$ is not an algebraic consequence of the
    zero-profit displays; it is the participation of those humans in
    equilibrium. Kept as a declared boundary. Proposition 6's wage of
    AI-assisted humans ($z_{AI}$) is implied but not printed in v11.
- Formalization risks: modelling the equilibrium (measurable partitions,
  the matching function, the resource constraint (1)) is out of reach in
  the time available; the rows are stated over the primitives with the
  zero-profit displays as hypotheses.

## Statement-First Setup

- Ten transparent Specs over reals `h z zAI w r s n nAI ws wpre used total
  Yhuman`, with `n(z)` spelled out as `1 / (h * (1 - z))`.
- `Assumptions.lean` empty; every premise is a binder.
- Proof tactics: `field_simp`, `linarith`, `nlinarith`, `ring`,
  `one_div_one_div`, `one_div_lt_one_div_of_lt`, `lt_div_iff₀`, `div_lt_iff₀`,
  `max_eq_right`, `mul_lt_mul_of_pos_left`.

## Next Proof Obligations

- Model the two-type economy's equilibrium (a finite LP) in Lean and derive
  the pre-AI wages $w_L = z_L$, $w_H = n(z_L)(z_H - z_L)$ rather than taking
  them as given.
- State Proposition 6.3 with the existential $\varepsilon$ once the partition
  near $z = 0$ is available.
- Run the statement precheck and the LLM audit lanes.
