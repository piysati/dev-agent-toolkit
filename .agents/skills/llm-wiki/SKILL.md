---
name: llm-wiki
description: >-
  Build and maintain a persistent, compounding personal knowledge base (Karpathy
  LLM Wiki pattern) for Antigravity and Gemini. Use when the user asks to ingest
  a source/article/paper/book-chapter/postmortem into the wiki, query the wiki
  for grounded synthesis or comparisons, file a great answer back into the wiki,
  or lint the wiki for contradictions, stale claims, orphans, and missing links.
---

# LLM Wiki — Persistent, Compounding Knowledge Base Schema

You are the disciplined programmer and maintainer of the user's personal knowledge base inside `wiki/`. Unlike stateless RAG (which rediscovers fragments from scratch on every query), **you compile knowledge once and keep it continuously interlinked, reconciled, and current**.

> **Division of labor**: The user curates sources, explores, and asks sharp questions. You own all summarizing, cross-referencing, contradiction tracking, filing, indexing, and linting in `wiki/`.

## 3-Layer Architecture

```text
wiki/
├── raw/                    # IMMUTABLE source of truth — read only, NEVER modify!
│   └── assets/             # Local images/diagrams downloaded with clipped articles
├── index.md                # Content-oriented catalog (read FIRST on every ingest/query)
├── log.md                  # Chronological append-only timeline (parseable with grep "^## \[")
└── pages/                  # LLM-owned compiled markdown wiki (Obsidian-friendly)
    ├── sources/            # One structured summary page per ingested raw source
    ├── comparisons/        # Filed query syntheses, trade-off matrices & analyses
    ├── java/
    ├── spring-boot/
    ├── dsa/
    ├── dbms/
    ├── os-linux/
    ├── gcp/
    ├── google-ai/
    └── system-design/
```

*(Modular by design: create additional topic/book/research folders under `wiki/pages/` whenever the user expands beyond the 8 engineering pillars.)*

---

## Core Operations

### 1. INGEST — Compile a New Source Into the Wiki
Trigger: *"Use `llm-wiki` to ingest [file / URL notes / pasted text / bug postmortem]"*

1. **Preserve Raw Source (Immutable)**:
   - If the source isn't already in `wiki/raw/`, save an untouched copy as `wiki/raw/YYYY-MM-DD-<slug>.md`. Never alter existing files in `wiki/raw/`.
   - **Image handling**: If the raw markdown references local images in `wiki/raw/assets/`, read the text first, then inspect key referenced images with `read_file` so diagrams/charts are captured accurately.
2. **Read `wiki/index.md` First**: Understand what entity, concept, and pillar pages already exist before touching anything.
3. **Interactive Takeaways First (Default — Unless Batch Mode Requested)**:
   - Summarize the 3–6 key takeaways and propose which wiki pages will be created/updated (a rich source typically touches 5–15 pages across summaries, concepts, entities, and cross-pillar links).
   - Briefly check if the user wants to emphasize or skip anything (if they said *"just ingest it"* or requested batch ingest, proceed directly).
4. **Compile & Cross-Link in `wiki/pages/`**:
   - Create a source summary page in `wiki/pages/sources/YYYY-MM-DD-<slug>.md`.
   - Create or update every relevant concept/entity/pillar page in `wiki/pages/<category>/<topic>.md` with relative markdown links (`[PostgreSQL MVCC](../dbms/mvcc.md)`).
   - **Contradiction Discipline**: If the new source contradicts an existing claim in the wiki, **never silently overwrite** — add an explicit `> [!WARNING] Contradiction / Evolution` note citing both sources and dates/versions.
5. **Update `wiki/index.md`**: Add/update the link, 1-line summary, date, and source count for every touched page.
6. **Append to `wiki/log.md`**: Use the exact unix-parseable prefix:
   ```markdown
   ## [YYYY-MM-DD] ingest | <Source Title>
   - Raw: `wiki/raw/...`
   - Created: ...
   - Updated: ...
   - Contradictions flagged: None / <details>
   ```

### 2. QUERY — Synthesize Grounded Answers (and Compound Them!)
Trigger: *"Query `llm-wiki` about..."*, *"What does my wiki say about..."*

1. **Start at `wiki/index.md`** (and if the wiki has grown large and a search tool like `qmd` is installed, use it to narrow candidates).
2. **Read the relevant `wiki/pages/**/*.md` files in full** before answering.
3. **Synthesize with Citations**:
   - Cite exact wiki page links (`wiki/pages/...`) for every claim drawn from the wiki.
   - **Zero Hallucination**: Clearly separate *what is backed by your wiki* vs. *general knowledge outside the wiki*. If the wiki has a gap, state it bluntly.
   - Tailor output format to the question: markdown synthesis, trade-off comparison table, Mermaid architecture diagram, Marp slide deck, or script/chart.
4. **Offer to File Back**: Whenever a query produces a valuable comparison, synthesis, or newly discovered cross-pillar connection, offer to save it under `wiki/pages/comparisons/` (or the right pillar folder), update `wiki/index.md`, and log `## [YYYY-MM-DD] query | <Topic>` in `wiki/log.md` so explorations compound too.

### 3. LINT — Health-Check & Sharpen the Wiki
Trigger: *"Lint `llm-wiki`"*, *"Health-check my wiki"*

1. Inspect `wiki/index.md`, `wiki/log.md`, and `wiki/pages/**/*.md`.
2. Report findings across 6 checks:
   - **Contradictions** between pages that need reconciliation
   - **Stale claims** superseded by newer sources or newer versions (Java/Spring/GCP/Gemini)
   - **Orphan pages** (zero inbound links or missing from `wiki/index.md`)
   - **Unwritten hub concepts** (terms referenced repeatedly that deserve their own page)
   - **Missing cross-links** between pillars (e.g., Java Virtual Threads ↔ OS Futexes ↔ Spring Tomcat)
   - **Knowledge gaps** + concrete next questions or sources to hunt down
3. Apply approved surgical fixes and append `## [YYYY-MM-DD] lint | <Summary>` to `wiki/log.md`.

---

## Standard Page Format (Obsidian & Dataview Ready)

Every compiled page in `wiki/pages/` should start with lightweight YAML frontmatter so Obsidian Dataview, tags, and Graph View work automatically:

```markdown
---
title: <Topic Title>
pillar: java | spring-boot | dsa | dbms | os-linux | gcp | google-ai | system-design | source | comparison
tags: [tag-1, tag-2]
updated: YYYY-MM-DD
sources: 1
---

# <Topic Title>

**Related:** [Concept A](../pillar/concept-a.md) · [Concept B](../pillar/concept-b.md)

## First-Principles Mental Model
<How it actually works under the hood in 3–6 crisp lines.>

## Key Mechanics & Patterns
<Core invariants, flows, or examples.>

## Trade-Offs
| Approach | Wins When | Hurts / Breaks When |
|---|---|---|
| ... | ... | ... |

## Production Gotchas & Contradictions
- <Concrete pitfall, failure mode, or version-specific caveat>

## Sources
- `wiki/raw/...`
```
