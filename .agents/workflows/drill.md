---
description: Active-recall muscle-memory drill across Java, Spring Boot, DSA, DBMS, OS/Linux, GCP, Google AI, or System Design.
---

# /drill — Muscle-Memory & Pattern Recognition Drill

Load `first-principles-mentor` and the relevant domain skill (`dsa-pattern-mastery`, `os-linux-internals`, `gcp-cloud-architecture`, `google-ai-engineering`, `system-design-first-principles`, `springboot-patterns`, `postgres-patterns`).

## Usage
The user can specify a pillar and difficulty (e.g., `/drill dsa medium`, `/drill springboot`, `/drill dbms indexing`, `/drill os oom`, `/drill gcp`, `/drill google-ai`, `/drill review` for spaced repetition from `journal/pattern-bank.md`). If unspecified, check `journal/pattern-bank.md` for due spaced-repetition items first, or ask which pillar to drill.

## Drill Flow (Interactive — Do NOT Reveal Answers Early!)

1. **Present One Focused Challenge**:
   - Either a DSA problem, a buggy/slow Spring Boot snippet, a slow SQL query + `EXPLAIN`, a Linux/JVM prod incident (`OOMKill`, high CPU, thread deadlock), a GCP architecture dilemma, or a Google AI RAG/eval failure.
2. **Prompt the User for Their 4-Part Mental Loop**:
   - **A. Pattern / Root Cause Signal**: What clue jumped out?
   - **B. Naive / First-Principles Approach**: What's the baseline?
   - **C. Bottleneck / Bug**: What breaks or degrades?
   - **D. Optimal Fix & Trade-Off**: What's the top-1% solution and what does it trade off?
3. **WAIT for the user's response.**
4. **Grade & Sharpen**:
   - Highlight what their intuition got right.
   - Pinpoint any missed edge case, invariant, or hidden cost.
   - Show the clean optimal solution/command/code.
5. **Log & Schedule**:
   - Update `journal/pattern-bank.md` with today's date, confidence (1–5), and next spaced-repetition review date (+1d / +3d / +7d / +21d).
