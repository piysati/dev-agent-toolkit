# LLM Wiki

A pattern for building persistent, compounding personal knowledge bases using LLMs — instantiated here inside **Super-Dev-Hub** for **Antigravity / Gemini**.

---

## The Core Idea

Most people's experience with LLMs and documents looks like RAG: you upload a collection of files, the LLM retrieves relevant chunks at query time, and generates an answer. This works, but the LLM is rediscovering knowledge from scratch on every question. There's no accumulation. Ask a subtle question that requires synthesizing five documents, and the LLM has to find and piece together the relevant fragments every time. Nothing is built up. NotebookLM, chat file uploads, and most RAG systems work this way.

The idea here is different. Instead of just retrieving from raw documents at query time, the LLM **incrementally builds and maintains a persistent wiki** — a structured, interlinked collection of markdown files that sits between you and the raw sources. When you add a new source, the LLM doesn't just index it for later retrieval. It reads it, extracts the key information, and integrates it into the existing wiki — updating entity pages, revising topic summaries, noting where new data contradicts old claims, strengthening or challenging the evolving synthesis. The knowledge is compiled once and then *kept current*, not re-derived on every query.

This is the key difference: **the wiki is a persistent, compounding artifact.** The cross-references are already there. The contradictions have already been flagged. The synthesis already reflects everything you've read. The wiki keeps getting richer with every source you add and every question you ask.

You never (or rarely) write the wiki yourself — **Antigravity / Gemini writes and maintains all of it**. You're in charge of sourcing, exploration, and asking the right questions. The LLM does all the grunt work — the summarizing, cross-referencing, filing, and bookkeeping that makes a knowledge base actually useful over time. In practice, you can keep Antigravity open on one side and **Obsidian** open on the other (pointed at `wiki/`). Antigravity makes edits based on your conversation, and you browse the results in real time — following links, checking the graph view, reading the updated pages. **Obsidian is the IDE; the LLM is the programmer; the wiki is the codebase.**

This pattern applies across many contexts:

- **Top 1% Engineering Mastery (Super-Dev-Hub default)**: accumulating deep, cross-linked notes across Java, Spring Boot, DSA, DBMS, OS & Linux, GCP, Google AI, and System Design — linking real production bug postmortems, RFCs, books, and papers into one living encyclopedia.
- **Personal**: tracking goals, health, psychology, self-improvement — filing journal entries, articles, and podcast notes into a structured picture over time.
- **Research**: going deep on a topic over weeks or months — reading papers, articles, and reports, and incrementally building a comprehensive wiki with an evolving thesis.
- **Reading a book**: filing each chapter as you go, building pages for concepts, chapters, themes, and how they connect (like [Tolkien Gateway](https://tolkiengateway.net/wiki/Main_Page), maintained personally by your LLM).
- **Business/team**: an internal wiki maintained by LLMs, fed by Slack threads, meeting transcripts, project documents, and customer calls, with humans reviewing updates.
- **Competitive analysis, due diligence, course notes, hobby deep-dives** — anything where you're accumulating knowledge over time and want it organized rather than scattered.

---

## Architecture (Three Layers)

1. **Raw sources (`wiki/raw/`)** — Your curated collection of source documents: articles, papers, bug dumps, images (`wiki/raw/assets/`), data files. These are **immutable** — Antigravity reads from them but never modifies them. This is your source of truth.
2. **The wiki (`wiki/pages/`, `wiki/index.md`, `wiki/log.md`)** — A directory of LLM-generated markdown files: source summaries, entity pages, concept pages, comparisons, overviews, and syntheses. **Antigravity owns this layer entirely.** It creates pages, updates them when new sources arrive, maintains cross-references, and keeps everything consistent. You read it; Antigravity writes it.
3. **The schema (`GEMINI.md` + [`.agents/skills/llm-wiki/SKILL.md`](.agents/skills/llm-wiki/SKILL.md))** — The instruction files that tell Antigravity how the wiki is structured, what the conventions are, and what workflows to follow when ingesting sources, answering questions, or linting the wiki. This is what turns the LLM into a disciplined wiki maintainer rather than a generic chatbot. Co-evolve this schema over time as you discover what works best for your workflow.

---

## Operations

### 1. Ingest
Drop a new source into `wiki/raw/` (or paste notes/postmortems in chat) and tell Antigravity to ingest it:
```text
Use the llm-wiki skill to ingest wiki/raw/2026-11-24-postgres-mvcc-notes.md
```
Typical flow: Antigravity reads the source, discusses key takeaways with you, writes a summary page in `wiki/pages/sources/`, updates `wiki/index.md`, updates all relevant entity/concept/pillar pages across `wiki/pages/` (a single rich source may touch 5–15 pages), flags any contradictions with earlier pages, and appends an entry to `wiki/log.md`.

- **Interactive single-source ingest (recommended default)**: Stay involved one source at a time — review takeaways, guide what to emphasize, and sharpen your mental model as the wiki grows.
- **Batch ingest**: Possible when importing many sources at once with lighter supervision.

### 2. Query
Ask questions against your compiled wiki:
```text
Use llm-wiki to answer: Based on my wiki, how do Spring @Transactional boundaries interact with HikariCP and PostgreSQL MVCC?
```
Antigravity reads `wiki/index.md` first to locate relevant pages, reads those pages in full, and synthesizes a grounded answer with citations. Outputs can be markdown synthesis, comparison tables, Mermaid diagrams, Marp slide decks, or charts.

**Key insight:** Good answers should be **filed back into the wiki** as new pages (e.g., under `wiki/pages/comparisons/` or a pillar folder) so your explorations compound in the knowledge base just like ingested sources do.

### 3. Lint
Periodically ask Antigravity to health-check the wiki:
```text
Use llm-wiki to lint my wiki.
```
Antigravity checks for:
- Contradictions between pages
- Stale claims superseded by newer sources or newer Java/Spring/GCP/Gemini releases
- Orphan pages with zero inbound links
- Important concepts mentioned across pages that lack their own dedicated page
- Missing cross-references across pillars
- Knowledge gaps worth investigating next (and suggests new sources or drills)

---

## Indexing and Logging

Two special files keep the wiki navigable for both you and Antigravity:

- **[`wiki/index.md`](wiki/index.md) (Content-Oriented)** — Master catalog of every page in the wiki: link, one-line summary, pillar/category, and source count/date. Updated on every ingest. When answering a query, Antigravity reads `index.md` first and drills into the exact pages needed — working cleanly at moderate scale (~100 sources / hundreds of pages) without needing heavy embedding infrastructure.
- **[`wiki/log.md`](wiki/log.md) (Chronological)** — Append-only timeline of every `ingest`, `query` (when filed), and `lint` pass. Every entry starts with a consistent unix-parseable header:
  ```markdown
  ## [2026-11-24] ingest | PostgreSQL MVCC & Vacuum Internals
  ```
  So `grep "^## \[" wiki/log.md | tail -5` instantly gives you the last 5 wiki operations.

---

## Optional: CLI Tools (As Your Wiki Scales)

At small-to-moderate scale, `wiki/index.md` is enough. Once your wiki grows to hundreds of pages and you want fast local search:
- **[qmd](https://github.com/tobi/qmd)** — Local on-device markdown search engine with hybrid BM25/vector search and LLM re-ranking, available as both a CLI and an MCP server.
- Or ask Antigravity to build a tiny custom search script tailored to your `wiki/` frontmatter and tags.

---

## Tips & Tricks (Obsidian + Git Superpowers)

- **Obsidian Web Clipper** — Browser extension that converts web articles directly into clean markdown files ready to drop into `wiki/raw/`.
- **Download images locally** — In Obsidian *Settings → Files and links*, set *Attachment folder path* to `wiki/raw/assets/`. Bind *"Download attachments for current file"* to a hotkey (e.g., `Ctrl+Shift+D` / `Cmd+Shift+D`). Because LLMs read markdown text and images separately, Antigravity reads the article text first and then inspects referenced local images with `read_file` when diagrams/charts matter.
- **Obsidian Graph View** — Visualizes the shape of your knowledge base: hub concepts, clusters across your 8 pillars, and orphan pages.
- **Marp** — Markdown-based slide deck format (with an Obsidian plugin) for turning wiki pages directly into crisp technical talks or design reviews.
- **Dataview** — Obsidian plugin that queries YAML frontmatter (`pillar`, `tags`, `updated`, `sources`) on your wiki pages to build live tables and dashboards automatically.
- **Git-Backed** — Because `wiki/` is plain markdown, you get full version history, diffs, branching, and easy backup for free.

---

## Why This Works

The hard part of maintaining a knowledge base is never the reading or thinking — it's the **bookkeeping**: updating cross-references, reconciling contradictions, refreshing summaries, and keeping dozens of pages consistent. Humans abandon wikis because maintenance cost grows faster than value. LLMs don't get bored, don't forget to update a link, and can cleanly update 10–15 pages in one pass.

Your job is to **curate sources, direct the analysis, ask sharp questions, and build intuition**. Antigravity's job is everything else.

In spirit, this is Vannevar Bush's **Memex (1945)** — a private, curated knowledge store with associative trails between documents — finally solving the missing piece: *who does the maintenance*.

---

## How It's Wired Inside Super-Dev-Hub

- **Executable Skill**: [`.agents/skills/llm-wiki/SKILL.md`](.agents/skills/llm-wiki/SKILL.md) (auto-discovered by Antigravity)
- **Wiki Root**: `wiki/` (`raw/`, `raw/assets/`, `pages/{java,spring-boot,dsa,dbms,os-linux,gcp,google-ai,system-design,sources,comparisons}/`, `index.md`, `log.md`)
- **How `wiki/` Complements `journal/`**:
  - Use **`journal/`** for active training (`roadmap-tracker.md`, spaced-repetition flashcards in `pattern-bank.md`, decision logs in `tradeoff-log.md`).
  - Use **`wiki/`** as your long-term, interlinked personal engineering encyclopedia — and co-evolve the schema in `.agents/skills/llm-wiki/SKILL.md` whenever you want new page types, formats, or conventions.
