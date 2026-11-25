---
description: Work Co-Pilot Mode — ship clean, surgical, tested production work fast while still decomposing the problem, weighing trade-offs, and capturing the lesson learned.
---

# /ship-and-learn — Fast Production Delivery + Pattern Debrief

Use when you have a real work task or deadline: combine **ECC production execution**, **Karpathy surgical minimalism**, and **First-Principles learning** without slowing down delivery.

## Workflow

1. **30-Second Framing (Before Coding)**:
   - State assumptions & verifiable acceptance criteria.
   - Break the task into a short `step -> verify` checklist.
   - Present a 3-row **Approach & Trade-Off Table** (Naive vs Recommended vs Over-Engineered) and state clearly why the recommended option wins.
2. **Surgical Implementation**:
   - Apply `karpathy-guidelines` + relevant ECC skills (`java-coding-standards`, `springboot-patterns`, `springboot-tdd`, `jpa-patterns`, `postgres-patterns`, `gcp-cloud-architecture`, `google-ai-engineering`).
   - Write/update targeted tests first when practical (reproduce bug or assert new contract).
   - Keep diff minimal and strictly scoped to the task.
3. **Verification Pass**:
   - Run build/tests/linters and verify edge cases, security, N+1 queries, and error handling.
4. **60-Second Top-1% Debrief (Always Include at the End)**:
   - **Pattern Used**: Name the exact pattern(s) applied.
   - **Why It Beats the Alternative**: 1–2 bullet trade-off takeaway.
   - **One Thing to Remember**: A sharp takeaway to build engineering instinct (and offer to log it to `journal/pattern-bank.md` or `journal/tradeoff-log.md`).
