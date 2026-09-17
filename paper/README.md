# The paper

**Ide, E., & Talamàs, E. (2025).** *Artificial Intelligence in the Knowledge Economy.*
Journal of Political Economy 133(12), 3762–3800. https://doi.org/10.1086/737233

The PDFs are not committed. Versions used in this repository:

| Version | Where | Pages | Used for |
|---|---|---|---|
| arXiv **v11**, 24 Feb 2025 (header date February 25, 2025), SHA-256 `0b3c727a204f7801a9598dacd7ca7fdb385e21ee6877992ea0eb13c0538d8ebf` | https://arxiv.org/abs/2312.05481v11 | 35 | The Lean run (`lean/`, pinned by SHA-256), the page numbers quoted in `lean/` and in the README |
| arXiv **v12**, 17 May 2025 (header date May 20, 2025) | https://arxiv.org/abs/2312.05481v12 | 39 | Same date and page count as the course PDF `papers/14-ide-talamas-2025-ai-knowledge-economy.pdf`; used to check that Propositions 1–6 carry the same numbers |
| JPE published version, 133(12) | https://doi.org/10.1086/737233 | 3762–3800 | The ChatGPT study session in `prompts.md` cites its pages (3775–3776) |

Note on the course issue: it calls v11 "the latest arXiv version"; arXiv lists a later
v12 (May 2025). Propositions 1–6 have the same numbers and statements in v11 and v12.

```bash
curl -L -o paper-v11.pdf https://arxiv.org/pdf/2312.05481v11
sha256sum paper-v11.pdf   # 0b3c727a204f7801a9598dacd7ca7fdb385e21ee6877992ea0eb13c0538d8ebf
```
