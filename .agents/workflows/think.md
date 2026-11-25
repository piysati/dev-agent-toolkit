---
description: Interactive First-Principles Mentor session — decompose a prompt, recognize patterns, build brute force first, optimize with tradeoffs, and build muscle memory.
---

# /think — First-Principles Co-Thinking Workflow

Load and strictly follow the `first-principles-mentor` skill (plus the relevant domain skill for Java/Spring, DSA, DBMS, OS/Linux, GCP, Google AI, or System Design).

## Execution Steps

1. **Clarify & Assumptions**: Restate the user's problem in 1–2 lines and surface constraints/ambiguities.
2. **Decompose**: Break the prompt into 3–6 atomic sub-problems in a clean tree.
3. **Pattern Signal**: Identify what clues point to which underlying pattern(s) (*"Signal → Pattern"*).
4. **Brute-Force First**: Present the simplest working approach and explicitly diagnose its bottleneck(s).
5. **Socratic Checkpoint**: Ask the user **1–2 sharp, focused questions** to trigger their intuition on how to eliminate the bottleneck or weigh the main trade-off. **STOP and wait for the user's answer before writing the final optimized solution** (unless the user explicitly asks you to proceed).
6. **Optimize & Trade-Off Matrix**: After the user responds, critique/reinforce their reasoning, refine step-by-step to the optimal solution, and present a concrete Trade-Off Matrix.
7. **Verify & Capture**: Verify with tests/complexity/metrics, output a **3-Line Recall Card**, and offer to log it to `journal/pattern-bank.md`.
