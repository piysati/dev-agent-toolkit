---
name: tech-writing-credibility
description: >-
  Turn real, verified engineering learnings from wiki/, journal/, and playground/
  into high-credibility technical LinkedIn posts and NotebookLM study/audio
  source packets. Use in Phase 2 (credibility building) or whenever the user asks
  to draft a LinkedIn post, technical breakdown, or NotebookLM source bundle from
  their hands-on work. Never generates generic AI fluff or unverified claims.
---

# Tech Writing & Credibility Engine (LinkedIn + NotebookLM)

Build genuine engineering credibility by publishing **earned, hands-on technical insights**—never generic engagement-bait or hallucinated claims.

## Golden Rule (Zero Cringe, Zero Fabrication)

- **Source from reality first**: Pull directly from the user's real `wiki/pages/`, `journal/pattern-bank.md`, `journal/tradeoff-log.md`, or `playground/` benchmarks/bugs.
- **Zero fabricated metrics or war stories**: Never invent *"We scaled to 10M QPS"* or fake latency numbers. If a post needs a real number, ask the user for their measured result or frame it cleanly as a first-principles breakdown / local benchmark.
- **No LinkedIn AI-slop**: Ban clichés (*"Here's why nobody talks about..."*, *"Let that sink in"*, *"Agree? 👇"*, excessive rocket emojis, hollow bullet lists). Write like a sharp Staff Engineer sharing one concrete mental model, bug lesson, or trade-off table.

---

## Mode 1: High-Credibility LinkedIn Technical Post

When drafting a LinkedIn post from a concept, bug, or design trade-off:

1. **Pick One Sharp Angle** (choose 1 per post):
   - **The "What Actually Broke" Post**: A subtle production trap (e.g., Spring `@Transactional` self-invocation, Container Exit Code 137 vs `-Xmx`, JPA N+1, composite index column order) + exact root cause + fix.
   - **The First-Principles Mental Model**: ELI5 analogy + under-the-hood mechanics + clean ASCII/Mermaid visual.
   - **The Honest Trade-Off Breakdown**: *"Everyone defaults to X, here's when Y wins and when X wins"* with a crisp 3-row comparison.
   - **The Brute-Force → Optimal Journey**: Show the naive baseline, the exact bottleneck, and the single insight that cracked it.
2. **Structure (Crisp & Scannable — 150 to 300 words)**:
   - **Hook (1–2 lines)**: State the concrete problem, misconception, or surprise directly.
   - **Core Insight (3–5 short paragraphs or tight bullets)**: Explain *why* from first principles (include 1 vivid analogy or real code/SQL/command snippet).
   - **Trade-Off / Gotcha (1–2 lines)**: Show nuance — prove you know when the advice does *not* apply.
   - **Closing (1 line)**: A genuine technical question or takeaway (no cheap engagement bait).
3. **Voice Calibration**: Match the user's real level and honesty — sharing what you learned while building/debugging beats pretending to be an infallible guru.

---

## Mode 2: NotebookLM Source Packet Generator

When the user wants to feed their `Super-Dev-Hub` knowledge into **Google NotebookLM** (for Audio Overviews / commute podcasts, deep study Q&A, flashcards, or presentation prep):

1. Gather the selected `wiki/pages/**/*.md`, `journal/pattern-bank.md`, and `journal/tradeoff-log.md` entries on the requested pillar or topic.
2. Compile them into a clean, self-contained, well-structured Markdown bundle (e.g., `wiki/exports/YYYY-MM-DD-<topic>-notebooklm.md`) containing:
   - Clear topic framing & learning objectives
   - First-principles mental models + ELI5 analogies + technical references
   - Explicit trade-off tables and "Common Misconceptions vs. Reality" pairs (NotebookLM's Audio Overview hosts love debating concrete trade-offs and misconceptions!)
   - Real commands, code snippets, and failure scenarios
   - A *"Questions to Stress-Test My Understanding"* section at the end
3. Remind the user to upload that single compiled `.md` (or `.pdf`) file directly to NotebookLM so every generated podcast/summary stays grounded in their exact verified notes.
